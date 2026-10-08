SELECT 
    job_title_short,
    salary_hour_avg,
    salary_year_avg,
    COALESCE(salary_year_avg, salary_hour_avg*2080) AS Year_Salary,
    CASE
    WHEN Year_Salary IS NULL THEN 'MISSING'
    WHEN Year_Salary < 75_000 THEN 'LOW'
    WHEN Year_Salary <= 150_000 THEN 'MEDIUM'
    ELSE 'HIGH'
    END AS Salary_Category
FROM job_postings_fact
ORDER BY Year_Salary ASC;