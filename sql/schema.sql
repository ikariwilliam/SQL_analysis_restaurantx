-- schema.sql
-- Ikota Eats: SQL Analytics Project
-- Core tables in dependency order (independent tables first, then dependents)

DROP TABLE IF EXISTS complaints;
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS staff;
DROP TABLE IF EXISTS riders;
DROP TABLE IF EXISTS suppliers;

CREATE TABLE suppliers (
    supplier_id      SERIAL PRIMARY KEY,
    supplier_name    VARCHAR(100),
    contact_name     VARCHAR(100),
    phone            VARCHAR(50),
    email            VARCHAR(100),
    supply_category  VARCHAR(50),
    supplied_items   TEXT,
    lead_time_days   INT
);

CREATE TABLE riders (
    rider_id    SERIAL PRIMARY KEY,
    rider_name  VARCHAR(100),
    phone       VARCHAR(50)
);

CREATE TABLE staff (
    staff_id    SERIAL PRIMARY KEY,
    staff_name  VARCHAR(100),
    role        VARCHAR(50)
);

CREATE TABLE customers (
    customer_id  SERIAL PRIMARY KEY,
    name         VARCHAR(100),
    phone        VARCHAR(50),
    email        VARCHAR(100),
    address      TEXT,
    axis         VARCHAR(50)
);

CREATE TABLE products (
    product_id    SERIAL PRIMARY KEY,
    product_name  VARCHAR(100),
    category      VARCHAR(50),
    unit_price    NUMERIC(10,2),
    unit_cost     NUMERIC(10,2),
    supplier_id   INT REFERENCES suppliers(supplier_id)
);

CREATE TABLE orders (
    order_id              SERIAL PRIMARY KEY,
    customer_id           INT REFERENCES customers(customer_id),
    staff_id              INT REFERENCES staff(staff_id),
    rider_id              INT REFERENCES riders(rider_id),
    axis                  VARCHAR(50),
    order_timestamp       TIMESTAMP,
    order_status          VARCHAR(20),
    subtotal_amount       NUMERIC(10,2),
    discount_amount       NUMERIC(10,2),
    final_amount_charged  NUMERIC(10,2)
);

CREATE TABLE order_items (
    item_id              SERIAL PRIMARY KEY,
    order_id             INT REFERENCES orders(order_id),
    product_id           INT REFERENCES products(product_id),
    quantity             INT,
    unit_price_at_sale   NUMERIC(10,2)
);

CREATE TABLE payments (
    payment_id      SERIAL PRIMARY KEY,
    order_id        INT REFERENCES orders(order_id),
    payment_method  VARCHAR(50),
    payment_status  VARCHAR(20),
    amount_paid     NUMERIC(10,2)
);

CREATE TABLE complaints (
    complaint_id      SERIAL PRIMARY KEY,
    order_id          INT REFERENCES orders(order_id),
    complaint_reason  VARCHAR(100),
    created_at        TIMESTAMP
);