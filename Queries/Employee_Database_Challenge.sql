select * from employees
select * from titles
select * from retirement_titles
select * from unique_titles
select * from dept_emp
select * from departments
select * from mentorship_eligibility

SELECT e.emp_no, e.first_name, e.last_name, t.title, t.from_date, t.to_date
INTO retirement_titles
FROM employees as e
JOIN titles as t 
ON e.emp_no = t.emp_no
WHERE e.birth_date BETWEEN '1952-01-01' AND '1955-12-31'
ORDER BY emp_no ASC;

-- Use Dictinct with Orderby to remove duplicate rows
SELECT DISTINCT ON (emp_no) emp_no, first_name, last_name, title
INTO unique_titles
FROM retirement_titles
ORDER BY emp_no ASC, to_date DESC;

SELECT COUNT(emp_no), title
INTO retiring_titles
FROM unique_titles
GROUP BY title
ORDER BY COUNT(emp_no) DESC;

SELECT DISTINCT ON (e.emp_no) 
	e.emp_no, e.first_name, e.last_name, e.birth_date, 
	de.from_date, de.to_date, 
	t.title
INTO mentorship_eligibility
FROM employees as e
JOIN dept_emp as de
ON e.emp_no = de.emp_no
JOIN titles as t
ON e.emp_no = t.emp_no
WHERE (de.to_date = '9999-01-01') 
AND(e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
ORDER BY e.emp_no;

SELECT COUNT(emp_no) from mentorship_eligibility
SELECT COUNT(emp_no) from unique_titles

-- Find the department name by sorting the number of retiring employees.
SELECT COUNT(u.emp_no), d.dept_name
FROM unique_titles as u
JOIN dept_emp as de
ON u.emp_no = de.emp_no
JOIN departments as d
ON de.dept_no = d.dept_no
GROUP BY d.dept_name
ORDER BY COUNT(u.emp_no) DESC;

-- Find the department name by sorting the number of employees qualified for mentorship program
SELECT COUNT (me.emp_no), d.dept_name
FROM mentorship_eligibility as me
JOIN dept_emp as de
ON me.emp_no = de.emp_no
JOIN departments as d
ON de.dept_no = d.dept_no
GROUP BY d.dept_name
ORDER BY COUNT(me.emp_no) DESC;