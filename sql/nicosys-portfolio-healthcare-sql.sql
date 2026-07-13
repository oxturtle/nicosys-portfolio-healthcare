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
Order By
	wait_time_minutes
;



