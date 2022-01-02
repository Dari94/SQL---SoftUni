/*1.Mountains and Peaks*/
CREATE TABLE mountains (
id INT (8) PRIMARY KEY NOT NULL auto_increment,
`name` VARCHAR(45)
);
CREATE TABLE peaks (
id INT (8) PRIMARY KEY NOT NULL auto_increment,
`name` VARCHAR(45),
mountain_id INT(8),
CONSTRAINT fk_peak_mountain
FOREIGN KEY (mountain_id)
REFERENCES mountains(id)
);
/*2*/
SELECT v.driver_id, v.vehicle_type, CONCAT(first_name, " ",last_name) AS 'driver_name'
FROM campers AS c
JOIN vehicles AS v
ON v.driver_id=c.id;

/*3*/
SELECT r.starting_point , r.end_point, c.id
, concat(c.first_name, " ", c.last_name) AS 'leader_name'
FROM routes AS r
JOIN campers AS c
ON c.id = r.leader_id;

/*5*/
