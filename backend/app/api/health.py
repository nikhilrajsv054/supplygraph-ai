from fastapi import APIRouter, Depends

from app.config import Settings, get_settings
from app.models.health import HealthResponse

router = APIRouter(tags=["health"])


@router.get("/health", response_model=HealthResponse)
def health(settings: Settings = Depends(get_settings)) -> HealthResponse:
    return HealthResponse(
        service=settings.app_name,
        environment=settings.app_environment,
        snowflake_configured=settings.snowflake_configured,
    )
