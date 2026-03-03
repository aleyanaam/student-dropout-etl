# Student Dropout ETL Pipeline 

An end-to-end ETL (Extract, Transform, Load) pipeline built with Python and PostgreSQL to process and analyze a student dropout prediction dataset.

## Overview

This project pulls raw student data from a CSV file, cleans and transforms it using pandas, and loads it into a local PostgreSQL database for analysis. It was built as a hands-on exercise in data engineering fundamentals.

## Tech Stack

- **Python 3** — pipeline logic
- **pandas** — data cleaning and transformation
- **SQLAlchemy + psycopg2** — database connection and loading
- **PostgreSQL** — data storage and querying
- **pgAdmin 4** — database management and query execution

## Dataset

[Student Dropout Prediction Dataset](https://www.kaggle.com/datasets/meharshanali/student-dropout-prediction-dataset?resource=download) from Kaggle

The dataset contains 10,000 student records with features including:

| Column | Description |
|---|---|
| `student_id` | Unique student identifier |
| `age` | Student age at enrollment |
| `gender` | Student gender |
| `gpa` | Grade point average |
| `attendance_rate` | Class attendance percentage |
| `study_hours_per_day` | Daily study hours |
| `family_income` | Family income level |
| `department` | Academic department |
| `dropout` | Target variable (1 = dropped out, 0 = did not) |

## Project Structure

```
student-dropout-etl/
├── etl.py          # Main ETL pipeline script
├── queries.sql     # Data quality checks and analysis queries
└── README.md
```

## Getting Started

### Prerequisites

- Python 3.8+
- PostgreSQL installed and running
- pgAdmin 4 (optional, for visual querying)

### Setup

1. Clone the repo:
```bash
git clone https://github.com/yourusername/student-dropout-etl.git
cd student-dropout-etl
```

2. Create and activate a virtual environment:
```bash
python3 -m venv venv
source venv/bin/activate
```

3. Install dependencies:
```bash
pip install pandas psycopg2-binary sqlalchemy
```

4. Download the dataset from [Kaggle](https://www.kaggle.com/datasets/thedevastator/higher-education-predictors-of-student-retention) and note the file path.

5. Create a PostgreSQL database called `student_dropout`.

6. Update the config variables at the top of `etl.py`:
```python
DB_USER = "postgres"
DB_PASSWORD = "yourpassword"
DB_HOST = "localhost"
DB_PORT = "5432"
DB_NAME = "student_dropout"
CSV_PATH = "/path/to/your/dataset.csv"
```

### Run the Pipeline

```bash
python3 etl.py
```

Expected output:
```
Starting ETL Pipeline...

Extracting data...
   → 10000 rows loaded
Transforming data...
   → 0 duplicate rows removed
   → Filled 500 missing values in 'family_income' with mean
   → Filled 500 missing values in 'study_hours_per_day' with mean
   → 10000 rows after cleaning
Loading into PostgreSQL...
   → 10000 rows loaded into 'students' table

Pipeline completed successfully!
```

## Data Cleaning Steps

- Standardized column names to lowercase with underscores
- Removed duplicate rows
- Dropped rows with missing target (`dropout`) values
- Filled 500 missing `family_income` values with column mean
- Filled 500 missing `study_hours_per_day` values with column mean

## Sample Analysis Queries

Run these in pgAdmin or any SQL client using `queries.sql`:

```sql
-- Dropout rate breakdown
SELECT
  dropout,
  COUNT(*) AS total,
  ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER(), 2) AS percentage
FROM students
GROUP BY dropout;

-- Average GPA by dropout status
SELECT dropout, ROUND(AVG(gpa)::numeric, 2) AS avg_gpa
FROM students
GROUP BY dropout;
```

## What I Learned

- Building a modular ETL pipeline with separate extract, transform, and load functions
- Handling missing data with mean imputation
- Loading data into PostgreSQL using SQLAlchemy
- Writing SQL queries for data quality checks and exploratory analysis
