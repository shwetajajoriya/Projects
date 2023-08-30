-- Cleaning Data & Data Exploration in SQL 

create database project;

use project;

select * from hr;

-- Rename id column to emp_id
ALTER TABLE hr
CHANGE COLUMN ï»¿id emp_id VARCHAR(20) NULL;

-- Check data types of all columns
describe hr;

select birthdate from hr;
SET sql_safe_updates = 0;

-- Change birthdate values to date
UPDATE hr
SET birthdate = CASE
	WHEN birthdate LIKE '%/%' THEN date_format(str_to_date(birthdate, '%m/%d/%Y'), '%Y-%m-%d')
    WHEN birthdate LIKE '%-%' THEN date_format(str_to_date(birthdate, '%m-%d-%Y'), '%Y-%m-%d')
    ELSE NULL
END;


-- Change birthdate column datatype
ALTER TABLE hr
MODIFY COLUMN birthdate DATE;

-- Convert hire_date values to date
UPDATE hr
SET hire_date = CASE
	WHEN hire_date LIKE '%/%' THEN date_format(str_to_date(hire_date, '%m/%d/%Y'), '%Y-%m-%d')
    WHEN hire_date LIKE '%-%' THEN date_format(str_to_date(hire_date, '%m-%d-%Y'), '%Y-%m-%d')
    ELSE NULL
END;

-- Change hire_date column data type
ALTER TABLE hr
MODIFY COLUMN hire_date DATE;

-- Convert termdate values to date and remove time
UPDATE hr
SET termdate = IF(termdate IS NOT NULL AND termdate != '', date(str_to_date(termdate, '%Y-%m-%d %H:%i:%s UTC')), '0000-00-00')
WHERE true;


SET sql_mode = 'ALLOW_INVALID_DATES';

-- Convert termdate column to date
ALTER TABLE hr
MODIFY COLUMN termdate DATE;


-- Add age column
ALTER TABLE hr ADD COLUMN age INT;

UPDATE hr
SET age = timestampdiff(YEAR, birthdate, CURDATE());

SELECT 
	min(age) AS youngest,
    max(age) AS oldest
FROM hr;

SELECT count(*) FROM hr WHERE age < 18;

SELECT COUNT(*) FROM hr WHERE termdate > CURDATE();

SELECT COUNT(*)
FROM hr
WHERE termdate = '0000-00-00';

SELECT location FROM hr;

select termdate from hr;


-- Questions
-- What is the gender breakdown of employees in the company?
-- What is the ethnicity breakdown of employees in the company?
-- What is the age distribution of employees in the company?
-- How many employees work at headquarters versus remote locations?
-- How does the gender distribution vary across departments and job titles?
-- What is the distribution of job titles across the company?
-- What is the distribution of employees across locations by city and state?
-- What is the tenure distribution for each department?



--  Gender breakdown of employees in the company
SELECT gender, COUNT(*) AS count
FROM hr
WHERE age >= 18 and termdate = '0000-00-00'
GROUP BY gender;


-- Ethnicity breakdown of employees in the company
SELECT race, COUNT(*) AS count
FROM hr
WHERE age >= 18 and termdate = '0000-00-00'
GROUP BY race
ORDER BY count DESC;


-- Age distribution of employees in the company
SELECT 
  MIN(age) AS youngest,
  MAX(age) AS oldest
FROM hr
WHERE age >= 18 and termdate = '0000-00-00';

SELECT 
  CASE 
    WHEN age >= 18 AND age <= 24 THEN '18-24'
    WHEN age >= 25 AND age <= 34 THEN '25-34'
    WHEN age >= 35 AND age <= 44 THEN '35-44'
    WHEN age >= 45 AND age <= 54 THEN '45-54'
    WHEN age >= 55 AND age <= 64 THEN '55-64'
    ELSE '65+' 
  END AS age_group, 
  COUNT(*) AS count
FROM 
  hr
WHERE 
  age >= 18 and termdate = '0000-00-00'
GROUP BY age_group
ORDER BY age_group;

SELECT 
  CASE 
    WHEN age >= 18 AND age <= 24 THEN '18-24'
    WHEN age >= 25 AND age <= 34 THEN '25-34'
    WHEN age >= 35 AND age <= 44 THEN '35-44'
    WHEN age >= 45 AND age <= 54 THEN '45-54'
    WHEN age >= 55 AND age <= 64 THEN '55-64'
    ELSE '65+' 
  END AS age_group, gender,
  COUNT(*) AS count
FROM 
  hr
WHERE 
  age >= 18 and termdate = '0000-00-00'
GROUP BY age_group,gender
ORDER BY age_group,gender;

-- Employees work at headquarters versus remote locations
SELECT location, COUNT(*) as count
FROM hr
WHERE age >= 18 and termdate = '0000-00-00'
GROUP BY location;

-- Gender distribution across departments
SELECT department, gender, COUNT(*) as count
FROM hr
WHERE age >= 18 and termdate = '0000-00-00'
GROUP BY department, gender
ORDER BY department;


--  Distribution of job titles across the company
SELECT jobtitle, COUNT(*) as count
FROM hr
WHERE age >= 18 and termdate = '0000-00-00'
GROUP BY jobtitle
ORDER BY jobtitle DESC;


-- Distribution of employees across locations by state
SELECT location_state, COUNT(*) as count
FROM hr
WHERE age >= 18 and termdate = '0000-00-00'
GROUP BY location_state
ORDER BY count DESC;


-- Tenure distribution for each department
SELECT department, ROUND(AVG(DATEDIFF(CURDATE(), termdate)/365),0) as avg_tenure
FROM hr
WHERE termdate <= CURDATE() AND termdate <> '0000-00-00' AND age >= 18
GROUP BY department;


-- Summary of Findings
-- There are more male employees
-- White race is the most dominant while Native Hawaiian and American Indian are the least dominant.
-- The youngest employee is 20 years old and the oldest is 57 years old
-- 5 age groups were created (18-24, 25-34, 35-44, 45-54, 55-64). A large number of employees were between 25-34 followed by 35-44 while the smallest group was 55-64.
-- A large number of employees work at the headquarters versus remotely.
-- The gender distribution across departments is fairly balanced but there are generally more male than female employees.
-- A large number of employees come from the state of Ohio.
-- The average tenure for each department is about 8 years.









