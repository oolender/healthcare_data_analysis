-- 1. DISTRIBUTION OF MEDICAL CONDITIONS
SELECT
    medical_condition,
    COUNT(*) AS patient_count,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER(), 2) AS percentage
FROM patients
GROUP BY medical_condition
ORDER BY patient_count DESC;


-- 2. AVERAGE BILLING AMOUNT BY INSURANCE PROVIDER
SELECT
    insurance_provider,
    COUNT(*) AS total_patients,
    ROUND(AVG(billing_amount), 2) AS avg_billing,
    ROUND(MIN(billing_amount), 2) AS min_billing,
    ROUND(MAX(billing_amount), 2) AS max_billing
FROM patients
GROUP BY insurance_provider
ORDER BY avg_billing DESC;


-- 3. AVERAGE HOSPITAL STAY BY MEDICAL CONDITION
SELECT
    medical_condition,
    ROUND(AVG(days_in_hospital), 1) AS avg_days,
    MIN(days_in_hospital) AS min_days,
    MAX(days_in_hospital) AS max_days,
    COUNT(*) AS total_patients
FROM patients
GROUP BY medical_condition
ORDER BY avg_days DESC;


-- 4. PATIENT ADMISSIONS TREND BY MONTH
SELECT
    DATE_TRUNC('month', date_of_admission) AS month,
    COUNT(*) AS admissions
FROM patients
GROUP BY 1
ORDER BY 1;


-- 5. ADMISSION TYPE BREAKDOWN BY AGE GROUP
SELECT
    age_group,
    admission_type,
    COUNT(*) AS patient_count
FROM patients
GROUP BY age_group, admission_type
ORDER BY age_group, patient_count DESC;