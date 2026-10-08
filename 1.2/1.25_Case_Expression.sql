
-- SELECT 
--     job_title_short, 
--     COUNT(*) AS total_postings,
--     MEDIAN(
--         CASE
--             WHEN salary_year_avg < 100_000 THEN salary_year_avg
--         END
--     ) as median_low_salary,
--      MEDIAN(
--         CASE
--             WHEN salary_year_avg >= 100_000 THEN salary_year_avg
--         END
--     ) as median_high_salary
-- FROM job_postings_fact
-- WHERE salary_year_avg IS NOT NULL
-- GROUP BY job_title_short
-- LIMIT 10;

WITH salaries as (
SELECT
    job_title_short,
    salary_hour_avg,
    salary_year_avg,
    CASE
        WHEN salary_year_avg IS NOT NULL THEN salary_year_avg
        WHEN salary_hour_avg IS NOT NULL THEN salary_hour_avg*2080
    END as standardized_salary
FROM 
    job_postings_fact
WHERE salary_year_avg IS NOT NULL OR salary_hour_avg IS NOT NULL
LIMIT 10)
SELECT 
    standardized_salary,
    CASE
        WHEN standardized_salary < 75_000 THEN 'Low'
        WHEN standardized_salary BETWEEN 75_000 AND 150_000 THEN 'Medium'
        WHEN standardized_salary >= 150_000 THEN 'High'
    END as salary_category 
FROM salaries
ORDER BY standardized_salary DESC;