-- DIM EMPLOYEE
CREATE OR REPLACE TABLE practice-project-2025-9898.ehs_analytics.dim_employee AS
SELECT DISTINCT
employee_id,
MAX(dept_name) AS dept_name,
MAX(site_location) AS site_location
FROM (
SELECT employee_id, dept_name, site_location FROM practice-project-2025-9898.ehs_analytics.incidents_clean
UNION DISTINCT
SELECT employee_id, dept_name, site_location FROM practice-project-2025-9898.ehs_analytics.training_clean
)
WHERE employee_id IS NOT NULL
GROUP BY employee_id;

-- DIM SITE
CREATE OR REPLACE TABLE practice-project-2025-9898.ehs_analytics.dim_site AS
SELECT DISTINCT site_location FROM (
SELECT site_location FROM practice-project-2025-9898.ehs_analytics.incidents_clean
UNION DISTINCT
SELECT site_location FROM practice-project-2025-9898.ehs_analytics.audit_clean
UNION DISTINCT
SELECT site_location FROM practice-project-2025-9898.ehs_analytics.training_clean
)
WHERE site_location IS NOT NULL;

-- DIM DEPARTMENT
CREATE OR REPLACE TABLE practice-project-2025-9898.ehs_analytics.dim_department AS
SELECT DISTINCT dept_name FROM (
SELECT dept_name FROM practice-project-2025-9898.ehs_analytics.incidents_clean
UNION DISTINCT
SELECT dept_name FROM practice-project-2025-9898.ehs_analytics.audit_clean
UNION DISTINCT
SELECT dept_name FROM practice-project-2025-9898.ehs_analytics.training_clean
)
WHERE dept_name IS NOT NULL;
