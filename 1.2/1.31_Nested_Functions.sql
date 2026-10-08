WITH skills as (SELECT 'python' as skill
UNION ALL
SELECT 'sql'
UNION ALL
SELECT 'r'), 
skills_array AS (
SELECT ARRAY_AGG(skill ORDER BY skill) as skills
FROM skills
)
SELECT 
    skills[1] as first_skill,
    skills[2] as second_skill,
    skills[3] as third_skill
FROM skills_array; 


SELECT { skill: 'python', type: 'programming' } AS skill_strut;

WITH skill_struct AS (
    SELECT
        STRUCT_PACK(
            skill := 'python',
            type := 'programming'
    ) as s
)
SELECT s.skill, s.type FROM skill_struct;

-- STRUCT EXAMPLE
WITH skill_talbe as(
    SELECT 'python' AS skills, 'programming' AS types
    UNION ALL
    SELECT 'sql', 'query_language'
    UNION ALL
    SELECT 'r', 'programming'
),
STRUCT_TABLE as (
    SELECT 
        STRUCT_PACK(
            skill := skills,
            type := types
        ) AS skill_info
    FROM skill_talbe
)
SELECT skill_info
FROM STRUCT_TABLE;


-- Array of Structs
SELECT [
    { skill: 'python', type: 'programming' },
    { skill: 'sql', type: 'query_language' }
] AS skills_array_of_structs;


WITH skill_talbe as(
    SELECT 'python' AS skills, 'programming' AS types
    UNION ALL
    SELECT 'sql', 'query_language'
    UNION ALL
    SELECT 'r', 'programming'
),
skills_array_struct AS (
    SELECT
        ARRAY_AGG(
        STRUCT_PACK(
            skill := skills,
            type := types
        ) 
    ) AS array_struct
    FROM skill_talbe
)
SELECT array_struct[3].skill
FROM skills_array_struct;


-- MAP
SELECT MAP{
    'skill' : 'python',
    'type' : 'programmin'
};

-- JSON
WITH raw_skill_json as (
SELECT
    '{"skill":"python", "type":"programming"}'::JSON AS skill_json
)
SELECT 
    STRUCT_PACK(
    skill := json_extract_string(skill_json, '$.skill'),
    type := json_extract_string(skill_json, '$.type')
    )
FROM raw_skill_json;


-- Arrays - Final Example
-- Build a flat skill table for co-workers to access job titles, salary info, and skills in one table

CREATE OR REPLACE TEMP TABLE job_skills_array_struct AS 
(SELECT
    jpf.job_id,
    jpf.job_title_short,
    jpf.salary_year_avg,
    ARRAY_AGG(sd.skills) AS skills_type
FROM job_postings_fact as jpf
LEFT JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
LEFT JOIN skills_dim AS sd
    ON sd.skill_id = sjd.skill_id
GROUP BY ALL);

-- FROM the perspective of a Data Analyst, analyze the median salary per skill
WITH flat_skills AS(
SELECT
    job_id,
    job_title_short,
    salary_year_avg,
    UNNEST(skills_array) AS skill
FROM job_skills_array
)
SELECT
    skill,
    MEDIAN(salary_year_avg) AS median_salary
FROM flat_skills
GROUP BY skill
ORDER BY median_salary DESC
;


-- Arrays - Final Example
-- Build a flat skill table for co-workers to access job titles, salary info, and skills in one table

-- CREATE OR REPLACE TEMP TABLE job_skills_array AS 
CREATE OR REPLACE TEMP TABLE job_skills_array_struct AS (
SELECT
    jpf.job_id,
    jpf.job_title_short,
    jpf.salary_year_avg,
    ARRAY_AGG(
        STRUCT_PACK(
            skill_name := sd.skills,
            skill_type := sd.type
        )
    ) AS skills_type
FROM job_postings_fact as jpf
LEFT JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
LEFT JOIN skills_dim AS sd
    ON sd.skill_id = sjd.skill_id
GROUP BY ALL);


-- From the perspective of a Data Analyst, analyze the median salary per type of skill
WITH flat_skills AS (SELECT 
    job_id,
    job_title_short,
    salary_year_avg,
    UNNEST(skills_type).skill_type AS skill_type,
    UNNEST(skills_type).skill_name AS skill_name,
FROM job_skills_array_struct)
SELECT
    skill_type,
    MEDIAN(salary_year_avg) AS median_salary
FROM flat_skills
WHERE skill_type IS NOT NULL
GROUP BY skill_type
ORDER BY median_salary DESC
;

