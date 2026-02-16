/*******************************************************************************
PROJECT: Hospital Readmission Analysis - Diabetes 130-US Dataset
OBJECTIVE: Identify risk factors and patterns in patient readmissions.
AUTHOR: [Your Name]
PIPELINE STAGE: Transformation & Analytics
*******************************************************************************/

-- =============================================================================
-- 1. DATA TRANSFORMATION (CLEANING & MAPPING)
-- =============================================================================
-- Creating a clean View for the BI Dashboard (Power BI/Tableau)

DROP VIEW IF EXISTS medical_analysis_view;

CREATE VIEW medical_analysis_view AS
SELECT 
    encounter_id,
    patient_nbr,
    -- Clean age ranges (remove brackets and parentheses)
    REPLACE(REPLACE(age, '[', ''), ')', '') AS age_range,
    gender,
    race,
    time_in_hospital,
    num_lab_procedures AS lab_procedures_count,
    num_medications AS medications_count,
    number_diagnoses AS total_diagnoses,
    -- Readmission Binary Indicator (Simplifying for analysis)
    CASE 
        WHEN readmitted = '<30' THEN 'Yes' 
        WHEN readmitted = '>30' THEN 'Yes' 
        ELSE 'No' 
    END AS is_readmitted,
    -- ICD-9 Diagnostic Mapping (International Standards)
    CASE 
        WHEN diag_1 LIKE '250%' THEN 'Diabetes'
        WHEN (diag_1 BETWEEN '390' AND '459') OR diag_1 = '785' THEN 'Circulatory'
        WHEN (diag_1 BETWEEN '460' AND '519') OR diag_1 = '786' THEN 'Respiratory'
        WHEN (diag_1 BETWEEN '520' AND '579') OR diag_1 = '787' THEN 'Digestive'
        WHEN (diag_1 BETWEEN '580' AND '629') OR diag_1 = '788' THEN 'Genitourinary'
        WHEN (diag_1 BETWEEN '140' AND '239') THEN 'Neoplasia (Cancer)'
        WHEN (diag_1 BETWEEN '710' AND '739') THEN 'Musculoskeletal'
        WHEN (diag_1 BETWEEN '800' AND '999') THEN 'Injury'
        ELSE 'Other/Unknown'
    END AS diagnostic_category,
    -- Medication Status
    insulin AS insulin_status,
    diabetesMed AS diabetes_med_prescribed,
    change AS med_change
FROM hospital_data
WHERE gender != 'Unknown/Invalid';

-- =============================================================================
-- 2. KEY PERFORMANCE INDICATORS (KPIs)
-- =============================================================================

-- KPI 1: Average length of stay by Diagnostic Category
SELECT 
    diagnostic_category, 
    AVG(time_in_hospital) AS avg_days_stay
FROM medical_analysis_view 
GROUP BY diagnostic_category 
ORDER BY avg_days_stay DESC;

-- KPI 2: Readmission Rate by Diagnostic Category (The "Gold" Metric)
SELECT 
    diagnostic_category,
    COUNT(*) AS total_patients,
    SUM(CASE WHEN is_readmitted = 'Yes' THEN 1 ELSE 0 END) AS total_readmissions,
    ROUND(CAST(SUM(CASE WHEN is_readmitted = 'Yes' THEN 1 ELSE 0 END) AS FLOAT) / COUNT(*) * 100, 2) AS readmission_rate_pct
FROM medical_analysis_view
GROUP BY diagnostic_category
ORDER BY readmission_rate_pct DESC;

-- KPI 3: Impact of Medication Change on Readmission
SELECT 
    med_change, 
    COUNT(*) AS patient_count,
    ROUND(CAST(SUM(CASE WHEN is_readmitted = 'Yes' THEN 1 ELSE 0 END) AS FLOAT) / COUNT(*) * 100, 2) AS readmission_rate_pct
FROM medical_analysis_view
GROUP BY med_change;