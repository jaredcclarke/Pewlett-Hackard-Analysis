-- Deliverable 1:
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

-- Use Dictinct with Orderby to remove duplicate rows
SELECT DISTINCT ON (emp_no) emp_no,
first_name,
last_name, 
title
INTO unique_titles
FROM retirement_titles
ORDER BY emp_no ASC, to_date DESC; 

-- Retrieve the number of employees by their most recent job title who are about to retire
SELECT COUNT(ut.emp_no), ut.title
INTO retiring_titles
FROM unique_titles as ut
GROUP BY title
ORDER BY count DESC;

-- DELIVERABLE 2:
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