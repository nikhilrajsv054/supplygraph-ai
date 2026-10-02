USE ROLE ACCOUNTADMIN;
USE WAREHOUSE SUPPLYGRAPH_WH;
USE DATABASE SUPPLYGRAPH;
USE SCHEMA RAW;

TRUNCATE TABLE QUALITY_EVENTS;
TRUNCATE TABLE INVENTORY;
TRUNCATE TABLE SHIPMENTS;
TRUNCATE TABLE ORDERS;

INSERT INTO ORDERS (
    order_id,
    customer_id,
    plant_id,
    part_id,
    order_date,
    required_date,
    status,
    quantity,
    fulfilled_quantity
)
SELECT
    'O' || LPAD(n::VARCHAR, 5, '0'),
    'C' || LPAD(customer_num::VARCHAR, 4, '0'),
    'PL' || LPAD(plant_num::VARCHAR, 2, '0'),
    'P' || LPAD(part_num::VARCHAR, 4, '0'),
    order_date,
    DATEADD(DAY, 5 + MOD(n, 16), order_date),
    CASE
        WHEN DATEADD(DAY, 5 + MOD(n, 16), order_date) > '2026-09-30'::DATE
            THEN 'OPEN'
        WHEN part_num IN (12, 44, 87, 156, 233)
            AND plant_num IN (3, 8)
            THEN 'AT_RISK'
        ELSE 'FULFILLED'
    END,
    10 + MOD(n * 23, 500),
    CASE
        WHEN DATEADD(DAY, 5 + MOD(n, 16), order_date) > '2026-09-30'::DATE
            THEN FLOOR((10 + MOD(n * 23, 500)) * (40 + MOD(n, 51)) / 100.0)
        WHEN part_num IN (12, 44, 87, 156, 233)
            AND plant_num IN (3, 8)
            THEN FLOOR((10 + MOD(n * 23, 500)) * (55 + MOD(n, 31)) / 100.0)
        ELSE 10 + MOD(n * 23, 500)
    END
FROM (
    SELECT
        n,
        MOD(n * 17, 500) + 1 AS customer_num,
        MOD(n * 3, 10) + 1 AS plant_num,
        MOD(n * 13, 300) + 1 AS part_num,
        DATEADD(DAY, -MOD(n * 11, 120), '2026-09-30'::DATE) AS order_date
    FROM (
        SELECT ROW_NUMBER() OVER (ORDER BY SEQ4()) AS n
        FROM TABLE(GENERATOR(ROWCOUNT => 10000))
    )
);

INSERT INTO SHIPMENTS (
    shipment_id,
    supplier_id,
    part_id,
    plant_id,
    shipment_date,
    expected_date,
    actual_date,
    status,
    quantity,
    material_cost,
    freight_cost,
    duty_cost,
    insurance_cost,
    handling_cost,
    currency
)
SELECT
    'SH' || LPAD(n::VARCHAR, 5, '0'),
    'S' || LPAD(supplier_num::VARCHAR, 3, '0'),
    'P' || LPAD(part_num::VARCHAR, 4, '0'),
    'PL' || LPAD(plant_num::VARCHAR, 2, '0'),
    shipment_date,
    expected_date,
    DATEADD(DAY, delay_days, expected_date),
    'DELIVERED',
    50 + MOD(n * 29, 950),
    ROUND((50 + MOD(n * 29, 950)) * (8 + MOD(part_num, 43)), 2),
    ROUND(75 + MOD(n * 17, 925), 2),
    ROUND(
        (50 + MOD(n * 29, 950)) * (8 + MOD(part_num, 43))
        * (0.05 + MOD(supplier_num, 4) * 0.01),
        2
    ),
    ROUND((50 + MOD(n * 29, 950)) * (8 + MOD(part_num, 43)) * 0.012, 2),
    ROUND(20 + MOD(n * 11, 180), 2),
    'USD'
FROM (
    SELECT
        timed.*,
        CASE
            WHEN supplier_num IN (7, 19, 42)
                THEN 4 + MOD(n, 7)
            WHEN plant_num IN (3, 8)
                AND shipment_date >= '2026-08-01'::DATE
                THEN 2 + MOD(n, 5)
            WHEN MOD(n, 6) = 0
                THEN 1 + MOD(n, 3)
            ELSE -MOD(n, 2)
        END AS delay_days
    FROM (
        SELECT
            base.*,
            DATEADD(DAY, 3 + MOD(n, 8), shipment_date) AS expected_date
        FROM (
            SELECT
                n,
                MOD(n * 7, 50) + 1 AS supplier_num,
                MOD(n * 13, 300) + 1 AS part_num,
                MOD(n * 3, 10) + 1 AS plant_num,
                DATEADD(
                    DAY,
                    -(20 + MOD(n * 7, 180)),
                    '2026-09-30'::DATE
                ) AS shipment_date
            FROM (
                SELECT ROW_NUMBER() OVER (ORDER BY SEQ4()) AS n
                FROM TABLE(GENERATOR(ROWCOUNT => 15000))
            )
        ) base
    ) timed
);

UPDATE SHIPMENTS
SET actual_date = DATEADD(
    DAY,
    -MOD(ABS(HASH(shipment_id)), 2),
    expected_date
)
WHERE supplier_id IN ('S007', 'S019', 'S042')
  AND MOD(ABS(HASH(shipment_id)), 100) < 35;

INSERT INTO INVENTORY
SELECT
    'PL' || LPAD(plant_num::VARCHAR, 2, '0'),
    'P' || LPAD(part_num::VARCHAR, 4, '0'),
    CASE
        WHEN snapshot_group = 0
            AND part_num IN (12, 44, 87, 156, 233)
            THEN 25 + MOD(n, 30)
        WHEN snapshot_group = 0
            AND plant_num IN (3, 8)
            AND MOD(part_num, 7) = 0
            THEN 45 + MOD(n, 50)
        ELSE 180 + MOD(n * 19, 800)
    END,
    25 + MOD(n * 11, 120),
    100 + MOD(part_num * 7, 150),
    DATEADD(DAY, -(snapshot_group * 7), '2026-09-30'::DATE)
FROM (
    SELECT
        n,
        MOD(n - 1, 10) + 1 AS plant_num,
        MOD(FLOOR((n - 1) / 10), 300) + 1 AS part_num,
        FLOOR((n - 1) / 3000) AS snapshot_group
    FROM (
        SELECT ROW_NUMBER() OVER (ORDER BY SEQ4()) AS n
        FROM TABLE(GENERATOR(ROWCOUNT => 5000))
    )
);

INSERT INTO QUALITY_EVENTS
SELECT
    'QE' || LPAD(event_num::VARCHAR, 5, '0'),
    supplier_id,
    part_id,
    shipment_id,
    CASE MOD(event_num, 5)
        WHEN 0 THEN 'DIMENSIONAL_DEFECT'
        WHEN 1 THEN 'DAMAGED_PACKAGING'
        WHEN 2 THEN 'MATERIAL_VARIANCE'
        WHEN 3 THEN 'FUNCTIONAL_FAILURE'
        ELSE 'CONTAMINATION'
    END,
    CASE
        WHEN supplier_id IN ('S007', 'S019', 'S042') THEN 'HIGH'
        WHEN MOD(event_num, 5) = 0 THEN 'MEDIUM'
        ELSE 'LOW'
    END,
    actual_date
FROM (
    SELECT
        shipments.*,
        ROW_NUMBER() OVER (
            ORDER BY
                CASE
                    WHEN supplier_id IN ('S007', 'S019', 'S042')
                         AND MOD(TO_NUMBER(SUBSTR(shipment_id, 3)), 3) = 0
                    THEN 0
                    ELSE 1
                END,
                HASH(shipment_id)
        ) AS event_num
    FROM SHIPMENTS AS shipments
)
WHERE event_num <= 3000;

SELECT 'ORDERS' AS entity, COUNT(*) AS row_count FROM ORDERS
UNION ALL
SELECT 'SHIPMENTS', COUNT(*) FROM SHIPMENTS
UNION ALL
SELECT 'INVENTORY', COUNT(*) FROM INVENTORY
UNION ALL
SELECT 'QUALITY_EVENTS', COUNT(*) FROM QUALITY_EVENTS
ORDER BY entity;