-- ============================================================
-- EHS Safety Intelligence — Base Table Schema
-- Platform : Google BigQuery
-- Purpose  : Define all three source tables with correct data
--            types, field descriptions, and constraints.
--            Run in order: incidents → audits → training.
--
-- NOTE: Replace `your_project.your_dataset` with your actual
--       BigQuery project and dataset names before running.
-- ============================================================


-- ─────────────────────────────────────────────
-- TABLE 1: incidents
-- Source   : Incident log records
-- Grain    : One row per reported workplace incident
-- Known issues documented in eda_01_incidents.sql
-- ─────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS `your_project.your_dataset.incidents` (

  -- Primary identifier
  incident_id     STRING    NOT NULL,  -- e.g. 1001, 1002. STRING to handle any alphanumeric future IDs

  -- Dates
  incident_date   DATE      NOT NULL,  -- Date the incident physically occurred
  reported_on     DATE,                -- Date the incident was formally reported
                                       -- NULL allowed: some reports may be pending
                                       -- NOTE: reported_on should never be before incident_date

  -- People
  employee_name   STRING,              -- Full name of the employee involved
  employee_id     STRING,              -- Employee identifier e.g. EMP258
                                       -- STRING not INT to preserve leading zeros / alphanumeric format
  supervisor      STRING,              -- Name of the responsible supervisor

  -- Location & shift
  dept_name       STRING,              -- Department name
                                       -- Raw data has inconsistencies: "Prod." vs "Production"
                                       -- Standardise to full names during cleaning
  site_location   STRING,              -- Physical site e.g. WH1, Plant A
                                       -- Raw data has inconsistencies: "Plant A" vs "Plant-A"
                                       -- Standardise to "Plant A" / "WH1" format during cleaning
  shift           STRING,              -- Shift during which incident occurred: Day | Night
                                       -- NULL observed in raw data — investigate during EDA

  -- Incident classification
  injury_type     STRING,              -- Type of injury: Cut | Strain | Fracture | Burn etc.
  severity        STRING,              -- Incident severity: Low | Med | HIGH
                                       -- Raw data has mixed casing — standardise to: Low | Medium | High
  root_cause      STRING,              -- Primary root cause e.g. Unsafe lifting | Wet floor
  near_miss_flag  STRING,              -- Whether this was a near miss: Y | N
                                       -- Raw data has mixed types: Y / N / 0 / 1
                                       -- Standardise to Y | N during cleaning

  -- Impact
  days_lost       INT64,               -- Number of working days lost due to the incident
                                       -- 0 is valid for near misses or minor injuries
                                       -- Negative values are invalid — flag in EDA

  -- Free text
  comments        STRING               -- Optional notes e.g. "late report", "minor"
                                       -- Nullable — not all incidents have additional notes

)
OPTIONS (
  description = "Raw workplace incident records. Contains one row per reported incident. Data quality issues (mixed casing, abbreviations, near_miss_flag type inconsistencies) are documented in eda_01_incidents.sql and must be resolved in the cleaning layer before use in reporting."
);


-- ─────────────────────────────────────────────
-- TABLE 2: audits
-- Source   : Safety audit records
-- Grain    : One row per safety audit conducted
-- Known issues documented in eda_02_audits.sql
-- ─────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS `your_project.your_dataset.audits` (

  -- Primary identifier
  audit_id        STRING,              -- e.g. A002, A003. NULLABLE — null values observed in raw data
                                       -- Investigate missing IDs in EDA before assigning surrogates

  -- Date
  audit_date      DATE,                -- Date the audit was conducted
                                       -- Raw data has MIXED FORMATS: 2025/02/24 and 14-04-25
                                       -- Must be standardised to DATE type during ingestion

  -- Location
  dept            STRING,              -- Department audited
                                       -- Same "Prod." vs "Production" issue as incidents table
  site            STRING,              -- Site audited e.g. Plant A | WH1
                                       -- Same "Plant-A" vs "Plant A" issue as incidents table

  -- Audit personnel
  auditor         STRING,              -- Full name of the auditor conducting the inspection

  -- Scores & findings
  score           STRING,              -- Audit score out of 100
                                       -- STORED AS STRING because raw data contains text values
                                       -- e.g. "eighty five" instead of numeric 85
                                       -- Use SAFE_CAST(score AS FLOAT64) for any calculations
                                       -- Clean to FLOAT64 in the cleaning layer
  non_compliance  INT64,               -- Number of non-compliance items identified
                                       -- 0 is valid (clean audit)

  -- Outcome
  status          STRING,              -- Audit result: Pass | FAIL
                                       -- Raw data has mixed casing — standardise to: Pass | Fail
                                       -- NOTE: contradictions exist (score=92 marked FAIL) — flag in EDA
  followup_required STRING,            -- Whether a follow-up audit is required: Y | N
                                       -- Raw data has mixed values: Y / N / Yes / 1 / 0
                                       -- Standardise to Y | N during cleaning

  -- Free text
  remarks         STRING               -- Notes on audit findings e.g. "Machine guarding", "Minor issues"
                                       -- Nullable

)
OPTIONS (
  description = "Raw safety audit records. One row per audit conducted. Critical data quality issues: mixed date formats, non-numeric score values, mixed followup_required flags, and score-vs-status contradictions. See eda_02_audits.sql for full profiling queries."
);


-- ─────────────────────────────────────────────
-- TABLE 3: training
-- Source   : Employee training and compliance records
-- Grain    : One row per employee per training type
-- Known issues documented in eda_03_training.sql
-- ─────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS `your_project.your_dataset.training` (

  -- Employee identifiers
  emp_id          STRING    NOT NULL,  -- Employee identifier e.g. EMP149
                                       -- NOTE: EMP149 appears with two different emp_name values
                                       -- in raw data — investigate as data entry error or ID reuse
  emp_name        STRING,              -- Full name of the employee

  -- Location
  dept            STRING,              -- Employee department
                                       -- Same "Prod." vs "Production" issue as other tables
  site            STRING,              -- Employee site e.g. Plant A | WH1
                                       -- Same "Plant-A" vs "Plant A" issue as other tables

  -- Training details
  training_type   STRING,              -- Type of training: Machine Safety | Fire Safety | Ergonomics
  trainer         STRING,              -- Name of the trainer who delivered the session

  -- Completion status
  completed       STRING,              -- Whether training was completed: Y | N
                                       -- Raw data has mixed values: Yes / Y / N
                                       -- Standardise to Y | N during cleaning

  -- Dates
  completion_date DATE,                -- Date training was completed
                                       -- Raw data has MIXED FORMATS: 2024/10/30 | 27-03-24 | 17-08-25
                                       -- Must be standardised to DATE type during ingestion
                                       -- NULL is valid for incomplete training
  expiry          DATE,                -- Date when training certification expires
                                       -- Raw data has same mixed format issue as completion_date
                                       -- NOTE: expiry should never be before completion_date

  -- Free text
  notes           STRING               -- Optional notes e.g. "late entry", "missed"
                                       -- Nullable

)
OPTIONS (
  description = "Raw employee training and compliance records. One row per employee per training type. Key data quality issues: mixed date formats across completion_date and expiry, mixed completed flag values (Yes/Y/N), and duplicate emp_id EMP149 with conflicting names. See eda_03_training.sql for full profiling queries."
);


-- ============================================================
-- QUICK RECORD COUNT VERIFICATION
-- Run after loading data to confirm all rows landed correctly
-- ============================================================

SELECT 'incidents' AS table_name, COUNT(*) AS row_count FROM `your_project.your_dataset.incidents`
UNION ALL
SELECT 'audits',                  COUNT(*)              FROM `your_project.your_dataset.audits`
UNION ALL
SELECT 'training',                COUNT(*)              FROM `your_project.your_dataset.training`
ORDER BY table_name;
