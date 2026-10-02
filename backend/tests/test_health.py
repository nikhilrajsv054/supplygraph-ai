from fastapi.testclient import TestClient

from app.config import Settings, get_settings
from app.main import app


def test_health_reports_service_without_exposing_secrets() -> None:
    app.dependency_overrides[get_settings] = lambda: Settings(
        snowflake_account=None,
        snowflake_user=None,
        snowflake_password=None,
    )
    try:
        response = TestClient(app).get("/api/health")
    finally:
        app.dependency_overrides.pop(get_settings, None)

    assert response.status_code == 200
    assert response.json() == {
        "status": "ok",
        "service": "SupplyGraph AI API",
        "environment": "development",
        "snowflake_configured": False,
    }
