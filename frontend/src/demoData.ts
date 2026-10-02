import type {
  ChatResponse,
  DashboardSummary,
  PartRisk,
  Persona,
  SupplierPerformance,
} from './types'

export const fallbackSummary: DashboardSummary = {
  supplier_count: 50,
  plant_count: 10,
  order_count: 10000,
  at_risk_part_count: 102,
  affected_order_count: 49,
  on_time_delivery_rate: 79.2,
  average_delivery_delay_days: 1.1,
  defect_rate: 20,
  fill_rate: 96.15,
  total_landed_cost: 256180682.9,
  currency: 'USD',
}

export const monthlyDelivery = [
  { month: 'Mar', rate: 85.6 },
  { month: 'Apr', rate: 81.94 },
  { month: 'May', rate: 79.21 },
  { month: 'Jun', rate: 81.94 },
  { month: 'Jul', rate: 80.27 },
  { month: 'Aug', rate: 71.41 },
  { month: 'Sep', rate: 56.91 },
]

export const fallbackSuppliers: SupplierPerformance[] = [
  { supplier_id: 'S007', supplier_name: 'Apex Components', region: 'Saudi Arabia', category: 'Chemicals', supplier_status: 'WATCHLIST', total_completed_shipments: 300, late_shipments: 197, on_time_delivery_rate: 34.33, average_delivery_delay_days: 4.7, defect_rate: 48.33 },
  { supplier_id: 'S021', supplier_name: 'Delta Industrial Supply', region: 'United Arab Emirates', category: 'Electronics', supplier_status: 'WATCHLIST', total_completed_shipments: 296, late_shipments: 169, on_time_delivery_rate: 42.91, average_delivery_delay_days: 4.1, defect_rate: 43.24 },
  { supplier_id: 'S034', supplier_name: 'Orion Materials', region: 'Qatar', category: 'Metals', supplier_status: 'WATCHLIST', total_completed_shipments: 301, late_shipments: 158, on_time_delivery_rate: 47.51, average_delivery_delay_days: 3.8, defect_rate: 41.86 },
  { supplier_id: 'S014', supplier_name: 'Gulf Precision Works', region: 'Oman', category: 'Machining', supplier_status: 'ACTIVE', total_completed_shipments: 287, late_shipments: 74, on_time_delivery_rate: 74.22, average_delivery_delay_days: 1.4, defect_rate: 18.82 },
  { supplier_id: 'S042', supplier_name: 'Crescent Polymers', region: 'Bahrain', category: 'Polymers', supplier_status: 'ACTIVE', total_completed_shipments: 305, late_shipments: 72, on_time_delivery_rate: 76.39, average_delivery_delay_days: 1.2, defect_rate: 16.72 },
]

export const fallbackPartRisks: PartRisk[] = [
  { plant_id: 'PL003', plant_name: 'Distribution Plant 03', part_id: 'P0042', part_name: 'Valve Assembly 042', category: 'Mechanical', criticality: 'CRITICAL', net_available_quantity: -84, reorder_point: 210, days_of_inventory: 0, risk_status: 'STOCKOUT', risk_score: 100 },
  { plant_id: 'PL008', plant_name: 'Distribution Plant 08', part_id: 'P0177', part_name: 'Sensor Module 177', category: 'Electronics', criticality: 'CRITICAL', net_available_quantity: -31, reorder_point: 180, days_of_inventory: 0, risk_status: 'STOCKOUT', risk_score: 100 },
  { plant_id: 'PL005', plant_name: 'Distribution Plant 05', part_id: 'P0205', part_name: 'Industrial Resin 205', category: 'Chemicals', criticality: 'HIGH', net_available_quantity: 18, reorder_point: 240, days_of_inventory: 2.4, risk_status: 'CRITICAL', risk_score: 90 },
  { plant_id: 'PL001', plant_name: 'Distribution Plant 01', part_id: 'P0119', part_name: 'Bearing Set 119', category: 'Mechanical', criticality: 'HIGH', net_available_quantity: 42, reorder_point: 195, days_of_inventory: 6.8, risk_status: 'CRITICAL', risk_score: 90 },
  { plant_id: 'PL009', plant_name: 'Distribution Plant 09', part_id: 'P0266', part_name: 'Control Board 266', category: 'Electronics', criticality: 'MEDIUM', net_available_quantity: 93, reorder_point: 160, days_of_inventory: 12.1, risk_status: 'CRITICAL', risk_score: 90 },
  { plant_id: 'PL006', plant_name: 'Distribution Plant 06', part_id: 'P0088', part_name: 'Seal Kit 088', category: 'Mechanical', criticality: 'HIGH', net_available_quantity: 118, reorder_point: 150, days_of_inventory: 19.2, risk_status: 'AT_RISK', risk_score: 70 },
]

export function demoChatResponse(question: string, persona: Persona): ChatResponse {
  const normalized = question.toLowerCase()
  const personaContext = {
    planning: 'For planning, use this governed result to adjust supply coverage and priorities.',
    procurement: 'For procurement, use this governed result to focus supplier and cost discussions.',
    logistics: 'For logistics, use this governed result to prioritize delivery-flow investigation.',
  }[persona]

  let metric = {
    name: 'ON_TIME_DELIVERY_RATE', display: 'On-Time Delivery Rate', value: 56.91, unit: '%', period: 'September 2026', definition: 'Percentage of completed shipments delivered on or before the expected date.', formula: 'on_time_shipments / total_completed_shipments * 100', source: 'GOVERNANCE.SUPPLIER_PERFORMANCE',
  }

  if (normalized.includes('fill')) {
    metric = { name: 'FILL_RATE', display: 'Fill Rate', value: 96.15, unit: '%', period: 'All available data', definition: 'Percentage of ordered quantity that has been fulfilled.', formula: 'SUM(fulfilled_quantity) / SUM(ordered_quantity) * 100', source: 'GOVERNANCE.ORDER_FULFILLMENT' }
  } else if (normalized.includes('landed') || normalized.includes('cost')) {
    metric = { name: 'TOTAL_LANDED_COST', display: 'Total Landed Cost', value: 256180682.9, unit: 'currency', period: 'All available data', definition: 'Total material, freight, duty, insurance and handling cost for received shipments.', formula: 'material_cost + freight_cost + duty_cost + insurance_cost + handling_cost', source: 'GOVERNANCE.SHIPMENT_LANDED_COST' }
  } else if (normalized.includes('affected') || normalized.includes('order')) {
    metric = { name: 'AFFECTED_ORDER_COUNT', display: 'Affected Order Count', value: 49, unit: 'orders', period: 'All available data', definition: 'Orders whose associated inbound shipment arrived after the required date.', formula: 'COUNT(order_id WHERE shipment_actual_date > order_required_date)', source: 'GOVERNANCE.ORDER_IMPACT' }
  }

  const formatted = metric.unit === '%' ? `${metric.value.toFixed(2)}%` : metric.value.toLocaleString('en-US')
  return {
    answer: `${metric.display} is ${formatted} for ${metric.period}. ${personaContext}`,
    intent: metric.name,
    persona,
    interpretation_source: 'deterministic',
    model: null,
    metrics: [{ name: metric.name, display_name: metric.display, value: metric.value, unit: metric.unit, currency: metric.unit === 'currency' ? 'USD' : null }],
    evidence: {
      canonical_metric: metric.name,
      definition: metric.definition,
      formula: metric.formula,
      source_object: metric.source,
      semantic_view: 'GOVERNANCE.SUPPLY_CHAIN_SV',
      time_semantics: 'Uses the approved governed time dimension.',
      period: metric.period,
      filters: {},
      business_owner: 'Supply Chain Operations',
    },
    sql: `SELECT governed_metric FROM ${metric.source}\nWHERE approved_semantic_definition = TRUE`,
    rows: [{ metric_value: metric.value, period: metric.period }],
  }
}