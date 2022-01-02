/*01. Employee Address*/
SELECT e.employee_id, e.job_title, e.address_id, a.address_text
FROM employees AS e
JOIN addresses AS a
ON e.address_id = a.address_id
ORDER BY address_id asc
LIMIT 5;

/*02. Addresses with Towns*/
SELECT e.first_name ,e.last_name, t.`name`, a.address_text
FROM employees AS e
JOIN addresses AS a
ON a.address_id = e.address_id
JOIN towns AS t
ON t.town_id = a.town_id
ORDER BY first_name asc,last_name
LIMIT 5;

/*03. Sales Employee*/
SELECT e.employee_id , e.first_name, e.last_name, d.`name`
FROM employees AS e
JOIN departments AS d
 ON e.department_id = d.department_id
 WHERE d.`name` = 'Sales'
 ORDER BY employee_id desc;
 
 /*04. Employee Departments*/
 SELECT e.employee_id, e.first_name, e.salary, d.`name`
 FROM employees AS e
 JOIN departments AS d
 ON e.department_id = d.department_id
 WHERE e.salary > 15000
 ORDER BY d.department_id desc
 LIMIT 5;
 
 /*05. Employees Without Project*/
 SELECT e.employee_id, e.first_name
 FROM employees AS e
LEFT JOIN employees_projects AS ep
 ON e.employee_id = ep.employee_id
 WHERE ep.employee_id is NULL
 ORDER BY employee_id desc
 LIMIT 3;
 
 /*06. Employees Hired After*/
 SELECT e.first_name, e.last_name, e.hire_date,d.`name`
 FROM employees AS e
 JOIN departments AS d
 ON e.department_id = d.department_id
 WHERE date(e.hire_date) > '1999-01-01 23:59:59.997'
 AND d.`name`in('Sales' ,'Finance')
 ORDER BY e.hire_date asc;
 
 /*7.Employees with Project*/
SELECT e.employee_id, e.first_name, p.`name`
 FROM employees AS e
 JOIN employees_projects AS ep
 ON e.employee_id = ep.employee_id
 JOIN projects AS p
 ON ep.project_id = p.project_id
 WHERE DATE(p.start_date) > '2002-08-13' AND p.end_date IS NULL
 AND ep.employee_id IS NOT NULL
 ORDER BY e.first_name,p.`name`
 LIMIT 5;
 
 /*8.Employee 24*/
 SELECT e.`employee_id`, e.`first_name`,
 CASE
	WHEN p.start_date >= '2005-01-01' THEN NULL
	ELSE p.`name`
	END AS project_name
 FROM `employees` AS e
 JOIN employees_projects AS ep
 ON e.employee_id = ep.employee_id
 JOIN projects AS p
 ON ep.project_id = p.project_id
 WHERE e.employee_id = 24
 ORDER BY project_name;
 
/*9.Employee Manager*/
SELECT e.employee_id, e.first_name, e.manager_id AS manager_id,
m.first_name AS manager_name
FROM employees AS e
JOIN employees AS m
ON m.employee_id = e.manager_id
WHERE e.manager_id IN (3,7)
ORDER BY e.first_name;

/*10.Employee Summary*/
SELECT e.employee_id, CONCAT(e.first_name," ",e.last_name)
 AS employee_name,
CONCAT(m.first_name, " ",m.last_name) AS manager_name,d.`name`
FROM employees AS e
JOIN employees AS m
ON m.employee_id= e.manager_id
JOIN departments AS d
ON d.department_id = e.department_id
ORDER BY employee_id
LIMIT 5;

 /*11. Min Average Salary*/
SELECT avg(salary) AS min_average_salary FROM employees
GROUP BY department_id
ORDER BY min_average_salary asc
LIMIT 1;

/*12. Highest Peaks in Bulgaria*/
SELECT mc.country_code,m.mountain_range, p.peak_name,p.elevation
FROM mountains_countries AS mc
JOIN mountains AS m
ON mc.mountain_id = m.id
JOIN peaks AS p
ON m.id = p.mountain_id
WHERE elevation > 2835 and mc.country_code = 'BG'
ORDER BY elevation desc;

/*13.Count Mountain Ranges*/
SELECT mc.country_code, count(mc.mountain_id) AS mountain_range
FROM countries AS c
JOIN mountains_countries AS mc
ON c.country_code = mc.country_code
WHERE mc.country_code IN ( 'BG','RU','US')
GROUP BY mc.country_code
ORDER BY mountain_range desc;

/*14. Countries with Rivers*/
SELECT c.country_name,r.river_name
FROM countries AS c
LEFT JOIN countries_rivers AS cr
ON c.country_code = cr.country_code
 LEFT JOIN rivers AS r
ON cr.river_id = r.id
WHERE c.continent_code = 'AF'
ORDER BY c.country_name asc
LIMIT 5;

/*15.*Continents and Currencies*/
SELECT c.`continent_code`, c.`currency_code`, count(*) AS 'currency_usage'
FROM `countries` AS `c`
GROUP BY c.`continent_code` , c.`currency_code`
HAVING `currency_usage` > 1 AND `currency_usage` = (
SELECT count(*) AS `count` FROM `countries` AS `c2`
WHERE `c2`.`continent_code` = c.`continent_code`
GROUP BY `c2`.`currency_code`
ORDER BY `count` DESC
LIMIT 1)
ORDER BY c.`continent_code` , c.`continent_code`;


/*16. Countries without any Mountains*/
SELECT COUNT(c.country_code) AS country_count
FROM countries AS c
LEFT JOIN mountains_countries AS mc
ON c.country_code = mc.country_code
WHERE mc.country_code IS null;

/*17. Highest Peak and Longest River by Country*/
SELECT c.country_name,max(p.elevation) AS highest_peak_elevation,
max(r.length) AS longest_river_length
FROM countries AS c
LEFT JOIN mountains_countries AS mc
ON c.country_code = mc.country_code
LEFT JOIN peaks AS p
ON p.mountain_id = mc.mountain_id
LEFT JOIN countries_rivers AS cr
ON c.country_code = cr.country_code
LEFT JOIN rivers AS r
ON cr.river_id = r.id
GROUP BY country_name
ORDER BY highest_peak_elevation desc, longest_river_length desc,
c.country_name
LIMIT 5;




