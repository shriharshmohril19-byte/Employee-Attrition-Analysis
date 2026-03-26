# Employee Attrition Analysis

End-to-end SQL analysis of an employee attrition dataset, including data cleaning, transformation, and advanced analytics. Uses window functions, aggregations, and feature engineering to uncover key drivers of attrition, segment employee risk, and generate actionable insights.

The project includes:
- Data cleaning & preprocessing
- Exploratory data analysis (EDA)
- Advanced SQL analytics
  
---

## Objectives
- Identify factors influencing employee attrition
- Analyze salary, experience, and job roles
- Evaluate impact of overtime and commute distance
- Detect high-risk employees
- Build a stress scoring system

---

## Dataset
- Source: Kaggle  
- Dataset: Employee Attrition Uncleaned Dataset
- Link: https://www.kaggle.com/datasets/nikhilbhosle/employee-attrition-uncleaned-dataset

---

## Data Cleaning Steps
- Removed duplicate records using `ROW_NUMBER()`
- Cleaned numeric fields using `REGEXP_REPLACE`
- Trimmed and standardized text fields
- Renamed inconsistent column names
- Performed validation checks (age, income)

---

## Key Analyses

### Attrition Insights
- Overall attrition rate
- Attrition by job role
- Attrition by salary bands

### Employee Segmentation
- Risk categorization (High / Medium / Low)
- Salary quartiles using `NTILE()`
- Experience-based grouping

###  Advanced SQL Techniques
- Window functions (`RANK`, `DENSE_RANK`, `NTILE`)
- CTEs (Common Table Expressions)
- Conditional aggregation

###  Custom KPI Creation
- Created a **Stress Score KPI** based on:
  - Job Satisfaction
  - Work-Life Balance
  - Number of Promotions
  - Distance from Home

---

## Key Insights
- Employees with **low salary + overtime** are high-risk
- Attrition is higher in **early tenure stages**
- Long commute distances reduce work-life balance
- Promotions significantly impact satisfaction

---

## Tech Stack
- SQL (MySQL)
- Data Analysis

---

## 🚀 Future Improvements
- Build ML model for attrition prediction
- Create dashboards (Power BI / Tableau)
- Add clustering for employee segmentation

---
