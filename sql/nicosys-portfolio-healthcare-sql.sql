--avg wait times in er: 74.31 minutes
Select
	avg(wait_time_minutes) average_wait_time_minutes
From
	er_visits 
;


--median wait time in er: 67 minutes
Select
	percentile_disc(.5)
	Within Group (Order By wait_time_minutes) as median_wait_time
From
	er_visits 
;

-- Days of the week experiencing longest wait times. 
Select
	  arrival_day
	, max(wait_time_minutes)
From
	er_visits
Group By
	  arrival_day
	, wait_time_minutes
Order By
	wait_time_minutes desc
;


--Hours experiencing the highest patient volume
Select
	  count(arrival_date) as number_of_patients
	, arrival_date
	, arrival_hour
From
	er_visits
Group By
	  arrival_hour
	, arrival_date
Order By
	number_of_patients desc
;

--Correlation between Severity Level and Wait Time | 1052 Low Severity | 439 Low Severity >=120 | 613 Low Severity <120 | Med Severity 1158, >=120: 13, <120:1145 | 452 | .97/.03
Select
	  visit_id
	, patient_id
	, arrival_date
	, arrival_day
	, arrival_hour
	, severity_level
	, wait_time_minutes
	, length_of_stay_hours
	, admitted
From
	er_visits
Where
	severity_level = 'Low'
	and wait_time_minutes <120
Order By
	wait_time_minutes
;


Select
	  visit_id
	, patient_id
	, arrival_date
	, arrival_day
	, arrival_hour
	, severity_level
	, wait_time_minutes
	, length_of_stay_hours
	, admitted
From
	er_visits
;




