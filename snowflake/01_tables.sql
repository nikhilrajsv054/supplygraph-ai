USE ROLE ACCOUNTADMIN;
USE WAREHOUSE SUPPLYGRAPH_WH;
USE DATABASE SUPPLYGRAPH;
USE SCHEMA RAW;

CREATE TABLE IF NOT EXISTS SUPPLIERS (
    supplier_id VARCHAR(20) PRIMARY KEY,
    supplier_name VARCHAR(200) NOT NULL,
    region VARCHAR(100),
    category VARCHAR(100),
    supplier_status VARCHAR(30)
);

CREATE TABLE IF NOT EXISTS PARTS (
    part_id VARCHAR(20) PRIMARY KEY,
    part_name VARCHAR(200) NOT NULL,
    category VARCHAR(100),
    criticality VARCHAR(20),
    lead_time_days INTEGER
);

CREATE TABLE IF NOT EXISTS PLANTS (
    plant_id VARCHAR(20) PRIMARY KEY,
    plant_name VARCHAR(200) NOT NULL,
    region VARCHAR(100),
    capacity NUMBER(18, 2)
);

CREATE TABLE IF NOT EXISTS CUSTOMERS (
    customer_id VARCHAR(20) PRIMARY KEY,
    customer_name VARCHAR(200) NOT NULL,
    region VARCHAR(100),
    segment VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS ORDERS (
    order_id VARCHAR(20) PRIMARY KEY,
    customer_id VARCHAR(20) NOT NULL,
    plant_id VARCHAR(20) NOT NULL,
    part_id VARCHAR(20) NOT NULL,
    order_date DATE NOT NULL,
    required_date DATE NOT NULL,
    status VARCHAR(30),
    quantity INTEGER,
    fulfilled_quantity INTEGER,
    FOREIGN KEY (customer_id) REFERENCES CUSTOMERS(customer_id),
    FOREIGN KEY (plant_id) REFERENCES PLANTS(plant_id),
    FOREIGN KEY (part_id) REFERENCES PARTS(part_id)
);

CREATE TABLE IF NOT EXISTS SHIPMENTS (
    shipment_id VARCHAR(20) PRIMARY KEY,
    supplier_id VARCHAR(20) NOT NULL,
    part_id VARCHAR(20) NOT NULL,
    plant_id VARCHAR(20) NOT NULL,
    shipment_date DATE NOT NULL,
    expected_date DATE NOT NULL,
    actual_date DATE,
    status VARCHAR(30),
    quantity INTEGER,
    material_cost NUMBER(18, 2),
    freight_cost NUMBER(18, 2),
    duty_cost NUMBER(18, 2),
    insurance_cost NUMBER(18, 2),
    handling_cost NUMBER(18, 2),
    currency VARCHAR(3),
    FOREIGN KEY (supplier_id) REFERENCES SUPPLIERS(supplier_id),
    FOREIGN KEY (part_id) REFERENCES PARTS(part_id),
    FOREIGN KEY (plant_id) REFERENCES PLANTS(plant_id)
);

CREATE TABLE IF NOT EXISTS INVENTORY (
    plant_id VARCHAR(20) NOT NULL,
    part_id VARCHAR(20) NOT NULL,
    available_quantity INTEGER,
    reserved_quantity INTEGER,
    reorder_point INTEGER,
    snapshot_date DATE NOT NULL,
    PRIMARY KEY (plant_id, part_id, snapshot_date),
    FOREIGN KEY (plant_id) REFERENCES PLANTS(plant_id),
    FOREIGN KEY (part_id) REFERENCES PARTS(part_id)
);

CREATE TABLE IF NOT EXISTS QUALITY_EVENTS (
    quality_event_id VARCHAR(20) PRIMARY KEY,
    supplier_id VARCHAR(20) NOT NULL,
    part_id VARCHAR(20) NOT NULL,
    shipment_id VARCHAR(20) NOT NULL,
    defect_type VARCHAR(100),
    severity VARCHAR(20),
    event_date DATE NOT NULL,
    FOREIGN KEY (supplier_id) REFERENCES SUPPLIERS(supplier_id),
    FOREIGN KEY (part_id) REFERENCES PARTS(part_id),
    FOREIGN KEY (shipment_id) REFERENCES SHIPMENTS(shipment_id)
);

SHOW TABLES IN SCHEMA SUPPLYGRAPH.RAW;