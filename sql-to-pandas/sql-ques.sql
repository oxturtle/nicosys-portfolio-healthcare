/*Question 1
Which 5 days had the most students enroll? The result set should include two columns:
start_date: This is the start date of the enrollment.
enrollment_count: This is the count of students enrolling on that start date.*/
SELECT 
    start_date
  , count(unique_id) as enrollment_count 

FROM 
    mock_enrollments

GROUP BY 
    start_date

ORDER BY 
   count(unique_id) desc
;


/*Question 2
How many students were enrolled on February 1, 2019 in 8th grade? The result set should include one column:
enrollment_count: This is the number of students enrolled in 8th grade on February 1, 2019.*/
SELECT 
  count(unique_id) as enrollment_count

FROM 
  mock_enrollments

WHERE grade = 8
  AND start_date = "2019-02-01"
;


/*
Question 3
Create a running total of passed assessments by school day starting March 1, 2019. The result set should include two columns:
date: The date of the school day.
cumulative_passed_assessments: The count of cumulative passed assessments.*/
SELECT 
    test_date
  , sum(passed) OVER (
     ORDER BY test_date) as cumulative_passed_assessments

FROM 
  mock_test_results

WHERE
  test_date >"2019-03-01"
  AND passed = 1
;
