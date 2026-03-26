/* =====================================================
   EMPLOYEE ATTRITION ANALYSIS
   SQL Data Analysis Project

   Dataset: Employee Attrition Uncleaned Dataset
   Source: Kaggle (https://www.kaggle.com/datasets/nikhilbhosle/employee-attrition-uncleaned-dataset) 
   Goal: Perform end-to-end data cleaning and exploratory 
   data analysis to identify key factors influencing 
   employee attrition.

   Key Skills:
   - Data Cleaning
   - Window Functions
   - Aggregations
   - Statistical Analysis
===================================================== */

/* =====================================================
   1. DATABASE SETUP
   - Creating database
   - Creating working table (duplicate of raw data)
===================================================== */
CREATE DATABASE emp_attrition;
USE emp_attrition;

/* Duplicating table so that the original dataset remains unchanged. We will work on the duplicate table. */

CREATE TABLE attrition_data
LIKE attrition;
INSERT INTO attrition_data
SELECT * 
FROM attrition;

SELECT * FROM attrition_data;

/* =====================================================
   2. DATA CLEANING
    Steps performed:
   - Duplicate detection and removal
   - Removing special characters from numeric fields
   - Trimming and standardizing text columns
   - Fixing inconsistent column names
   - Data validation checks
===================================================== */

/* Detecting duplicate records using ROW_NUMBER() partitioned by Employee ID */

WITH cte AS 
(
SELECT *,
ROW_NUMBER()
OVER (PARTITION BY `ï»¿Employee ID`) AS row_id
FROM attrition_data
)
SELECT *
FROM cte
WHERE row_id > 1;

/* We see that there are many duplicates, and we need to get rid of them. 
However, it is not possible to update a CTE, ie, not possible to delete the duplicates from the CTE. Hence, we look at another method.
Creating a new table and inserting the values into this table, and then deleting the duplicates from it. */

CREATE TABLE `attrition_data2` (
  `ï»¿Employee ID` int DEFAULT NULL,
  `Age` int DEFAULT NULL,
  `Gender` text,
  `Years at Company` int DEFAULT NULL,
  `Job Role` text,
  `Monthly Income` int DEFAULT NULL,
  `Work-Life Balance` text,
  `Job Satisfaction` text,
  `Performance Rating` text,
  `Number of Promotions` int DEFAULT NULL,
  `Overtime` text,
  `Distance from Home` int DEFAULT NULL,
  `Education Level` text,
  `Marital Status` text,
  `Number of Dependents` int DEFAULT NULL,
  `Job Level` text,
  `Company Size` text,
  `Company Tenure (In Months)` int DEFAULT NULL,
  `Remote Work` text,
  `Leadership Opportunities` text,
  `Innovation Opportunities` text,
  `Company Reputation` text,
  `Employee Recognition` text,
  `Attrition` text,
  `row_id` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO attrition_data2
SELECT *,
ROW_NUMBER()
OVER (PARTITION BY `ï»¿Employee ID`) AS row_id
FROM attrition_data;

/* Remove duplicates by assigning row_id and deleting records where row_id > 1 (keeping first occurrence) */
DELETE FROM attrition_data2
WHERE row_id>1;

SELECT * 
FROM attrition_data2
WHERE row_id > 1;

/* Alternative duplicate removal using self-join */
DELETE e1
FROM attrition_data2 e1
JOIN attrition_data2 e2
ON e1.`ï»¿Employee ID` = e2.`ï»¿Employee ID`
AND e1.`ï»¿Employee ID` > e2.`ï»¿Employee ID`;
-- All duplicates deleted --

/* Removing unwanted characters from numeric fields */
UPDATE attrition_data2
SET 
    Age = REGEXP_REPLACE(Age, '[^0-9]', ''),
    `Monthly Income` = REGEXP_REPLACE(`Monthly Income`, '[^0-9]', ''),
    `Distance from Home` = REGEXP_REPLACE(`Distance from Home`, '[^0-9]', ''),
    `Years at Company` = REGEXP_REPLACE(`Years at Company`, '[^0-9]', ''),
    `Number of Promotions` = REGEXP_REPLACE(`Number of Promotions`, '[^0-9]', ''),
    `Number of Dependents` = REGEXP_REPLACE(`Number of Dependents`, '[^0-9]', ''),
    `Company Tenure (In Months)` = REGEXP_REPLACE(`Company Tenure (In Months)`, '[^0-9]', '');

UPDATE attrition_data2
SET 
    `Job Role` = TRIM(`Job Role`),
    `Work-Life Balance` = TRIM(`Work-Life Balance`),
    Gender = TRIM(Gender),
    Attrition = TRIM(Attrition),
    `Performance Rating` = TRIM(`Performance Rating`),
    Overtime = TRIM(Overtime);

/* Removing unwanted characters from text fields */
UPDATE attrition_data2
SET `Education Level` = REGEXP_REPLACE(`Education Level`, '[^a-zA-Z]', '');

SELECT * 
FROM attrition_data2;
-- All unwanted characters deleted --

/* Adding space between the words */
UPDATE attrition_data2
SET `Education Level` = 
    REPLACE(
        REPLACE(
            REPLACE(`Education Level`, 'Degree', ' Degree'),
        'School', ' School'),
    'PhD', 'PhD');

/* Standardizing column names:
   - Removing spaces
   - Replacing with underscores */

SHOW COLUMNS FROM attrition_data2;

SELECT 
    CONCAT(
        'ALTER TABLE attrition_data2 RENAME COLUMN `',
        COLUMN_NAME,
        '` TO `',
        REPLACE(COLUMN_NAME, ' ', '_'),
        '`;'
    ) AS rename_query
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'attrition_data2'
AND TABLE_SCHEMA = DATABASE()
AND COLUMN_NAME LIKE '% %';

ALTER TABLE attrition_data2 RENAME COLUMN `ï»¿Employee ID` TO `Employee_ID`;
ALTER TABLE attrition_data2 RENAME COLUMN `Company Reputation` TO `Company_Reputation`;
ALTER TABLE attrition_data2 RENAME COLUMN `Company Size` TO `Company_Size`;
ALTER TABLE attrition_data2 RENAME COLUMN `Company Tenure (In Months)` TO `Company_Tenure`;
ALTER TABLE attrition_data2 RENAME COLUMN `Distance from Home` TO `Distance_from_Home`;
ALTER TABLE attrition_data2 RENAME COLUMN `Education Level` TO `Education_Level`;
ALTER TABLE attrition_data2 RENAME COLUMN `Employee Recognition` TO `Employee_Recognition`;
ALTER TABLE attrition_data2 RENAME COLUMN `Innovation Opportunities` TO `Innovation_Opportunities`;
ALTER TABLE attrition_data2 RENAME COLUMN `Job Level` TO `Job_Level`;
ALTER TABLE attrition_data2 RENAME COLUMN `Job Role` TO `Job_Role`;
ALTER TABLE attrition_data2 RENAME COLUMN `Job Satisfaction` TO `Job_Satisfaction`;
ALTER TABLE attrition_data2 RENAME COLUMN `Leadership Opportunities` TO `Leadership_Opportunities`;
ALTER TABLE attrition_data2 RENAME COLUMN `Marital Status` TO `Marital_Status`;
ALTER TABLE attrition_data2 RENAME COLUMN `Monthly Income` TO `Monthly_Income`;
ALTER TABLE attrition_data2 RENAME COLUMN `Number of Dependents` TO `No_of_Dependents`;
ALTER TABLE attrition_data2 RENAME COLUMN `Number of Promotions` TO `No_of_Promotions`;
ALTER TABLE attrition_data2 RENAME COLUMN `Performance Rating` TO `Performance_Rating`;
ALTER TABLE attrition_data2 RENAME COLUMN `Remote Work` TO `Remote_Work`;
ALTER TABLE attrition_data2 RENAME COLUMN `Work-Life Balance` TO `Work_Life_Balance`;
ALTER TABLE attrition_data2 RENAME COLUMN `Years at Company` TO `Years_at_Company`;


SHOW COLUMNS FROM attrition_data2;

/* Deleting unwanted columns */
ALTER TABLE attrition_data2
DROP COLUMN row_id;

SELECT * 
FROM attrition_data2;

/* Data validation checks:
   - Ensuring working age (18–65)
   - Checking for negative salary values */
SELECT *
FROM attrition_data2
WHERE Age < 18 OR Age > 65;
-- No invalid working age -- 

/* Checking for negative income */
SELECT *
FROM attrition_data2
WHERE Monthly_Income < 0;
-- No negative income --

SELECT * 
FROM attrition_data2;

-- ALL DATA HAS BEEN CLEANED --

						--   D A T A   A N A L Y S I S   --
                        
                        
/* =====================================================
   3. DATA ANALYSIS
===================================================== */

-- 1. AVG INCOME BY JOB ROLE | Identifying salary distribution and workforce composition across roles.
SELECT Job_Role, 
COUNT(*) AS No_of_Employees,
ROUND(AVG(Age),0) AS Avg_Age,
ROUND(AVG(Monthly_Income), 2) AS Avg_Income
FROM attrition_data2
GROUP BY Job_Role
ORDER BY Avg_Income DESC;

-- 2. TOTAL ATTRITION RATE | Calculating overall attrition rate of the company
SELECT 
    COUNT(*) AS No_of_Employees,
    SUM(CASE 
			WHEN Attrition = 'Left' THEN 1 ELSE 0 
		END) AS attrition_count,
    ROUND(SUM(CASE 
			WHEN Attrition = 'Left' THEN 1 ELSE 0 
		END) * 100.0 / COUNT(*), 2) AS attrition_rate
FROM attrition_data2;

-- 3. ATTRITION RATE BY JOB ROLE | Identifying job roles with highest employee turnover
SELECT 
    Job_Role,
    COUNT(*) AS No_of_Employees,
    SUM(CASE WHEN Attrition = 'Left' THEN 1 ELSE 0 END) AS Employees_Left,
    ROUND(SUM(CASE 
			WHEN Attrition = 'Left' THEN 1 ELSE 0 
		END) * 100.0 / COUNT(Job_Role), 2) AS Attrition_Rate
    FROM attrition_data2
    GROUP BY Job_Role
    ORDER BY Attrition_Rate DESC;
    
-- 4. ATTRITION VS SALARY BRACKETS | Segmenting employees into salary groups to analyze relationship between income and attrition 
SELECT 
    CASE 
        WHEN Monthly_Income < 3000 THEN 'Low'
        WHEN Monthly_Income BETWEEN 3000 AND 5000 THEN 'Low-Medium'
        WHEN Monthly_Income > 5000 AND Monthly_Income < 7000 THEN 'Medium-High'
        ELSE 'High'
    END AS Salary_Band,
    COUNT(*) AS No_of_Employees,
    SUM(CASE WHEN Attrition = 'Left' THEN 1 ELSE 0 END) AS Attrition
FROM attrition_data2
GROUP BY salary_band
ORDER BY 
	CASE salary_band
		WHEN 'Low' THEN 1
        WHEN 'Low-Medium' THEN 2
        WHEN 'Medium-High' THEN 3
        ELSE 4 
	END;

-- 5. HIGHEST PAID EMPLOYEES PER JOB ROLE | Using RANK() to identify top 3 highest paid employees within each job role
SELECT *
FROM (
    SELECT 
        Employee_ID,
        Job_Role,
        Monthly_Income,
        RANK() OVER (PARTITION BY Job_Role ORDER BY Monthly_Income DESC) AS rank_in_dept
    FROM attrition_data2
) t
WHERE rank_in_dept <= 3;

-- 6. EXPERIENCE VS ATTRITION | Analyzing how employee tenure impacts attrition
SELECT 
    Years_at_Company,
    COUNT(*) AS total,
    SUM(CASE WHEN Attrition = 'Left' THEN 1 ELSE 0 END) AS left_count
FROM attrition_data2
GROUP BY Years_at_Company
ORDER BY Years_at_Company;

-- 7. OVERTIME IMPACT ON ATTRITION | Analysing whether overtime contributes to attrition
SELECT 
    Overtime,
    COUNT(*) AS total,
    SUM(CASE WHEN Attrition = 'Left' THEN 1 ELSE 0 END) AS attrition
FROM attrition_data2
GROUP BY OverTime;


CREATE TABLE departments AS
SELECT DISTINCT Job_Role FROM attrition_data2;

SELECT 
    e.Employee_ID,
    e.Job_Role
FROM attrition_data2 e
JOIN departments d
ON e.Job_Role = d.Job_Role;

-- 8. DENSE RANKING SALARY BY JOB ROLE | Ranking employees based on salary
SELECT 
    Employee_ID,
    Job_Role,
    Monthly_Income,
    DENSE_RANK() OVER (ORDER BY Monthly_Income DESC) AS salary_rank
FROM attrition_data2
ORDER BY Job_Role DESC, salary_rank ;

-- 9. RISK SEGMENTATION | Categorizing employees into risk levels based on salary and overtime patterns
SELECT 
Employee_ID, Job_Role,
    CASE 
        WHEN Monthly_Income <= 3000 AND Overtime = 'Yes' THEN 'High Risk'
        WHEN Monthly_Income > 3000 AND Monthly_Income < 7000 AND Overtime = 'Yes' THEN 'Medium Risk'
        ELSE 'Low Risk'
    END AS risk_category
FROM attrition_data2
ORDER BY 
Job_Role, risk_category,
	CASE 
		WHEN 'High Risk' THEN 1
        WHEN 'Medium Risk' THEN 2
        ELSE 3
	END;

-- 10. TOP VS BOTTOM EMPLOYEES | Dividing employees into 4 income groups using NTILE()
SELECT *
FROM (
    SELECT 
        Employee_ID,
        Monthly_Income,
        NTILE(4) OVER (ORDER BY Monthly_Income DESC) AS quartile
    FROM attrition_data2
) t;

-- 11. ATTRITION RATE PER QUARTILE | Evaluating attrition rates per quartile
WITH quartile_data AS (
    SELECT 
        Employee_ID,
        Monthly_Income,
        Attrition,
        NTILE(4) OVER (ORDER BY Monthly_Income) AS quartile
    FROM attrition_data2
)
SELECT 
    quartile,
    COUNT(*) AS total_employees,
    MIN(Monthly_Income) AS min_income,
    MAX(Monthly_Income) AS max_income,
    ROUND(
        SUM(CASE WHEN Attrition = 'Left' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS attrition_rate
FROM quartile_data
GROUP BY quartile
ORDER BY quartile;

-- 12. ATTRITION BY EXPERIENCE BRACKET | Grouping employees into experience brackets
SELECT 
    CASE 
        WHEN Years_at_Company <= 3 THEN '0-3 Years'
        WHEN Years_at_Company > 3 AND Years_at_Company <= 7 THEN '3-7 Years'
        WHEN Years_at_Company > 7 AND Years_at_Company <= 12 THEN '7-12 Years'
        WHEN Years_at_Company > 12 AND Years_at_Company <= 20 THEN '12-20 Years'
        ELSE '20+ Years'
    END AS experience_group,
    COUNT(*) AS employees,
    SUM(CASE WHEN Attrition='Left' THEN 1 ELSE 0 END) AS attrition
FROM attrition_data2
GROUP BY experience_group
ORDER BY 
	CASE experience_group
		WHEN '0-3 Years' THEN 1
        WHEN '3-7 Years' THEN 2
        WHEN '7-12 Years' THEN 3
        WHEN '12-20 Years' THEN 4
        ELSE 5
	END;

-- 13. JOB ROLE CONTRIBUTION TO ATTRITION | Calculating percentage contribution of each job role to total attrition
WITH dept_attrition AS (
    SELECT 
        Job_Role,
        SUM(CASE WHEN Attrition='Left' THEN 1 ELSE 0 END) AS dept_attrition
    FROM attrition_data2
    GROUP BY Job_Role
),
total AS (
    SELECT SUM(dept_attrition) AS total_attrition FROM dept_attrition
)
SELECT 
    d.Job_Role,
    d.dept_attrition,
    ROUND(d.dept_attrition * 100.0 / t.total_attrition, 2) AS contribution_pct
FROM dept_attrition d, total t;

-- 14. ATTRITION BY GENDER PER JOB ROLE | Analyzing attrition by gender for each job role
SELECT 
    Job_Role, Gender,
    COUNT(*) AS employees,
    SUM(CASE WHEN Attrition='Left' THEN 1 ELSE 0 END) AS attrition
FROM attrition_data2
GROUP BY Job_Role, Gender
ORDER BY Job_Role DESC, Gender DESC;

-- 15. ATTRITION VS NON ATTRITION SALARY DISTRIBUTION | Comparing salary statistics between employees who left and those who stayed 
SELECT 
    Attrition,
    AVG(Monthly_Income) AS avg_income,
    MIN(Monthly_Income) AS min_income,
    MAX(Monthly_Income) AS max_income
FROM attrition_data2
GROUP BY Attrition;

-- 16. MEDIAN SALARY | Calculating median salary using window functions
SELECT 
ROUND(AVG(Monthly_Income),2) AS median_salary
FROM (
    SELECT 
        Monthly_Income,
        ROW_NUMBER() OVER (ORDER BY Monthly_Income) AS rn,
        COUNT(*) OVER () AS total
    FROM attrition_data2
) t
WHERE rn IN (FLOOR((total+1)/2), FLOOR((total+2)/2));

-- 17. SALARY OUTLIERS | Detecting employees with extreme salaries using statistical thresholds (mean ± 2 * std deviation)
WITH stats AS (
    SELECT 
        AVG(Monthly_Income) AS avg_income,
        STDDEV(Monthly_Income) AS std_dev
    FROM attrition_data2
)
SELECT 
    e.Employee_ID,
    e.Monthly_Income,
    CASE 
        WHEN e.Monthly_Income > s.avg_income + 2*s.std_dev THEN 'High Outlier'
        WHEN e.Monthly_Income < s.avg_income - 2*s.std_dev THEN 'Low Outlier'
    END AS outlier_type
FROM attrition_data2 e, stats s
WHERE e.Monthly_Income > s.avg_income + 2*s.std_dev
   OR e.Monthly_Income < s.avg_income - 2*s.std_dev;

-- 18. HIGH SALARY OUTLIERS ATTRITION | Counting total high-income outliers who have left the company
WITH stats AS (
    SELECT 
        AVG(Monthly_Income) AS avg_income,
        STDDEV(Monthly_Income) AS std_dev
    FROM attrition_data2
),
outliers AS (
    SELECT 
        e.Employee_ID,
        e.Monthly_Income,
        e.Attrition,
        CASE 
            WHEN e.Monthly_Income > s.avg_income + 2*s.std_dev THEN 'High Outlier'
            WHEN e.Monthly_Income < s.avg_income - 2*s.std_dev THEN 'Low Outlier'
        END AS outlier_type
    FROM attrition_data2 e
    CROSS JOIN stats s
    WHERE e.Monthly_Income > s.avg_income + 2*s.std_dev
       OR e.Monthly_Income < s.avg_income - 2*s.std_dev
)
SELECT COUNT(*) AS High_Outliers_Left
FROM outliers
WHERE Attrition = 'Left'
AND 
outlier_type = 'High Outlier';

-- 19. SALARY OUTLIERS FOR ATTRITED EMPLOYEES | Listing all salary outliers who have attrited 
WITH stats AS (
    SELECT 
        AVG(Monthly_Income) AS avg_income,
        STDDEV(Monthly_Income) AS std_dev
    FROM attrition_data2
),
outliers AS (
    SELECT 
        e.Employee_ID,
        e.Monthly_Income,
        e.Attrition,
        CASE 
            WHEN e.Monthly_Income > s.avg_income + 2*s.std_dev THEN 'High Outlier'
            WHEN e.Monthly_Income < s.avg_income - 2*s.std_dev THEN 'Low Outlier'
        END AS outlier_type
    FROM attrition_data2 e
    CROSS JOIN stats s
    WHERE e.Monthly_Income > s.avg_income + 2*s.std_dev
       OR e.Monthly_Income < s.avg_income - 2*s.std_dev
)
SELECT *
FROM outliers
WHERE Attrition = 'Left';


SELECT * FROM attrition_data2;

-- 20. Job Satisfaction per Job Level | Counting no of employees by job satisfaction for each Job Level
SELECT 
    Job_Level,
    Job_Satisfaction,
    COUNT(*) AS employee_count
FROM attrition_data2
GROUP BY Job_Level, Job_Satisfaction
ORDER BY Job_Level, Job_Satisfaction;

-- 21. No of promotions vs Total Employees | Counting no of employees by no of promotions
SELECT 
    No_of_Promotions,
    COUNT(*) AS total_employees
FROM attrition_data2
GROUP BY No_of_Promotions
ORDER BY No_of_Promotions;

-- 22. NO OF EMPLOYEES VS DISTANCE FROM HOME | Calculating no of employees by how far they live from work
SELECT 
    CASE 
        WHEN Distance_from_Home <= 10 THEN 'Very Close'
        WHEN Distance_from_Home > 10 AND Distance_from_Home <= 25 THEN 'Close'
        WHEN Distance_from_Home > 25 AND Distance_from_Home <= 50 THEN 'Moderate'
        WHEN Distance_from_Home > 50 AND Distance_from_Home <= 70 THEN 'Moderate'
        ELSE 'Far'
    END AS distance_category,
    COUNT(*) AS Total_Employees
FROM attrition_data2
GROUP BY distance_category;


SELECT DISTINCT Work_Life_Balance FROM attrition_data2;

-- 23. AVG WORK LIFE BALANCE & JOB SATISFACTION BY MARITAL STATUS PER EDUCATION LEVEL | Analyzing job satisfaction and work life balance for each education level by marital status
SELECT 
    Education_Level,
    Marital_Status,
    ROUND (AVG(CASE 
        WHEN Job_Satisfaction = 'Low' THEN 1
        WHEN Job_Satisfaction = 'Medium' THEN 2
        WHEN Job_Satisfaction = 'High' THEN 3
        WHEN Job_Satisfaction = 'Very High' THEN 4
    END), 2) AS avg_satisfaction,
    ROUND(AVG(CASE 
        WHEN Work_Life_Balance = 'Poor' THEN 1
        WHEN Work_Life_Balance = 'Fair' THEN 2
        WHEN Work_Life_Balance = 'Good' THEN 3
        WHEN Work_Life_Balance = 'Excellent' THEN 4
    END), 2) AS avg_wlb
FROM attrition_data2
GROUP BY Education_Level, Marital_Status
ORDER BY Education_Level DESC;

-- 24. NO OF PROMOTIONS VS AVG JOB SATISFACTION | Analyzing avg job staisfaction by no of promotions
SELECT 
    No_of_Promotions,
    ROUND(AVG(CASE 
        WHEN Job_Satisfaction = 'Low' THEN 1
        WHEN Job_Satisfaction = 'Medium' THEN 2
        WHEN Job_Satisfaction = 'High' THEN 3
        WHEN Job_Satisfaction = 'Very High' THEN 4
    END), 2) AS avg_satisfaction
FROM attrition_data2
GROUP BY No_of_Promotions;

-- 25. BURNOUT VS INCOME | Detecting burnt out employees (low job satisfaction, poor work liife balance and staying more than 25 kms away) and their avg salaries 
SELECT Job_Role, COUNT(*) AS Burntout_employees,
ROUND(AVG(Monthly_Income), 2) AS avg_income
FROM attrition_data2
WHERE Job_Satisfaction IN ('Low')
  AND Work_Life_Balance IN ('Poor')
  AND No_of_Promotions = 0
  AND Distance_From_Home > 25
  GROUP BY Job_Role
  ORDER BY avg_income DESC;

-- 26. STRESS SCORE | Assigning stress scores for all employees
SELECT Employee_ID, Age, Gender, Job_Role, Attrition, Monthly_Income,
ROUND(((5 - CASE 
            WHEN Job_Satisfaction = 'Low' THEN 1
            WHEN Job_Satisfaction = 'Medium' THEN 2
            WHEN Job_Satisfaction = 'High' THEN 3
            WHEN Job_Satisfaction = 'Very High' THEN 4
        END) +
    (5 - CASE 
            WHEN Work_Life_Balance = 'Poor' THEN 1
            WHEN Work_Life_Balance = 'Fair' THEN 2
            WHEN Work_Life_Balance = 'Good' THEN 3
            WHEN Work_Life_Balance = 'Excellent' THEN 4
        END)
    +
    (5 - CASE 
			WHEN Leadership_Opportunities = 'No' THEN 1
            WHEN Leadership_Opportunities = 'Yes' THEN 5
		END) + 
    (5 - CASE 
			WHEN Remote_Work = 'No' THEN 1
            WHEN Remote_Work = 'Yes' THEN 4
		END) +
    (5 - CASE 
			WHEN Innovation_Opportunities = 'No' THEN 1
            WHEN Innovation_Opportunities = 'Yes' THEN 4
		END) + 
    (5 - CASE 
            WHEN Employee_Recognition = 'Low' THEN 1
            WHEN Employee_Recognition = 'Medium' THEN 2
            WHEN Employee_Recognition = 'High' THEN 3
            WHEN Employee_Recognition = 'Very High' THEN 4
        END) +
    (Distance_From_Home / 10) - No_of_Promotions
),1) AS stress_score
FROM attrition_data2
ORDER BY stress_score DESC;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
