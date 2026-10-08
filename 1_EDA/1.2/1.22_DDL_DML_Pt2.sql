CREATE OR REPLACE TABLE  staging.job_postings_flat as 
SELECT
    jpf.job_title_short,
    jpf.job_id,
    jpf.job_title,
    jpf.job_location,
    jpf.job_via,
    jpf.job_schedule_type,
    jpf.job_work_from_home,
    jpf.search_location,
    jpf.job_posted_date,
    jpf.job_no_degree_mention,
    jpf.job_health_insurance,
    jpf.job_country,
    jpf.salary_rate,
    jpf.salary_year_avg,
    jpf.salary_hour_avg,
    cd.name as company_name
FROM data_jobs.job_postings_fact AS jpf
LEFT JOIN data_jobs.company_dim AS cd
    ON cd.company_id = jpf.company_id
;

SELECT COUNT(*)
FROM staging.job_postings_flat;

CREATE OR REPLACE VIEW staging.priority_jobs_flat_view as 
SELECT jpf.*
FROM staging.job_postings_flat as jpf
JOIN staging.priority_roles as r ON r.role_name = jpf.job_title_short
WHERE r.priority_lvl = 1
;

SELECT job_title_short, COUNT(*) as counts
FROM staging.priority_jobs_flat_view
GROUP BY job_title_short
ORDER BY counts DESC
;


CREATE TEMPORARY TABLE data_engineer_temp_test as 
SELECT DISTINCT job_title
FROM staging.priority_jobs_flat_view
WHERE job_title_short LIKE '%Data Engineer';

DROP TABLE data_engineer_temp;

SHOW TABLES FROM jobs_mart.main;
SHOW TABLES FROM jobs_mart.staging;

SE