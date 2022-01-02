/*01. Find Names of All Employees by First Name*/
SELECT `first_name`, `last_name` FROM `employees`
WHERE substring(`first_name`,1,2)= 'Sa'
ORDER BY `employee_id`;

/*02. Find Names of All Employees by Last Name*/
SELECT `first_name`, `last_name` FROM `employees`
WHERE `last_name` LIKE '%ei%'
ORDER BY `employee_id`;

/*03. Find First Names of All Employess*/
SELECT `first_name` FROM `employees`
WHERE (`department_id`=3 OR `department_id`=10) AND
 EXTRACT(YEAR FROM `hire_date`)  BETWEEN '1995' AND '2005'
 ORDER BY `employee_id`;
 
/* 04. Find All Employees Except Engineers*/
SELECT `first_name`, `last_name` FROM `employees`
WHERE `job_title` NOT LIKE '%engineer%'
 ORDER BY `employee_id`;
 
/* 05. Find Towns with Name Length*/
SELECT `name` FROM `towns`
WHERE (char_length(`name`)=5) OR (char_length(`name`)=6)
ORDER BY `name`;

/*06. Find Towns Starting With*/
SELECT `town_id`, `name` FROM `towns`
WHERE `name` LIKE 'M%'
 OR `name` LIKE'K%'
OR `name` LIKE 'B%'
OR `name` LIKE 'E%'
ORDER BY `name`;

/*07. Find Towns Not Starting With*/
SELECT `town_id`,`name` FROM `towns`
WHERE `name` NOT LIKE 'R%'
 AND `name` NOT LIKE'B%'
AND `name` NOT LIKE 'D%'
ORDER BY `name`;

/*8. Create View Employees Hired After*/
CREATE VIEW `v_employees_hired_after_2000` AS
SELECT `first_name`, `last_name` FROM `employees`
WHERE EXTRACT(YEAR FROM `hire_date`)  > 2000;

/*09. Length of Last Name*/
SELECT `first_name`, `last_name` FROM `employees`
WHERE (char_length(`last_name`)=5);

/*10. Countries Holding 'A'*/
SELECT `country_name`,`iso_code` FROM `countries`
WHERE `country_name` LIKE '%a%a%a%'
ORDER BY `iso_code`;

/*11. Mix of Peak and River Names*/
SELECT `peak_name`,`river_name`,
CONCAT(LOWER(`peak_name`),'',SUBSTRING(LOWER(`river_name`),2)) AS `mix`
FROM `peaks`,`rivers`
WHERE RIGHT(`peak_name`,1)=LEFT(`river_name`,1)
ORDER BY `mix`;

/*12. Games From 2011 and 2012 Year*/
SELECT `name`,DATE_FORMAT(`start`,'%Y-%m-%d') AS `start` FROM `games`
WHERE EXTRACT(YEAR FROM `start`) =2011  OR 
EXTRACT(YEAR FROM `start`) =2012
ORDER BY `start`,`name`
LIMIT 50;

/*13. User Email Providers*/
SELECT `user_name`, SUBSTRING(`email`, LOCATE('@', `email`)+1) AS `Email Provider`
  FROM `users`
ORDER BY `Email Provider`,`user_name`;

/*14. Get Users with IP Address Like Pattern*/
SELECT `user_name`,`ip_address` FROM `users`
WHERE `ip_address` LIKE '___.1%.%.___'
ORDER BY `user_name`;

/*15. Show All Games with Duration*/
SELECT `name`,
(CASE
WHEN HOUR(`start`) BETWEEN 0 AND 11 THEN 'Morning'
WHEN HOUR(`start`) BETWEEN 12 AND 17 THEN 'Afternoon'
WHEN HOUR(`start`) BETWEEN 18 AND 23 THEN 'Evening'
END
) AS 'Part of the DAY',
(CASE
WHEN `duration` BETWEEN 0 AND 3 THEN 'Extra Short'
WHEN `duration` BETWEEN 4 AND 6 THEN 'Short'
WHEN `duration` BETWEEN 7 AND 10 THEN 'Long'
ELSE 'Extra Long'
END) AS 'Duratin'
 FROM `games`;
 
 /*16. Orders Table*/
SELECT  `product_name`, `order_date` ,
ADDDATE(`order_date`, INTERVAL +3 DAY) AS `pay_due`,
ADDDATE(`order_date`, INTERVAL +1 MONTH) AS `deliver_due`
FROM `orders`;
