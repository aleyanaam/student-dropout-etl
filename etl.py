import pandas as pd
from sqlalchemy import create_engine

# --- UPDATE THESE ---
DB_USER = "postgres"
DB_PASSWORD = "livandmaddie"   # your actual Postgres password
DB_HOST = "localhost"
DB_PORT = "5432"
DB_NAME = "student_dropout"
CSV_PATH = "/Users/aleyanamcleod/Downloads/student_dropout_dataset_v3.csv"
# --------------------

# 1. EXTRACT
print("Reading CSV...")
df = pd.read_csv(CSV_PATH)

# 2. TRANSFORM
print("Cleaning data...")
df.columns = df.columns.str.strip().str.lower().str.replace(" ", "_")
df = df.drop_duplicates()
df = df.dropna(subset=["dropout"])

# 3. LOAD
print("Loading into PostgreSQL...")
engine = create_engine(f"postgresql+psycopg2://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}")
df.to_sql("students", engine, if_exists="replace", index=False)

print(f"Done! {len(df)} rows loaded into the 'students' table.")