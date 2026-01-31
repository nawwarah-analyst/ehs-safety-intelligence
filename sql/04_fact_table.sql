-- INCIDENTS + TRAINING FACT
CREATE OR REPLACE TABLE practice-project-2025-9898.ehs_analytics.dim_department AS
SELECT DISTINCT dept_name FROM (
SELECT dept_name FROM practice-project-2025-9898.ehs_analytics.incidents_clean
UNION DISTINCT
SELECT dept_name FROM practice-project-2025-9898.ehs_analytics.audit_clean
UNION DISTINCT
SELECT dept_name FROM practice-project-2025-9898.ehs_analytics.training_clean
)
WHERE dept_name IS NOT NULL;

-- DEPARTMENT + RISK FACT
CREATE OR REPLACE TABLE practice-project-2025-9898.ehs_analytics.dim_department AS
SELECT DISTINCT dept_name FROM (
SELECT dept_name FROM practice-project-2025-9898.ehs_analytics.incidents_clean
UNION DISTINCT
SELECT dept_name FROM practice-project-2025-9898.ehs_analytics.audit_clean
UNION DISTINCT
SELECT dept_name FROM practice-project-2025-9898.ehs_analytics.training_clean
)
WHERE dept_name IS NOT NULL;
