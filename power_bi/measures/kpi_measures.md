-Dim Date Table
dim_date =
VAR MinDate =
MINX (
UNION (
SELECTCOLUMNS ( fact_incidents, "d", fact_incidents[incident_date] ),
SELECTCOLUMNS ( fact_audit, "d", fact_audit[audit_date] ),
SELECTCOLUMNS ( fact_training, "d", fact_training[completion_date] )
),
[d]
)
VAR MaxDate =
MAXX (
UNION (
SELECTCOLUMNS ( fact_incidents, "d", fact_incidents[incident_date]),
SELECTCOLUMNS ( fact_audit, "d", fact_audit[audit_date] ),
SELECTCOLUMNS ( fact_training, "d", fact_training[completion_date])
),
[d]
)
RETURN
ADDCOLUMNS (
CALENDAR ( MinDate, MaxDate ),
"Year", YEAR ( [Date] ),
"Quarter", "Q" & FORMAT ( [Date], "Q" ),
"Month Number", MONTH ( [Date] ),
"Month Name", FORMAT ( [Date], "MMM" ),
"Month Year", FORMAT ( [Date], "MMM YYYY" ),
"Month Year Sort", FORMAT ( [Date], "YYYYMM" ), -- Essential for sorting charts
"Weekday", FORMAT ( [Date], "dddd" ),
"Is Weekend", IF( WEEKDAY([Date], 2) > 5, "Weekend", "Weekday" ) -- Great for seeing if accidents happen on weekends
)
