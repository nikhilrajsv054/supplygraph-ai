export type Persona = 'planning' | 'procurement' | 'logistics'

export interface DashboardSummary {
  supplier_count: number
  plant_count: number
  order_count: number
  at_risk_part_count: number
  affected_order_count: number
  on_time_delivery_rate: number
  average_delivery_delay_days: number
  defect_rate: number
  fill_rate: number
  total_landed_cost: number
  currency: string
}

export interface SupplierPerformance {
  supplier_id: string
  supplier_name: string
  region: string
  category: string
  supplier_status: string
  total_completed_shipments: number
  late_shipments: number
  on_time_delivery_rate: number
  average_delivery_delay_days: number
  defect_rate: number
}

export interface PartRisk {
  plant_id: string
  plant_name: string
  part_id: string
  part_name: string
  category: string
  criticality: string
  net_available_quantity: number
  reorder_point: number
  days_of_inventory: number | null
  risk_status: string
  risk_score: number
}

export interface ChatResponse {
  answer: string
  intent: string
  persona: Persona
  interpretation_source: 'cortex' | 'deterministic'
  model: string | null
  metrics: Array<{
    name: string
    display_name: string
    value: number
    unit: string
    currency: string | null
  }>
  evidence: {
    canonical_metric: string
    definition: string
    formula: string
    source_object: string
    semantic_view: string
    time_semantics: string
    period: string
    filters: Record<string, unknown>
    business_owner: string
  }
  sql: string
  rows: Array<Record<string, unknown>>
}