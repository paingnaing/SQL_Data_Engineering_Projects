CREATE SCHEMA IF NOT EXISTS jobs_mart.staging;

CREATE TABLE IF NOT EXISTS jobs_mart.staging.preferred_roles (
    role_id INTEGER PRIMARY KEY,
    role_name VARCHAR
);

INSERT INTO jobs_mart.staging.preferred_roles (
    role_id,
    role_name
)
VALUES
    (1, 'Data Engineer'),
    (2, 'Senior Data Engineer'),
    (3, 'Software Engineer')
    ON CONFLICT DO NOTHING
;

SELECT current_database(), current_schema();

SELECT *
FROM jobs_mart.staging.preferred_roles;

SELECT * FROM main.preferred_roles;

SELECT * FROM staging.preferred_roles;

ALTER TABLE staging.preferred_roles
ADD COLUMN preferred_role BOOLEAN;

UPDATE staging.preferred_roles
SET preferred_role = TRUE
WHERE role_id = 1 or role_id = 2;

UPDATE staging.preferred_roles
SET preferred_role = False
WHERE role_id = 3;

ALTER TABLE staging.preferred_roles
RENAME TO priority_roles
;

SELECT * FROM staging.priority_roles;

ALTER TABLE staging.priority_roles
RENAME COLUMN preferred_role to priority_lvl;

ALTER TABLE staging.priority_roles
ALTER COLUMN priority_lvl TYPE INTEGER;

UPDATE staging.priority_roles
SET priority_lvl = 3 
WHERE role_id = 3;

