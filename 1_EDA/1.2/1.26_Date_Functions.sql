SELECT 
    job_posted_date::DATE as date,
    EXTRACT('month' FROM date) as MONTH
FROM job_postings_fact
LIMIT 10;