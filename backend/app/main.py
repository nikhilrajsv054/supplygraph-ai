from pathlib import Path

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
from fastapi.staticfiles import StaticFiles
from starlette.requests import Request

from app.api.analytics import router as analytics_router
from app.api.chat import router as chat_router
from app.api.health import router as health_router
from app.config import get_settings
from app.services.snowflake_service import DataAccessError


def create_app() -> FastAPI:
    settings = get_settings()
    app = FastAPI(
        title=settings.app_name,
        version="0.1.0",
        docs_url=f"{settings.api_prefix}/docs",
        openapi_url=f"{settings.api_prefix}/openapi.json",
    )
    app.add_middleware(
        CORSMiddleware,
        allow_origins=settings.allowed_origins,
        allow_credentials=True,
        allow_methods=["GET", "POST"],
        allow_headers=["*"],
    )
    app.include_router(health_router, prefix=settings.api_prefix)
    app.include_router(analytics_router, prefix=settings.api_prefix)
    app.include_router(chat_router, prefix=settings.api_prefix)

    @app.exception_handler(DataAccessError)
    async def data_access_error_handler(
        _request: Request,
        _exc: DataAccessError,
    ) -> JSONResponse:
        return JSONResponse(
            status_code=503,
            content={"detail": "Analytics service temporarily unavailable"},
        )

    static_directory = Path(__file__).resolve().parents[1] / "static"
    if static_directory.is_dir():
        app.mount(
            "/",
            StaticFiles(directory=static_directory, html=True),
            name="frontend",
        )

    return app


app = create_app()
