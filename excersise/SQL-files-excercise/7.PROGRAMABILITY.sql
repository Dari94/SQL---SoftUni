/*1*/
DELIMITER $$
CREATE PROCEDURE usp_get_employees_salary_above_35000 ()
BEGIN
SELECT first_name ,last_name FROM employees
WHERE salary > 35000
ORDER BY first_name, last_name, employee_id asc;
END $$

CALL usp_get_employees_salary_above_35000 ();

/*2*/
DELIMITER $$
CREATE PROCEDURE usp_get_employees_salary_above (min_salary decimal)
BEGIN
SELECT first_name ,last_name FROM employees
WHERE salary >= min_salary
ORDER BY first_name, last_name, employee_id asc;
END $$

CALL usp_get_employees_salary_above ( 48100);

/*3*/
DELIMITER $$
CREATE PROCEDURE usp_get_towns_starting_with  (start_with VARCHAR(20))
BEGIN
SELECT t.`name` FROM towns AS t
WHERE t.`name` LIKE CONCAT(start_with,'%')
ORDER BY t.`name` asc;
END $$

CALL usp_get_towns_starting_with  ( 'b');

/*4*/
DELIMITER $$
CREATE PROCEDURE usp_get_employees_from_town  (town_name VARCHAR(45))
BEGIN
SELECT e.first_name , e.last_name FROM employees AS e
JOIN addresses AS a
ON e.address_id = a.address_id
JOIN towns AS t
ON a.town_id = t.town_id
WHERE t.`name` LIKE town_name
ORDER BY e.first_name, e.last_name, e.employee_id;
END $$

CALL usp_get_employees_from_town ( 'Sofia');


/*5*/
delimiter $$
CREATE FUNCTION ufn_get_salary_level (salary_emp DECIMAL)
RETURNS VARCHAR(10)
DETERMINISTIC
BEGIN
   DECLARE result VARCHAR(10);

IF salary_emp < 30000 THEN SET result := 'Low';
ELSEIF salary_emp BETWEEN 30000 AND 50000 THEN SET result := 'Average';
ELSE SET result := 'High';
END IF;

RETURN result;
END $$

SELECT uufn_get_salary_level (13500);

/*6*/
delimiter $$
CREATE PROCEDURE usp_get_employees_by_salary_level1(salary_level VARCHAR(20))
BEGIN
SELECT first_name ,last_name
 FROM employees
WHERE LOWER(ufn_get_salary_level(salary)) = salary_level
ORDER BY first_name desc ,last_name desc;
END $$

call usp_get_employees_by_salary_level1  ('High');

/*7*/
CREATE FUNCTION ufn_is_word_comprised(set_of_letters varchar(50), word varchar(50))  
RETURNS boolean
DETERMINISTIC
BEGIN
   DECLARE result boolean;

RETURN result;
END $$

/*8*/
CREATE PROCEDURE usp_get_holders_full_name ()
BEGIN
SELECT CONCAT(ah.first_name, ' ',ah.last_name) AS full_name
FROM account_holders AS ah
ORDER BY full_name asc, ah.id;
END $$

CALL usp_get_holders_full_name ();
/*9*/
CREATE PROCEDURE usp_get_holders_with_balance_higher_than  (salary_level DECIMAL)
BEGIN
SELECT ah.first_name, ah.last_name
FROM account_holders AS ah
JOIN accounts AS a
ON a.account_holder_id = ah.id
GROUP BY a.account_holder_id
HAVING SUM(balance) > salary_level
ORDER BY a.id;
END $$

CALL usp_get_holders_with_balance_higher_than(7000);

/*10*/
create function ufn_calculate_future_value (sum double, yearly_interest_rate double, number_of_years int)
returns double
begin
declare result double;
set result = sum;
while number_of_years >= 1 do
set result := result + (result * yearly_interest_rate);
set number_of_years := number_of_years - 1 ;
end while;
return result;
end;
/*11. Calculating Interest*/
CREATE function ufn_calculate_future_value (sum  DOUBLE,yearly_interest_rate DOUBLE,number_of_years INT)
returns DECIMAL(10, 4)
begin
  DECLARE result DOUBLE;

  SET result = sum;

  WHILE number_of_years >= 1 do
    SET result := result + (result * yearly_interest_rate);
    SET number_of_years := number_of_years - 1;
  end WHILE;

  RETURN result;
end;

CREATE PROCEDURE usp_calculate_future_value_for_account(account_id INT,interest_rate DECIMAL(10, 4))
begin
  SELECT a.`id`,
         ah.`first_name`,
         ah.`last_name`,
         a.`balance`AS account_balance,
         Ufn_calculate_future_value(a.`balance`, interest_rate, 5) AS balance_in_5_years
  FROM   account_holders AS ah
  JOIN accounts AS a
  ON a.account_holder_id = ah.id
  WHERE  account_id = a.id;
END;  

/*12.	Deposit Money*/
DELIMETER $$
CREATE PROCEDURE usp_deposit_money1(acc_id INT, money_a DECIMAL(19,4)) 
BEGIN
   START TRANSACTION;
   IF(money_a <= 0)
   THEN ROLLBACK;
   ELSE
      UPDATE accounts
      SET balance = balance + money_a
      WHERE id= acc_id;
      END IF;
END $$

CALL usp_deposit_money1(1, 10);

/*13.	Withdraw Money*/
DELIMETER $$
CREATE PROCEDURE
  usp_withdraw_money(account_id   INT,
                     money_amount DECIMAL(20,4))
begin
  start transaction;
  IF money_amount <= 0 THEN
    rollback;
  ELSEIF
    money_amount >
    (
           SELECT `balance`
           FROM   accounts
           WHERE  account_id = id) THEN
    rollback;
  ELSE
    UPDATE accounts
    SET    balance = balance - money_amount
    WHERE  account_id = id;
  
  end IF;
end $$

/*14.	Money Transfer*/
CREATE PROCEDURE usp_transfer_money(from_account_id INT, to_account_id INT, amount DECIMAL (20,4))  
BEGIN
   START TRANSACTION;
   IF
      (
      SELECT `id`
      FROM   accounts
      WHERE  id = from_account_id) IS NULL THEN
    rollback;
  ELSEIF
          (
          SELECT `id`
          FROM   accounts
          WHERE  id = to_account_id) IS NULL THEN
    rollback;
  ELSEIF
    amount < 0 THEN
    rollback;
  ELSEIF
    amount >
    (
           SELECT `balance`
           FROM   accounts
           WHERE  from_account_id = id) THEN
    rollback;
  ELSEIF
    from_account_id = to_account_id THEN
    rollback;
  ELSE
    UPDATE accounts
    SET    balance = balance - amount
    WHERE  from_account_id = id;
    
    UPDATE accounts
    SET    balance = balance + amount
    WHERE  to_account_id = id;
  
  end IF;
END $$