--What is the average wait time in ER: 74.31 minutes
Select
	avg(wait_time_minutes) average_wait_time_minutes
From
	er_visits 
;


--What is the median wait time in ER: 67 minutes
Select
	percentile_disc(.5)
	Within Group (Order By wait_time_minutes) as median_wait_time
From
	er_visits 
;

-- What days of the week experience the longest wait times? Mondays, Tuesdays, Thursdays, and Saturdays 
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


/*What Hour(s) experienced the highest patient volume?
The top 3 hours of the day that experienced the most patients in a day are:
02:00 at 144 pts, 21:00 at 141 pts, and 0:00 with 140 pts. Totaling 425 pts. 

Amount of Severity Level pts during peak times: 
Low = 137 | 32% of pts during peak hours are Low Severity  
Medium = 165 | 39% of pts during peak hours are Medium Severity
High = 100 | 24% of pts during peak hours are High Severity
Critical = 23 | 5% of pts during peak hours are Critical 
*/
Select
	sum(number_of_patients_er_visits)
From
	(
		Select
			  count(*) as number_of_patients_er_visits
			, arrival_hour
		From
			er_visits
		Where
			severity_level = 'Medium'
			and arrival_hour IN (2, 21, 0)
		Group By
			  arrival_hour
		Order By
			number_of_patients_er_visits desc
	)
;

--What hours of day see the most patients in the ER? 0200, 2100, and 000
Select
			  count(*) as number_of_patients_er_visits
			, arrival_hour
		From
			er_visits
		Group By
			  arrival_hour
		Order By
			number_of_patients_er_visits desc


/*Does Severity Levels impact Wait Times? 
Yes. As severity levles rise, so does the maximum wait times.
1052 Low Severity 
Med Severity 1158
High Severity 642
Critical 148
*/

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
	and wait_time_minutes >120
Order By
	wait_time_minutes
;

/*Are Admitted Patients waiting longer than dicharged patients?
Yes, but it's not substantial. Admitted pts wait an avg 76 min vs Dishcarged Patients at 73 min
*/
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


--Is there a pattern to Patients' ER visits?
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




--How many times in 18 months does a patient visit the ER? Are these normal or frequent flyers?
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
;
