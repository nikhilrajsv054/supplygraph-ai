from datetime import date
from typing import Any, Optional

from fastapi.testclient import TestClient

from app.dependencies import get_analytics_repository
from app.main import app
from app.services.analytics_repository import GovernedQueryResult


class FakeAnalyticsRepository:
    def get_dashboard_summary(self) -> dict[str, Any]:
        return {
            "supplier_count": 50,
            "plant_count": 10,
            "order_count": 10000,
            "at_risk_part_count": 102,
            "affected_order_count": 49,
            "on_time_delivery_rate": 79.2,
            "average_delivery_delay_days": 1.1,
            "defect_rate": 20.0,
            "fill_rate": 96.15,
            "total_landed_cost": 256180682.9,
            "currency": "USD",
        }

    def list_suppliers(self, limit: int) -> list[dict[str, Any]]:
        return [self._supplier()][0:limit]

    def get_supplier(self, supplier_id: str) -> Optional[dict[str, Any]]:
        return self._supplier() if supplier_id == "S007" else None

    def list_part_risks(
        self, risk_status: Optional[str], limit: int
    ) -> list[dict[str, Any]]:
        return []

    def list_plant_performance(self, limit: int) -> list[dict[str, Any]]:
        return []

    def list_order_impacts(
        self, impact_status: str, limit: int
    ) -> list[dict[str, Any]]:
        return [
            {
                "order_id": "O01008",
                "customer_name": "Synthetic Customer 0137",
                "supplier_name": "Apex Components",
                "part_name": "Synthetic Part 0205",
                "plant_name": "Distribution Plant 05",
                "required_date": date(2026, 8, 18),
                "shipment_actual_date": date(2026, 8, 20),
                "shipment_delay_days": 8,
                "impact_status": impact_status,
            }
        ][0:limit]

    def get_metric_definition(self, metric_name: str) -> dict[str, Any]:
        return {
            "metric_name": metric_name,
            "display_name": "On-Time Delivery Rate",
            "definition": "Percentage of completed shipments delivered on time.",
            "formula": "on_time_shipments / completed_shipments * 100",
            "source_object": "GOVERNANCE.SUPPLIER_PERFORMANCE",
            "time_semantics": "Based on actual delivery date.",
            "business_owner": "Supply Chain Operations",
        }

    def run_metric(
        self, metric_name: str, period_mode: str
    ) -> GovernedQueryResult:
        return GovernedQueryResult(
            sql="SELECT governed_metric FROM approved_semantic_view",
            rows=[
                {
                    "metric_value": 56.91,
                    "period": "September 2026",
                }
            ],
        )

    @staticmethod
    def _supplier() -> dict[str, Any]:
        return {
            "supplier_id": "S007",
            "supplier_name": "Apex Components",
            "region": "Saudi Arabia",
            "category": "Chemicals",
            "supplier_status": "WATCHLIST",
            "total_completed_shipments": 300,
            "late_shipments": 197,
            "on_time_delivery_rate": 34.33,
            "average_delivery_delay_days": 4.7,
            "defect_rate": 48.33,
        }


def override_repository() -> FakeAnalyticsRepository:
    return FakeAnalyticsRepository()


app.dependency_overrides[get_analytics_repository] = override_repository
client = TestClient(app)


def test_dashboard_summary_uses_typed_governed_metrics() -> None:
    response = client.get("/api/dashboard/summary")

    assert response.status_code == 200
    assert response.json()["fill_rate"] == 96.15
    assert response.json()["affected_order_count"] == 49


def test_supplier_detail_normalizes_identifier() -> None:
    response = client.get("/api/suppliers/s007")

    assert response.status_code == 200
    assert response.json()["supplier_name"] == "Apex Components"


def test_unknown_supplier_returns_404() -> None:
    response = client.get("/api/suppliers/s999")

    assert response.status_code == 404


def test_order_impact_contract_serializes_dates() -> None:
    response = client.get("/api/orders/impact")

    assert response.status_code == 200
    assert response.json()[0]["required_date"] == "2026-08-18"