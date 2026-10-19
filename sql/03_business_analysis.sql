
/*
==========================================================
Olist E-commerce Analytics
Business Analysis SQL
==========================================================

Purpose:
Business-focused SQL analysis covering:
- Revenue and sales performance
- Product and category analysis
- Seller performance
- Delivery and logistics
- Customer experience
- Marketing funnel
- Advanced SQL techniques

Database:
olist_ecommerce_analytics

Author:
Sharon Reddy
==========================================================
*/


-- =========================================================
-- SECTION 1: MONTHLY REVENUE AND ORDER GROWTH
-- Business question:
-- How are revenue and order volumes changing month by month?
-- Techniques: CTE, aggregation, LAG, percentage growth
-- =========================================================

WITH monthly_metrics AS (
    SELECT
        DATE_TRUNC('month', o.order_purchase_timestamp)::date
            AS month,
        COUNT(DISTINCT o.order_id) AS total_orders,
        ROUND(SUM(oi.price)::numeric, 2) AS revenue,
        ROUND(SUM(oi.freight_value)::numeric, 2) AS freight_revenue
    FROM orders AS o
    INNER JOIN order_items AS oi
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY DATE_TRUNC('month', o.order_purchase_timestamp)::date
),
monthly_growth AS (
    SELECT
        *,
        LAG(revenue) OVER (ORDER BY month) AS previous_month_revenue,
        LAG(total_orders) OVER (ORDER BY month) AS previous_month_orders
    FROM monthly_metrics
)
SELECT
    month,
    total_orders,
    revenue,
    freight_revenue,
    previous_month_revenue,
    ROUND(
        100.0 * (revenue - previous_month_revenue)
        / NULLIF(previous_month_revenue, 0),
        2
    ) AS revenue_growth_pct,
    previous_month_orders,
    ROUND(
        100.0 * (total_orders - previous_month_orders)
        / NULLIF(previous_month_orders, 0),
        2
    ) AS order_growth_pct
FROM monthly_growth
ORDER BY month;