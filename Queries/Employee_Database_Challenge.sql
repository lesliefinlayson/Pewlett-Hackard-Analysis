
--Challenge
--Number of titles retiring
SELECT ce.emp_no, ce.first_name, ce.last_name,
	ti.title, ti.from_date, ti.to_date
INTO ret_titles
FROM current_employees as ce
INNER JOIN titles as ti
ON (ce.emp_no = ti.emp_no)
ORDER BY ce.emp_no

--show most recent title per employee
SELECT emp_no, first_name, last_name, to_date, title
INTO unique_titles
FROM (
	SELECT emp_no, first_name, last_name, to_date, title, ROW_NUMBER() OVER
	(PARTITION BY (emp_no)
	ORDER BY to_date DESC) rn
	FROM ret_titles
	)tmp WHERE rn = 1
ORDER BY emp_no

--Counting number of employees per title
SELECT COUNT(title), title
INTO retiring_titles
FROM unique_titles
GROUP BY title
ORDER BY COUNT DESC;

--employee list for potential mentorship program
SELECT e.emp_no, e.first_name, e.last_name, e.birth_date,
	de.from_date, de.to_date, ti.title
INTO mentorship
FROM employees as e
INNER JOIN dept_employees as de
	on (e.emp_no = de.emp_no)
INNER JOIN titles as ti
	on (e.emp_no = ti.emp_no)
WHERE (de.to_date = '9999-01-01')
AND (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
ORDER BY e.emp_no

--show most recent title per mentorship employee
SELECT emp_no, first_name, last_name, to_date, title
INTO unique_titlesmentorship
FROM (
	SELECT emp_no, first_name, last_name, to_date, title, ROW_NUMBER() OVER
	(PARTITION BY (emp_no)
	ORDER BY to_date DESC) rn
	FROM mentorship
	)tmp WHERE rn = 1
ORDER BY emp_no

--Counting number of employees per title eligible for mentorship
SELECT COUNT(title), title
INTO mentorship_titles
FROM unique_titlesmentorship
GROUP BY title
ORDER BY COUNT DESC;

SELECT * FROM  mentorship_tit
