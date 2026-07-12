--The following code is how I built the tables for my healthcare portfolio project. 

Create Table appointments (
	  appointment_id bigint
	, patient_id bigint
	, provider_id bigint
	, department char(20)
	, appointment_date date
	, appointment_day char(10)
	, appointment_type varchar(20)
	, appointment_status char(10)
	, appointment_duration_mintues int
	, patient_satisfaction_score decimal(2,1)
)
;

Create Table patients (
	  patient_id bigint
	, patient_name varchar(25)
	, age int
	, gender varchar(10)
	, city varchar(25)
)
;


Create Table providers (
	  provider_id bigint
	, provider_name varchar(25)
	, department char(17)
	, years_experience int
)
;

Create Table er_visits (
	  visit_id bigint
	, patient_id bigint
	, arrival_date date
	, arrival_day char(9)
	, arrival_hour int
	, severity_level varchar(20)
	, wait_time_minutes int
	, length_of_stay_hours decimal(4,2)
	, admitted char(3)
)
;


Select 
	*
From
	
;