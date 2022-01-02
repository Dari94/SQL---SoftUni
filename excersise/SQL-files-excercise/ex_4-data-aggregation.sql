SELECT count(`id`) AS 'count'
FROM `wizzard_deposits`;

/*2. Longeest Magic Wand*/
SELECT max(`magic_wand_size`) AS 'longest_magic_wand'
FROM `wizzard_deposits`;

/*03. Longest Magic Wand per Deposit Groups*/
SELECT `deposit_group`,max(`magic_wand_size`) AS 'longest_magic_wand'
FROM `wizzard_deposits`
GROUP BY `deposit_group`
ORDER BY `longest_magic_wand` asc, `deposit_group`;

/*04. Smallest Deposit Group per Magic Wand Size*/
SELECT `deposit_group`
FROM `wizzard_deposits`
HAVING avg(`magic_wand_size`);

/*5.	 Deposits Sum*/
SELECT `deposit_group`,sum(`deposit_amount`) AS 'total_sum'
FROM `wizzard_deposits`
GROUP BY `deposit_group`
ORDER BY `total_sum` asc;


/*6. Deposits Sum for Ollivander Family*/
SELECT `deposit_group`,sum(`deposit_amount`) AS 'total_sum'
FROM `wizzard_deposits`
WHERE `magic_wand_creator` = 'Ollivander family'
GROUP BY `deposit_group`
ORDER BY `deposit_group`;

/*7.	Deposits Filter*/
SELECT `deposit_group`,sum(`deposit_amount`) AS 'total_sum'
FROM `wizzard_deposits`
WHERE `magic_wand_creator` = 'Ollivander family'
GROUP BY `deposit_group`
HAVING `total_sum` < 150000
ORDER BY `total_sum`desc;

/*8. Deposit Charge*/
SELECT `deposit_group`,`magic_wand_creator`,
min(`deposit_charge`) AS 'min_deposit_group'
FROM `wizzard_deposits`
GROUP BY `deposit_group`, `magic_wand_creator`
ORDER BY `magic_wand_creator` asc, `deposit_group` asc;

/*9. Age Groups*/
SELECT
CASE
WHEN `age` >= 0 AND `age` <11 THEN '[0-10]' 
WHEN `age` >= 11 AND `age` <21 THEN '[11-20]' 
WHEN `age` >= 21 AND `age` <31 THEN '[21-30]' 
WHEN `age` >= 31 AND `age` <41 THEN '[31-40]' 
WHEN `age` >= 41 AND `age` <51 THEN '[41-50]' 
WHEN `age` >= 51 AND `age` <61 THEN '[51-60]' 
WHEN `age` >= 61 THEN '[61+]' 
END AS `age_group`,count(`age`) AS `wizzard_count`
FROM `wizzard_deposits`
GROUP BY `age_group`
ORDER by `age_group` asc;

/*10. First Letter*/
SELECT SUBSTRING(`first_name`,1,1) AS 'first_letter'
FROM `wizzard_deposits`
WHERE `deposit_group` = 'Troll Chest'
GROUP BY `first_letter`
ORDER BY `first_letter`;

/*11.	Average Interest */
SELECT `deposit_group`, `is_deposit_expired`,
avg(`deposit_interest`) AS 'average_interest'
FROM `wizzard_deposits`
WHERE `deposit_start_date` > '1985-01-01'
GROUP BY `deposit_group`, `is_deposit_expired`
ORDER BY `deposit_group` DESC, `is_deposit_expired`;

/*Rich Wizard, Poor Wizard**/
SELECT
	SUM(`host_dep`.`deposit_amount` - `guest_dep`.`deposit_amount`) as 'sum_difference'
FROM
    `wizzard_deposits` AS `host_dep`, `wizzard_deposits` AS `guest_dep`
WHERE
     `guest_dep`.`id` - `host_dep`.`id` = 1;

/*13.	 Employees Minimum Salaries */
SELECT `department_id`,min(`salary`) AS 'minimum_salary'
FROM `employees`
WHERE `hire_date` > 01/01/2000 
GROUP BY `department_id`
HAVING `department_id` = 2 or 
 `department_id` = 5 or `department_id` =7
ORDER BY `department_id`;

/*14.	Employees Average Salaries */
CREATE table `high paid employees` AS
SELECT * FROM`employees`
WHERE `salary` > 30000 and `manager_id` !=42;
UPDATE `high paid employees`
SET `salary` = `salary` + 5000
WHERE `department_id` = 1;
SELECT `department_id`,avg(`salary`) AS 'avg_salary'
FROM `high paid employees`
GROUP BY `department_id` 
ORDER BY `department_id` asc;

/*15. Employees Maximum Salaries*/
SELECT `department_id`, max(`salary`) AS 'max_salary'
FROM `employees`
GROUP BY `department_id`
HAVING `max_salary` NOT BETWEEN 30000 AND 70000
ORDER BY `department_id` asc;

/*16.	Employees Count Salaries*/
SELECT `manager_id` FROM `employees`;
SELECT count(`salary`) AS 'salary_count'
FROM `employees`
WHERE `manager_id` IS NULL;

/*17.	3rd Highest Salary**/
WITH `salary_rank` AS(
   SELECT `department_id`,`salary`,dense_rank() OVER(PARTITION BY `department_id`
   ORDER BY `salary` desc) AS 'rownum'
   FROM `employees`)
SELECT DISTINCT `department_id`,`salary`
AS 'third_highest_salary'
FROM `salary_rank`
WHERE `rownum` =3;

SELECT `department_id`, round(`salary`,4) AS 'third_highest_salary'
FROM `employees` AS es
WHERE
(SELECT `employee_id` FROM `employees` AS ine
WHERE ine.`department_id` = es.`department_id`
GROUP BY `salary`
ORDER BY `salary` desc LIMIT 1 OFFSET 2
)= `employee_id`
GROUP BY `department_id`
ORDER BY `department_id` ASC;
/*18. Salary Challenge*/
SELECT e.`first_name` , e.`last_name`,e.`department_id`
FROM `employees` AS e
WHERE `salary` > (
  SELECT AVG(e2.`salary`)
  FROM `employees` AS e2
  WHERE e2.`department_id` = e.`department_id`
  GROUP BY e2.`department_id`
  )
ORDER BY e.`department_id`, e.`employee_id`
LIMIT 10;

/*19.	Departments Total Salaries*/
SELECT `department_id`,sum(`salary`) AS 'total_salary'
FROM `employees`
GROUP BY `department_id`
ORDER BY `department_id`;