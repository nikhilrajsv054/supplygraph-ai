from dataclasses import dataclass
from typing import Any, Optional, Protocol

from app.services.snowflake_service import SnowflakeService


@dataclass(frozen=True)
class GovernedQueryResult:
    sql: str
    rows: list[dict[str, Any]]


class AnalyticsRepository(Protocol):
    def get_dashboard_summary(self) -> dict[str, Any]: ...

    def list_suppliers(self, limit: int) -> list[dict[str, Any]]: ...

    def get_supplier(
        self, supplier_id: str
    ) -> Optional[dict[str, Any]]: ...

    def list_part_risks(
        self, risk_status: Optional[str], limit: int
    ) -> list[dict[str, Any]]: ...

    def list_plant_performance(self, limit: int) -> list[dict[str, Any]]: ...

    def list_order_impacts(
        self, impact_status: str, limit: int
    ) -> list[dict[str, Any]]: ...

    def get_metric_definition(self, metric_name: str) -> dict[str, Any]: ...

    def run_metric(
        self, metric_name: str, period_mode: str
    ) -> GovernedQueryResult: ...


class SnowflakeAnalyticsRepository:
    _METRIC_SQL = {
        ("ON_TIME_DELIVERY_RATE", "ALL"): """
            SELECT
                ROUND(
                    100.0 * COUNT_IF(actual_date <= expected_date)
                    / NULLIF(COUNT(*), 0),
                    2
                ) AS metric_value,
                'All available data' AS period
            FROM SUPPLYGRAPH.GOVERNANCE.SHIPMENT_LANDED_COST
            WHERE shipment_status = 'DELIVERED'
                AND actual_date IS NOT NULL
        """,
        ("ON_TIME_DELIVERY_RATE", "LATEST_MONTH"): """
            WITH latest_month AS (
                SELECT DATE_TRUNC('MONTH', MAX(actual_date)) AS month_start
                FROM SUPPLYGRAPH.GOVERNANCE.SHIPMENT_LANDED_COST
                WHERE shipment_status = 'DELIVERED'
                    AND actual_date IS NOT NULL
            )
            SELECT
                ROUND(
                    100.0 * COUNT_IF(actual_date <= expected_date)
                    / NULLIF(COUNT(*), 0),
                    2
                ) AS metric_value,
                TO_CHAR(MIN(actual_date), 'MMMM YYYY') AS period
            FROM SUPPLYGRAPH.GOVERNANCE.SHIPMENT_LANDED_COST
            WHERE shipment_status = 'DELIVERED'
                AND actual_date IS NOT NULL
                AND DATE_TRUNC('MONTH', actual_date) = (
                    SELECT month_start FROM latest_month
                )
        """,
        ("AVERAGE_DELIVERY_DELAY", "ALL"): """
            SELECT
                ROUND(
                    AVG(GREATEST(DATEDIFF(DAY, expected_date, actual_date), 0)),
                    2
                ) AS metric_value,
                'All available data' AS period
            FROM SUPPLYGRAPH.GOVERNANCE.SHIPMENT_LANDED_COST
            WHERE shipment_status = 'DELIVERED'
                AND actual_date IS NOT NULL
        """,
        ("DEFECT_RATE", "ALL"): """
            SELECT
                ROUND(
                    100.0 * SUM(defective_shipments)
                    / NULLIF(SUM(total_completed_shipments), 0),
                    2
                ) AS metric_value,
                'All available data' AS period
            FROM SUPPLYGRAPH.GOVERNANCE.SUPPLIER_PERFORMANCE
        """,
        ("DAYS_OF_INVENTORY", "ALL"): """
            SELECT
                ROUND(
                    SUM(net_available_quantity)
                    / NULLIF(SUM(average_daily_demand), 0),
                    1
                ) AS metric_value,
                TO_CHAR(MAX(snapshot_date), 'YYYY-MM-DD') AS period
            FROM SUPPLYGRAPH.GOVERNANCE.PART_RISK
        """,
        ("AFFECTED_ORDER_COUNT", "ALL"): """
            SELECT
                COUNT_IF(impact_status = 'AFFECTED') AS metric_value,
                'All available data' AS period
            FROM SUPPLYGRAPH.GOVERNANCE.ORDER_IMPACT
        """,
        ("FILL_RATE", "ALL"): """
            SELECT
                ROUND(
                    100.0 * SUM(fulfilled_quantity)
                    / NULLIF(SUM(ordered_quantity), 0),
                    2
                ) AS metric_value,
                'All available data' AS period
            FROM SUPPLYGRAPH.GOVERNANCE.ORDER_FULFILLMENT
        """,
        ("TOTAL_LANDED_COST", "ALL"): """
            SELECT
                ROUND(SUM(total_landed_cost), 2) AS metric_value,
                'All available data' AS period,
                MIN(currency) AS currency
            FROM SUPPLYGRAPH.GOVERNANCE.SHIPMENT_LANDED_COST
            WHERE shipment_status = 'DELIVERED'
        """,
        ("LANDED_COST_PER_UNIT", "ALL"): """
            SELECT
                ROUND(
                    SUM(total_landed_cost)
                    / NULLIF(SUM(received_quantity), 0),
                    2
                ) AS metric_value,
                'All available data' AS period,
                MIN(currency) AS currency
            FROM SUPPLYGRAPH.GOVERNANCE.SHIPMENT_LANDED_COST
            WHERE shipment_status = 'DELIVERED'
        """,
    }

    _DASHBOARD_SQL = """
        SELECT
            (SELECT COUNT(*) FROM SUPPLYGRAPH.GOVERNANCE.SUPPLIER)
                AS supplier_count,
            (SELECT COUNT(*) FROM SUPPLYGRAPH.GOVERNANCE.PLANT)
                AS plant_count,
            (SELECT COUNT(*) FROM SUPPLYGRAPH.GOVERNANCE.ORDER_FULFILLMENT)
                AS order_count,
            (
                SELECT COUNT(*)
                FROM SUPPLYGRAPH.GOVERNANCE.PART_RISK
                WHERE risk_status <> 'HEALTHY'
            ) AS at_risk_part_count,
            (
                SELECT COUNT(*)
                FROM SUPPLYGRAPH.GOVERNANCE.ORDER_IMPACT
                WHERE impact_status = 'AFFECTED'
            ) AS affected_order_count,
            (
                SELECT ROUND(
                    100.0 * SUM(on_time_shipments)
                    / NULLIF(SUM(total_completed_shipments), 0),
                    2
                )
                FROM SUPPLYGRAPH.GOVERNANCE.SUPPLIER_PERFORMANCE
            ) AS on_time_delivery_rate,
            (
                SELECT ROUND(
                    SUM(
                        average_delivery_delay_days
                        * total_completed_shipments
                    ) / NULLIF(SUM(total_completed_shipments), 0),
                    2
                )
                FROM SUPPLYGRAPH.GOVERNANCE.SUPPLIER_PERFORMANCE
            ) AS average_delivery_delay_days,
            (
                SELECT ROUND(
                    100.0 * SUM(defective_shipments)
                    / NULLIF(SUM(total_completed_shipments), 0),
                    2
                )
                FROM SUPPLYGRAPH.GOVERNANCE.SUPPLIER_PERFORMANCE
            ) AS defect_rate,
            (
                SELECT ROUND(
                    100.0 * SUM(fulfilled_quantity)
                    / NULLIF(SUM(ordered_quantity), 0),
                    2
                )
                FROM SUPPLYGRAPH.GOVERNANCE.ORDER_FULFILLMENT
            ) AS fill_rate,
            (
                SELECT ROUND(SUM(total_landed_cost), 2)
                FROM SUPPLYGRAPH.GOVERNANCE.SHIPMENT_LANDED_COST
            ) AS total_landed_cost,
            (
                SELECT MIN(currency)
                FROM SUPPLYGRAPH.GOVERNANCE.SHIPMENT_LANDED_COST
            ) AS currency
    """

    _SUPPLIERS_SQL = """
        SELECT
            supplier_id,
            supplier_name,
            region,
            category,
            supplier_status,
            total_completed_shipments,
            late_shipments,
            on_time_delivery_rate,
            average_delivery_delay_days,
            defect_rate
        FROM SUPPLYGRAPH.GOVERNANCE.SUPPLIER_PERFORMANCE
        ORDER BY average_delivery_delay_days DESC, supplier_id
        LIMIT %(limit)s
    """

    _SUPPLIER_SQL = """
        SELECT
            supplier_id,
            supplier_name,
            region,
            category,
            supplier_status,
            total_completed_shipments,
            late_shipments,
            on_time_delivery_rate,
            average_delivery_delay_days,
            defect_rate
        FROM SUPPLYGRAPH.GOVERNANCE.SUPPLIER_PERFORMANCE
        WHERE supplier_id = %(supplier_id)s
    """

    _PART_RISKS_SQL = """
        SELECT
            plant_id,
            plant_name,
            part_id,
            part_name,
            category,
            criticality,
            net_available_quantity,
            reorder_point,
            days_of_inventory,
            risk_status,
            risk_score
        FROM SUPPLYGRAPH.GOVERNANCE.PART_RISK
        WHERE (%(risk_status)s IS NULL OR risk_status = %(risk_status)s)
        ORDER BY risk_score DESC, days_of_inventory, part_id
        LIMIT %(limit)s
    """

    _PLANTS_SQL = """
        SELECT
            plant_id,
            plant_name,
            plant_region,
            COUNT(*) AS shipment_count,
            ROUND(
                100.0 * COUNT_IF(
                    shipment_status = 'DELIVERED'
                    AND actual_date <= expected_date
                ) / NULLIF(COUNT_IF(shipment_status = 'DELIVERED'), 0),
                2
            ) AS on_time_delivery_rate,
            ROUND(
                AVG(
                    IFF(
                        shipment_status = 'DELIVERED',
                        GREATEST(
                            DATEDIFF(DAY, expected_date, actual_date),
                            0
                        ),
                        NULL
                    )
                ),
                2
            ) AS average_delivery_delay_days,
            ROUND(SUM(total_landed_cost), 2) AS total_landed_cost,
            MIN(currency) AS currency
        FROM SUPPLYGRAPH.GOVERNANCE.SHIPMENT_LANDED_COST
        GROUP BY plant_id, plant_name, plant_region
        ORDER BY average_delivery_delay_days DESC, plant_id
        LIMIT %(limit)s
    """

    _ORDER_IMPACTS_SQL = """
        SELECT
            order_id,
            customer_name,
            supplier_name,
            part_name,
            plant_name,
            required_date,
            shipment_actual_date,
            shipment_delay_days,
            impact_status
        FROM SUPPLYGRAPH.GOVERNANCE.ORDER_IMPACT
        WHERE impact_status = %(impact_status)s
        ORDER BY shipment_delay_days DESC, order_id
        LIMIT %(limit)s
    """

    _METRIC_DEFINITION_SQL = """
        SELECT
            metric_name,
            display_name,
            definition,
            formula,
            source_object,
            time_semantics,
            business_owner
        FROM SUPPLYGRAPH.GOVERNANCE.METRIC_CATALOG
        WHERE metric_name = %(metric_name)s
    """

    def __init__(self, service: SnowflakeService) -> None:
        self._service = service

    def get_dashboard_summary(self) -> dict[str, Any]:
        return self._service.execute(self._DASHBOARD_SQL)[0]

    def list_suppliers(self, limit: int) -> list[dict[str, Any]]:
        return self._service.execute(self._SUPPLIERS_SQL, {"limit": limit})

    def get_supplier(
        self, supplier_id: str
    ) -> Optional[dict[str, Any]]:
        rows = self._service.execute(
            self._SUPPLIER_SQL,
            {"supplier_id": supplier_id},
        )
        return rows[0] if rows else None

    def list_part_risks(
        self, risk_status: Optional[str], limit: int
    ) -> list[dict[str, Any]]:
        return self._service.execute(
            self._PART_RISKS_SQL,
            {"risk_status": risk_status, "limit": limit},
        )

    def list_plant_performance(self, limit: int) -> list[dict[str, Any]]:
        return self._service.execute(self._PLANTS_SQL, {"limit": limit})

    def list_order_impacts(
        self, impact_status: str, limit: int
    ) -> list[dict[str, Any]]:
        return self._service.execute(
            self._ORDER_IMPACTS_SQL,
            {"impact_status": impact_status, "limit": limit},
        )

    def get_metric_definition(self, metric_name: str) -> dict[str, Any]:
        rows = self._service.execute(
            self._METRIC_DEFINITION_SQL,
            {"metric_name": metric_name},
        )
        if not rows:
            raise ValueError("Metric definition not found")
        return rows[0]

    def run_metric(
        self, metric_name: str, period_mode: str
    ) -> GovernedQueryResult:
        key = (metric_name, period_mode)
        if key not in self._METRIC_SQL:
            key = (metric_name, "ALL")
        sql = self._METRIC_SQL[key]
        return GovernedQueryResult(sql=sql, rows=self._service.execute(sql))

