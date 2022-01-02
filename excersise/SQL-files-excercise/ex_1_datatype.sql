/*1.Create Tables*/
CREATE TABLE `towns` (
`id` INT NOT NULL PRIMARY KEY,
`name` VARCHAR(45)
);
CREATE TABLE `minions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `age` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
); 
/*2.Alter Minions Table*/
ALTER TABLE `minions` ADD column `town_id` int;
ALTER TABLE `minions`
ADD CONSTRAINT `fk_minions_towns` FOREIGN KEY(`town_id`)
REFERENCES `towns`(`id`);

/*3.Insert Records in Both Tables*/
INSERT INTO `towns`(`id`, `name`)
VALUES (1, 'Sofia'),
(2, 'Plovdiv'),
(3, 'Varna');

SELECT *FROM `towns`;

INSERT INTO `minions`(`id`, `name`, `age`, `town_id`)
VALUES
(1, 'Kevin', 22,1),
(2, 'Bob', 15,3),
(3, 'Steward', NULL, 2);

SELECT * FROM `minions`;

/*4.Truncate Table Minions*/
TRUNCATE TABLE `minions`;

SELECT * FROM `minions`;

/*5.Drop All Tables*/
DROP TABLE `minions`;
DROP TABLE `towns`;

/*6.Create Table People*/
CREATE TABLE `people` (
`id` INT AUTO_INCREMENT PRIMARY KEY,
`name` VARCHAR(200) NOT NULL,
`picture` BLOB(2) NULL,
`height` DOUBLE(10,2) NULL,
`weight` DOUBLE(10,2) NULL,
`gender` VARCHAR(45) NOT NULL,
`birthdate` DATE NOT NULL,
`biography` TEXT NULL);
INSERT INTO `people` (`id` , `name`, `height`, `gender`, `birthdate`)
VALUES
(1,'Kevin',1.83,'m','2005.8.10');

/*7.Create Table Users*/
CREATE TABLE `users` (
`id` INT AUTO_INCREMENT PRIMARY KEY,
`name` VARCHAR(30),
`username` VARCHAR(26),
`profile_picture` BLOB(0.9),
`last_login_time` TIME,
`is_deleted` BOOLEAN);
INSERT INTO `users` (`id` , `name`, `username`, `last_login_time`, `is_deleted`)
VALUES
(2,'Kevin','Miler','09:10:00',0);

/*8.Change Primary Key*/
ALTER TABLE `users`
  MODIFY `id` INT NOT NULL;
ALTER TABLE `users`
  DROP PRIMARY KEY;
ALTER TABLE `users`
  ADD CONSTRAINT `pk_users` PRIMARY KEY (`id`,`username`);

/*9.Set Default Value of a Field*/
ALTER TABLE `users`
SET `last_login_time`DATETIME DEFAULT CURRENT_TIMESTAMP;

/*10.set Unique Field*/
ALTER TABLE `users`
DROP PRIMARY KEY,
ADD CONSTRAINT `pk_id`
PRIMARY KEY(`id`),
ADD CONSTRAINT `uq_username`
UNIQUE(`username`);

/*11.Movies Database*/
CREATE DATABASE `Movies`;
CREATE TABLE `directors` (
`id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
`director_name` VARCHAR(50),
`notes` TEXT NULL);
INSERT INTO `directors`(`id`)
VALUES
(1),(2),(3),(4),(5);
CREATE TABLE `genres` (
`id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
`genre_name` VARCHAR(50),
`notes` TEXT NULL);
INSERT INTO `genres`(`id`)
VALUES
(1),(2),(3),(4),(5);
CREATE TABLE `categories` (
`id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
`category_name` VARCHAR(50),
`notes` TEXT NULL);
INSERT INTO `categories`(`id`)
VALUES
(1),(2),(3),(4),(5);
CREATE TABLE `movies` (
`id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
`title` VARCHAR(50),
`director_id` INT NOT NULL,
`copyright_year` DATE,
`length` DOUBLE,
`genre_id` INT NOT NULL,
`category_id` INT NOT NULL,
`rating` DOUBLE,
`notes` TEXT NULL);
INSERT INTO `movies`(`id`, `director_id`,`genre_id`,`category_id`)
VALUES
(1,1,1,1),
(2,2,2,2),
(3,3,3,3),
(4,4,4,4),
(5,5,5,5);
DROP TABLE `movies`;
/*12.Car Rental Database*/
CREATE DATABASE IF NOT EXISTS `car_rental`;
CREATE TABLE `categories` (
`id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
`category` VARCHAR(50),
`daily_rate` DOUBLE,
`weekly_rate` DOUBLE,
`monthly_rate` DOUBLE,
`weekend_rate` DOUBLE);
CREATE TABLE `cars` (
`id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
`plate_number` INT,
`make` VARCHAR(50),
`model` VARCHAR(50),
`car_year` INT,
`category_id` INT,
`doors` INT,
`picture` BLOB,
`car_condition` TEXT,
`available` BOOLEAN );
CREATE TABLE `employees` (
`id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
`first_name` VARCHAR(50),
`last_name` VARCHAR(50),
`title` VARCHAR(50),
`notes` TEXT);
CREATE TABLE `customers` (
`id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
`driver_license` VARCHAR(50),
`full_name` VARCHAR(50),
`address` TEXT,
`city` VARCHAR(50),
`zip_code` INT,
`notes` TEXT);
CREATE TABLE `rental_orders` (
`id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
`employee_id` INT NOT NULL,
`customer_id` INT NOT NULL,
`car_id` INT NOT NULL,
`car_condition` TEXT,
`tank_level` DOUBLE,
`kilometrage_start` DOUBLE,
`kilometrage_end` DOUBLE,
`total_kilometrage` DOUBLE,
`start_date` DATE,
`end_date` DATE,
`total_days` INT,
`rate_applied` DOUBLE,
`tax_rate` DOUBLE,
`order_status` VARCHAR(50),
`notes` TEXT);

INSERT INTO `categories`(`id`)
VALUES
(1),(2),(3);
INSERT INTO `cars`(`id`)
VALUES
(1),(2),(3);
INSERT INTO `employees`(`id`)
VALUES
(1),(2),(3);
INSERT INTO `customers`(`id`)
VALUES
(1),(2),(3);
INSERT INTO `rental_orders`(`id`,`employee_id`,`customer_id`,`car_id`)
VALUES
(1,1,1,1),(2,2,2,2),(3,3,3,3);

/*13.Hotel Database*/
CREATE DATABASE IF NOT EXISTS `Hotel`;
CREATE TABLE `employees`(
`id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
`first_name` VARCHAR(45),
`last_name` VARCHAR(45),
`title` VARCHAR(45),
`notes` TEXT);
CREATE TABLE `customers`(
`account_number` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
`first_name` VARCHAR(45),
`last_name` VARCHAR(45),
`phone_number` INT,
`emergency_name` VARCHAR(45),
`emergency_number` INT,
`notes` TEXT);
CREATE TABLE `room_status`(
`room_status` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
`notes` TEXT);
CREATE TABLE `room_types`(
`room_type` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
`notes` TEXT);
CREATE TABLE `bed_types`(
`bed_type` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
`notes` TEXT);
CREATE TABLE `rooms`(
`room_number` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
`room_type` INT NOT NULL,
`bed_type` INT NOT NULL,
`room_status` INT NOT NULL,
`notes` TEXT);
CREATE TABLE `payments`(
`id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
`employee_id` INT NOT NULL,
`payment_date` DATE,
`account_number` INT,
`first_date_occupied` DATE,
`last_date_occupied` DATE,
`total_days` INT,
`amount_charged` DOUBLE,
`tax_rate` DOUBLE,
`tax_amount` DOUBLE,
`payment_total` DOUBLE,
`notes` TEXT);
CREATE TABLE `occupancies`(
`id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
`employee_id` INT NOT NULL,
`date_occupied` DATE,
`account_number` INT NOT NULL,
`room_number` INT NOT NULL,
`rate_applied` INT,
`phone_charge` INT,
`notes` TEXT);
INSERT INTO `employees`(`id`)
VALUES
(1),(2),(3);
INSERT INTO `customers`(`account_number`)
VALUES
(1),(2),(3);
INSERT INTO `room_status`(`room_status`)
VALUES
(1),(2),(3);
INSERT INTO `room_types`(`room_type`)
VALUES
(1),(2),(3);
INSERT INTO `bed_types`(`bed_type`)
VALUES
(1),(2),(3);
INSERT INTO `rooms`(`room_number`,`room_type`,`bed_type`,`room_status`)
VALUES
(1,1,1,1),(2,2,2,2),(3,3,3,3);
INSERT INTO `payments`(`id`,`employee_id`,`account_number`,`tax_rate`)
VALUES
(1,1,1,4.5),(2,2,2,5.5),(3,3,3,5.5);
truncate table `payments`;
INSERT INTO `occupancies`(`id`,`employee_id`,`account_number`,`room_number`)
VALUES
(1,1,1,1),(2,2,2,2),(3,3,3,3);

/*14.SoftUni Database*/
CREATE DATABASE IF NOT EXISTS `soft_uni`;

CREATE TABLE `towns`(
`id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
`name` VARCHAR(30) NOT NULL
);
CREATE TABLE `addresses`(
`id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
`adress_text` VARCHAR(255) NOT NULL,
`town_id` INT,
CONSTRAINT fk_addresses_towns
FOREIGN KEY `addresses`(`town_id`)
REFERENCES `towns`(`id`)
);
CREATE TABLE `departments`(
`id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
`name` VARCHAR(50) NOT NULL
);
CREATE TABLE `employees`(
`id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
`first_name` VARCHAR(45),
`middle_name` VARCHAR(45),
`last_name` VARCHAR(45),
`job_title` VARCHAR(45),
`department_id` INT,
`hire_date` DATE,
`salary` DECIMAL(10,2),
`address_id` INT,

CONSTRAINT fk_employees_departments
FOREIGN KEY `employees`(`department_id`)
REFERENCES `departments`(`id`),

CONSTRAINT fk_employees_addresses
FOREIGN KEY `employees`(`address_id`)
REFERENCES `addresses`(`id`)
);

/*15.Basic Insert*/
INSERT INTO `towns`
(`id`,`name`)
VALUES
(1,'Sofia'),
(2,'Plovdiv'),
(3,'Varna'),
(4,'Burgas');
INSERT INTO `departments`
(`id`,`name`)
VALUES
(1,'Engineering'),
(2,'Sales'),
(3,'Marketing'),
(4,'Software Development'),
(5,'Quality Assurance');

INSERT INTO `employees`
(`id`,
`first_name`,
`middle_name`,
`last_name`,
`job_title`,
`department_id`,
`hire_date`,
`salary`)
VALUES
(1,'Ivan', 'Ivanov' , 'Ivanov','.NET Developer',4,'2013/02/01',3500.00),
(2,'Petar', 'Petrov' , 'Petrov','Senior Engineer',1,'2004/03/02',4000.00),
(3,'Maria', 'Petrova' ,'Ivanova','Intern',5,'2016/08/28',525.25),
(4,'Georgi', 'Terziev' , 'Ivanov','CEO',2,'2007/12/09',3000.00),
(5,'Peter','Pan' , 'Pan','Intern',3,'2016/08/28',599.88);

/*16.Basic Select All Fields*/
SELECT * FROM `towns`;
SELECT * FROM `departments`;
SELECT * FROM `employees`;

/*17.Basic Select All Fields and Order Them*/
SELECT  * FROM `towns`
ORDER BY `name`;
SELECT * FROM `departments`
ORDER BY `name`;
SELECT * FROM `employees`
ORDER BY  `salary` DESC;

/*18.Basic Select Some Fields*/
SELECT `name` FROM `towns`
ORDER BY `name`;
SELECT `name` FROM `departments`
ORDER BY `name`;
SELECT `first_name`,`last_name`,`job_title`,`salary` FROM `employees`
ORDER BY  `salary` DESC;

/*19.	Increase Employees Salary*/
UPDATE `employees`
SET `salary` = `salary`* 1.10
WHERE `id` IN (1,2,3,4,5);
SELECT `salary` FROM `employees`;

/*20.Decrease Tax Rate*/
UPDATE `payments`
SET `tax_rate` = `tax_rate`* 0.97
WHERE `id` IN (1,2,3);
SELECT `tax_rate` FROM `payments`;

/*21.Delete All Records*/
TRUNCATE TABLE `occupancies`;