-- CREATE
CREATE OR REPLACE TEMP TABLE src_priority_jobs AS
SELECT
    jpf.job_id,
    jpf.job_title_short,
    cd.name as company_name,
    jpf.job_posted_date,
    jpf.salary_year_avg,
    r.priority_lvl,
    CURRENT_TIMESTAMP as updated_at
FROM 
    data_jobs.job_postings_fact jpf
LEFT JOIN data_jobs.company_dim cd on cd.company_id =  jpf.company_id
INNER JOIN staging.priority_roles r on r.role_name = jpf.job_title_short;


-- -- UPDATE
-- UPDATE main.priority_jobs_snapshot AS tgt
-- SET 
--     priority_lvl = src.priority_lvl,
--     updated_at = src.updated_at
-- FROM src_priority_jobs AS src
-- WHERE tgt.job_id = src.job_id
--     AND tgt.priority_lvl IS DISTINCT FROM src.priority_lvl;


-- -- INSERT
-- INSERT INTO main.priority_jobs_snapshot(
--     job_id,
--     job_title_short,
--     company_name,
--     job_posted_date,
--     salary_year_avg,
--     priority_lvl,
--     updated_at
-- )
-- SELECT
--     src.job_id,
--     src.job_title_short,
--     src.company_name,
--     src.job_posted_date,
--     src.salary_year_avg,
--     src.priority_lvl,
--     src.updated_at
-- FROM src_priority_jobs as src
-- WHERE NOT EXISTS(
--     SELECT 1
--     FROM main.priority_jobs_snapshot tgt
--     WHERE tgt.job_id = src.job_id
-- );


-- -- DELETE 
-- DELETE FROM main.priority_jobs_snapshot as tgt
-- WHERE NOT EXISTS(
--     SELECT 1
--     FROM src_priority_jobs src
--     WHERE src.job_id = tgt.job_id
-- );

-- MERGE INTO
MERGE INTO main.priority_jobs_snapshot as tgt
USING src_priority_jobs as src
on tgt.job_id = src.job_id
WHEN MATCHED AND tgt.priority_lvl IS DISTINCT FROM src.priority_lvl THEN
    UPDATE SET
     priority_lvl = src.priority_lvl,
     updated_at = src.updated_at
WHEN NOT MATCHED THEN
    INSERT (
    job_id,
    job_title_short,
    company_name,
    job_posted_date,
    salary_year_avg,
    priority_lvl,
    updated_at
)
VALUES (
    src.job_id,
    src.job_title_short,
    src.company_name,
    src.job_posted_date,
    src.salary_year_avg,
    src.priority_lvl,
    src.updated_at
)
WHEN NOT MATCHED BY SOURCE THEN DELETE;

SELECT
    job_title_short,
    count(*) as count,
    priority_lvl,
    min(updated_at) as updated_at
FROM
    priority_jobs_snapshot
GROUP BY
    job_title_short,
    priority_lvl
ORDER BY
    count DESC
    ;