# 1. Fundamental Base Measures
### These are the building blocks. Create these first.

#### Code snippet

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

#### Code snippet

##### Monthly Man Hours (Assuming 1200 pax * 174 hours avg)
`Monthly Man Hours = 1200 * 174`

##### LTIFR (Lost Time Injury Frequency Rate)
###### Formula: (LTI / Hours) * 1,000,000
`LTIFR = VAR TotalLTI = [LTI Count]`
-- Assuming 1,200 employees working 176 hours a month
`VAR TotalHours = 1200 * 176
RETURN
DIVIDE(TotalLTI * 1000000, TotalHours, 0)`

##### TRIR (Total Recordable Incident Rate)
###### Formula: (Recordable / Hours) * 200,000
`TRIR = DIVIDE([Recordable Incidents] * 200000, [Monthly Man Hours], 0)`

##### Severity Rate (Average Days Lost per Incident)
`Severity Rate = DIVIDE([Total Days Lost], [Total Incidents], 0)`
