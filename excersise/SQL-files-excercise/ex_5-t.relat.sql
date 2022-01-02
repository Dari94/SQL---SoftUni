/*1.one-to-one relation*/
CREATE DATABASE `demo`;
CREATE table `persons` (
`person_id` INT(8) PRIMARY KEY NOT NULL AUTO_INCREMENT,
`first_name` VARCHAR(45),
`salary` DECIMAL(10,2),
`passport_id` INT(8) UNIQUE
);
CREATE table `passports` (
`passport_id` INT(8) PRIMARY KEY NOT NULL AUTO_INCREMENT,
`passport_number` VARCHAR(45)
);
INSERT INTO `persons`(`person_id`, `first_name`, `salary`,
 `passport_id`)
VALUES
(1, 'Roberto', 43300.00,102),
(2, 'Tom', 56100.00,103),
(3, 'Yana',60200.00, 101);
INSERT INTO `passports`(`passport_id`, `passport_number`)
VALUES
(101, 'N34FG21B'),
(102,'K65LO4R7'),
(103,'ZE657QP2');
ALTER table `persons`
ADD CONSTRAINT `fk_persons_passports`
FOREIGN KEY `persons`(`passport_id`)
REFERENCES `passports`(`passport_id`);

/*02. One-To-Many Relationship*/
CREATE table `manufacturers` (
`manufacturer_id` INT(8) PRIMARY KEY,
`name` VARCHAR(45),
`established_on` DATE
);
CREATE table `models` (
`model_id` INT(8) PRIMARY KEY,
`name` VARCHAR(45),
`manufacturer_id` INT(8)
);
INSERT INTO `manufacturers`(`manufacturer_id`, `name`, 
`established_on`)
VALUES
(1,'BMW', '1916.03.01'),
(2,'Tesla', '2003.01.01'),
(3,'Lada', '1966.05.01');
INSERT INTO `models`(`model_id`, `name`, 
`manufacturer_id`)
VALUES
(101,'X1',1),
(102,'i6',1),
(103,'Model S',2),
(104,'Model X',2),
(105,'Model 3',2),
(106,'Nova',3);
ALTER table `models`
ADD CONSTRAINT `fk_models_manufacturers`
FOREIGN KEY `models`(`manufacturer_id`)
REFERENCES `manufacturers`(`manufacturer_id`);

/*03. Many-To-Many Relationship*/
CREATE DATABASE `demo_two`;
CREATE table `students` (
`student_id` INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(45)
);
CREATE table `exams` (
`exam_id` INT PRIMARY KEY,
`name` VARCHAR(45)
);
CREATE table `students_exams` (
`student_id` INT,
`exam_id` INT,

CONSTRAINT pk_students_exams
PRIMARY KEY(`student_id`, `exam_id`),

CONSTRAINT fk_students_exams_students
FOREIGN KEY `students_exams`(`student_id`)
REFERENCES `students`(`student_id`),

CONSTRAINT fk_students_exams_exams
FOREIGN KEY `students_exams`(`exam_id`)
REFERENCES `exams`(`exam_id`)
);
INSERT INTO `students`(`student_id`, `name`)
VALUES
(1,'Mila'),
(2,'Toni'),
(3,'Ron');
INSERT INTO `exams`(`exam_id`, `name`)
VALUES
(101,'Spring MVC'),
(102,'Neo4j'),
(103,'Oracle 11g');
INSERT INTO `students_exams`(`student_id`,`exam_id`)
VALUES
(1,101),
(1,102),
(2,101),
(3,103),
(2,102),
(1,103);

/*04. Self-Referencing*/
CREATE table `teachers` (
`teacher_id` INT PRIMARY KEY,
`name` VARCHAR(45),
`manager_id` INT);
INSERT INTO `teachers`(`teacher_id`,`name`,`manager_id`)
VALUES
(101,'John',null),
(102,'Maya',106),
(103,'Silvia',106),
(104,'Ted',105),
(105,'Mark',101),
(106,'Greta',101);
ALTER table `teachers`
ADD CONSTRAINT `fk_teachers_teachers`
FOREIGN KEY (`manager_id`)
REFERENCES `teachers`(`teacher_id`);

/*05. Online Store Database*/
CREATE TABLE `cities`(
`city_id` INT(11) AUTO_INCREMENT PRIMARY KEY,
`name` VARCHAR(50)
);
CREATE TABLE `customers`(
`customer_id` INT(11) AUTO_INCREMENT PRIMARY KEY,
`name` VARCHAR(50),`birthday`DATE, `city_id` INT(11),
CONSTRAINT fk_customers_cities
FOREIGN KEY `customers`(`city_id`)
REFERENCES `cities`(`city_id`));

CREATE TABLE `orders`(
`order_id` INT(11) AUTO_INCREMENT PRIMARY KEY,
`customer_id` INT(11),
CONSTRAINT fk_orders_customers
FOREIGN KEY `orders`(`customer_id`)
REFERENCES `customers`(`customer_id`)
);

CREATE TABLE `item_types`(
`item_type_id`  INT(11) AUTO_INCREMENT PRIMARY KEY,
`name` VARCHAR(50)
);

CREATE TABLE `items`(
`item_id` INT(11) AUTO_INCREMENT PRIMARY KEY,
`name` VARCHAR(50),
`item_type_id` INT,

CONSTRAINT fk_items_item_types
FOREIGN KEY `items` (`item_type_id`)
REFERENCES `item_types`(`item_type_id`)
);

CREATE TABLE `order_items` (
`order_id` INT,
`item_id` INT,

CONSTRAINT pk_order_items
PRIMARY KEY(`order_id`, `item_id`),

CONSTRAINT fk_order_items_orders
FOREIGN KEY `order_items` (`order_id`)
REFERENCES `orders`(`order_id`),

CONSTRAINT fk_order_items_items
FOREIGN KEY `order_items` (`item_id`)
REFERENCES `items`(`item_id`)
);

/*6.University Database*/
CREATE DATABASE `demo_three`;
CREATE TABLE `majors`(
`major_id`  INT AUTO_INCREMENT PRIMARY KEY,
`name` VARCHAR(50)
);
CREATE TABLE `students`(
`student_id` INT AUTO_INCREMENT PRIMARY KEY,
`student_number` VARCHAR(12),
`student_name` VARCHAR(50),
`major_id` INT,
CONSTRAINT fk_students_majors
FOREIGN KEY `students`(`major_id`)
REFERENCES `majors`(`major_id`)
);
CREATE TABLE `payments`(
`payment_id` INT AUTO_INCREMENT PRIMARY KEY,
`payment_date`DATE,
`payment_amount`DECIMAL(8,2),
`student_id` INT,
CONSTRAINT fk_payments_students
FOREIGN KEY `payments`(`student_id`)
REFERENCES `students`(`student_id`)
);
CREATE TABLE `subjects`(
`subject_id`  INT AUTO_INCREMENT PRIMARY KEY,
`subject_name` VARCHAR(50)
);
CREATE TABLE `agenda` (
`student_id` INT,
`subject_id` INT,

CONSTRAINT pk_subjects_students
PRIMARY KEY(`student_id`, `subject_id`),

CONSTRAINT fk_agenda_students
FOREIGN KEY `agenda` (`student_id`)
REFERENCES `students`(`student_id`),

CONSTRAINT fk_agenda_subjects
FOREIGN KEY `agenda` (`subject_id`)
REFERENCES `subjects`(`subject_id`)
);

/*9.	Peaks in Rila*/
SELECT * FROM `mountains`,`peaks`;
SELECT m.`mountain_range` AS `mountain_range`,`peak_name`,`elevation`
FROM `peaks`
JOIN `mountains` AS m
ON peaks.`mountain_id` = m.`id`
WHERE m.`mountain_range` LIKE '%Rila%'
ORDER BY `elevation` desc;