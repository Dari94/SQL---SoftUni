SET GLOBAL log_bin_trust_function_creators = 1;
delimiter %%
CREATE FUNCTION ufn_count_employees_town(town_name VARCHAR(20))
RETURNS DOUBLE
BEGIN
DECLARE e_count DOUBLE;

SET e_count := (SELECT COUNT(e.employee_id) FROM employees AS e
JOIN addresses AS a
ON a.address_id = e.address_id
JOIN towns AS t
ON t.town_id = a.town_id
WHERE t.`name` = town_name);

RETURN e_count;
END %%

SELECT ufn_count_employees_town('Varna');
DELIMITER %%
CREATE PROCEDURE usp_raise_salaries(department_name VARCHAR(45))
BEGIN
UPDATE employees AS e
JOIN departments AS d
ON d.department_id = e.department_id
SET e.salary = e.salary* 1.05
WHERE d.`name` = department_name;
END%%

CALL usp_raise_salaries ('Sales');

DELIMITER %%
CREATE PROCEDURE usp_raise_salary_by_id(id INT)
BEGIN
DECLARE does_exist INT;
SET does_exist := (SELECT COUNT(*) FROM employees WHERE employee_id=id);
IF (does_exist > 0) THEN
UPDATE employees AS e
SET e.salary = e.salary* 1.05
WHERE e.employee_id = id;
END IF;
END %%
CALL usp_raise_salary_by_id (2);


CREATE TABLE deleted_employees(
employee_id INT PRIMART KEY NOT NULL,
 first_name VARCHAR (45),
 last_name VARCHAR(45),
 middle_name VARCHAR (45),
 job_title VARCHAR (45),
 deparment_id INT,
 salary DOUBLE
 ) 
 DELIMITER %%
 CREATE TRIGGER `employ_AUPD` AFTER DELETE ON employees
 FOR EACH ROW
 INSERT INTO deleted_employees (first_name, last_name)
 VALUES (OLD.first_name, OLD.last_name)