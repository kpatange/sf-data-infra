CREATE OR REPLACE TABLE orders_parquet (
    order_id INT,
    customer_name STRING,
    product STRING,
    quantity INT,
    price FLOAT,
    order_date DATE
);
COPY INTO orders
FROM @my_stage/orders.parquet
FILE_FORMAT = (TYPE = 'PARQUET');
SELECT
  order_id,
  customer_name,
  product,
  quantity,
  price,
  order_date
FROM orders