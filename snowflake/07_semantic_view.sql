-- =============================================================================
-- Supply-Chain Semantic View  (ontology-faithful edition)
-- =============================================================================
-- All 8 requested entities are first-class logical tables, each backed by a
-- GOVERNANCE secure view.  ORDER_IMPACT is kept as an optional bridge table.
--
-- Entity-to-table mapping
-- -----------------------------------------------------------------------
--   Entity          Logical table   Physical view
-- -----------------------------------------------------------------------
--   Supplier        supplier        GOVERNANCE.SUPPLIER          (06)
--   Part            part            GOVERNANCE.PART              (06)
--   Plant           plant           GOVERNANCE.PLANT             (06)
--   Customer        customer        GOVERNANCE.CUSTOMER          (06)
--   Shipment        shipment        GOVERNANCE.SHIPMENT_LANDED_COST (04)
--   Order           orders          GOVERNANCE.ORDER_FULFILLMENT    (04)
--   Inventory       inventory       GOVERNANCE.PART_RISK            (04)
--   Quality Event   quality_event   GOVERNANCE.QUALITY_EVENT        (06)
--   (bridge)        ord_impact      GOVERNANCE.ORDER_IMPACT         (04)
-- -----------------------------------------------------------------------
--
-- On-Time Delivery Rate is computed from per-shipment EXPECTED_DATE,
-- ACTUAL_DATE, and SHIPMENT_STATUS so that time-period filters are correct.
--
-- No RAW objects are referenced.
-- =============================================================================

CREATE OR REPLACE SEMANTIC VIEW SUPPLYGRAPH.GOVERNANCE.SUPPLY_CHAIN_SV

  -- =========================================================================
  -- LOGICAL TABLES
  -- =========================================================================
  TABLES (

    -- ---- Dimension entities ------------------------------------------------

    supplier AS SUPPLYGRAPH.GOVERNANCE.SUPPLIER
      PRIMARY KEY (SUPPLIER_ID)
      WITH SYNONYMS = ('vendor', 'provider')
      COMMENT = 'Supplier master data',

    part AS SUPPLYGRAPH.GOVERNANCE.PART
      PRIMARY KEY (PART_ID)
      WITH SYNONYMS = ('component', 'material', 'SKU')
      COMMENT = 'Part / material catalog',

    plant AS SUPPLYGRAPH.GOVERNANCE.PLANT
      PRIMARY KEY (PLANT_ID)
      WITH SYNONYMS = ('facility', 'warehouse', 'site')
      COMMENT = 'Manufacturing and distribution plants',

    customer AS SUPPLYGRAPH.GOVERNANCE.CUSTOMER
      PRIMARY KEY (CUSTOMER_ID)
      WITH SYNONYMS = ('buyer', 'account')
      COMMENT = 'Customer master data',

    -- ---- Transactional / fact entities --------------------------------------

    shipment AS SUPPLYGRAPH.GOVERNANCE.SHIPMENT_LANDED_COST
      PRIMARY KEY (SHIPMENT_ID)
      WITH SYNONYMS = ('delivery', 'inbound shipment')
      COMMENT = 'Shipment-level cost breakdown and delivery tracking',

    orders AS SUPPLYGRAPH.GOVERNANCE.ORDER_FULFILLMENT
      PRIMARY KEY (ORDER_ID)
      WITH SYNONYMS = ('purchase order', 'customer order')
      COMMENT = 'Order fulfillment grain — one row per order',

    inventory AS SUPPLYGRAPH.GOVERNANCE.PART_RISK
      PRIMARY KEY (PLANT_ID, PART_ID)
      WITH SYNONYMS = ('stock', 'inventory position', 'part risk')
      COMMENT = 'Latest inventory snapshot with risk scoring by plant-part',

    quality_event AS SUPPLYGRAPH.GOVERNANCE.QUALITY_EVENT
      PRIMARY KEY (QUALITY_EVENT_ID)
      WITH SYNONYMS = ('defect', 'quality incident', 'NCR')
      COMMENT = 'Individual quality / defect events tied to a shipment',

    -- ---- Optional bridge ---------------------------------------------------

    ord_impact AS SUPPLYGRAPH.GOVERNANCE.ORDER_IMPACT
      PRIMARY KEY (ORDER_ID)
      WITH SYNONYMS = ('order impact', 'delay impact')
      COMMENT = 'Order-level shipment delay and impact assessment (bridge)'
  )

  -- =========================================================================
  -- RELATIONSHIPS
  -- =========================================================================
  RELATIONSHIPS (

    -- Shipment → dimensions
    shipment_to_supplier AS shipment (SUPPLIER_ID) REFERENCES supplier,
    shipment_to_part     AS shipment (PART_ID)     REFERENCES part,
    shipment_to_plant    AS shipment (PLANT_ID)    REFERENCES plant,

    -- Order → dimensions
    orders_to_customer AS orders (CUSTOMER_ID) REFERENCES customer,
    orders_to_part     AS orders (PART_ID)     REFERENCES part,
    orders_to_plant    AS orders (PLANT_ID)    REFERENCES plant,

    -- Inventory → dimensions
    inventory_to_part  AS inventory (PART_ID)  REFERENCES part,
    inventory_to_plant AS inventory (PLANT_ID) REFERENCES plant,

    -- Quality Event → shipment (supplier/part/plant reached via shipment)
    quality_event_to_shipment AS quality_event (SHIPMENT_ID) REFERENCES shipment,

    -- Bridge: Order Impact
    impact_to_orders   AS ord_impact (ORDER_ID)    REFERENCES orders,
    impact_to_supplier AS ord_impact (SUPPLIER_ID) REFERENCES supplier
  )

  -- =========================================================================
  -- FACTS  (row-level measurable values)
  -- =========================================================================
  FACTS (

    -- ---- Shipment costs & delivery flags -----------------------------------
    shipment.material_cost   AS shipment.MATERIAL_COST,
    shipment.freight_cost    AS shipment.FREIGHT_COST,
    shipment.duty_cost       AS shipment.DUTY_COST,
    shipment.insurance_cost  AS shipment.INSURANCE_COST,
    shipment.handling_cost   AS shipment.HANDLING_COST,

    shipment.received_qty AS shipment.RECEIVED_QUANTITY
      COMMENT = 'Units received in this shipment',

    -- Row-level delivery flags for shipment-level OTD calculation.
    -- PRIVATE so Cortex Analyst cannot select them directly; they exist
    -- only to feed the on_time_delivery_rate metric.
    PRIVATE shipment.is_delivered AS
      IFF(shipment.SHIPMENT_STATUS = 'DELIVERED'
          AND shipment.ACTUAL_DATE IS NOT NULL, 1, 0)
      COMMENT = 'Binary flag: 1 if shipment is delivered with an actual date',

    PRIVATE shipment.is_on_time AS
      IFF(shipment.SHIPMENT_STATUS = 'DELIVERED'
          AND shipment.ACTUAL_DATE IS NOT NULL
          AND shipment.ACTUAL_DATE <= shipment.EXPECTED_DATE, 1, 0)
      COMMENT = 'Binary flag: 1 if delivered on or before expected date',

    -- ---- Order fulfillment -------------------------------------------------
    orders.ordered_qty AS orders.ORDERED_QUANTITY
      COMMENT = 'Units originally ordered',

    orders.fulfilled_qty AS orders.FULFILLED_QUANTITY
      COMMENT = 'Units fulfilled against the order',

    orders.unfulfilled_qty AS orders.UNFULFILLED_QUANTITY
      COMMENT = 'Units remaining unfulfilled',

    -- ---- Order impact (bridge) ---------------------------------------------
    ord_impact.order_qty AS ord_impact.ORDER_QUANTITY,

    ord_impact.delay_days AS ord_impact.SHIPMENT_DELAY_DAYS
      COMMENT = 'Calendar days the linked shipment was late (0 if on time)',

    -- ---- Inventory / risk --------------------------------------------------
    inventory.available_qty     AS inventory.AVAILABLE_QUANTITY,
    inventory.reserved_qty      AS inventory.RESERVED_QUANTITY,
    inventory.net_available_qty AS inventory.NET_AVAILABLE_QUANTITY
      COMMENT = 'Available minus reserved quantity',
    inventory.reorder_point_qty AS inventory.REORDER_POINT,
    inventory.avg_daily_demand  AS inventory.AVERAGE_DAILY_DEMAND
      COMMENT = 'Rolling 30-day average daily demand',
    inventory.quality_event_count AS inventory.QUALITY_EVENT_COUNT
      COMMENT = 'Pre-aggregated quality-event count for this plant-part',
    inventory.risk_score_val AS inventory.RISK_SCORE
      COMMENT = 'Composite risk score (0-100)'
  )

  -- =========================================================================
  -- DIMENSIONS
  -- =========================================================================
  DIMENSIONS (

    -- ---- Supplier ----------------------------------------------------------
    supplier.supplier_name AS supplier.SUPPLIER_NAME
      COMMENT = 'Legal supplier name',
    supplier.region AS supplier.REGION
      WITH SYNONYMS = ('supplier region')
      COMMENT = 'Geographic region of the supplier',
    supplier.category AS supplier.CATEGORY
      WITH SYNONYMS = ('supplier category')
      COMMENT = 'Supplier classification category',
    supplier.status AS supplier.SUPPLIER_STATUS
      WITH SYNONYMS = ('supplier status')
      COMMENT = 'Current supplier status (ACTIVE, INACTIVE, etc.)',

    -- ---- Part --------------------------------------------------------------
    part.part_name AS part.PART_NAME,
    part.category AS part.CATEGORY
      WITH SYNONYMS = ('part category')
      COMMENT = 'Part classification category',
    part.criticality AS part.CRITICALITY
      WITH SYNONYMS = ('part criticality')
      COMMENT = 'Criticality tier of the part',
    part.lead_time_days AS part.LEAD_TIME_DAYS
      COMMENT = 'Standard supplier lead time in calendar days',

    -- ---- Plant -------------------------------------------------------------
    plant.plant_name AS plant.PLANT_NAME,
    plant.region AS plant.REGION
      WITH SYNONYMS = ('plant region')
      COMMENT = 'Geographic region of the plant',
    plant.capacity AS plant.CAPACITY
      COMMENT = 'Rated plant capacity',

    -- ---- Customer ----------------------------------------------------------
    customer.customer_name AS customer.CUSTOMER_NAME,
    customer.region AS customer.REGION
      WITH SYNONYMS = ('customer region')
      COMMENT = 'Geographic region of the customer',
    customer.segment AS customer.SEGMENT
      WITH SYNONYMS = ('customer segment')
      COMMENT = 'Market segment of the customer',

    -- ---- Shipment ----------------------------------------------------------
    shipment.shipment_date AS shipment.SHIPMENT_DATE
      COMMENT = 'Date the shipment was dispatched',
    shipment.expected_date AS shipment.EXPECTED_DATE
      COMMENT = 'Expected delivery date',
    shipment.actual_date AS shipment.ACTUAL_DATE
      COMMENT = 'Actual delivery date',
    shipment.shipment_status AS shipment.SHIPMENT_STATUS,
    shipment.currency AS shipment.CURRENCY,

    -- Shipment time hierarchy (on actual_date for delivery-period analysis)
    shipment.delivery_year    AS YEAR(shipment.ACTUAL_DATE)
      COMMENT = 'Delivery year',
    shipment.delivery_quarter AS QUARTER(shipment.ACTUAL_DATE)
      COMMENT = 'Delivery quarter (1-4)',
    shipment.delivery_month   AS MONTH(shipment.ACTUAL_DATE)
      COMMENT = 'Delivery month (1-12)',

    -- ---- Order -------------------------------------------------------------
    orders.order_date AS orders.ORDER_DATE
      COMMENT = 'Date the order was placed',
    orders.required_date AS orders.REQUIRED_DATE
      COMMENT = 'Customer-requested delivery date',
    orders.order_status AS orders.ORDER_STATUS,

    -- Order time hierarchy
    orders.order_year    AS YEAR(orders.ORDER_DATE)
      COMMENT = 'Order year',
    orders.order_quarter AS QUARTER(orders.ORDER_DATE)
      COMMENT = 'Order quarter (1-4)',
    orders.order_month   AS MONTH(orders.ORDER_DATE)
      COMMENT = 'Order month (1-12)',

    -- ---- Inventory ---------------------------------------------------------
    inventory.snapshot_date AS inventory.SNAPSHOT_DATE
      COMMENT = 'Date of the inventory snapshot',
    inventory.risk_status AS inventory.RISK_STATUS
      COMMENT = 'HEALTHY, AT_RISK, CRITICAL, or STOCKOUT',

    -- ---- Quality Event -----------------------------------------------------
    quality_event.defect_type AS quality_event.DEFECT_TYPE
      WITH SYNONYMS = ('defect category', 'failure mode')
      COMMENT = 'Classification of the defect',
    quality_event.severity AS quality_event.SEVERITY
      COMMENT = 'Severity level of the quality event',
    quality_event.event_date AS quality_event.EVENT_DATE
      COMMENT = 'Date the quality event was recorded',
    quality_event.event_year AS YEAR(quality_event.EVENT_DATE)
      COMMENT = 'Quality-event year',
    quality_event.event_quarter AS QUARTER(quality_event.EVENT_DATE)
      COMMENT = 'Quality-event quarter (1-4)',
    quality_event.event_month AS MONTH(quality_event.EVENT_DATE)
      COMMENT = 'Quality-event month (1-12)',

    -- ---- Order Impact (bridge) ---------------------------------------------
    ord_impact.impact_status AS ord_impact.IMPACT_STATUS
      WITH SYNONYMS = ('delay status')
      COMMENT = 'NOT_AFFECTED, AT_RISK, AFFECTED, or NO_LINKED_SHIPMENT'
  )

  -- =========================================================================
  -- METRICS  (governed, aggregatable measures)
  -- =========================================================================
  METRICS (

    -- 1. On-Time Delivery Rate (%)
    --    Computed at the SHIPMENT grain so time-period filters are correct.
    --    A shipment counts as on-time when ACTUAL_DATE <= EXPECTED_DATE.
    shipment.on_time_delivery_rate AS
      ROUND(
        100.0 * SUM(shipment.is_on_time)
              / NULLIF(SUM(shipment.is_delivered), 0),
        2
      )
      WITH SYNONYMS = ('OTD', 'OTD rate', 'on time delivery')
      COMMENT = 'Percentage of delivered shipments that arrived on or before the expected date',

    -- 2. Fill Rate (%)
    --    Ratio of fulfilled quantity to ordered quantity.
    orders.fill_rate AS
      ROUND(
        100.0 * SUM(orders.fulfilled_qty)
              / NULLIF(SUM(orders.ordered_qty), 0),
        2
      )
      WITH SYNONYMS = ('order fill rate', 'fulfilment rate')
      COMMENT = 'Percentage of ordered units that were fulfilled',

    -- 3. Days of Inventory
    --    Aggregate net available quantity divided by aggregate daily demand.
    inventory.days_of_inventory AS
      ROUND(
        SUM(inventory.net_available_qty)
        / NULLIF(SUM(inventory.avg_daily_demand), 0),
        1
      )
      WITH SYNONYMS = ('DOI', 'days of supply', 'inventory days')
      COMMENT = 'Weighted-average days of supply across the selected plant-part scope',

    -- 4. Total Landed Cost
    --    Sum of all cost components across shipments.
    shipment.total_landed_cost AS
      SUM(
        shipment.material_cost + shipment.freight_cost
        + shipment.duty_cost + shipment.insurance_cost
        + shipment.handling_cost
      )
      WITH SYNONYMS = ('TLC', 'total cost', 'landed cost')
      COMMENT = 'Aggregate material + freight + duty + insurance + handling cost',

    -- 5. Landed Cost per Unit
    --    Weighted-average cost per unit received.
    shipment.landed_cost_per_unit AS
      ROUND(
        SUM(
          shipment.material_cost + shipment.freight_cost
          + shipment.duty_cost + shipment.insurance_cost
          + shipment.handling_cost
        )
        / NULLIF(SUM(shipment.received_qty), 0),
        2
      )
      WITH SYNONYMS = ('unit cost', 'cost per unit')
      COMMENT = 'Weighted-average total landed cost per unit received',

    -- 6. Quality Event Count
    --    Row-level count from the quality_event entity.
    quality_event.quality_event_count AS
      COUNT(*)
      WITH SYNONYMS = ('defect count', 'NCR count')
      COMMENT = 'Number of quality events in the selected scope'
  )

  COMMENT = 'Governed supply-chain semantic view. Eight first-class entities (Supplier, Part, Plant, Customer, Shipment, Order, Inventory, Quality Event) plus an ORDER_IMPACT bridge. On-Time Delivery Rate is shipment-grain so time filters are correct. Sources: SUPPLYGRAPH.GOVERNANCE secure views only.'

  AI_SQL_GENERATION
    'When the user asks about cost, default to Total Landed Cost unless they specify a component. On-Time Delivery Rate and Fill Rate are percentages (0-100). Days of Inventory is a ratio metric — higher means more buffer. Use the orders table for customer-centric questions and shipment table for supplier/logistics questions. The inventory table reflects the latest snapshot; do not aggregate across snapshot dates. Quality events reach supplier and part through the shipment relationship. Dimension attributes for Supplier, Part, Plant, and Customer live on their own tables, not as denormalised columns on shipment or orders.'
;
