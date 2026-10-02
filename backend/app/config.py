from functools import lru_cache
from typing import Optional

from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    app_name: str = "SupplyGraph AI API"
    app_environment: str = "development"
    api_prefix: str = "/api"
    frontend_origins: str = "http://localhost:5173"

    snowflake_account: Optional[str] = None
    snowflake_user: Optional[str] = None
    snowflake_password: Optional[str] = None
    snowflake_database: str = "SUPPLYGRAPH"
    snowflake_schema: str = "GOVERNANCE"
    snowflake_warehouse: str = "SUPPLYGRAPH_WH"
    snowflake_role: str = "SUPPLYGRAPH_APP"

    cortex_enabled: bool = True
    cortex_model: str = "llama3.1-70b"

    model_config = SettingsConfigDict(
        env_file=(".env", "../.env"),
        env_file_encoding="utf-8",
        extra="ignore",
    )

    @property
    def snowflake_configured(self) -> bool:
        return bool(
            self.snowflake_account
            and self.snowflake_user
            and self.snowflake_password
        )

    @property
    def allowed_origins(self) -> list[str]:
        return [
            origin.strip()
            for origin in self.frontend_origins.split(",")
            if origin.strip()
        ]


@lru_cache
def get_settings() -> Settings:
    return Settings()
