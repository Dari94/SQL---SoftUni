SELECT `department_id`,count(`first_name`) AS `number of employees`
FROM `employees`
GROUP BY `department_id`;

SELECT e.`department_id`,round(avg(e.`salary`),2) AS `average salary`
FROM `employees` AS e
GROUP BY `department_id`;

SELECT e.`department_id`, round(min(e.`salary`),2) AS `Min Salary`
FROM `employees` AS e
GROUP BY `department_id`
HAVING `Min Salary` > 800;


