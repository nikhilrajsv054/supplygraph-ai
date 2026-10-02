from typing import Optional

from fastapi import APIRouter, Depends, HTTPException, Query

from app.dependencies import get_analytics_repository
from app.models.analytics import (
    DashboardSummary,
    OrderImpact,
    PartRisk,
    PlantPerformance,
    SupplierPerformance,
)
from app.services.analytics_repository import AnalyticsRepository

router = APIRouter(tags=["analytics"])


@router.get("/dashboard/summary", response_model=DashboardSummary)
def dashboard_summary(
    repository: AnalyticsRepository = Depends(get_analytics_repository),
) -> DashboardSummary:
    return DashboardSummary.model_validate(repository.get_dashboard_summary())


@router.get("/suppliers", response_model=list[SupplierPerformance])
def suppliers(
    limit: int = Query(10, ge=1, le=100),
    repository: AnalyticsRepository = Depends(get_analytics_repository),
) -> list[SupplierPerformance]:
    return [
        SupplierPerformance.model_validate(row)
        for row in repository.list_suppliers(limit)
    ]


@router.get(
    "/suppliers/{supplier_id}",
    response_model=SupplierPerformance,
)
def supplier_detail(
    supplier_id: str,
    repository: AnalyticsRepository = Depends(get_analytics_repository),
) -> SupplierPerformance:
    row = repository.get_supplier(supplier_id.upper())
    if row is None:
        raise HTTPException(status_code=404, detail="Supplier not found")
    return SupplierPerformance.model_validate(row)


@router.get("/parts/risk", response_model=list[PartRisk])
def part_risks(
    risk_status: Optional[str] = Query(None),
    limit: int = Query(20, ge=1, le=100),
    repository: AnalyticsRepository = Depends(get_analytics_repository),
) -> list[PartRisk]:
    normalized_status = risk_status.upper() if risk_status else None
    return [
        PartRisk.model_validate(row)
        for row in repository.list_part_risks(normalized_status, limit)
    ]


@router.get("/plants/performance", response_model=list[PlantPerformance])
def plant_performance(
    limit: int = Query(10, ge=1, le=100),
    repository: AnalyticsRepository = Depends(get_analytics_repository),
) -> list[PlantPerformance]:
    return [
        PlantPerformance.model_validate(row)
        for row in repository.list_plant_performance(limit)
    ]


@router.get("/orders/impact", response_model=list[OrderImpact])
def order_impacts(
    impact_status: str = Query("AFFECTED"),
    limit: int = Query(20, ge=1, le=100),
    repository: AnalyticsRepository = Depends(get_analytics_repository),
) -> list[OrderImpact]:
    return [
        OrderImpact.model_validate(row)
        for row in repository.list_order_impacts(impact_status.upper(), limit)
    ]
