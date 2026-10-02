from typing import Any, Literal, Optional

from pydantic import BaseModel, Field


Persona = Literal["planning", "procurement", "logistics"]
InterpretationSource = Literal["cortex", "deterministic"]


class ChatRequest(BaseModel):
    question: str = Field(min_length=3, max_length=500)
    persona: Persona = "planning"


class MetricResult(BaseModel):
    name: str
    display_name: str
    value: float
    unit: str
    currency: Optional[str] = None


class Evidence(BaseModel):
    canonical_metric: str
    definition: str
    formula: str
    source_object: str
    semantic_view: str
    time_semantics: str
    period: str
    filters: dict[str, Any]
    business_owner: str


class ChatResponse(BaseModel):
    answer: str
    intent: str
    persona: Persona
    interpretation_source: InterpretationSource
    model: Optional[str] = None
    metrics: list[MetricResult]
    evidence: Evidence
    sql: str
    rows: list[dict[str, Any]]
