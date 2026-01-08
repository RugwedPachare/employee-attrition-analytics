CREATE DATABASE IF NOT EXISTS hr_analytics;
USE hr_analytics;

CREATE TABLE IF NOT EXISTS hr_data(
Age INT,
  Attrition VARCHAR(5),
  BusinessTravel VARCHAR(50),
  DailyRate INT,
  Department VARCHAR(50),
  DistanceFromHome INT,
  Education INT,
  EducationField VARCHAR(50),
  EmployeeCount INT,
  EmployeeNumber INT,
  EnvironmentSatisfaction INT,
  Gender VARCHAR(10),
  HourlyRate INT,
  JobInvolvement INT,
  JobLevel INT,
  JobRole VARCHAR(50),
  JobSatisfaction INT,
  MaritalStatus VARCHAR(20),
  MonthlyIncome INT,
  MonthlyRate INT,
  NumCompaniesWorked INT,
  Over18 VARCHAR(5),
  OverTime VARCHAR(5),
  PercentSalaryHike INT,
  PerformanceRating INT,
  RelationshipSatisfaction INT,
  StandardHours INT,
  StockOptionLevel INT,
  TotalWorkingYears INT,
  TrainingTimesLastYear INT,
  WorkLifeBalance INT,
  YearsAtCompany INT,
  YearsInCurrentRole INT,
  YearsSinceLastPromotion INT,
  YearsWithCurrManager INT
);

# 1. CHECK FOR ROW COUNT
SELECT COUNT(*) FROM hr_data;

# 2. CHECK ATTRITION VALUE 
SELECT DISTINCT Attrition FROM hr_data;

# 3. CHECK IMPORTANT COLUMNS FOR NULLs
SELECT 
  SUM(CASE WHEN MonthlyIncome IS NULL THEN 1 ELSE 0 END) AS income_nulls,
  SUM(CASE WHEN Department IS NULL THEN 1 ELSE 0 END) AS dept_nulls,
  SUM(CASE WHEN JobRole IS NULL THEN 1 ELSE 0 END) AS role_nulls
FROM hr_data;

# 4. ATTRITION COUNT(CORE BUSINESS KPI)
SELECT Attrition,
  COUNT(*) AS total_employees
FROM hr_data
GROUP BY Attrition;

# 5. ATTRITION PERCRNTAGE
SELECT 
  ROUND(
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100 / COUNT(*), 2
  ) AS employee_percentage
FROM hr_data;

# 6. DEPARTMENT THAT LOSE MOST EMPLOYEES
SELECT Department,
  COUNT(*) AS total_employee,
  SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS employee_left,
  ROUND(
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2
  ) AS attrition_rate
FROM hr_data
GROUP BY Department
ORDER BY attrition_rate DESC;

# 7. ATTRITION BY JOB
SELECT JobRole,
  COUNT(*) AS total,
  SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS left_count
FROM hr_data
GROUP BY JobRole
ORDER by left_count DESC;

# 8. SALARY GROUPING
SELECT
  CASE 
    WHEN MonthlyIncome < 3000 THEN 'Low Income'
    WHEN MonthlyIncome BETWEEN 3000 AND 7000 THEN 'Medium Income'
    ELSE 'High Income'
  END AS income_group,
SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS attrition_count
FROM hr_data
GROUP BY income_group;

# 9. ATTRITION BY EXPERIRNCE
SELECT 
  YearsAtCompany,
  COUNT(*) AS total_employees,
  SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS employees_left,
  ROUND(
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2
  ) AS attrition_rate
FROM hr_data
GROUP BY YearsAtCompany
ORDER BY YearsAtCompany;

# 10. BUCKET EXPERIENCE
SELECT
  CASE
    WHEN YearsAtCompany <= 2 THEN '0-2 Years'
    WHEN YearsAtCompany BETWEEN 3 AND 5 THEN '3-5 Years'
    WHEN YearsAtCompany BETWEEN 6 AND 10 THEN '6-10 Years'
    WHEN YearsAtCompany BETWEEN 11 AND 20 THEN '11-20 Years'
    WHEN YearsAtCompany BETWEEN 21 AND 30 THEN '21-30 Years'
    ELSE '30+ Years'
    END AS experience_group,
  COUNT(*) AS total,
  SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS left_count,
  ROUND(
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2
  ) AS attrition_rate
FROM hr_data
GROUP BY experience_group
ORDER BY attrition_rate DESC;

# 11. OVERTIME VS ATTRITION
SELECT OverTime,
  COUNT(*) AS total_employees,
  SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS employees_left,
  ROUND(
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2
  ) AS attrition_rate
FROM hr_data
GROUP BY OverTime
ORDER BY attrition_rate;

# 12. JOB SATISFACTION VS ATTRITION
SELECT JobSatisfaction,
  COUNT(*) AS total,
  SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS left_count,
  ROUND(
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2
  ) AS attrition_rate
FROM hr_data
GROUP BY JobSatisfaction
ORDER BY JobSatisfaction;




