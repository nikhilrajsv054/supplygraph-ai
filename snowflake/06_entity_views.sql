-- =============================================================================
-- Governed Entity Views
-- =============================================================================
-- Thin SECURE views over RAW dimension and event tables.
-- These establish the governance boundary so the semantic view in
-- 07_semantic_view.sql can model every entity as a first-class logical table
-- without referencing RAW directly.
--
-- Existing GOVERNANCE views (SUPPLIER_PERFORMANCE, SHIPMENT_LANDED_COST,
-- ORDER_FULFILLMENT, ORDER_IMPACT, PART_RISK) remain untouched; they carry
-- pre-computed metrics and enriched joins that the semantic view still needs.
-- =============================================================================

USE ROLE ACCOUNTADMIN;
USE WAREHOUSE SUPPLYGRAPH_WH;
USE DATABASE SUPPLYGRAPH;

-- ---------------------------------------------------------------------------
-- Supplier  (pure dimension)
-- ---------------------------------------------------------------------------
CREATE OR REPLACE SECURE VIEW GOVERNANCE.SUPPLIER AS
SELECT
    supplier_id,
    supplier_name,
    region,
    category,
    supplier_status
FROM RAW.SUPPLIERS;

-- ---------------------------------------------------------------------------
-- Part  (pure dimension)
-- ---------------------------------------------------------------------------
CREATE OR REPLACE SECURE VIEW GOVERNANCE.PART AS
SELECT
    part_id,
    part_name,
    category,
    criticality,
    lead_time_days
FROM RAW.PARTS;

-- ---------------------------------------------------------------------------
-- Plant  (pure dimension)
-- ---------------------------------------------------------------------------
CREATE OR REPLACE SECURE VIEW GOVERNANCE.PLANT AS
SELECT
    plant_id,
    plant_name,
    region,
    capacity
FROM RAW.PLANTS;

-- ---------------------------------------------------------------------------
-- Customer  (pure dimension)
-- ---------------------------------------------------------------------------
CREATE OR REPLACE SECURE VIEW GOVERNANCE.CUSTOMER AS
SELECT
    customer_id,
    customer_name,
    region,
    segment
FROM RAW.CUSTOMERS;

-- ---------------------------------------------------------------------------
-- Quality Event  (event / fact grain)
-- ---------------------------------------------------------------------------
CREATE OR REPLACE SECURE VIEW GOVERNANCE.QUALITY_EVENT AS
SELECT
    quality_event_id,
    supplier_id,
    part_id,
    shipment_id,
    defect_type,
    severity,
    event_date
FROM RAW.QUALITY_EVENTS;
