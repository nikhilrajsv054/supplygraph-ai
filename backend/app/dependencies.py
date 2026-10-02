from typing import Optional

from fastapi import Depends

from app.config import Settings, get_settings
from app.services.analytics_repository import (
    AnalyticsRepository,
    SnowflakeAnalyticsRepository,
)
from app.services.cortex_service import (
    CortexIntentResolver,
    SnowflakeCortexIntentResolver,
)
from app.services.snowflake_service import SnowflakeService


def get_analytics_repository(
    settings: Settings = Depends(get_settings),
) -> AnalyticsRepository:
    return SnowflakeAnalyticsRepository(SnowflakeService(settings))


def get_cortex_intent_resolver(
    settings: Settings = Depends(get_settings),
) -> Optional[CortexIntentResolver]:
    if not settings.cortex_enabled or not settings.snowflake_configured:
        return None
    return SnowflakeCortexIntentResolver(
        SnowflakeService(settings),
        settings.cortex_model,
    )
