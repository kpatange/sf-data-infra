CREATE TABLE sales_data_csv (
    Order_ID INTEGER,
    Customer_Name STRING,
    Product STRING,
    Quantity INTEGER,
    Price FLOAT,
    Order_Date DATE
);


COPY INTO sales_data_csv
FROM @my_stage/sales_data.csv
FILE_FORMAT = (TYPE = 'CSV' FIELD_OPTIONALLY_ENCLOSED_BY = '"' SKIP_HEADER = 1);
