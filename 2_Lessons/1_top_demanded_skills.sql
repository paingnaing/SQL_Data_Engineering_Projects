/* 
Question - What are the most in-demand skills for data engineers?
    - Identify the 10 in-demand skills for data engineers
    - Focus on remote job postings
    - Why ? 
        - Retrives the top 10 skills with the higehest demand in the remote 
*/

SELECT sd.skills, count(*) as count
FROM job_postings_fact jpf
JOIN skills_job_dim sjd on sjd.job_id = jpf.job_id
JOIN skills_dim sd on sd.skill_id = sjd.skill_id
WHERE job_title_short LIKE 'Data Engineer' AND job_work_from_home = True
GROUP BY jpf.job_title_short, sd.skills
ORDER BY count DESC
LIMIT 10
;
/*
┌────────────┬───────┐
│   skills   │ count │
│  varchar   │ int64 │
├────────────┼───────┤
│ sql        │ 29221 │
│ python     │ 28776 │
│ aws        │ 17823 │
│ azure      │ 14143 │
│ spark      │ 12799 │
│ airflow    │  9996 │
│ snowflake  │  8639 │
│ databricks │  8183 │
│ java       │  7267 │
│ gcp        │  6446 │
└────────────┴───────┘
*/
