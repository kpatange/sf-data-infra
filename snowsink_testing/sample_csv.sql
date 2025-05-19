CREATE OR REPLACE TABLE orders (
  order_id        INTEGER,
  customer_id     INTEGER,
  order_date      DATE,
  order_amount    NUMBER(10, 2),
  order_status    STRING
);


INSERT INTO orders (order_id, customer_id, order_date, order_amount, order_status)
VALUES 
  (1001, 201, '2024-05-01', 250.75, 'SHIPPED'),
  (1002, 202, '2024-05-02', 100.00, 'PENDING'),
  (1003, 203, '2024-05-03', 315.00, 'CANCELLED'),
  (1004, 204, '2024-05-04', 500.50, 'SHIPPED'),
  (1005, 205, '2024-05-05', 75.25,  'PROCESSING');
