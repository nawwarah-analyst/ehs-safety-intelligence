-- ============================================================
-- EDA | Cross-Table Analysis
-- Purpose: Validate relationships across incidents, audits,
--          and training tables.
-- ============================================================


-- ─────────────────────────────────────────────
-- SECTION 1: ENTITY COVERAGE CHECK
-- Purpose: Confirm all three tables share the same
--          sites and departments — mismatches mean
--          JOINs will silently drop records.
-- ─────────────────────────────────────────────

-- 1.1 Sites present in incidents but NOT in audits
SELECT DISTINCT site_location AS site
FROM `portfolio-project-487605.ehs_project.ehs_incidents`
WHERE site_location NOT IN (
  SELECT DISTINCT site FROM `portfolio-project-487605.ehs_project.ehs_audit`
);

-- 1.2 Sites present in incidents but NOT in training
SELECT DISTINCT site_location AS site
FROM `portfolio-project-487605.ehs_project.ehs_incidents`
WHERE site_location NOT IN (
  SELECT DISTINCT site FROM `portfolio-project-487605.ehs_project.ehs_training`
);

-- 1.3 Departments present in incidents but NOT in audits
SELECT DISTINCT dept_name AS dept
FROM `portfolio-project-487605.ehs_project.ehs_incidents`
WHERE dept_name NOT IN (
  SELECT DISTINCT dept FROM `portfolio-project-487605.ehs_project.ehs_audit`
);

-- 1.4 Full site coverage summary across all three tables
SELECT
  all_sites.site,
  MAX(CASE WHEN src = 'incidents' THEN 1 ELSE 0 END) AS in_incidents,
  MAX(CASE WHEN src = 'audits'    THEN 1 ELSE 0 END) AS in_audits,
  MAX(CASE WHEN src = 'training'  THEN 1 ELSE 0 END) AS in_training
FROM (
  SELECT DISTINCT site_location AS site, 'incidents' AS src FROM `portfolio-project-487605.ehs_project.ehs_incidents`
  UNION ALL
  SELECT DISTINCT site,           'audits'    FROM `portfolio-project-487605.ehs_project.ehs_audit`
  UNION ALL
  SELECT DISTINCT site,           'training'  FROM `portfolio-project-487605.ehs_project.ehs_training`
) all_sites
GROUP BY site
ORDER BY site;


-- ─────────────────────────────────────────────
-- SECTION 2: EMPLOYEE VALIDATION
-- Purpose: Check whether employees involved in
--          incidents have any training records.
-- ─────────────────────────────────────────────

-- 2.1 Employees who had an incident but have NO training records
SELECT DISTINCT
  i.employee_id,
  i.employee_name,
  i.dept_name,
  i.site_location
FROM `portfolio-project-487605.ehs_project.ehs_incidents` i
LEFT JOIN `portfolio-project-487605.ehs_project.ehs_training` t
  ON i.employee_id = t.emp_id
WHERE t.emp_id IS NULL
ORDER BY i.dept_name;

-- 2.2 Employees with HIGH severity incidents who had
--     incomplete or no relevant training
SELECT
  i.incident_id,
  i.employee_id,
  i.employee_name,
  i.dept_name,
  i.injury_type,
  i.severity,
  i.root_cause,
  t.training_type,
  t.completed
FROM `portfolio-project-487605.ehs_project.ehs_incidents` i
LEFT JOIN `portfolio-project-487605.ehs_project.ehs_training` t
  ON i.employee_id = t.emp_id
WHERE UPPER(i.severity) = 'HIGH'
ORDER BY i.incident_date

-- ─────────────────────────────────────────────
-- SECTION 3: HIGH-RISK SITE COMPOSITE SUMMARY
-- Purpose: Single view combining all three data
--          sources per site. This is the EDA-level
--          preview of what the executive dashboard
--          should show.
-- ─────────────────────────────────────────────
WITH incident_summary AS (
  SELECT
    site_location                                                       AS site,
    COUNT(*)                                                            AS total_incidents,
    COUNTIF(UPPER(severity) = 'HIGH')                                   AS high_severity,
    ROUND(AVG(SAFE_CAST(days_lost AS FLOAT64)), 2)                      AS avg_days_lost,
    COUNTIF(UPPER(CAST(near_miss_flag AS STRING)) IN ('Y', '1'))        AS near_misses
  FROM `portfolio-project-487605.ehs_project.ehs_incidents`
  GROUP BY site_location
),
audit_summary AS (
  SELECT
    site,
    COUNT(*)                                                             AS total_audits,
    ROUND(AVG(SAFE_CAST(score AS FLOAT64)), 2)                          AS avg_audit_score,
    COUNTIF(UPPER(status) = 'FAIL')                                     AS failed_audits,
    SUM(non_compliance)                                                  AS total_non_compliance
  FROM `portfolio-project-487605.ehs_project.ehs_audit`
  GROUP BY site
),
training_summary AS (
  SELECT
    site,
    COUNT(*)                                                             AS total_training_records,
    ROUND(
      COUNTIF(completed = TRUE) * 100.0 / COUNT(*), 1
    )                                                                    AS completion_rate_pct
  FROM `portfolio-project-487605.ehs_project.ehs_training`
  GROUP BY site
)
 
SELECT
  COALESCE(i.site, a.site, t.site)  AS site,
  i.total_incidents,
  i.high_severity,
  i.avg_days_lost,
  i.near_misses,
  a.total_audits,
  a.avg_audit_score,
  a.failed_audits,
  a.total_non_compliance,
  t.total_training_records,
  t.completion_rate_pct              AS training_completion_pct
FROM incident_summary  i
FULL OUTER JOIN audit_summary    a ON i.site = a.site
FULL OUTER JOIN training_summary t ON COALESCE(i.site, a.site) = t.site
ORDER BY i.total_incidents DESC;
