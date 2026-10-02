USE ROLE ACCOUNTADMIN;
USE WAREHOUSE SUPPLYGRAPH_WH;
USE DATABASE SUPPLYGRAPH;
USE SCHEMA RAW;

ALTER TABLE ORDERS
    ADD COLUMN IF NOT EXISTS fulfilled_quantity INTEGER;

ALTER TABLE SHIPMENTS
    ADD COLUMN IF NOT EXISTS material_cost NUMBER(18, 2);

ALTER TABLE SHIPMENTS
    ADD COLUMN IF NOT EXISTS freight_cost NUMBER(18, 2);

ALTER TABLE SHIPMENTS
    ADD COLUMN IF NOT EXISTS duty_cost NUMBER(18, 2);

ALTER TABLE SHIPMENTS
    ADD COLUMN IF NOT EXISTS insurance_cost NUMBER(18, 2);

ALTER TABLE SHIPMENTS
    ADD COLUMN IF NOT EXISTS handling_cost NUMBER(18, 2);

ALTER TABLE SHIPMENTS
    ADD COLUMN IF NOT EXISTS currency VARCHAR(3);

UPDATE ORDERS
SET fulfilled_quantity = CASE
    WHEN status = 'FULFILLED' THEN quantity
    WHEN status = 'AT_RISK' THEN FLOOR(
        quantity * (
            55 + MOD(TO_NUMBER(SUBSTR(order_id, 2)), 31)
        ) / 100.0
    )
    ELSE FLOOR(
        quantity * (
            40 + MOD(TO_NUMBER(SUBSTR(order_id, 2)), 51)
        ) / 100.0
    )
END;

UPDATE SHIPMENTS
SET
    material_cost = ROUND(
        quantity * (8 + MOD(TO_NUMBER(SUBSTR(part_id, 2)), 43)),
        2
    ),
    freight_cost = ROUND(
        75 + MOD(TO_NUMBER(SUBSTR(shipment_id, 3)) * 17, 925),
        2
    ),
    duty_cost = ROUND(
        quantity
        * (8 + MOD(TO_NUMBER(SUBSTR(part_id, 2)), 43))
        * (
            0.05
            + MOD(TO_NUMBER(SUBSTR(supplier_id, 2)), 4) * 0.01
        ),
        2
    ),
    insurance_cost = ROUND(
        quantity * (8 + MOD(TO_NUMBER(SUBSTR(part_id, 2)), 43)) * 0.012,
        2
    ),
    handling_cost = ROUND(
        20 + MOD(TO_NUMBER(SUBSTR(shipment_id, 3)) * 11, 180),
        2
    ),
    currency = 'USD';

SELECT
    COUNT(*) AS order_count,
    COUNT_IF(fulfilled_quantity IS NULL) AS orders_missing_fulfillment,
    ROUND(
        100.0 * SUM(fulfilled_quantity) / NULLIF(SUM(quantity), 0),
        2
    ) AS overall_fill_rate
FROM ORDERS;

SELECT
    COUNT(*) AS shipment_count,
    COUNT_IF(
        material_cost IS NULL
        OR freight_cost IS NULL
        OR duty_cost IS NULL
        OR insurance_cost IS NULL
        OR handling_cost IS NULL
        OR currency IS NULL
    ) AS shipments_missing_costs,
    ROUND(
        SUM(
            material_cost
            + freight_cost
            + duty_cost
            + insurance_cost
            + handling_cost
        ),
        2
    ) AS total_landed_cost,
    MIN(currency) AS currency
FROM SHIPMENTS;