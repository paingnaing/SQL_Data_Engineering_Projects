SELECT sd.skills, ROUND(MEDIAN(salary_year_avg), 1), count(*) as Count
FROM job_postings_fact jpf
JOIN skills_job_dim sjd on sjd.job_id = jpf.job_id
JOIN skills_dim sd on sd.skill_id = sjd.skill_id
WHERE job_title_short LIKE 'Data Engineer' AND job_work_from_home = True
GROUP BY sd.skills
ORDER BY Count DESC
LIMIT 25
;
/*
┌────────────┬───────────────────────────────────┬───────┐
│   skills   │ round(median(salary_year_avg), 1) │ Count │
│  varchar   │              double               │ int64 │
├────────────┼───────────────────────────────────┼───────┤
│ sql        │                          130000.0 │ 29221 │
│ python     │                          135000.0 │ 28776 │
│ aws        │                          137320.3 │ 17823 │
│ azure      │                          128000.0 │ 14143 │
│ spark      │                          140000.0 │ 12799 │
│ airflow    │                          150000.0 │  9996 │
│ snowflake  │                          135500.0 │  8639 │
│ databricks │                          132750.0 │  8183 │
│ java       │                          135000.0 │  7267 │
│ gcp        │                          136000.0 │  6446 │
│ kafka      │                          145000.0 │  6415 │
│ scala      │                          137290.5 │  6304 │
│ redshift   │                          130000.0 │  5737 │
│ hadoop     │                          135000.0 │  5447 │
│ pyspark    │                          140000.0 │  4898 │
│ git        │                          140000.0 │  4641 │
│ power bi   │                          120000.0 │  4600 │
│ nosql      │                          134415.0 │  4514 │
│ tableau    │                          115000.0 │  4402 │
│ docker     │                          135000.0 │  4316 │
│ kubernetes │                          150500.0 │  4202 │
│ sql server │                          120000.0 │  3931 │
│ bigquery   │                          135000.0 │  3523 │
│ mongodb    │                          135750.0 │  3512 │
│ postgresql │                          122500.0 │  3360 │
└────────────┴───────────────────────────────────┴───────┘
*/