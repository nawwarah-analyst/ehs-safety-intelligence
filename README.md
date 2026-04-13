# EHS Safety Intelligence System
### Operational Risk Analytics for Manufacturing & Logistics

> **From reactive to predictive** — transforming fragmented safety records into an enterprise-grade risk intelligence platform using BigQuery and Power BI.

---

## The Problem

A mid-size manufacturing and logistics company is flying blind on safety:

| Question | Status |
|---|---|
| Which departments are driving incidents? | ❌ No visibility |
| Why do the same accidents keep repeating? | ❌ No root-cause tracking |
| Are employees properly trained? | ❌ No compliance view |
| Which site will fail the next audit? | ❌ No early warnings |

Safety records lived in disconnected Excel files. Management only reacted **after** injuries occurred.

---

## Solution

A full EHS Business Intelligence pipeline — from raw messy data to executive-ready dashboards — built to shift the organisation from **reactive incident response** to **proactive risk prevention**.

```
Raw Excel Records
      │
      ▼
 BigQuery (Data Warehouse)
 ├── Data cleaning & standardisation
 ├── Date normalisation & severity scoring
 ├── Compliance flag generation
 └── Dimensional modelling (Employee, Site, Department)
      │
      ▼
 Analytics Layer
 ├── Risk & KPI aggregation tables
 └── Incident × Training × Audit relationships
      │
      ▼
 Power BI Dashboards
 ├── Executive Summary
 ├── EHS Manager View
 └── Plant Manager View
```

---

## Data Sources

Three source tables simulate real enterprise EHS data with intentional messiness — inconsistent date formats, missing severity values, duplicate records, and mismatched department names:

| Source | Description | Key Fields |
|---|---|---|
| `incidents.csv` | Workplace injury and near-miss logs | date, site, department, type, severity, LTI flag |
| `audits.csv` | Safety audit scores by site | date, site, auditor, score, findings, closure status |
| `training.csv` | Employee training completion records | employee_id, course, completion_date, pass/fail |

---

## SQL Pipeline (BigQuery)

The SQL layer runs in five sequential files, each building on the previous:

### Stage 1 — Schema (`01_schema.sql`)
- Defines all table structures and data types
- Sets up the base tables for incidents, audits, and training records

### Stage 2 — Data Cleaning (`02_data_cleaning.sql`)
- Standardises date formats across all three tables
- Normalises severity labels (`HIGH`, `High`, `high` → `High`)
- Removes duplicate incident records
- Flags missing training completion dates

### Stage 3 — Dimensions (`03_dimensions.sql`)
- `dim_site` — site metadata with region and plant type
- `dim_department` — department hierarchy
- `dim_employee` — employee dimension with job role and tenure
- `dim_date` — full date spine for trend analysis

### Stage 4 — Fact Table (`04_fact_table.sql`)
- `fct_incidents` — incident fact table with severity scoring and LTI flags
- `fct_audit_scores` — audit performance with open findings count
- `fct_training_compliance` — compliance rate by department and period

### Stage 5 — KPI Metrics (`05_kpi_metrics.sql`)
- Pre-aggregated KPI mart consumed by Power BI
- LTIFR calculation, near-miss rate, rolling audit score trend
- Training compliance % by site and department

---

## Key KPIs

The system tracks both **lagging** and **leading** safety indicators:

**Lagging (what already happened)**
- Total incidents by site and department
- Lost-Time Injuries (LTI) count
- Lost-Time Injury Frequency Rate (LTIFR)
- Average severity score

**Leading (early warning signals)**
- Near-miss rate by department
- Training compliance % by site
- Audit score trend (3-month rolling)
- Open non-compliance findings
- Follow-up closure rate

Monitoring leading indicators enables management to intervene **before** a near-miss becomes a recordable injury.

---

## Dashboard Preview

![Executive Summary Dashboard](power_bi/dashboard_preview/executive_summary.png)

The Power BI report contains three pages:

**1. Executive Summary** — High-level KPI scorecard. LTIFR, severity trend, top 3 at-risk sites, training compliance gauge. Designed for 60-second consumption by plant directors.

**2. EHS Manager View** — Incident breakdown by type, department, and cause. Audit score heatmap by site. Near-miss vs recordable injury ratio trend.

**3. Plant Manager View** — Site-specific drill-down. Employee training completion table. Open corrective actions with age and owner. Compliance status by department.

---

## Project Structure

```
ehs-safety-intelligence/
│
├── data/
│   ├── raw/                      # Original messy source files
│   └── processed/                # Cleaned outputs after BigQuery pipeline
│
├── sql/
│   ├── 01_schema.sql             # Table definitions and data types
│   ├── 02_data_cleaning.sql      # Standardisation, deduplication, null handling
│   ├── 03_dimensions.sql         # dim_site, dim_employee, dim_department, dim_date
│   ├── 04_fact_table.sql         # fct_incidents, fct_audits, fct_training
│   └── 05_kpi_metrics.sql        # Aggregations and KPI mart for Power BI
│
├── power_bi/
│   ├── ehs_dashboard.pbix        # Full Power BI report file
│   └── dashboard_preview/        # Screenshot exports
│
├── reports/
│   └── ehs_findings_report.md    # Written analysis of key findings
│
└── README.md
```

---

## Key Findings

Analysis of 12 months of simulated data surfaced the following insights:

- **Site 3 (Warehouse East)** accounts for 38% of all lost-time injuries despite representing only 21% of total headcount — driven by a combination of low training compliance (61%) and the highest near-miss rate across all sites.
- **Maintenance** and **Loading** departments are repeat-offender departments — same incident types (manual handling, slip/trip) recurring quarterly with no corrective closure.
- **Audit scores** dropped 14 points on average in Q3 across three sites, preceding a spike in recordable incidents in Q4 — confirming audits as a leading indicator worth monitoring closely.
- **Training compliance below 70%** at the department level correlates with a 2.3× higher incident rate in the following quarter.

---

## What This Project Demonstrates

This is not a charting exercise. It demonstrates:

- **Real-world data engineering** — handling messy, inconsistent EHS records the way they actually arrive from the field
- **Safety-critical KPI design** — building metrics that align with ISO 45001 and OSHA recordkeeping standards
- **Dimensional modelling for BI** — star schema design optimised for Power BI DAX queries
- **Executive communication** — translating operational data into decisions, not just dashboards
- **Domain depth** — understanding the difference between LTI, LTIFR, near-miss rates, and why each matters to a different stakeholder

---

## Relevant Industries

This architecture mirrors how EHS analytics is implemented in:
- Manufacturing & heavy industry
- Logistics and warehousing
- Oil & gas / energy
- Construction
- Any regulated industry under ISO 45001, OSHA, or RIDDOR

---

## Potential Extensions

- **Predictive risk scoring** — ML model to flag departments at elevated injury risk 30–60 days out, trained on audit trends and training gaps
- **Incident forecasting** — time-series model to anticipate high-risk periods (seasonal patterns, shift changes)
- **Cost of injury modelling** — estimate direct and indirect costs per incident type for financial reporting
- **Automated training alerts** — trigger notifications when compliance drops below threshold

---

## Tools & Stack

| Layer | Tool |
|---|---|
| Data warehouse | Google BigQuery |
| Data transformation | SQL (BigQuery dialect) |
| Visualisation | Microsoft Power BI |
| Source data format | CSV (simulated from Excel) |
| Documentation | Markdown |

---

## About This Project

Built as a portfolio project to demonstrate end-to-end analytics capability in a safety-critical domain. The data is synthetic but designed to reflect realistic patterns found in manufacturing EHS operations.

**Connect:** [LinkedIn](https://linkedin.com) | **Portfolio:** [GitHub](https://github.com/nawwarah-analyst)
