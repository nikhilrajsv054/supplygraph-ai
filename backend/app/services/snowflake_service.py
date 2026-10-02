from contextlib import closing
from typing import Any, Mapping, Optional

from app.config import Settings


class DataAccessError(RuntimeError):
    pass


class SnowflakeService:
    def __init__(self, settings: Settings) -> None:
        self._settings = settings

    def execute(
        self,
        sql: str,
        parameters: Optional[Mapping[str, Any]] = None,
    ) -> list[dict[str, Any]]:
        if not self._settings.snowflake_configured:
            raise DataAccessError("Snowflake credentials are not configured")

        try:
            import snowflake.connector
            from snowflake.connector import DictCursor
            from snowflake.connector.errors import Error as SnowflakeError
        except (ImportError, OSError) as exc:
            raise DataAccessError("Snowflake connector is unavailable") from exc

        try:
            with closing(
                snowflake.connector.connect(
                    account=self._settings.snowflake_account,
                    user=self._settings.snowflake_user,
                    password=self._settings.snowflake_password,
                    warehouse=self._settings.snowflake_warehouse,
                    database=self._settings.snowflake_database,
                    schema=self._settings.snowflake_schema,
                    role=self._settings.snowflake_role,
                    login_timeout=15,
                    network_timeout=30,
                    session_parameters={"QUERY_TAG": "SUPPLYGRAPH_AI"},
                )
            ) as connection:
                with closing(connection.cursor(DictCursor)) as cursor:
                    cursor.execute(sql, parameters or {})
                    return [
                        {str(key).lower(): value for key, value in row.items()}
                        for row in cursor.fetchall()
                    ]
        except SnowflakeError as exc:
            raise DataAccessError("Snowflake query failed") from exc
