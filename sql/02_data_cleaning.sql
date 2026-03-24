
-- DATA QUALITY CHECK
SELECT
    COUNT(*) - COUNT(name)               AS null_names,
    COUNT(*) - COUNT(billing_amount)     AS null_billing,
    COUNT(*) - COUNT(date_of_admission)  AS null_admission_date,
    COUNT(*) - COUNT(medical_condition)  AS null_conditions
FROM patients;

SELECT name, date_of_admission, COUNT(*) AS duplicates
FROM patients
GROUP BY name, date_of_admission
HAVING COUNT(*) > 1;

-- STANDARDIZE TEXT FIELDS
UPDATE patients 
SET name = INITCAP(TRIM(name));

UPDATE patients 
SET hospital = TRIM(TRAILING ',' 
FROM REGEXP_REPLACE(hospital, '^(and\s+|ltd\s+)', '', 'i'));

UPDATE patients 
SET billing_amount = ROUND(billing_amount, 2);

-- ADD DERIVED COLUMNS
-- Calculate length of hospital stay in days
ALTER TABLE patients ADD COLUMN days_in_hospital INT;

UPDATE patients
SET days_in_hospital = (discharge_date - date_of_admission);

-- Bucket patients into age groups
ALTER TABLE patients ADD COLUMN age_group VARCHAR(20);

UPDATE patients
SET age_group = CASE
    WHEN age < 18 THEN 'Minor'
    WHEN age < 35 THEN 'Young Adult'
    WHEN age < 60 THEN 'Middle Age'
    ELSE 'Senior'
END;

-- Extract admission month and year
ALTER TABLE patients ADD COLUMN admission_month INT;
ALTER TABLE patients ADD COLUMN admission_year  INT;

UPDATE patients
SET admission_month = EXTRACT(MONTH FROM date_of_admission),
    admission_year  = EXTRACT(YEAR  FROM date_of_admission);