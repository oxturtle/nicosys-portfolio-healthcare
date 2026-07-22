/*
Business Question: 
Does provider Experience appear to influence patient satisfaction?

Stakeholder: 
Leadership of Valley Regional Medical Center

Purpose:
To see if providers' years of experience has an affect on overall patient satisfaction scores. 

SQL Query: (see below)

Findings:
Across all providers, the average satisfaction scores are within 4.09 - 4.25. 
Every provider has been part of a 5.0 max patient satisfaction score. 
The minimum patient satisfaction score ranges from 2.0 - 2.8. 

Business Insight:
Low scores and high scores are associated across high and low years of experience. 
The average, maximum, and minimum satisfaction scores are close within range of each provider's year of experience. 

Recomendation:
Years of expereince alone does not seem to influence patient satisfaction. 
Furhter investigations into appointment type, department, repeat visits to the same provider or being randomly assigned, and other operational factors. 
*/

Select
	  prov.provider_id
	, prov.years_experience
	, max(patient_satisfaction_score)
	, min(patient_satisfaction_score)
	, round(avg(patient_satisfaction_score),2) as avg_satisf_score

From
	providers prov
		inner join appointments app
			on prov.provider_id=app.provider_id

Group By	
	  prov.provider_id 
	, prov.years_experience

Order By
	avg_satisf_score desc
;


Select
	*
From
	appointments
;

Select
	*
From
	providers
;


--tables used:
Select 
	*
From
	er_visits er
;

Select
	*
From
	patients pts
;

Select 
	*
From
	appointments
;



	



/*
Business Question: 
Which cities generate the highest Emergency Department utilization?
Out of the 3 cities within the datasets, Henderson generates the highest Emergency Department utilization at 1103 visits. 

Stakeholder: 
Leadership of Valley Regional Medical Center

Purpose:
To see patient cities that visit the Emergency Department the most. 

SQL Query: (see below)

Findings:
Henderson generated the highest Emergency Department utilization with 1103 ER visits. 
North Las Vegas generated 970 ER visits.
Las Vegas generated 927 visits. 

Business Insight:
Representing the largest share among the three cities in the dataset, 
Henerson residents accounted for approximately 37% of all Emergency Department visits.
North Las Vegas accounted for ~32%, while Las Vegas accounted for ~31%. 

Recomendation:
Look further into why Henderson residents account for the highest share of Emergency Department visits.
Additional analysis of patient demographics, level of severity, insurance type, and primary diagnoses may help determine wheter higher utilization reflects operational factors.
*/

Select
	  pts.city
	, count(*) as number_of_er_visits 
From
	er_visits er
		inner join patients pts
			on er.patient_id=pts.patient_id
Group By
	pts.city
;





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
