from fastapi.testclient import TestClient

from app.dependencies import (
    get_analytics_repository,
    get_cortex_intent_resolver,
)
from app.main import app
from app.services.cortex_service import CortexIntent
from tests.test_analytics import override_repository


app.dependency_overrides[get_analytics_repository] = override_repository
app.dependency_overrides[get_cortex_intent_resolver] = lambda: None
client = TestClient(app)


class FakeCortexResolver:
    model = "test-cortex-model"

    def resolve(self, _question: str) -> CortexIntent:
        return CortexIntent(
            metric_name="ON_TIME_DELIVERY_RATE",
            period_mode="LATEST_MONTH",
        )


class UnsupportedCortexResolver:
    model = "test-cortex-model"

    def resolve(self, _question: str) -> CortexIntent:
        return CortexIntent(metric_name="UNSUPPORTED", period_mode="ALL")


def test_same_metric_is_identical_across_personas() -> None:
    responses = [
        client.post(
            "/api/chat",
            json={
                "question": "What is on-time delivery this month?",
                "persona": persona,
            },
        )
        for persona in ("planning", "procurement", "logistics")
    ]

    assert all(response.status_code == 200 for response in responses)
    payloads = [response.json() for response in responses]
    metric_signatures = [
        (
            payload["metrics"],
            payload["evidence"],
            payload["sql"],
            payload["rows"],
        )
        for payload in payloads
    ]
    assert metric_signatures[0] == metric_signatures[1] == metric_signatures[2]
    assert len({payload["answer"] for payload in payloads}) == 3


def test_unsupported_question_does_not_generate_sql() -> None:
    response = client.post(
        "/api/chat",
        json={"question": "Delete all supply records", "persona": "planning"},
    )

    assert response.status_code == 422
    assert "Ask about" in response.json()["detail"]


def test_cortex_interprets_flexible_question_before_governed_query() -> None:
    app.dependency_overrides[get_cortex_intent_resolver] = FakeCortexResolver
    try:
        response = client.post(
            "/api/chat",
            json={
                "question": "Are vendors keeping their promises lately?",
                "persona": "procurement",
            },
        )
    finally:
        app.dependency_overrides[get_cortex_intent_resolver] = lambda: None

    assert response.status_code == 200
    payload = response.json()
    assert payload["interpretation_source"] == "cortex"
    assert payload["model"] == "test-cortex-model"
    assert payload["metrics"][0]["name"] == "ON_TIME_DELIVERY_RATE"
    assert payload["evidence"]["period"] == "September 2026"


def test_cortex_rejects_destructive_request_with_metric_keywords() -> None:
    app.dependency_overrides[
        get_cortex_intent_resolver
    ] = UnsupportedCortexResolver
    try:
        response = client.post(
            "/api/chat",
            json={
                "question": "Delete all on-time delivery records",
                "persona": "planning",
            },
        )
    finally:
        app.dependency_overrides[get_cortex_intent_resolver] = lambda: None

    assert response.status_code == 422
    assert "Ask about" in response.json()["detail"]


def test_persona_is_restricted_to_known_roles() -> None:
    response = client.post(
        "/api/chat",
        json={"question": "What is OTD?", "persona": "administrator"},
    )

    assert response.status_code == 422