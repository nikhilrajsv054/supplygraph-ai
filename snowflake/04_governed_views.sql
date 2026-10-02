USE ROLE ACCOUNTADMIN;
USE WAREHOUSE SUPPLYGRAPH_WH;
USE DATABASE SUPPLYGRAPH;

CREATE OR REPLACE TABLE GOVERNANCE.METRIC_CATALOG (
    metric_name VARCHAR(100),
    display_name VARCHAR(200),
    definition VARCHAR(1000),
    formula VARCHAR(1000),
    source_object VARCHAR(200),
    time_semantics VARCHAR(500),
    business_owner VARCHAR(200)
);

INSERT INTO GOVERNANCE.METRIC_CATALOG VALUES
(
    'ON_TIME_DELIVERY_RATE',
    'On-Time Delivery Rate',
    'Percentage of completed shipments delivered on or before the expected date.',
    'on_time_shipments / total_completed_shipments * 100',
    'GOVERNANCE.SUPPLIER_PERFORMANCE',
    'Based on shipment expected date and actual delivery date.',
    'Supply Chain Operations'
),
(
    'AVERAGE_DELIVERY_DELAY',
    'Average Delivery Delay',
    'Average number of late days across completed shipments. On-time shipments contribute zero days.',
    'SUM(max(actual_date - expected_date, 0)) / total_completed_shipments',
    'GOVERNANCE.SUPPLIER_PERFORMANCE',
    'Based on completed shipments in the selected period.',
    'Supply Chain Operations'
),
(
    'DEFECT_RATE',
    'Defect Rate',
    'Percentage of completed shipments associated with at least one quality event.',
    'defective_shipments / total_completed_shipments * 100',
    'GOVERNANCE.SUPPLIER_PERFORMANCE',
    'Quality events are attributed using shipment identifiers.',
    'Supplier Quality'
),
(
    'NET_AVAILABLE_INVENTORY',
    'Net Available Inventory',
    'Inventory remaining after reserved quantity is deducted.',
    'available_quantity - reserved_quantity',
    'GOVERNANCE.PART_RISK',
    'Uses the latest inventory snapshot.',
    'Inventory Operations'
),
( 
    'DAYS_OF_INVENTORY',
    'Days of Inventory',
    'Estimated days before net available inventory is exhausted.',
    'net_available_inventory / average_daily_demand',
    'GOVERNANCE.PART_RISK',
    'Demand uses orders from the latest 30-day period.',
    'Inventory Operations'
),
(
    'AFFECTED_ORDER_COUNT',
    'Affected Order Count',
    'Orders whose associated inbound shipment arrived after the order required date.',
    'COUNT(order_id WHERE shipment_actual_date > order_required_date)',
    'GOVERNANCE.ORDER_IMPACT',
    'Uses the latest relevant inbound shipment expected before each order required date.',
    'Customer Operations'
),
(
    'FILL_RATE',
    'Fill Rate',
    'Percentage of ordered quantity that has been fulfilled for the selected order population.',
    'SUM(fulfilled_quantity) / SUM(ordered_quantity) * 100',
    'GOVERNANCE.ORDER_FULFILLMENT',
    'Uses orders and fulfillment quantities in the selected order-date period.',
    'Supply Planning'
),
(
    'TOTAL_LANDED_COST',
    'Total Landed Cost',
    'Total material, freight, duty, insurance and handling cost for received shipments.',
    'material_cost + freight_cost + duty_cost + insurance_cost + handling_cost',
    'GOVERNANCE.SHIPMENT_LANDED_COST',
    'Uses delivered shipments in the selected actual-delivery period and reported currency.',
    'Procurement Finance'
),
(
    'LANDED_COST_PER_UNIT',
    'Landed Cost per Unit',
    'Total landed cost divided by received shipment quantity.',
    'SUM(total_landed_cost) / SUM(received_quantity)',
    'GOVERNANCE.SHIPMENT_LANDED_COST',
    'Uses delivered shipments in the selected actual-delivery period and reported currency.',
    'Procurement Finance'
);

CREATE OR REPLACE VIEW ANALYTICS.SUPPLIER_METRICS AS
WITH shipment_metrics AS (
    SELECT
        supplier_id,
        COUNT_IF(status = 'DELIVERED' AND actual_date IS NOT NULL)
            AS total_completed_shipments,
        COUNT_IF(actual_date <= expected_date) AS on_time_shipments,
        COUNT_IF(actual_date > expected_date) AS late_shipments,
        AVG(
            IFF(
                actual_date > expected_date,
                DATEDIFF(DAY, expected_date, actual_date),
                0
            )
        ) AS average_delivery_delay_days,
        MAX(
            IFF(
                actual_date > expected_date,
                DATEDIFF(DAY, expected_date, actual_date),
                0
            )
        ) AS maximum_delivery_delay_days,
        MAX(actual_date) AS latest_delivery_date
    FROM RAW.SHIPMENTS
    GROUP BY supplier_id
),
quality_metrics AS (
    SELECT
        supplier_id,
        COUNT(DISTINCT shipment_id) AS defective_shipments
    FROM RAW.QUALITY_EVENTS
    GROUP BY supplier_id
)
SELECT
    shipment_metrics.*,
    COALESCE(quality_metrics.defective_shipments, 0) AS defective_shipments
FROM shipment_metrics
LEFT JOIN quality_metrics
    ON shipment_metrics.supplier_id = quality_metrics.supplier_id;

CREATE OR REPLACE SECURE VIEW GOVERNANCE.SUPPLIER_PERFORMANCE AS
SELECT
    suppliers.supplier_id,
    suppliers.supplier_name,
    suppliers.region,
    suppliers.category,
    suppliers.supplier_status,
    metrics.total_completed_shipments,
    metrics.on_time_shipments,
    metrics.late_shipments,
    ROUND(
        100.0 * metrics.on_time_shipments
        / NULLIF(metrics.total_completed_shipments, 0),
        2
    ) AS on_time_delivery_rate,
    ROUND(metrics.average_delivery_delay_days, 2)
        AS average_delivery_delay_days,
    metrics.maximum_delivery_delay_days,
    metrics.defective_shipments,
    ROUND(
        100.0 * metrics.defective_shipments
        / NULLIF(metrics.total_completed_shipments, 0),
        2
    ) AS defect_rate,
    metrics.latest_delivery_date
FROM RAW.SUPPLIERS AS suppliers
JOIN ANALYTICS.SUPPLIER_METRICS AS metrics
    ON suppliers.supplier_id = metrics.supplier_id;

CREATE OR REPLACE VIEW ANALYTICS.PART_INVENTORY_METRICS AS
WITH latest_inventory AS (
    SELECT *
    FROM RAW.INVENTORY
    WHERE snapshot_date = (
        SELECT MAX(snapshot_date)
        FROM RAW.INVENTORY
    )
),
recent_demand AS (
    SELECT
        plant_id,
        part_id,
        SUM(quantity) AS ordered_quantity
    FROM RAW.ORDERS
    WHERE order_date >= DATEADD(
        DAY,
        -30,
        (SELECT MAX(order_date) FROM RAW.ORDERS)
    )
    GROUP BY plant_id, part_id
),
quality AS (
    SELECT
        part_id,
        COUNT(*) AS quality_event_count
    FROM RAW.QUALITY_EVENTS
    GROUP BY part_id
)
SELECT
    inventory.plant_id,
    plants.plant_name,
    inventory.part_id,
    parts.part_name,
    parts.category,
    parts.criticality,
    parts.lead_time_days,
    inventory.available_quantity,
    inventory.reserved_quantity,
    inventory.available_quantity - inventory.reserved_quantity
        AS net_available_quantity,
    inventory.reorder_point,
    ROUND(COALESCE(demand.ordered_quantity, 0) / 30.0, 2)
        AS average_daily_demand,
    ROUND(
        (inventory.available_quantity - inventory.reserved_quantity)
        / NULLIF(demand.ordered_quantity / 30.0, 0),
        1
    ) AS projected_days_of_supply,
    COALESCE(quality.quality_event_count, 0) AS quality_event_count,
    inventory.snapshot_date
FROM latest_inventory AS inventory
JOIN RAW.PARTS AS parts ON inventory.part_id = parts.part_id
JOIN RAW.PLANTS AS plants ON inventory.plant_id = plants.plant_id
LEFT JOIN recent_demand AS demand
    ON inventory.plant_id = demand.plant_id
    AND inventory.part_id = demand.part_id
LEFT JOIN quality ON inventory.part_id = quality.part_id;

CREATE OR REPLACE SECURE VIEW GOVERNANCE.PART_RISK AS
SELECT
    plant_id,
    plant_name,
    part_id,
    part_name,
    category,
    criticality,
    lead_time_days,
    available_quantity,
    reserved_quantity,
    net_available_quantity,
    reorder_point,
    average_daily_demand,
    IFF(
        net_available_quantity <= 0,
        0,
        projected_days_of_supply
    ) AS days_of_inventory,
    IFF(
        net_available_quantity <= 0,
        0,
        projected_days_of_supply
    ) AS projected_days_of_supply,
    quality_event_count,
    snapshot_date,
    CASE
        WHEN net_available_quantity <= 0 THEN 'STOCKOUT'
        WHEN projected_days_of_supply <= 14 THEN 'CRITICAL'
        WHEN net_available_quantity <= reorder_point THEN 'AT_RISK'
        ELSE 'HEALTHY'
    END AS risk_status,
    CASE
        WHEN net_available_quantity <= 0 THEN 100
        WHEN projected_days_of_supply <= 14 THEN 90
        WHEN net_available_quantity <= reorder_point THEN 70
        ELSE 10
    END AS risk_score
FROM ANALYTICS.PART_INVENTORY_METRICS;

CREATE OR REPLACE VIEW ANALYTICS.ORDER_FULFILLMENT_METRICS AS
SELECT
    orders.order_id,
    orders.customer_id,
    orders.plant_id,
    orders.part_id,
    orders.order_date,
    orders.required_date,
    orders.status AS order_status,
    orders.quantity AS ordered_quantity,
    orders.fulfilled_quantity,
    GREATEST(orders.quantity - orders.fulfilled_quantity, 0)
        AS unfulfilled_quantity,
    ROUND(
        100.0 * orders.fulfilled_quantity / NULLIF(orders.quantity, 0),
        2
    ) AS order_fill_rate
FROM RAW.ORDERS AS orders;

CREATE OR REPLACE SECURE VIEW GOVERNANCE.ORDER_FULFILLMENT AS
SELECT
    fulfillment.order_id,
    customers.customer_id,
    customers.customer_name,
    customers.region AS customer_region,
    customers.segment AS customer_segment,
    plants.plant_id,
    plants.plant_name,
    plants.region AS plant_region,
    parts.part_id,
    parts.part_name,
    parts.category AS part_category,
    parts.criticality AS part_criticality,
    fulfillment.order_date,
    fulfillment.required_date,
    fulfillment.order_status,
    fulfillment.ordered_quantity,
    fulfillment.fulfilled_quantity,
    fulfillment.unfulfilled_quantity,
    fulfillment.order_fill_rate
FROM ANALYTICS.ORDER_FULFILLMENT_METRICS AS fulfillment
JOIN RAW.CUSTOMERS AS customers
    ON fulfillment.customer_id = customers.customer_id
JOIN RAW.PLANTS AS plants
    ON fulfillment.plant_id = plants.plant_id
JOIN RAW.PARTS AS parts
    ON fulfillment.part_id = parts.part_id;

CREATE OR REPLACE VIEW ANALYTICS.SHIPMENT_COST_METRICS AS
SELECT
    shipments.shipment_id,
    shipments.supplier_id,
    shipments.part_id,
    shipments.plant_id,
    shipments.shipment_date,
    shipments.expected_date,
    shipments.actual_date,
    shipments.status AS shipment_status,
    shipments.quantity AS received_quantity,
    shipments.material_cost,
    shipments.freight_cost,
    shipments.duty_cost,
    shipments.insurance_cost,
    shipments.handling_cost,
    shipments.currency,
    shipments.material_cost
        + shipments.freight_cost
        + shipments.duty_cost
        + shipments.insurance_cost
        + shipments.handling_cost AS total_landed_cost,
    ROUND(
        (
            shipments.material_cost
            + shipments.freight_cost
            + shipments.duty_cost
            + shipments.insurance_cost
            + shipments.handling_cost
        ) / NULLIF(shipments.quantity, 0),
        2
    ) AS landed_cost_per_unit
FROM RAW.SHIPMENTS AS shipments;

CREATE OR REPLACE SECURE VIEW GOVERNANCE.SHIPMENT_LANDED_COST AS
SELECT
    costs.shipment_id,
    suppliers.supplier_id,
    suppliers.supplier_name,
    suppliers.region AS supplier_region,
    suppliers.category AS supplier_category,
    parts.part_id,
    parts.part_name,
    parts.category AS part_category,
    plants.plant_id,
    plants.plant_name,
    plants.region AS plant_region,
    costs.shipment_date,
    costs.expected_date,
    costs.actual_date,
    costs.shipment_status,
    costs.received_quantity,
    costs.material_cost,
    costs.freight_cost,
    costs.duty_cost,
    costs.insurance_cost,
    costs.handling_cost,
    costs.total_landed_cost,
    costs.landed_cost_per_unit,
    costs.currency
FROM ANALYTICS.SHIPMENT_COST_METRICS AS costs
JOIN RAW.SUPPLIERS AS suppliers
    ON costs.supplier_id = suppliers.supplier_id
JOIN RAW.PARTS AS parts
    ON costs.part_id = parts.part_id
JOIN RAW.PLANTS AS plants
    ON costs.plant_id = plants.plant_id;

CREATE OR REPLACE VIEW ANALYTICS.ORDER_SHIPMENT_IMPACT AS
WITH ranked_shipments AS (
    SELECT
        orders.order_id,
        orders.customer_id,
        orders.plant_id,
        orders.part_id,
        orders.order_date,
        orders.required_date,
        orders.status AS order_status,
        orders.quantity AS order_quantity,
        shipments.shipment_id,
        shipments.supplier_id,
        shipments.expected_date AS shipment_expected_date,
        shipments.actual_date AS shipment_actual_date,
        GREATEST(
            DATEDIFF(DAY, shipments.expected_date, shipments.actual_date),
            0
        ) AS shipment_delay_days,
        ROW_NUMBER() OVER (
            PARTITION BY orders.order_id
            ORDER BY shipments.expected_date DESC, shipments.shipment_id DESC
        ) AS shipment_rank
    FROM RAW.ORDERS AS orders
    LEFT JOIN RAW.SHIPMENTS AS shipments
        ON orders.plant_id = shipments.plant_id
        AND orders.part_id = shipments.part_id
        AND shipments.expected_date <= orders.required_date
)
SELECT
    *,
    CASE
        WHEN shipment_id IS NULL THEN 'NO_LINKED_SHIPMENT'
        WHEN shipment_actual_date > required_date THEN 'AFFECTED'
        WHEN shipment_actual_date > shipment_expected_date THEN 'AT_RISK'
        ELSE 'NOT_AFFECTED'
    END AS impact_status
FROM ranked_shipments
WHERE shipment_rank = 1;

CREATE OR REPLACE SECURE VIEW GOVERNANCE.ORDER_IMPACT AS
SELECT
    impact.order_id,
    customers.customer_id,
    customers.customer_name,
    customers.segment AS customer_segment,
    plants.plant_id,
    plants.plant_name,
    parts.part_id,
    parts.part_name,
    parts.criticality AS part_criticality,
    impact.order_date,
    impact.required_date,
    impact.order_status,
    impact.order_quantity,
    impact.shipment_id,
    suppliers.supplier_id,
    suppliers.supplier_name,
    impact.shipment_expected_date,
    impact.shipment_actual_date,
    impact.shipment_delay_days,
    impact.impact_status
FROM ANALYTICS.ORDER_SHIPMENT_IMPACT AS impact
JOIN RAW.CUSTOMERS AS customers ON impact.customer_id = customers.customer_id
JOIN RAW.PLANTS AS plants ON impact.plant_id = plants.plant_id
JOIN RAW.PARTS AS parts ON impact.part_id = parts.part_id
LEFT JOIN RAW.SUPPLIERS AS suppliers
    ON impact.supplier_id = suppliers.supplier_id;

SELECT
    supplier_name,
    on_time_delivery_rate,
    average_delivery_delay_days,
    late_shipments,
    defect_rate
FROM GOVERNANCE.SUPPLIER_PERFORMANCE
ORDER BY average_delivery_delay_days DESC
LIMIT 10;