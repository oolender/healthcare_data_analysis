-- 1. DOCTOR RANKING BY AVERAGE BILLING PER CONDITION
SELECT
    doctor,
    medical_condition,
    ROUND(AVG(billing_amount), 2) AS avg_billing,
    COUNT(*) AS patients_treated,
    RANK() OVER (
        PARTITION BY medical_condition
        ORDER BY AVG(billing_amount) DESC
    ) AS billing_rank
FROM patients
GROUP BY doctor, medical_condition;


-- 2. BILLING QUARTILE SEGMENTATION
SELECT
    name,
    medical_condition,
    billing_amount,
    NTILE(4) OVER (ORDER BY billing_amount) AS billing_quartile
FROM patients;

-- 3. TEST RESULTS VS. HOSPITALIZATION COST
WITH test_summary AS (
    SELECT
        test_results,
        COUNT(*) AS total_patients,
        ROUND(AVG(days_in_hospital), 2) AS avg_days,
        ROUND(AVG(billing_amount), 2) AS avg_billing
    FROM patients
    GROUP BY test_results
)
SELECT
    *,
    -- Calculate each group's share of total billing
    ROUND(avg_billing / SUM(avg_billing) OVER() * 100, 2) AS billing_share_pct
FROM test_summary
ORDER BY avg_days DESC;

-- 4. MONTH-OVER-MONTH ADMISSION GROWTH
WITH monthly_admissions AS (
    SELECT
        DATE_TRUNC('month', date_of_admission) AS month,
        COUNT(*) AS admissions
    FROM patients
    GROUP BY 1
)
SELECT
    month,
    admissions,
    LAG(admissions) OVER (ORDER BY month) AS prev_month_admissions,
    ROUND(
        100.0 * (admissions - LAG(admissions) OVER (ORDER BY month))
              / LAG(admissions) OVER (ORDER BY month),2) AS mom_growth_pct
FROM monthly_admissions
ORDER BY month;

-- 5. TOP 5 HOSPITALS PER MEDICAL CONDITION
SELECT *
FROM (
    SELECT
        hospital,
        medical_condition,
        COUNT(*) AS total_cases,
        RANK() OVER (
            PARTITION BY medical_condition
            ORDER BY COUNT(*) DESC
        ) AS hospital_rank
    FROM patients
    GROUP BY hospital, medical_condition
) ranked
WHERE hospital_rank <= 5
ORDER BY medical_condition, hospital_rank;
