/*
Business Question: 
Which patient age groups experience the longest Emergency Department wait times?

Stakeholder: 
Leadershiop of Valley Regional Medical Center

Purpose:
To see if specific age demographics experience longer wait times than others. 

SQL Query: (see below)

Findings:
The age groups that expereince the longest ER wait times or 180 minutes are, 53, 61, 74, and 76. 
However, the wait time that has the most occurance is 179 mintues, being experienced by 8 age groups. This is double that of age groups experiencing 180 minute wait times. 

Business Insight:
The patient age group experiencing the longest Emergency Department wait times of 180 minutes are, 53, 61, 74, and 76. People who wait 179 minutes occur 50% more than those waiting 180 minutes.
Everyone waiting 180 minutes was over 50 years old. While those waiting 179 minutes have 71% patients over the age of 40, and 29% under 31 years old. 

*/
--Which patient age groups experience the longest Emergency Department wait times?
Select
	  pts.age
	, max(wait_time_minutes) max_wait_time_minutes
From
	er_visits er
		inner join patients pts
			on er.patient_id=pts.patient_id
Group By
	pts.age
Order By
	max_wait_time_minutes desc
;

--Of the wait times, which occurs the most? 179 mintues occurs 8 times compared to 180 minutes occuring 4 times. 
Select
	  max_wait_time_minutes
	, count(max_wait_time_minutes)
From
	(
		Select
			  pts.age
			, max(wait_time_minutes) max_wait_time_minutes
		From
			er_visits er
				inner join patients pts
					on er.patient_id=pts.patient_id
		Group By
			pts.age
		Order By
			max_wait_time_minutes desc
	)
Group By
	max_wait_time_minutes
Order By
	max_wait_time_minutes desc
;

--What are the age groups experiencing wait times of 179 minutes? 89, 70, 52, 48, 42, 30, 24 (71% are over 40)
--What are the age groups experiencing wait times of 180 minutes? 76, 74, 61, 53 (All over 53)
Select
	    pts.age
	--, max(wait_time_minutes) max_wait_time_minutes
From
	er_visits er
		inner join patients pts
			on er.patient_id=pts.patient_id
Where
	wait_time_minutes = 179 --replace the wait time with 180 to see age groups experiencing 180 min wait times.
Group By
	pts.age
Order By
	age desc
;