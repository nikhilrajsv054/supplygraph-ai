from datetime import date
from typing import Optional

from pydantic import BaseModel


class DashboardSummary(BaseModel):
    supplier_count: int
    plant_count: int
    order_count: int
    at_risk_part_count: int
    affected_order_count: int
    on_time_delivery_rate: float
    average_delivery_delay_days: float
    defect_rate: float
    fill_rate: float
    total_landed_cost: float
    currency: str


class SupplierPerformance(BaseModel):
    supplier_id: str
    supplier_name: str
    region: str
    category: str
    supplier_status: str
    total_completed_shipments: int
    late_shipments: int
    on_time_delivery_rate: float
    average_delivery_delay_days: float
    defect_rate: float


class PartRisk(BaseModel):
    plant_id: str
    plant_name: str
    part_id: str
    part_name: str
    category: str
    criticality: str
    net_available_quantity: int
    reorder_point: int
    days_of_inventory: Optional[float]
    risk_status: str
    risk_score: int


class PlantPerformance(BaseModel):
    plant_id: str
    plant_name: str
    plant_region: str
    shipment_count: int
    on_time_delivery_rate: float
    average_delivery_delay_days: float
    total_landed_cost: float
    currency: str


class OrderImpact(BaseModel):
    order_id: str
    customer_name: str
    supplier_name: Optional[str]
    part_name: str
    plant_name: str
    required_date: date
    shipment_actual_date: Optional[date]
    shipment_delay_days: Optional[int]
    impact_status: str
