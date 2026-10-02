USE ROLE ACCOUNTADMIN;
USE WAREHOUSE SUPPLYGRAPH_WH;
USE DATABASE SUPPLYGRAPH;
USE SCHEMA RAW;

TRUNCATE TABLE SUPPLIERS;
TRUNCATE TABLE PARTS;
TRUNCATE TABLE PLANTS;
TRUNCATE TABLE CUSTOMERS;

INSERT INTO SUPPLIERS
SELECT
    'S' || LPAD(n::VARCHAR, 3, '0'),
    CASE n
        WHEN 7 THEN 'Apex Components'
        WHEN 19 THEN 'Delta Industrial Supply'
        WHEN 42 THEN 'Orion Materials'
        ELSE 'Synthetic Supplier ' || LPAD(n::VARCHAR, 3, '0')
    END,
    CASE MOD(n, 5)
        WHEN 0 THEN 'India'
        WHEN 1 THEN 'UAE'
        WHEN 2 THEN 'Saudi Arabia'
        WHEN 3 THEN 'Qatar'
        ELSE 'Oman'
    END,
    CASE MOD(n, 4)
        WHEN 0 THEN 'Electronics'
        WHEN 1 THEN 'Metals'
        WHEN 2 THEN 'Packaging'
        ELSE 'Chemicals'
    END,
    IFF(n IN (7, 19, 42), 'WATCHLIST', 'ACTIVE')
FROM (
    SELECT ROW_NUMBER() OVER (ORDER BY SEQ4()) AS n
    FROM TABLE(GENERATOR(ROWCOUNT => 50))
);

INSERT INTO PARTS
SELECT
    'P' || LPAD(n::VARCHAR, 4, '0'),
    'Synthetic Part ' || LPAD(n::VARCHAR, 4, '0'),
    CASE MOD(n, 4)
        WHEN 0 THEN 'Electronics'
        WHEN 1 THEN 'Metals'
        WHEN 2 THEN 'Packaging'
        ELSE 'Chemicals'
    END,
    CASE
        WHEN n IN (12, 44, 87, 156, 233) THEN 'CRITICAL'
        WHEN MOD(n, 5) = 0 THEN 'HIGH'
        ELSE 'STANDARD'
    END,
    3 + MOD(n, 28)
FROM (
    SELECT ROW_NUMBER() OVER (ORDER BY SEQ4()) AS n
    FROM TABLE(GENERATOR(ROWCOUNT => 300))
);

INSERT INTO PLANTS
SELECT
    'PL' || LPAD(n::VARCHAR, 2, '0'),
    'Distribution Plant ' || LPAD(n::VARCHAR, 2, '0'),
    CASE MOD(n, 5)
        WHEN 0 THEN 'India'
        WHEN 1 THEN 'UAE'
        WHEN 2 THEN 'Saudi Arabia'
        WHEN 3 THEN 'Qatar'
        ELSE 'Oman'
    END,
    6000 + (n * 850)
FROM (
    SELECT ROW_NUMBER() OVER (ORDER BY SEQ4()) AS n
    FROM TABLE(GENERATOR(ROWCOUNT => 10))
);

INSERT INTO CUSTOMERS
SELECT
    'C' || LPAD(n::VARCHAR, 4, '0'),
    'Synthetic Customer ' || LPAD(n::VARCHAR, 4, '0'),
    CASE MOD(n, 5)
        WHEN 0 THEN 'India'
        WHEN 1 THEN 'UAE'
        WHEN 2 THEN 'Saudi Arabia'
        WHEN 3 THEN 'Qatar'
        ELSE 'Oman'
    END,
    CASE MOD(n, 3)
        WHEN 0 THEN 'Enterprise'
        WHEN 1 THEN 'Mid-Market'
        ELSE 'Small Business'
    END
FROM (
    SELECT ROW_NUMBER() OVER (ORDER BY SEQ4()) AS n
    FROM TABLE(GENERATOR(ROWCOUNT => 500))
);

SELECT 'SUPPLIERS' AS entity, COUNT(*) AS row_count FROM SUPPLIERS
UNION ALL
SELECT 'PARTS', COUNT(*) FROM PARTS
UNION ALL
SELECT 'PLANTS', COUNT(*) FROM PLANTS
UNION ALL
SELECT 'CUSTOMERS', COUNT(*) FROM CUSTOMERS
ORDER BY entity;