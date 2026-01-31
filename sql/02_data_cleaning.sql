-- INCIDENT CLEANING
CREATE OR REPLACE TABLE `practice-project-2025-9898.ehs_analytics.incidents_clean` AS
SELECT
    -- 1. Identifiers
    incident_id,
    employee_id,

    -- 2. Date Standardization & Lag Calculation
    SAFE_CAST(incident_date AS DATE) AS incident_date,
    SAFE_CAST(reported_on AS DATE) AS reported_on,
    -- Business Logic: Measures how long it takes for a supervisor to report an accident
    DATE_DIFF(SAFE_CAST(reported_on AS DATE), SAFE_CAST(incident_date AS DATE), DAY) AS reporting_lag_days,

    -- 3. Department & Site Cleaning
    CASE
        WHEN UPPER(dept_name) IN ('PROD.', 'PROD', 'PRODUCTION') THEN 'Production'
        WHEN UPPER(dept_name) IN ('LOG.', 'LOGISTICS') THEN 'Logistics'
        WHEN UPPER(dept_name) IN ('MAINT', 'MAINTENANCE') THEN 'Maintenance'
        ELSE INITCAP(dept_name)
    END AS dept_name,

    CASE
        WHEN UPPER(site_location) IN ('PLANT-A', 'PLANTA') THEN 'Plant A'
        WHEN UPPER(site_location) IN ('PLANT-B', 'PLANTB') THEN 'Plant B'
        ELSE INITCAP(site_location)
    END AS site_location,

    -- 4. Operational Context
    INITCAP(shift) AS shift, -- Standardizes 'day', 'DAY', 'Day' to 'Day'
    UPPER(injury_type) AS injury_type,

    -- 5. Severity Ranking (Numeric prefix helps Power BI sorting)
    CASE
        WHEN UPPER(severity) IN ('HIGH', '3') THEN '3 - High'
        WHEN UPPER(severity) IN ('MED', 'MEDIUM', '2') THEN '2 - Medium'
        WHEN UPPER(severity) IN ('LOW', '1') THEN '1 - Low'
        ELSE '0 - Unclassified'
    END AS severity_level,

    -- 6. Numeric Cleaning
    CASE
        WHEN days_lost = 'three' THEN 3
        ELSE SAFE_CAST(days_lost AS INT64)
    END AS days_lost,

    -- 7. Flags & Root Cause
    root_cause,
    CASE
        WHEN near_miss_flag IN ('Y', '1', 'Yes') THEN 1
        WHEN near_miss_flag IN ('N', '0', 'No') THEN 0
        ELSE 0 
    END AS is_near_miss,

    -- 8. Time Intelligence (For easier filtering in dashboards)
    EXTRACT(YEAR FROM SAFE_CAST(incident_date AS DATE)) AS incident_year,
    EXTRACT(MONTH FROM SAFE_CAST(incident_date AS DATE)) AS incident_month,
    FORMAT_DATE('%b', SAFE_CAST(incident_date AS DATE)) AS month_name -- e.g., 'Jan'

FROM `practice-project-2025-9898.ehs_analytics.ehs_incidents`;
--

-- AUDIT CLEANING
CREATE OR REPLACE TABLE `practice-project-2025-9898.ehs_analytics.audit_clean` AS
SELECT
    -- 1. Standardize ID
    IF(audit_id = '', NULL, audit_id) AS audit_id,

    -- 2. FIX: Date Standardizing (Using PARSE_DATE to handle common messy formats)
    COALESCE(
  -- Try YYYY/MM/DD (Standard ISO-ish with slashes)
     SAFE.PARSE_DATE('%Y/%m/%d', audit_date),
  
  -- Try DD-MM-YY (Common manual entry, e.g., 25-01-26)
     SAFE.PARSE_DATE('%d-%m-%y', audit_date),
  
  -- Try DD-MM-YYYY (If some years are 4 digits)
     SAFE.PARSE_DATE('%d-%m-%Y', audit_date),
  
  -- Try YYYY-MM-DD (Standard BigQuery format)
   SAFE_CAST(audit_date AS DATE)
) AS audit_date,

    -- 3. Standardize department (Using INITCAP for consistency)
    CASE
        WHEN UPPER(dept) IN ('PROD.', 'PROD') THEN 'Production'
        ELSE INITCAP(dept)
    END AS dept_name,

    -- 4. Standardize site
    CASE
        WHEN UPPER(site) IN ('PLANT-A', 'PLANTA') THEN 'Plant A'
        WHEN UPPER(site) IN ('PLANT-B', 'PLANTB') THEN 'Plant B'
        ELSE INITCAP(site)
    END AS site_location,

    -- 5. Convert score to numeric (SAFE_CAST prevents crashes)
    CASE
        WHEN LOWER(score) = 'eighty five' THEN 85
        ELSE SAFE_CAST(score AS INT64)
    END AS audit_score,

    -- 6. Clean Non-Compliance text
    SAFE_CAST(non_compliance AS INT64) AS non_compliance_count,

    -- 7. Standardize status
    CASE
        WHEN UPPER(status) IN ('P', 'PASS') THEN 'Pass'
        WHEN UPPER(status) IN ('F', 'FAIL') THEN 'Fail'
        ELSE 'Pending'
    END AS audit_status,

    -- 8. Standardize followup_required
    CASE
        WHEN UPPER(followup_required) IN ('Y', 'YES', '1') THEN 1
        WHEN UPPER(followup_required) IN ('N', 'NO', '0') THEN 0
        ELSE 0
    END AS is_followup_required

FROM `practice-project-2025-9898.ehs_analytics.ehs_audits`;


-- TRAINING CLEANING
CREATE OR REPLACE TABLE `practice-project-2025-9898.ehs_analytics.training_clean` AS
SELECT
    -- 1. Standardize employee ID
    CASE WHEN emp_id = '' THEN NULL ELSE emp_id END AS employee_id,

    -- 2. Standardize department
    CASE
        WHEN dept IN ('Prod.','Prod') THEN 'Production'
        ELSE dept
    END AS dept_name,

    -- 3. Standardize site
      CASE
        WHEN UPPER(site_location) IN ('PLANT-A', 'PLANTA') THEN 'Plant A'
        WHEN UPPER(site_location) IN ('PLANT-B', 'PLANTB') THEN 'Plant B'
        ELSE INITCAP(site_location)
    END AS site_location,

    training_type,

    -- 4. Standardize completed
    CASE 
    WHEN completed IS TRUE THEN 1
    WHEN completed IS FALSE THEN 0
    ELSE NULL 
    END AS is_completed,

    -- 5. Standardize dates
    COALESCE(
  -- Try YYYY/MM/DD (Standard ISO-ish with slashes)
     SAFE.PARSE_DATE('%Y/%m/%d', completion_date),
  
  -- Try DD-MM-YY (Common manual entry, e.g., 25-01-26)
     SAFE.PARSE_DATE('%d-%m-%y', completion_date),
  
  -- Try DD-MM-YYYY (If some years are 4 digits)
     SAFE.PARSE_DATE('%d-%m-%Y', completion_date),
  
  -- Try YYYY-MM-DD (Standard BigQuery format)
   SAFE_CAST(completion_date AS DATE)
) AS completion_date,

    COALESCE(
  -- Try YYYY/MM/DD (Standard ISO-ish with slashes)
     SAFE.PARSE_DATE('%Y/%m/%d', expiry),
  
  -- Try DD-MM-YY (Common manual entry, e.g., 25-01-26)
     SAFE.PARSE_DATE('%d-%m-%y', expiry),
  
  -- Try DD-MM-YYYY (If some years are 4 digits)
     SAFE.PARSE_DATE('%d-%m-%Y', expiry),
  
  -- Try YYYY-MM-DD (Standard BigQuery format)
   SAFE_CAST(expiry AS DATE)
) AS expiry_date,
FROM `practice-project-2025-9898.ehs_analytics.ehs_training`;
