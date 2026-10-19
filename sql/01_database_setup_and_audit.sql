-- ============================================================
-- OLIST E-COMMERCE ANALYTICS
-- DATABASE SCHEMA
-- ============================================================

-- ------------------------------------------------------------
-- 1. CUSTOMERS
-- ------------------------------------------------------------

CREATE TABLE customers (
    customer_id VARCHAR(32) PRIMARY KEY,
    customer_unique_id VARCHAR(32) NOT NULL,
    customer_zip_code_prefix INT,
    customer_city VARCHAR(100),
    customer_state CHAR(2)
);


-- ------------------------------------------------------------
-- 2. ORDERS
-- ------------------------------------------------------------

CREATE TABLE orders (
    order_id VARCHAR(32) PRIMARY KEY,
    customer_id VARCHAR(32) NOT NULL,
    order_status VARCHAR(30),
    order_purchase_timestamp TIMESTAMP,
    order_approved_at TIMESTAMP,
    order_delivered_carrier_date TIMESTAMP,
    order_delivered_customer_date TIMESTAMP,
    order_estimated_delivery_date TIMESTAMP,

    CONSTRAINT fk_orders_customer
        FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
);


-- ------------------------------------------------------------
-- 3. PRODUCTS
-- ------------------------------------------------------------

CREATE TABLE products (
    product_id VARCHAR(32) PRIMARY KEY,
    product_category_name VARCHAR(100),
    product_name_length INT,
    product_description_length INT,
    product_photos_qty INT,
    product_weight_g INT,
    product_length_cm INT,
    product_height_cm INT,
    product_width_cm INT
);


-- ------------------------------------------------------------
-- 4. SELLERS
-- ------------------------------------------------------------

CREATE TABLE sellers (
    seller_id VARCHAR(32) PRIMARY KEY,
    seller_zip_code_prefix INT,
    seller_city VARCHAR(100),
    seller_state CHAR(2)
);


-- ------------------------------------------------------------
-- 5. ORDER ITEMS
-- ------------------------------------------------------------

CREATE TABLE order_items (
    order_id VARCHAR(32),
    order_item_id INT,
    product_id VARCHAR(32),
    seller_id VARCHAR(32),
    shipping_limit_date TIMESTAMP,
    price NUMERIC(12,2),
    freight_value NUMERIC(12,2),

    PRIMARY KEY (order_id, order_item_id),

    CONSTRAINT fk_order_items_order
        FOREIGN KEY (order_id)
        REFERENCES orders(order_id),

    CONSTRAINT fk_order_items_product
        FOREIGN KEY (product_id)
        REFERENCES products(product_id),

    CONSTRAINT fk_order_items_seller
        FOREIGN KEY (seller_id)
        REFERENCES sellers(seller_id)
);


-- ------------------------------------------------------------
-- 6. ORDER PAYMENTS
-- ------------------------------------------------------------

CREATE TABLE order_payments (
    order_id VARCHAR(32),
    payment_sequential INT,
    payment_type VARCHAR(30),
    payment_installments INT,
    payment_value NUMERIC(12,2),

    PRIMARY KEY (order_id, payment_sequential),

    CONSTRAINT fk_payments_order
        FOREIGN KEY (order_id)
        REFERENCES orders(order_id)
);


-- ------------------------------------------------------------
-- 7. ORDER REVIEWS
-- ------------------------------------------------------------

CREATE TABLE order_reviews (
    review_id VARCHAR(32),
    order_id VARCHAR(32),
    review_score INT,
    review_comment_title TEXT,
    review_comment_message TEXT,
    review_creation_date TIMESTAMP,
    review_answer_timestamp TIMESTAMP,

    PRIMARY KEY (review_id, order_id),

    CONSTRAINT fk_reviews_order
        FOREIGN KEY (order_id)
        REFERENCES orders(order_id)
);


-- ------------------------------------------------------------
-- 8. CATEGORY TRANSLATION
-- ------------------------------------------------------------

CREATE TABLE category_translation (
    product_category_name VARCHAR(100) PRIMARY KEY,
    product_category_name_english VARCHAR(100)
);


-- ------------------------------------------------------------
-- 9. GEOLOCATION
-- ------------------------------------------------------------

CREATE TABLE geolocation (
    geolocation_zip_code_prefix INT,
    geolocation_lat NUMERIC(10,7),
    geolocation_lng NUMERIC(10,7),
    geolocation_city VARCHAR(100),
    geolocation_state CHAR(2)
);


-- ------------------------------------------------------------
-- 10. MARKETING QUALIFIED LEADS
-- ------------------------------------------------------------

CREATE TABLE marketing_qualified_leads (
    mql_id VARCHAR(32) PRIMARY KEY,
    first_contact_date DATE,
    landing_page_id VARCHAR(100),
    origin VARCHAR(100)
);


-- ------------------------------------------------------------
-- 11. CLOSED DEALS
-- ------------------------------------------------------------

CREATE TABLE closed_deals (
    mql_id VARCHAR(32) PRIMARY KEY,
    seller_id VARCHAR(32),
    won_date DATE,
    business_segment VARCHAR(150),
    lead_type VARCHAR(100),
    lead_behaviour_profile VARCHAR(100),
    business_type VARCHAR(100),
    declared_monthly_revenue NUMERIC(15,2),
    declared_product_catalog_size INT,
    declared_product_catalog_length INT,
    average_stock NUMERIC(15,2),
    business_owner VARCHAR(100),
    business_state CHAR(2),
    business_city VARCHAR(100),
    business_postal_code INT,

    CONSTRAINT fk_closed_deals_mql
        FOREIGN KEY (mql_id)
        REFERENCES marketing_qualified_leads(mql_id)
);

SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
ORDER BY table_name;

SELECT COUNT(*) AS customer_count
FROM customers;

SELECT COUNT(*) AS product_count
FROM products;

SELECT
    COUNT(*) AS total_products,
    COUNT(product_category_name) AS products_with_category,
    COUNT(*) - COUNT(product_category_name) AS missing_category
FROM products;

SELECT COUNT(*) AS seller_count
FROM sellers;

SELECT
    COUNT(*) AS total_sellers,
    COUNT(DISTINCT seller_id) AS unique_sellers,
    COUNT(*) - COUNT(DISTINCT seller_id) AS duplicate_seller_ids
FROM sellers;

SELECT COUNT(*) AS category_count
FROM category_translation;

SELECT *
FROM category_translation
ORDER BY product_category_name
LIMIT 20;

SELECT COUNT(*) AS mql_count
FROM marketing_qualified_leads;

SELECT COUNT(*) AS order_count
FROM orders;

SELECT
    order_status,
    COUNT(*) AS order_count
FROM orders
GROUP BY order_status
ORDER BY order_count DESC;

SELECT COUNT(*) AS order_item_count
FROM order_items;
SELECT COUNT(DISTINCT order_id) AS unique_orders
FROM order_items;
SELECT
    ROUND(SUM(price), 2) AS total_product_revenue,
    ROUND(SUM(freight_value), 2) AS total_freight,
    ROUND(SUM(price + freight_value), 2) AS total_order_item_value
FROM order_items;

SELECT COUNT(*) AS payment_count
FROM order_payments;
SELECT COUNT(DISTINCT order_id) AS orders_with_payments
FROM order_payments;
SELECT
    payment_type,
    COUNT(*) AS payment_records,
    ROUND(SUM(payment_value), 2) AS payment_value
FROM order_payments
GROUP BY payment_type
ORDER BY payment_value DESC;

SELECT COUNT(*) AS review_count
FROM order_reviews;
SELECT
    review_score,
    COUNT(*) AS review_count,
    ROUND(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER (),
        2
    ) AS percentage
FROM order_reviews
GROUP BY review_score
ORDER BY review_score;
SELECT
    COUNT(*) AS total_reviews,
    COUNT(review_comment_title) AS reviews_with_title,
    COUNT(review_comment_message) AS reviews_with_message,
    COUNT(*) - COUNT(review_comment_title) AS missing_titles,
    COUNT(*) - COUNT(review_comment_message) AS missing_messages
FROM order_reviews;
SELECT *
FROM order_reviews
WHERE review_score NOT BETWEEN 1 AND 5;

SELECT COUNT(*) AS geolocation_rows
FROM geolocation;
SELECT COUNT(DISTINCT geolocation_zip_code_prefix) AS unique_zip_prefixes
FROM geolocation;
SELECT
    COUNT(*) AS total_rows,
    COUNT(*) - (
        SELECT COUNT(*)
        FROM (
            SELECT DISTINCT
                geolocation_zip_code_prefix,
                geolocation_lat,
                geolocation_lng,
                geolocation_city,
                geolocation_state
            FROM geolocation
        ) AS unique_locations
    ) AS duplicate_rows
FROM geolocation;
SELECT COUNT(DISTINCT geolocation_zip_code_prefix) AS unique_zip_prefixes
FROM geolocation;

CREATE TABLE closed_deals (
    mql_id VARCHAR(32) PRIMARY KEY,
    seller_id VARCHAR(32),
    sdr_id VARCHAR(32),
    sr_id VARCHAR(32),
    won_date TIMESTAMP,
    business_segment VARCHAR(150),
    lead_type VARCHAR(100),
    lead_behaviour_profile VARCHAR(100),
    has_company VARCHAR(20),
    has_gtin VARCHAR(20),
    average_stock VARCHAR(50),
    business_type VARCHAR(100),
    declared_product_catalog_size NUMERIC(15,2),
    declared_monthly_revenue NUMERIC(15,2),

    CONSTRAINT fk_closed_deals_mql
        FOREIGN KEY (mql_id)
        REFERENCES marketing_qualified_leads(mql_id)
);
SELECT COUNT(*) AS closed_deal_count
FROM closed_deals;

SELECT COUNT(*) AS orphan_mqls
FROM closed_deals cd
LEFT JOIN marketing_qualified_leads mql
    ON cd.mql_id = mql.mql_id
WHERE mql.mql_id IS NULL;
SELECT COUNT(*) AS orphan_sellers
FROM closed_deals cd
LEFT JOIN sellers s
    ON cd.seller_id = s.seller_id
WHERE s.seller_id IS NULL;

SELECT
    COUNT(*) AS total_closed_deals,
    COUNT(DISTINCT seller_id) AS unique_sellers_in_deals
FROM closed_deals;
SELECT
    COUNT(DISTINCT cd.seller_id) AS matching_sellers
FROM closed_deals cd
INNER JOIN sellers s
    ON cd.seller_id = s.seller_id;
	SELECT
    COUNT(DISTINCT cd.seller_id) AS unmatched_sellers
FROM closed_deals cd
LEFT JOIN sellers s
    ON cd.seller_id = s.seller_id
WHERE s.seller_id IS NULL;

SELECT COUNT(*) AS total_customers
FROM customers;

SELECT
    customer_id,
    COUNT(*) AS occurrences
FROM customers
GROUP BY customer_id
HAVING COUNT(*) > 1;

SELECT
    COUNT(*) AS total_rows,
    COUNT(*) - COUNT(customer_id) AS missing_customer_id,
    COUNT(*) - COUNT(customer_unique_id) AS missing_unique_id,
    COUNT(*) - COUNT(customer_zip_code_prefix) AS missing_zip,
    COUNT(*) - COUNT(customer_city) AS missing_city,
    COUNT(*) - COUNT(customer_state) AS missing_state
FROM customers;

SELECT
    COUNT(*) AS customer_records,
    COUNT(DISTINCT customer_unique_id) AS unique_customers
FROM customers;

SELECT DISTINCT customer_state
FROM customers
WHERE customer_state IS NULL
   OR LENGTH(customer_state) <> 2
ORDER BY customer_state;

SELECT COUNT(*) AS orphan_orders
FROM orders o
LEFT JOIN customers c
    ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

-- Orders Data Quality Audit

SELECT COUNT(*) AS total_orders
FROM orders;
SELECT
    order_id,
    COUNT(*) AS occurrences
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1;

SELECT
    COUNT(*) AS total_orders,
    COUNT(*) - COUNT(order_purchase_timestamp) AS missing_purchase,
    COUNT(*) - COUNT(order_approved_at) AS missing_approved,
    COUNT(*) - COUNT(order_delivered_carrier_date) AS missing_carrier,
    COUNT(*) - COUNT(order_delivered_customer_date) AS missing_delivery,
    COUNT(*) - COUNT(order_estimated_delivery_date) AS missing_estimated_delivery
FROM orders;

SELECT
    order_status,
    COUNT(*) AS order_count,
    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),
        2
    ) AS percentage
FROM orders
GROUP BY order_status
ORDER BY order_count DESC;

SELECT COUNT(*) AS invalid_approval_dates
FROM orders
WHERE order_approved_at < order_purchase_timestamp;

SELECT COUNT(*) AS invalid_carrier_dates
FROM orders
WHERE order_delivered_carrier_date < order_approved_at;

SELECT COUNT(*) AS invalid_delivery_dates
FROM orders
WHERE order_delivered_customer_date < order_purchase_timestamp;

SELECT COUNT(*) AS invalid_estimated_dates
FROM orders
WHERE order_estimated_delivery_date < order_purchase_timestamp;

SELECT
    order_status,
    COUNT(*) AS invalid_orders
FROM orders
WHERE order_delivered_carrier_date < order_approved_at
GROUP BY order_status
ORDER BY invalid_orders DESC;
SELECT
    order_status,
    COUNT(*) AS missing_approved_date
FROM orders
WHERE order_approved_at IS NULL
GROUP BY order_status
ORDER BY missing_approved_date DESC;
