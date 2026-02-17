# EHS Safety Intelligence System
## Operational Risk Analytics for Manufacturing & Logistics

### Project Overview
This project simulates an enterprise-grade `Environment, Health & Safety (EHS) analytics system` built for a mid-size manufacturing and logistics company facing:
- Rising workplace incidents
- Failing safety audits
- Training non-compliance
- Increasing regulatory pressure

The goal is to convert fragmented Excel-based safety records into a data-driven risk intelligence platform that allows management to:
- Identify high-risk departments and sites
- Track audit and training compliance
- Detect early warning signals before accidents occur

### Business Problem
The company has no centralized view of safety performance.
Management cannot answer:
- Which departments are driving incidents?
- Why do the same accidents keep repeating?
- Are employees properly trained?
- Which site will fail the next audit?

They currently react after injuries occur instead of preventing them.

### Solution Architecture
This project implements a full EHS Business Intelligence pipeline:
#### Data Sources
- Incident logs
- Safety audits
- Training records

#### Data Processing
- Data cleaning & standardization in BigQuery
- Date normalization, severity scoring, compliance flags
- Dimensional modeling (Employee, Site, Department)

#### Analytics Layer
- Risk and KPI aggregation tables
- Incident, training, and audit relationships

#### Visualization
Interactive  `Power BI dashboards` for:
- Executives
- EHS Managers
- Plant Managers

### Dashboard Preview
![Executive Summary](executive_summary.png)

### Key Business KPIs
The system tracks:
- Total incidents
- Lost-time injuries (LTI)
- LTIFR
- Severity score
- Near-miss rate
- Training compliance
- Audit score
- Non-compliance volume
- Follow-up closure rate

These metrics allow leadership to monitor both:
- Lagging indicators (injuries)
- Leading indicators (training, audits, near misses)

### What This Project Demonstrates
This is not a charting exercise.
It demonstrates:
- Real-world messy data handling
- Safety-critical KPI design
- Risk-based analytics
- Dimensional modeling for BI
- Executive-level reporting

It mirrors how EHS analytics is implemented in regulated industries such as:
- Manufacturing
- Logistics
- Energy
- Heavy industry

### Who This Is For
This project is designed for:
- EHS Managers
- Operations Leaders
- Compliance Officers
- Data Analytics recruiters

It shows how data can be used to:
- Reduce injuries
- Improve audit performance
- Lower regulatory and financial risk

### Next Steps
Future extensions could include:
- Predictive risk scoring
- Incident forecasting
- Automated training alerts
- Cost of injury modeling
