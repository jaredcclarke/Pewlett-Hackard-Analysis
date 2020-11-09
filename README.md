# Pewlett-Hackard-Analysis
## Overview
Pewlett Hackard has a the issue of a large number of employees that are of retirement age and will have many open positions. The purpose assignment was to detemine the number of retiring employees per title and identify employees who are eligible to participate in a mentorship program. 

### Reources
* PostgresSQL 11
* pgAdmin 4
* Visual Studio Code 1.50.1
* Quick DBD
* departments.csv
* dept_emp.csv
* employees.csv
* titles.csv

## Results
* Primary and foreign keys are shown in this database diagram:
![](https://github.com/jaredcclarke/Pewlett-Hackard-Analysis/blob/main/EmployeeDB.png)

* The following code shows the queries that created the `retirement_titles.csv`
which shows all the employees of retirement age by title. Retiremnet age was determined to be anyone born between January 1, 1952 and December 31, 1955.
```
-- Retrieve the emp_no, first_name, and last_name columns from the Employees table
SELECT emp_no, first_name, last_name
FROM employees;

-- Retrieve the title, from_date, and to_date columns from the Titles table.
SELECT title, from_date, to_date
FROM titles;

-- Create a new table using the INTO clause.
SELECT e.emp_no, 
e.first_name, 
e.last_name,
ti.title,
ti.from_date,
ti.to_date
INTO retirement_titles
FROM employees AS e
-- Join both tables on the primary key.
INNER JOIN titles AS ti
ON (e.emp_no = ti.emp_no)
-- Filter the data on the birth_date column to retrieve the employees who were born between 1952 and 1955
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY emp_no ASC;
```
![](https://github.com/jaredcclarke/Pewlett-Hackard-Analysis/blob/main/Resources/retirement_titles.png)

* In this retiremnt_title table, many employee numbers are duplicated due to promotions and title changes, so there was a need to create a table with retiring employees with their current titles. This was done by using the `DISTINCT ON`clause. This new table was referred to as Unique Titles. (`unique_titles.csv`)
```
-- Use Dictinct with Orderby to remove duplicate rows
SELECT DISTINCT ON (emp_no) emp_no,
first_name,
last_name, 
title
INTO unique_titles
FROM retirement_titles
ORDER BY emp_no ASC, to_date DESC; 
```
![](https://github.com/jaredcclarke/Pewlett-Hackard-Analysis/blob/main/Resources/unique_titles.png)

* Now that there are no longer duplicate employee numbers and multiple job titles for employees, a total count of employees that are of retirement age were separated by department. (`retiring_titles.csv`)
```
-- Retrieve the number of employees by their most recent job title who are about to retire
SELECT COUNT(ut.emp_no), ut.title
INTO retiring_titles
FROM unique_titles as ut
GROUP BY title
ORDER BY count DESC;
```

![](https://github.com/jaredcclarke/Pewlett-Hackard-Analysis/blob/main/Resources/retiring_titles.png)

* Since Pewlett Hackard expects a large number of employees retiring, the company would like to know the employees who are eligible to be mentored by the retiring employees to take over thier roles. This was the query used to create the mentorship eligibity table (`mentorship_eligibility.csv`). The requirements for mentorship eligibility was current employees who were born bewtween January 1, 1965 and December 31, 1965. 
```
-- Retrieve the emp_no, first_name, last_name, and birth_date columns from the Employees table.
SELECT emp_no,
first_name,
last_name,
birth_date
FROM employees;

-- Retrieve the from_date and to_date columns from the Department Employee table.
SELECT from_date,
to_date 
FROM dept_emp;

-- Retrieve the title column from the Titles table
SELECT title
FROM titles;

-- Use a DISTINCT ON statement to retrieve the first occurrence of the employee number for each set of rows defined by the ON () clause.
SELECT DISTINCT ON (ti.emp_no) 
e.emp_no, 
e.first_name, 
e.last_name,
e.birth_date,
de.from_date,
de.to_date,
ti.title
-- Create a new table using the INTO clause.
INTO mentorship_eligibility
FROM employees as e
-- Join the Employees and the Department Employee tables on the primary key.
INNER JOIN dept_emp as de
ON (e.emp_no = de.emp_no)
-- Join the Employees and the Titles tables on the primary key.
INNER JOIN titles as ti
ON (e.emp_no = ti.emp_no)
-- Filter the data on the to_date column to get current employees whose birth dates are between January 1, 1965 and December 31, 1965.
WHERE (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
		AND (de.to_date = '9999-01-01')
-- Order the table by the employee number.
ORDER BY ti.emp_no ASC;
```
![](https://github.com/jaredcclarke/Pewlett-Hackard-Analysis/blob/main/Resources/mentorship_eligibility.png)

## Summary
According to the retiring titles data, 29,414 Senior Engineers, 28,254 Senior Staff, 14,222 Engineers, 12,243 Staff, 4,502 Technique Leaders, 1761 Assitant Engineers, and 2 Managers who are eligible for retirement. That's 90,398 postitions that need to be filled.
By running a count query by title of mentorship eligible employees (shown below), there are more than enough qualified retiring employees to mentor the next generation, though, they will need to hire a lot more employees.
![](https://github.com/jaredcclarke/Pewlett-Hackard-Analysis/blob/main/Resources/mentorship_eligibility_count.png)


