
# Hospital Readmission Analysis: Diabetes 130-US Pipeline

## Project Overview

This project focuses on building a **data pipeline** to analyze hospital readmission patterns for diabetic patients across 130 US hospitals. Using **SQL (SQLite)**, I transformed a raw medical dataset into a structured analytical view to identify which diagnostic categories and medication factors contribute most to hospital readmissions.

## Tech Stack

* **Database:** SQLite / DBeaver
* **Language:** SQL (Advanced CASE statements, CTEs/Views, Data Cleaning)
* **Domain:** Healthcare Analytics / ICD-9 Coding

## Data Pipeline

The analysis follows a professional **ETL (Extract, Transform, Load)** workflow:

1. **Ingestion:** Raw CSV data containing over 100k records was imported into a staging table.
2. **Cleaning:** Handled missing values (originally marked as `?`) and normalized inconsistent data types.
3. **Feature Engineering:** * Mapped over 900 raw **ICD-9 codes** into 9 high-level medical categories (Circulatory, Respiratory, Diabetes, etc.).
* Simplified the `readmitted` status into a binary `is_readmitted` flag for clearer KPI calculation.
* Cleaned age ranges to be visualization-ready.


Basically, I implemented a T-mode pipeline (Transform) using SQL Views to decouple raw medical data from the analytical layer, ensuring data consistency and reproducibility for BI tools.


4. **Presentation Layer:** Created a `medical_analysis_view` to serve as the single source of truth for BI tools.

## Key Insights (KPIs)

Based on the SQL analysis:

* **Primary Risk Factor:** Patients with **Circulatory** issues show the highest length of stay and significant readmission rates.
* **Medication Impact:** Preliminary data suggests that patients with "Changes" in their diabetes medication have different readmission profiles compared to those with stable prescriptions.
* **Data Quality:** Identified that certain fields like `weight` had over 90% missing data, highlighting areas for hospital data collection improvement.

## 📂 Repository Structure

```bash
├── sql/
│   └── medical_analysis_pipeline.sql  # The main "gordote" script
├── data/
│   └── source_link.txt                # Link to the original Kaggle dataset
└── README.md                          # Project documentation

```


