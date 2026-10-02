from dataclasses import dataclass
from typing import Optional

from app.models.chat import (
    ChatRequest,
    ChatResponse,
    Evidence,
    MetricResult,
)
from app.services.analytics_repository import AnalyticsRepository
from app.services.cortex_service import CortexError, CortexIntentResolver


class UnsupportedQuestionError(ValueError):
    pass


@dataclass(frozen=True)
class MetricIntent:
    metric_name: str
    intent: str
    unit: str


class ChatService:
    _SEMANTIC_VIEW = "GOVERNANCE.SUPPLY_CHAIN_SV"
    _PERSONA_CONTEXT = {
        "planning": "For planning, use this governed result to adjust supply coverage and priorities.",
        "procurement": "For procurement, use this governed result to focus supplier and cost discussions.",
        "logistics": "For logistics, use this governed result to prioritize delivery-flow investigation.",
    }

    _METRIC_INTENTS = {
        "ON_TIME_DELIVERY_RATE": MetricIntent(
            "ON_TIME_DELIVERY_RATE", "SUPPLIER_PERFORMANCE", "%"
        ),
        "AVERAGE_DELIVERY_DELAY": MetricIntent(
            "AVERAGE_DELIVERY_DELAY", "SUPPLIER_PERFORMANCE", "days"
        ),
        "DEFECT_RATE": MetricIntent(
            "DEFECT_RATE", "SUPPLIER_QUALITY", "%"
        ),
        "DAYS_OF_INVENTORY": MetricIntent(
            "DAYS_OF_INVENTORY", "INVENTORY_RISK", "days"
        ),
        "AFFECTED_ORDER_COUNT": MetricIntent(
            "AFFECTED_ORDER_COUNT", "ORDER_IMPACT", "orders"
        ),
        "FILL_RATE": MetricIntent(
            "FILL_RATE", "ORDER_FULFILLMENT", "%"
        ),
        "TOTAL_LANDED_COST": MetricIntent(
            "TOTAL_LANDED_COST", "LANDED_COST", "currency"
        ),
        "LANDED_COST_PER_UNIT": MetricIntent(
            "LANDED_COST_PER_UNIT", "LANDED_COST", "currency/unit"
        ),
    }

    def __init__(
        self,
        repository: AnalyticsRepository,
        intent_resolver: Optional[CortexIntentResolver] = None,
    ) -> None:
        self._repository = repository
        self._intent_resolver = intent_resolver

    def answer(self, request: ChatRequest) -> ChatResponse:
        (
            metric_intent,
            period_mode,
            interpretation_source,
            model,
        ) = self._interpret(request.question)
        definition = self._repository.get_metric_definition(
            metric_intent.metric_name
        )
        result = self._repository.run_metric(
            metric_intent.metric_name,
            period_mode,
        )
        if not result.rows or result.rows[0].get("metric_value") is None:
            raise UnsupportedQuestionError(
                "No governed data is available for that question"
            )

        row = result.rows[0]
        value = float(row["metric_value"])
        period = str(row.get("period") or "All available data")
        currency = row.get("currency")
        display_value = self._format_value(
            value,
            metric_intent.unit,
            currency,
        )
        answer = (
            f"{definition['display_name']} is {display_value} for {period}. "
            f"{self._PERSONA_CONTEXT[request.persona]}"
        )

        filters = {}
        if period_mode == "LATEST_MONTH":
            filters["actual_delivery_month"] = period

        return ChatResponse(
            answer=answer,
            intent=metric_intent.intent,
            persona=request.persona,
            interpretation_source=interpretation_source,
            model=model,
            metrics=[
                MetricResult(
                    name=metric_intent.metric_name,
                    display_name=definition["display_name"],
                    value=value,
                    unit=metric_intent.unit,
                    currency=currency,
                )
            ],
            evidence=Evidence(
                canonical_metric=metric_intent.metric_name,
                definition=definition["definition"],
                formula=definition["formula"],
                source_object=definition["source_object"],
                semantic_view=self._SEMANTIC_VIEW,
                time_semantics=definition["time_semantics"],
                period=period,
                filters=filters,
                business_owner=definition["business_owner"],
            ),
            sql=result.sql.strip(),
            rows=result.rows,
        )

    def _interpret(
        self,
        question: str,
    ) -> tuple[MetricIntent, str, str, Optional[str]]:
        if self._intent_resolver is not None:
            try:
                interpretation = self._intent_resolver.resolve(question)
                if interpretation.metric_name == "UNSUPPORTED":
                    raise UnsupportedQuestionError(
                        "Ask about delivery, inventory, fulfillment, quality, "
                        "order impact, or landed cost."
                    )
                metric_intent = self._METRIC_INTENTS.get(
                    interpretation.metric_name
                )
                if metric_intent is not None:
                    period_mode = interpretation.period_mode
                    if metric_intent.metric_name != "ON_TIME_DELIVERY_RATE":
                        period_mode = "ALL"
                    return (
                        metric_intent,
                        period_mode,
                        "cortex",
                        self._intent_resolver.model,
                    )
            except CortexError:
                pass

        metric_intent = self._resolve_intent(question)
        return (
            metric_intent,
            self._resolve_period(question, metric_intent),
            "deterministic",
            None,
        )

    @staticmethod
    def _resolve_period(question: str, metric_intent: MetricIntent) -> str:
        normalized = question.lower()
        requests_current_period = any(
            phrase in normalized
            for phrase in ("this month", "current month", "latest month")
        )
        if (
            requests_current_period
            and metric_intent.metric_name == "ON_TIME_DELIVERY_RATE"
        ):
            return "LATEST_MONTH"
        return "ALL"

    @staticmethod
    def _resolve_intent(question: str) -> MetricIntent:
        normalized = " ".join(question.lower().replace("-", " ").split())

        if "landed cost per unit" in normalized or "cost per unit" in normalized:
            return MetricIntent(
                "LANDED_COST_PER_UNIT", "LANDED_COST", "currency/unit"
            )
        if "landed cost" in normalized or "total cost" in normalized:
            return MetricIntent("TOTAL_LANDED_COST", "LANDED_COST", "currency")
        if "fill rate" in normalized or "fulfilment rate" in normalized:
            return MetricIntent("FILL_RATE", "ORDER_FULFILLMENT", "%")
        if any(
            phrase in normalized
            for phrase in ("on time delivery", "on time rate", "otd")
        ):
            return MetricIntent(
                "ON_TIME_DELIVERY_RATE", "SUPPLIER_PERFORMANCE", "%"
            )
        if "defect" in normalized or "quality" in normalized:
            return MetricIntent("DEFECT_RATE", "SUPPLIER_QUALITY", "%")
        if "affected order" in normalized or "orders affected" in normalized:
            return MetricIntent(
                "AFFECTED_ORDER_COUNT", "ORDER_IMPACT", "orders"
            )
        if any(
            phrase in normalized
            for phrase in ("stockout", "days of inventory", "days of supply")
        ):
            return MetricIntent("DAYS_OF_INVENTORY", "INVENTORY_RISK", "days")
        if "delay" in normalized and "delivery" in normalized:
            return MetricIntent(
                "AVERAGE_DELIVERY_DELAY", "SUPPLIER_PERFORMANCE", "days"
            )

        raise UnsupportedQuestionError(
            "Ask about on-time delivery, delay, defects, inventory, affected "
            "orders, fill rate, or landed cost"
        )

    @staticmethod
    def _format_value(value: float, unit: str, currency: object) -> str:
        if unit == "%":
            return f"{value:,.2f}%"
        if unit == "currency":
            return f"{currency or 'USD'} {value:,.2f}"
        if unit == "currency/unit":
            return f"{currency or 'USD'} {value:,.2f} per unit"
        return f"{value:,.1f} {unit}"
