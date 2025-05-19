CREATE TABLE raw_orders_json (
    order_data VARIANT
);


COPY INTO raw_orders
FROM @my_stage/orders.json
FILE_FORMAT = (TYPE = 'JSON');

SELECT
  order_data:order_id::INTEGER AS order_id,
  order_data:customer:name::STRING AS customer_name,
  order_data:items[0]:product::STRING AS first_product
FROM raw_orders;