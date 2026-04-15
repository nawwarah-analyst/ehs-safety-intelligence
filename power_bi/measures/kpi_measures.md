# 1. Fundamental Base Measures

##### Total Incident Count
`Total Incidents = COUNT(fact_incidents[incident_id])`

##### Lost Time Injuries (LTI) - Only count serious injuries
`LTI Count = CALCULATE([Total Incidents],fact_incidents[days_lost] > 0)`

##### Recordable Incidents (For TRIR)
`Recordable Incidents = CALCULATE( [Total Incidents], fact_incidents[incident_type] IN {"LTI", "Medical Aid"})`

##### Total Days Lost
`Total Days Lost = SUM(fact_incidents[days_lost])`

---
# 2. Industry Standard Rates (LTIFR & TRIR)
### A mid-size company with 1,200 employees, we will estimate **2,500,000 man-hours per year** (approx. 208,333 per month).


##### Monthly Man Hours (Assuming 1200 pax * 174 hours avg)
`Total Man Hours = 
VAR AvgMonthlyHours = 174
VAR TotalHeadcount = 1200
VAR NumberOfMonthsSelected = DISTINCTCOUNT(dim_date[Month Year])
RETURN
TotalHeadcount * AvgMonthlyHours * NumberOfMonthsSelected`

##### LTIFR (Lost Time Injury Frequency Rate)
###### Formula: (LTI / Hours) * 1,000,000
`LTIFR = 
DIVIDE([LTI Count] * 1000000,[Total Man Hours], 0)`

##### Severity Score
`Avg Severity Score = AVERAGE(fact_incidents[severity_score])`

##### Near Miss Ratio
`Near Miss Ratio = DIVIDE([Total Near Miss], [Total Incidents])`

---
# 3. Compliance
##### Training Completion
`Training Completion % =
VAR TotalStaff = DISTINCTCOUNT(dim_employee[employee_id])
VAR TrainedStaff = CALCULATE(DISTINCTCOUNT(fact_training[employee_id]), fact_training[is_completed] = 1)
RETURN
DIVIDE(TrainedStaff, TotalStaff, 0)`

##### Expiring Certificates
`Expiring Certificates = 
CALCULATE(
    COUNT(fact_training[employee_id]),
    USERELATIONSHIP(dim_date[Date], fact_training[expiry_date]))`

##### Average Audit Score
`Avg Audit Score = AVERAGE(fact_audits[audit_score])`

##### Follow-up Rate
`Follow-up Rate = AVERAGE(fact_audits[is_followup_required])`
