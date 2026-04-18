# Supply Chain Risk & Financial Exposure Analytics

## Procurement Risk Intelligence for Operations & Finance Teams

### Project Overview

This project simulates an enterprise-grade supply chain risk system built for a procurement team facing a problem most organisations cannot quantify:

- Supplier deliveries are unpredictable — but no one knows by how much
- Capital is being tied up in safety stock to buffer against unknown volatility
- Finance cannot put a dollar figure on supplier-driven risk
- Procurement decisions are based on average lead times, which hide the real danger

The goal is to convert raw order and delivery data into a quantified, decision-ready risk intelligence platform that allows leadership to:

- Know exactly how much of their portfolio is financially exposed
- Identify which suppliers and categories are driving that exposure
- Act before disruptions happen, not after

---

### Business Problem

The procurement team has no centralised view of supplier reliability in financial terms.
Leadership cannot answer:

- Which suppliers are the most unpredictable — and how unpredictable?
- How much money is currently at risk because of delivery volatility?
- Which product categories need immediate intervention?
- Are we over-buffering with safety stock because we don't trust our suppliers?

They currently respond to supply disruptions reactively. This project changes that.

---

### Solution Architecture

This project implements a full procurement risk intelligence pipeline:

#### Data Source
- Supply chain logistics dataset (Kaggle) — 1,000 orders, 30 suppliers, 5 product categories, Jan–Dec 2023

#### Statistical Engine (Python)
- Feature engineering: Actual Lead Time derived from Order Date and Delivery Date
- Supplier Volatility Index: Coefficient of Variation (CV) of lead times per supplier
- Risk classification: High / Medium / Low grade assigned to every supplier
- Output: Enriched dataset with risk metrics that don't exist in the raw data

#### Relational Engine (BigQuery)
- Star Schema design: `Fact_Orders` joined to `Dim_Suppliers`
- Pre-aggregated executive risk view — isolates Value at Risk by category and risk grade
- Optimised for fast Power BI query performance

#### Visualisation (Power BI)
- Interactive 2-page dashboard for executives and procurement analysts
- DAX measures for Value at Risk, Risk Exposure %, and dynamic Risk Status flags

---

### Dashboard Preview

[![Executive Summary](power_bi/dashboard_preview/executive_summary.png)](power_bi/dashboard_preview/executive_summary.png)

---

### Key Results

| Metric | Value |
|---|---|
| Total Portfolio Value | $25.29M |
| **Value at Risk (VaR)** | **$22.43M** |
| Risk Exposure % | **88.69%** |
| Orders with Disruptions | 514 of 1,000 (51.4%) |
| Categories in Critical Status | Electronics, Pharma |

> 88.69% of total procurement spend is tied to High Volatility suppliers. In a healthy supply chain, this figure typically sits below 30%.

---

### Key Business KPIs

The system tracks:

- **Value at Risk (VaR)** — total spend tied to High Volatility suppliers
- **Risk Exposure %** — proportion of portfolio at risk
- **Volatility Index (CV)** — delivery unpredictability score per supplier
- **Risk Grade** — High / Medium / Low classification per supplier
- **Avg Actual Lead Time** — true end-to-end delivery window
- **Disruption Rate** — share of orders affected by Shortage, Strike, Weather, or Customs events

These metrics combine to give procurement and finance a single view of both current exposure and the suppliers driving it.

---

### What This Project Demonstrates

This is not a standard dashboard exercise.
It demonstrates:

- Feature engineering on raw transactional data (deriving metrics that don't exist)
- Statistical modelling for operational risk (Coefficient of Variation as a volatility signal)
- Cloud data engineering (BigQuery Star Schema with pre-aggregated analytical views)
- Executive-level DAX logic (VaR, dynamic risk status flags, conditional formatting)
- End-to-end pipeline thinking: raw data → enriched metrics → relational model → decision dashboard

It mirrors how supply chain risk analytics is applied in:

- Manufacturing and logistics operations
- Procurement and strategic sourcing teams
- Finance teams responsible for working capital optimisation

---

### Who This Is For

This project is designed for:

- Procurement Managers and Supply Chain Leaders
- Operations and Finance Directors
- Data Analytics recruiters evaluating full-stack analytical capability

It shows how data can be used to:

- Quantify supplier risk in financial terms
- Reduce safety stock costs through better supplier intelligence
- Prevent reactive crisis management with proactive risk scoring

---

### Next Steps

Future extensions could include:

- Composite risk index incorporating demand volatility and price fluctuation
- Automated monthly supplier re-scoring pipeline with risk grade change alerts
- Predictive disruption modelling using historical `Disruption_Type` and `Disruption_Severity` data
- Cost of disruption modelling (inventory holding cost + stock-out penalty)

---

### Full Technical Documentation

For complete methodology, formula derivations, SQL schema design, DAX logic, and a limitations analysis — see [`Technical Documentation.pdf`](Technical%20Documentation.pdf)

---

> **Stack:** Python · SQL (Google BigQuery) · Power BI (DAX)  
> **Data:** [Kaggle Supply Chain Logistics Dataset](https://www.kaggle.com/) — simulated for portfolio purposes
