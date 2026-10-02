from typing import Optional

from fastapi import APIRouter, Depends, HTTPException

from app.dependencies import (
    get_analytics_repository,
    get_cortex_intent_resolver,
)
from app.models.chat import ChatRequest, ChatResponse
from app.services.analytics_repository import AnalyticsRepository
from app.services.chat_service import ChatService, UnsupportedQuestionError
from app.services.cortex_service import CortexIntentResolver

router = APIRouter(tags=["conversation"])


@router.post("/chat", response_model=ChatResponse)
def chat(
    request: ChatRequest,
    repository: AnalyticsRepository = Depends(get_analytics_repository),
    intent_resolver: Optional[CortexIntentResolver] = Depends(
        get_cortex_intent_resolver
    ),
) -> ChatResponse:
    try:
        return ChatService(repository, intent_resolver).answer(request)
    except UnsupportedQuestionError as exc:
        raise HTTPException(status_code=422, detail=str(exc)) from exc
