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

-- What days of the week experience the longest wait times? Mondays, Tuesdays, Thursdays, and Saturdays experience max wait times of 179 and 180 minutes. 
Select
	  arrival_day
	, max(wait_time_minutes) max_wait_time_min
From
	er_visits
Group By
	  arrival_day
Order By
	max_wait_time_min desc
;

/*
Between 179 and 180, which days have more occurances of each?
Although Mon, Tues, Thurs, and Sat experience the highest wait times, 180 min only occurs once. 
The days experiencing 179 min wait times more than once are Saturdays(3) and Thursdays(2). 
*/



Select
	    count(*) instance_waiting_179_min
	  , arrival_day
From
	er_visits
Where
	wait_time_minutes = 179
Group By
	arrival_day
Order By
	instance_waiting_179_min desc
;

Select
	    count(*) instance_waiting_180_min
	  , arrival_day
From
	er_visits
Where
	wait_time_minutes = 180
Group By
	arrival_day
Order By
	instance_waiting_180_min
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


--This version of code allows me to do what the above code does without having to manually change the where clause, severity_level.
--This shows me all severity levels and I can compare all at once. 
Select
	  sum(number_of_patients_er_visits) pts_seen_in_busy_hours
	, severity_level
From
	(
		Select
			  count(*) as number_of_patients_er_visits
			, arrival_hour
			, severity_level
		From
			er_visits
		Where
			arrival_hour IN (2, 21, 0)
		Group By
			    arrival_hour
			  , severity_level
		Order By
			number_of_patients_er_visits desc
	)
Group By
	severity_level
Order By
	pts_seen_in_busy_hours desc
;
	


/*
I couldn't calculate the percent copmposition of the amount of pts seen during busy hours.
I used 
*/
WITH busy_hours AS (
    SELECT
          severity_level
        , COUNT(*) AS pts_seen_in_busy_hours
    FROM 
		er_visits
    WHERE 
		arrival_hour IN (0, 2, 21)
    GROUP BY 
		severity_level
)
SELECT
      severity_level
    , pts_seen_in_busy_hours
    , ROUND(
	        pts_seen_in_busy_hours * 100.0 /
	        SUM(pts_seen_in_busy_hours) OVER (), 2
    	   ) AS pct_composition
FROM 
	busy_hours
ORDER BY 
	pts_seen_in_busy_hours DESC
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
1052 Low Severity pts seen with avg wait time of 109 min
Med Severity 1158 pts seen with avg wait time of 73 min
High Severity 642 pts seen with avg wait time of 35 min
Critical 148 pts seen with avg wait time of 7 min
*/


--The following was an easier way to find the avg wait times based on severity levels. I didn't realize until validating in Excel, that there was an easier way. 
Select
	  avg(wait_time_minutes) avg_wait_time_minutes
	, severity_level

From
	er_visits

Group By
	severity_level

Order By
	avg_wait_time_minutes desc
;


--Low avg wait time = 108.85
Select
	avg(wait_time_minutes)
From
	(
		Select
			*
		From
			er_visits
		Where
			severity_level = 'Low'
			--and wait_time_minutes >120
		Order By
			wait_time_minutes
	)
;

--Medium avg wait time = 73.16
Select
	avg(wait_time_minutes)
From
	(
		Select
			*
		From
			er_visits
		Where
			severity_level = 'Medium'
			--and wait_time_minutes >120
		Order By
			wait_time_minutes
	)
;


--High avg wait time = 35.22 min
Select
	avg(wait_time_minutes)
From
	(
		Select
			*
		From
			er_visits
		Where
			severity_level = 'High'
			--and wait_time_minutes >120
		Order By
			wait_time_minutes
	)
;

--Critical avg wait time = 7 
Select
	avg(wait_time_minutes)
From
	(
		Select
			*
		From
			er_visits
		Where
			severity_level = 'Critical'
			--and wait_time_minutes >120
		Order By
			wait_time_minutes
	)
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


Select
	  count(occurances)
	, occurances
From
	(
		Select
			  count(wait_time_minutes) occurances
			, wait_time_minutes
		From
			er_visits
		Where
			wait_time_minutes >120
		Group By
			wait_time_minutes
		Order By
			occurances desc
	)
Group By
	occurances
Order By
	count(occurances)
;

