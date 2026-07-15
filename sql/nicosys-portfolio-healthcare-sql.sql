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
	severity_level = 'Critical'
	--and wait_time_minutes <120
Order By
	wait_time_minutes
;

--Wait Times of Admitted Patients: 76 min vs Dishcarged Patients: 73 min
Select
	  avg(wait_time_minutes) avg_wait_time_min
	, admitted
From
	er_visits
Where
	admitted = 'Yes'
Group By
	admitted
;

Select
	  avg(wait_time_minutes) avg_wait_time_min
	, admitted
From
	er_visits
Where
	admitted = 'No'
Group By
	admitted
;

--Patient Volume
Select
	  patient_id
	, count(patient_id) number_of_er_visits
From
	er_visits
Group By
	patient_id
Order By
	number_of_er_visits desc
;

Select
	  patient_id
	, count(patient_id) number_of_visits
	, arrival_date
	, severity_level
	, admitted
From
	er_visits
Group By
	  patient_id
	, severity_level
	, admitted
	, arrival_date
Order By
	patient_id
;

--Patient's volume of er visits
SELECT
    patient_id,
    arrival_date,
    severity_level,
    admitted,
    ROW_NUMBER() OVER (
        PARTITION BY patient_id
        ORDER BY arrival_date
    ) AS visit_order
FROM er_visits
ORDER BY patient_id, arrival_date;
;

Select
	  visits_in_18_months
	, count(visits_in_18_months) number_of_pts
From
	(
		SELECT
		      patient_id
		    , COUNT(*) AS visits_in_18_months
			--, severity_level
		FROM 
			er_visits
		GROUP BY 
			  patient_id
			--, severity_level
		ORDER BY 
			visits_in_18_months DESC
	)
Group By
	visits_in_18_months
Order By
	number_of_pts desc
;


SELECT
      patient_id
    , COUNT(*) AS visits_in_18_months
	--, severity_level
FROM 
	er_visits
GROUP BY 
	  patient_id
	--, severity_level
ORDER BY 
	visits_in_18_months DESC;


SELECT
    visits_in_18_months,
    NTILE(100) OVER (ORDER BY visits_in_18_months) AS percentile
FROM (
    SELECT
        patient_id,
        COUNT(*) AS visits_in_18_months
    FROM er_visits
    GROUP BY patient_id
) t;


--Records from 2025-01-01 to 2026-06-25
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
WHERE 
	arrival_day IN ('Monday', 'Tuesday', 'Thursday', 'Saturday')
	and wait_time_minutes >60
	and arrival_hour IN (1, 10)
Order By
	wait_time_minutes desc
;

Select
	avg(length_of_stay_hours)
From
	(
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
		WHERE 
			arrival_day IN ('Monday', 'Tuesday', 'Thursday', 'Saturday')
			and wait_time_minutes >60
			and arrival_hour IN (1, 10)
		Order By
			wait_time_minutes desc
	)
;






