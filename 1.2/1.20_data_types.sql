SELECT 
    company_id,
    job_id, 
    CAST(job_work_from_home as INT) as job_work_from_home,
    CAST(job_posted_date as DATE) as job_posted_date, 
    CAST(salary_year_avg as DECIMAL(10, 0)) as salary_year_avg
FROM data_jobs.job_postings_fact
WHERE salary_year_avg IS NOT NULL
LIMIT 10;
