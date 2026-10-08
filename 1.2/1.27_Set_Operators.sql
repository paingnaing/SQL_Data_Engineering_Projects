CREATE TEMP TABLE jobs_2023 as 
SELECT * EXCLUDE (job_id, job_posted_date)
FROM job_postings_fact
WHERE EXTRACT(Year FROM job_posted_date) = 2023
;

SELECT *
FROM jobs_2023
LIMIT 10;

CREATE TEMP TABLE jobs_2024 as 
SELECT * EXCLUDE (job_id, job_posted_date)
FROM job_postings_fact
WHERE EXTRACT(Year FROM job_posted_date) = 2024
;

SELECT *
FROM jobs_2024
LIMIT 10;

SELECT *
FROM jobs_2023
INTERSECT ALL
SELECT * 
FROM jobs_2024;
