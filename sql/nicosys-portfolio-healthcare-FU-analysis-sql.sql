/*
Business Question: 
Which patient age groups experience the longest Emergency Department wait times?

To define age groups, the catergories of age are referenced from healthcare industry-strandards:
0–17 (pediatrics) The dataset does not contain any patients under 18.

18–44 (young adults)

45–64 (middle-aged adults)

65+ (older adults / Medicare)


Stakeholder: 
Leadershiop of Valley Regional Medical Center

Purpose:
To see if specific age demographics experience longer wait times than others. 

SQL Query: (see below)

Findings:
Age group 45-64 experience the longest wait times averaging 77 min and a median wait time 72 min.

Business Insight:
The patient age group experiencing the longest Emergency Department wait times compared to others are ages 45-64. 
The average wait time is 77.34 minutes, the median wait time is 72 min, and the max wait time is 180 minutes. Their total ER visist is 867.
Age group 18-44 wait an average of 73.99 minutes, have a median wait time of 66 minutes, and experienced a max wait time of 179 min. Their total ER visist is 934.
Lastly Older Adults (ages 65+) wait on average 72.38 minutes, have a median wait time of 65 minutes, and experienced a max watit time of 180 mintues. Their total ER visist is 1199. 

Recomendation:
Further investigate whether the longer wait times among patients aged 45-64 are associated with visit severity, arrival time, diagnostic needs, or other operational factors. 
Since the difference in average wait times is modest, no operational change should be made based on age alone. 
*/
--Which patient age groups experience the longest Emergency Department wait times?

--The following CTE, groups the ages into 4 categories. The dataset does not contain any patients under 18. 
with patient_age_groups as (
	Select
		  er.wait_time_minutes
		, pts.age
		, case
			when pts.age <18 then 'Under_18'
			when pts.age between 18 and 44 then '18-44'
			when pts.age between 45 and 64 then '45-64' --middle age
			when pts.age >64 then 'Older_Adults'
			else 'Group_Not_Represented'
		  end as age_group
	From
		er_visits er
			inner join patients pts
				on er.patient_id=pts.patient_id
)
--Then from the CTE, I select the fields I want displayed and group findings by age groups.
Select
	  age_group
	, count(*) as total_er_visits
	, round(avg(wait_time_minutes),2) as average_wait_time_minutes 
	--round((),2) allows me to take a value and only go up to 2 decimal places
	, percentile_cont(.5)
		within group(order by wait_time_minutes) as median_wait_time
	, max(wait_time_minutes) as max_wait_time_minutes
From
	patient_age_groups
Group By
	age_group
Order By
	average_wait_time_minutes desc
;
	
