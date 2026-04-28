-- ============================================================
-- EDA | Table: training
-- Purpose: Profile the raw training table before cleaning.
-- ============================================================


-- ─────────────────────────────────────────────
-- SECTION 1: ROW COUNT & BASIC OVERVIEW
-- ─────────────────────────────────────────────

-- 1.1 Total training records
SELECT COUNT(*) AS total_rows
FROM `portfolio-project-487605.ehs_project.ehs_training`;

-- 1.2 Date range — completion and expiry
SELECT
  MIN(completion_date) AS earliest_completion,
  MAX(completion_date) AS latest_completion,
  MIN(expiry)          AS earliest_expiry,
  MAX(expiry)          AS latest_expiry
FROM `portfolio-project-487605.ehs_project.ehs_training`;

-- 1.3 Sample of raw data
SELECT *
FROM `portfolio-project-487605.ehs_project.ehs_training`
LIMIT 20;


-- ─────────────────────────────────────────────
-- SECTION 2: NULL / MISSING VALUE AUDIT
-- ─────────────────────────────────────────────

SELECT
  COUNTIF(emp_id          IS NULL) AS null_emp_id,
  COUNTIF(emp_name        IS NULL) AS null_emp_name,
  COUNTIF(dept            IS NULL) AS null_dept,
  COUNTIF(site            IS NULL) AS null_site,
  COUNTIF(training_type   IS NULL) AS null_training_type,
  COUNTIF(completed       IS NULL) AS null_completed,
  COUNTIF(completion_date IS NULL) AS null_completion_date,
  COUNTIF(expiry          IS NULL) AS null_expiry,
  COUNTIF(trainer         IS NULL) AS null_trainer,
  COUNTIF(notes           IS NULL) AS null_notes,
  COUNT(*)                         AS total_rows
FROM `portfolio-project-487605.ehs_project.ehs_training`;


-- ─────────────────────────────────────────────
-- SECTION 3: DUPLICATE CHECK
-- Known issue: EMP149 appears with two different
--              emp_name values — data entry error or
--              reused employee ID.
-- ─────────────────────────────────────────────

-- 3.1 Employees with more than one name against same emp_id
SELECT
  emp_id,
  COUNT(DISTINCT emp_name) AS name_variants,
  STRING_AGG(DISTINCT emp_name, ' | ') AS names_found
FROM `portfolio-project-487605.ehs_project.ehs_training`
GROUP BY emp_id
HAVING COUNT(DISTINCT emp_name) > 1;

-- 3.2 Same employee, same training type, completed more than once
--     (legitimate refresher vs data duplicate)
SELECT
  emp_id, emp_name, training_type,
  COUNT(*) AS record_count,
  STRING_AGG(CAST(completion_date AS STRING), ', ') AS completion_dates
FROM `portfolio-project-487605.ehs_project.ehs_training`
GROUP BY emp_id, emp_name, training_type
HAVING COUNT(*) > 1
ORDER BY record_count DESC;

-- 3.3 Fully identical rows
SELECT
  emp_id, emp_name, dept, training_type, completed, completion_date,
  COUNT(*) AS occurrences
FROM `portfolio-project-487605.ehs_project.ehs_training`
GROUP BY 1, 2, 3, 4, 5, 6
HAVING COUNT(*) > 1;


-- ─────────────────────────────────────────────
-- SECTION 4: CATEGORICAL COLUMN PROFILING
-- ─────────────────────────────────────────────

-- 4.1 dept — same "Prod." vs "Production" issue as other tables
SELECT
  dept,
  COUNT(*) AS record_count,
  ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS pct
FROM `portfolio-project-487605.ehs_project.ehs_training`
GROUP BY dept
ORDER BY record_count DESC;

-- 4.2 site — check for "Plant A" vs "Plant-A" inconsistency
SELECT
  site,
  COUNT(*) AS record_count,
  ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS pct
FROM `portfolio-project-487605.ehs_project.ehs_training`
GROUP BY site
ORDER BY record_count DESC;

-- 4.3 training_type — what types exist and how frequent?
SELECT
  training_type,
  COUNT(*) AS record_count,
  ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS pct
FROM `portfolio-project-487605.ehs_project.ehs_training`
GROUP BY training_type
ORDER BY record_count DESC;

-- 4.4 completed — known issue: mixed Yes/Y/N values
SELECT
  completed,
  COUNT(*) AS record_count
FROM `portfolio-project-487605.ehs_project.ehs_training`
GROUP BY completed
ORDER BY record_count DESC;

-- 4.5 notes — check what kinds of notes are logged
SELECT
  COALESCE(notes, '(null)') AS notes,
  COUNT(*) AS record_count
FROM `portfolio-project-487605.ehs_project.ehs_training`
GROUP BY notes
ORDER BY record_count DESC;


-- ─────────────────────────────────────────────
-- SECTION 5: DATE FORMAT AUDIT
-- Known issue: completion_date and expiry have
--   mixed formats: 2024/10/30, 27-03-24, 17-08-25
--   These must all be standardised before date math.
-- ─────────────────────────────────────────────

-- 5.1 Find non-standard completion_date formats (contains dashes)
SELECT
  emp_id, emp_name,
  completion_date,
  expiry
FROM `portfolio-project-487605.ehs_project.ehs_training`
WHERE REGEXP_CONTAINS(CAST(completion_date AS STRING), r'^\d{2}-\d{2}-\d{2}$')
   OR REGEXP_CONTAINS(CAST(expiry AS STRING),          r'^\d{2}-\d{2}-\d{2}$');
