-- ============================================================
-- Student Dropout ETL Pipeline — SQL Queries
-- Database: student_dropout | Table: students
-- ============================================================


-- ------------------------------------------------------------
-- DATA QUALITY CHECKS
-- ------------------------------------------------------------

-- Total row count
SELECT COUNT(*) AS total_rows FROM students;

-- Check for nulls across key columns
SELECT
  COUNT(*) - COUNT(student_id)        AS missing_student_id,
  COUNT(*) - COUNT(age)               AS missing_age,
  COUNT(*) - COUNT(gender)            AS missing_gender,
  COUNT(*) - COUNT(family_income)     AS missing_family_income,
  COUNT(*) - COUNT(study_hours_per_day) AS missing_study_hours,
  COUNT(*) - COUNT(gpa)               AS missing_gpa,
  COUNT(*) - COUNT(dropout)           AS missing_dropout
FROM students;

-- Check for duplicate student IDs
SELECT student_id, COUNT(*)
FROM students
GROUP BY student_id
HAVING COUNT(*) > 1;

-- Preview first 10 rows
SELECT * FROM students LIMIT 10;


-- ------------------------------------------------------------
-- DATA CLEANING
-- ------------------------------------------------------------

-- Fill missing family_income with average
UPDATE students
SET family_income = (
  SELECT AVG(family_income) FROM students WHERE family_income IS NOT NULL
)
WHERE family_income IS NULL;

-- Fill missing study_hours_per_day with average
UPDATE students
SET study_hours_per_day = (
  SELECT AVG(study_hours_per_day) FROM students WHERE study_hours_per_day IS NOT NULL
)
WHERE study_hours_per_day IS NULL;

-- Verify no nulls remain
SELECT
  COUNT(*) - COUNT(family_income)       AS missing_family_income,
  COUNT(*) - COUNT(study_hours_per_day) AS missing_study_hours
FROM students;


-- ------------------------------------------------------------
-- ANALYSIS QUERIES
-- ------------------------------------------------------------

-- Dropout count and percentage
SELECT
  dropout,
  COUNT(*) AS total,
  ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER(), 2) AS percentage
FROM students
GROUP BY dropout;

-- Average GPA by dropout status
SELECT
  dropout,
  ROUND(AVG(gpa)::numeric, 2) AS avg_gpa
FROM students
GROUP BY dropout;

-- Average study hours by dropout status
SELECT
  dropout,
  ROUND(AVG(study_hours_per_day)::numeric, 2) AS avg_study_hours
FROM students
GROUP BY dropout;

-- Dropout rate by department
SELECT
  department,
  dropout,
  COUNT(*) AS total
FROM students
GROUP BY department, dropout
ORDER BY department;

-- Dropout rate by gender
SELECT
  gender,
  dropout,
  COUNT(*) AS total,
  ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (PARTITION BY gender), 2) AS pct
FROM students
GROUP BY gender, dropout
ORDER BY gender;

-- Average attendance rate by dropout status
SELECT
  dropout,
  ROUND(AVG(attendance_rate)::numeric, 2) AS avg_attendance
FROM students
GROUP BY dropout;
