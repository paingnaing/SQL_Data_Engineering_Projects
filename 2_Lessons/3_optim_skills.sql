/*
Question: What are the most optimal skills for data engineers-balancing both demand and salary?
- Create a ranking column that combines demand count and median salary to identify the most valuable skills.
- Focus only on remote Data Engineer positions with specified annual salaries.
- Why?
- This approach highlights skills that balance market demand and financial reward. 
It weights core skills approp
*/

SELECT sd.skills,
    ROUND(MEDIAN(salary_year_avg), 1) Median_salary, 
    COUNT(jpf.*) LN,
    LN * Median_salary optimal_score
FROM job_postings_fact jpf
JOIN skills_job_dim sjd on sjd.job_id = jpf.job_id
JOIN skills_dim sd on sd.skill_id = sjd.skill_id
WHERE job_title_short LIKE 'Data Engineer' AND job_work_from_home = True
GROUP BY sd.skills
HAVING count(jpf.*) > 100
ORDER BY optimal_score DESC
LIMIT 25
;
