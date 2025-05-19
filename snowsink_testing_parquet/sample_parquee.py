#pip install pandas pyarrow


import pandas as pd

# Sample data
data = {
    "order_id": [1001, 1002, 1003],
    "customer_name": ["John Doe", "Jane Smith", "Alice Brown"],
    "product": ["Widget A", "Widget B", "Widget C"],
    "quantity": [2, 1, 5],
    "price": [19.99, 29.99, 9.99],
    "order_date": pd.to_datetime(["2025-05-01", "2025-05-02", "2025-05-03"])
}

# Create DataFrame
df = pd.DataFrame(data)

# Save to Parquet
df.to_parquet("orders.parquet", engine="pyarrow", index=False)
print("✅ Parquet file created: orders.parquet")
