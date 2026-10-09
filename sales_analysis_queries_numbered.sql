-- SQL SALES ANALYSIS PROJECT
-- Dataset: fictional retail sales data for learning and portfolio practice
-- Revenue formula: quantity * unit_price

CREATE DATABASE sales_analysis;
USE sales_analysis;

CREATE TABLE sales (
    order_id INT PRIMARY KEY,
    order_date DATE,
    customer_name VARCHAR(100),
    city VARCHAR(50),
    category VARCHAR(50),
    product_name VARCHAR(100),
    quantity INT,
    unit_price DECIMAL(10,2),
    payment_method VARCHAR(30)
);


USE sales_analysis;

INSERT INTO sales
(order_id, order_date, customer_name, city, category,
 product_name, quantity, unit_price, payment_method)
VALUES
(1001, '2026-01-05', 'Aarav Sharma', 'Jaipur', 'Electronics', 'Mouse', 2, 500.00, 'UPI'),
(1002, '2026-01-06', 'Priya Singh', 'Delhi', 'Furniture', 'Office Chair', 1, 4500.00, 'Card'),
(1003, '2026-01-08', 'Rahul Verma', 'Mumbai', 'Electronics', 'Keyboard', 3, 1200.00, 'UPI'),
(1004, '2026-01-10', 'Neha Gupta', 'Jaipur', 'Stationery', 'Notebook', 10, 80.00, 'Cash'),
(1005, '2026-01-12', 'Aarav Sharma', 'Delhi', 'Electronics', 'Monitor', 1, 12000.00, 'Card'),
(1006, '2026-01-15', 'Imran Khan', 'Ajmer', 'Furniture', 'Desk', 2, 6500.00, 'UPI'),
(1007, '2026-01-18', 'Priya Singh', 'Mumbai', 'Stationery', 'Pen Pack', 5, 150.00, 'Cash'),
(1008, '2026-01-20', 'Karan Mehta', 'Jaipur', 'Electronics', 'Headphones', 2, 1800.00, 'Card'),
(1009, '2026-02-02', 'Neha Gupta', 'Delhi', 'Furniture', 'Bookshelf', 1, 7000.00, 'UPI'),
(1010, '2026-02-04', 'Rahul Verma', 'Ajmer', 'Electronics', 'Mouse', 4, 500.00, 'Cash'),
(1011, '2026-02-07', 'Sara Ali', 'Mumbai', 'Stationery', 'Notebook', 20, 80.00, 'UPI'),
(1012, '2026-02-10', 'Karan Mehta', 'Jaipur', 'Furniture', 'Office Chair', 2, 4500.00, 'Card'),
(1013, '2026-02-14', 'Imran Khan', 'Delhi', 'Electronics', 'Keyboard', 2, 1200.00, 'UPI'),
(1014, '2026-02-17', 'Aarav Sharma', 'Ajmer', 'Stationery', 'Pen Pack', 8, 150.00, 'Cash'),
(1015, '2026-02-22', 'Sara Ali', 'Jaipur', 'Electronics', 'Monitor', 2, 12000.00, 'Card');


-- 1. View all sales records
SELECT *
FROM sales;


-- 2. Calculate sales for each order
SELECT
    order_id,
    product_name,
    quantity,
    unit_price,
    quantity * unit_price AS total_sales
FROM sales;


-- 3. Total revenue
SELECT
    SUM(quantity * unit_price) AS total_revenue
FROM sales;


-- 4. Revenue by category
SELECT
    category,
    SUM(quantity * unit_price) AS total_revenue
FROM sales
GROUP BY category
ORDER BY total_revenue DESC;


-- 5. Revenue by city
SELECT
    city,
    SUM(quantity * unit_price) AS total_revenue
FROM sales
GROUP BY city
ORDER BY total_revenue DESC;


-- 6. Revenue and quantity by product
SELECT
    product_name,
    SUM(quantity) AS total_quantity_sold,
    SUM(quantity * unit_price) AS total_revenue
FROM sales
GROUP BY product_name
ORDER BY total_revenue DESC;


-- 7. Monthly revenue
SELECT
    DATE_FORMAT(order_date, '%Y-%m') AS sales_month,
    SUM(quantity * unit_price) AS total_revenue
FROM sales
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY sales_month;


-- 8. Revenue by payment method
SELECT
    payment_method,
    COUNT(*) AS total_orders,
    SUM(quantity * unit_price) AS total_revenue
FROM sales
GROUP BY payment_method
ORDER BY total_revenue DESC;


-- 9. Customer order count and total spending
SELECT
    customer_name,
    COUNT(*) AS total_orders,
    SUM(quantity * unit_price) AS total_spent
FROM sales
GROUP BY customer_name
ORDER BY total_spent DESC;


-- 10. Top 5 highest-value orders
SELECT
    order_id,
    customer_name,
    city,
    product_name,
    quantity,
    unit_price,
    quantity * unit_price AS order_revenue
FROM sales
ORDER BY order_revenue DESC
LIMIT 5;


-- 11. Categories with revenue above 10,000
SELECT
    category,
    SUM(quantity * unit_price) AS total_revenue
FROM sales
GROUP BY category
HAVING SUM(quantity * unit_price) > 10000
ORDER BY total_revenue DESC;


-- 12. Total orders, total revenue, and average order value
SELECT
    COUNT(*) AS total_orders,
    SUM(quantity * unit_price) AS total_revenue,
    AVG(quantity * unit_price) AS average_order_value
FROM sales;


-- 13. Repeat customer analysis
SELECT
    customer_name,
    COUNT(*) AS total_orders,
    SUM(quantity * unit_price) AS total_spent
FROM sales
GROUP BY customer_name
HAVING COUNT(*) > 1
ORDER BY total_orders DESC, total_spent DESC;


-- 14. Revenue percentage by category
SELECT
    category,
    SUM(quantity * unit_price) AS total_revenue,
    ROUND(
        SUM(quantity * unit_price) * 100.0 /
        (SELECT SUM(quantity * unit_price) FROM sales),
        2
    ) AS revenue_percentage
FROM sales
GROUP BY category
ORDER BY total_revenue DESC;


-- 15. CTE: categories with revenue above 10,000
WITH category_sales AS (

-- 16. Rank products by revenue
    SELECT
        category,
        SUM(quantity * unit_price) AS total_revenue
    FROM sales
    GROUP BY category
)

-- 17. Compare product revenue with average product revenue
SELECT
    category,
    total_revenue
FROM category_sales
WHERE total_revenue > 10000
ORDER BY total_revenue DESC;

-- 18. Revenue percentage by city
WITH city_sales AS (
    SELECT
        city,
        SUM(quantity * unit_price) AS total_revenue
    FROM sales
    GROUP BY city
)
SELECT
    city,
    total_revenue,
    ROUND(
        total_revenue * 100.0 / SUM(total_revenue) OVER (),
        2
    ) AS revenue_percentage
FROM city_sales
ORDER BY total_revenue DESC;

-- 19. Top-revenue product in each city
    SELECT
        product_name,
        SUM(quantity * unit_price) AS total_revenue
    FROM sales
    GROUP BY product_name
)
SELECT
    product_name,
    total_revenue,
    RANK() OVER (
        ORDER BY total_revenue DESC
    ) AS revenue_rank
FROM product_sales
ORDER BY revenue_rank;

-- 20. Product performance vs average revenue
WITH product_sales AS (
    SELECT
        product_name,
        SUM(quantity * unit_price) AS total_revenue
    FROM sales
    GROUP BY product_name
)
SELECT
    product_name,
    total_revenue,
    ROUND(AVG(total_revenue) OVER (), 2) AS average_product_revenue,
    CASE
        WHEN total_revenue > AVG(total_revenue) OVER ()
        THEN 'Above Average'
        ELSE 'Below or Equal to Average'
    END AS performance
FROM product_sales
ORDER BY total_revenue DESC;

-- 21. Revenue percentage by city
WITH city_sales AS (
    SELECT
        city,
        SUM(quantity * unit_price) AS total_revenue
    FROM sales
    GROUP BY city
)
SELECT
    city,
    total_revenue,
    ROUND(
        total_revenue * 100.0 / SUM(total_revenue) OVER (),
        2
    ) AS revenue_percentage
FROM city_sales
ORDER BY total_revenue DESC;

-- 22. Top-revenue product in each city
WITH city_product_sales AS (
    SELECT
        city,
        product_name,
        SUM(quantity * unit_price) AS total_revenue
    FROM sales
    GROUP BY city, product_name
),
ranked_products AS (
    SELECT
        city,
        product_name,
        total_revenue,
        ROW_NUMBER() OVER (
            PARTITION BY city
            ORDER BY total_revenue DESC
        ) AS row_num
    FROM city_product_sales
)
SELECT
    city,
    product_name,
    total_revenue
FROM ranked_products
WHERE row_num = 1
ORDER BY city;
