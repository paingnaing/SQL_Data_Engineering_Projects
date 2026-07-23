/*
Question: What are the most in-demand skills for data engineers?
- Join job postings to inner join table similar to query 2
- Identify the top 10 in-demand skills for data engineers
- Focus on remote job postings
- Why? Retrieves the top 10 skills with the highest demand in the remote job market,
    providing insights into the most valuable skills for data engineers seeking remote work
*/

SELECT sd.skills, count(*) as nos
FROM job_postings_fact jpf
JOIN skills_job_dim sjd on sjd.job_id = jpf.job_id
JOIN skills_dim sd on sd.skill_id = sjd.skill_id
WHERE jpf.job_title_short = 'Data Engineer'
    AND job_work_from_home = 'True'
GROUP BY sd.skills
ORDER BY nos DESC
LIMIT 10;

┌────────────┬───────┐
│   skills   │  nos  │
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



