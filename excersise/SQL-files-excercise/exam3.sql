CREATE DATABASE CJMS;
CREATE table planets (
id INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(30) NOT NULL
);
CREATE TABLE spaceports(
id INT AUTO_INCREMENT PRIMARY KEY,
`name` VARCHAR(50)  NOT NULL,
planet_id INT,

CONSTRAINT fk_spaceports_planets
FOREIGN KEY spaceports(planet_id)
REFERENCES planets(id)
);

CREATE table spaceships (
id INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(50) NOT NULL,
manufacturer VARCHAR(30) NOT NULL,
light_speed_rate INT default(0)
);
CREATE TABLE journeys(
id INT AUTO_INCREMENT PRIMARY KEY,
journey_start DATETIME NOT NULL,
journey_end DATETIME NOT NULL,
purpose ENUM('Medical', 'Technical', 
'Educational', 'Military') NOT NULL,
destination_spaceport_id INT,
spaceship_id INT,

CONSTRAINT fk_journeys_spaceports
FOREIGN KEY journeys(destination_spaceport_id)
REFERENCES spaceports(id),

CONSTRAINT fk_journeys_spaceships
FOREIGN KEY journeys(spaceship_id)
REFERENCES spaceships(id)
);
CREATE table colonists (
id INT PRIMARY KEY AUTO_INCREMENT,
first_name VARCHAR(20) NOT NULL,
last_name VARCHAR(20) NOT NULL,
ucn CHAR(10) NOT NULL UNIQUE,
birth_date DATE NOT NULL
);
CREATE TABLE travel_cards(
id INT AUTO_INCREMENT PRIMARY KEY,
card_number CHAR(10) NOT NULL UNIQUE,
job_during_journey ENUM('Pilot', 'Engineer', 
'Ttrooper', 'Cleaner','Cook') NOT NULL,
colonist_id INT,
journey_id INT,

CONSTRAINT fk_travel_cards_colonists
FOREIGN KEY travel_cards(colonist_id)
REFERENCES colonists(id),

CONSTRAINT fk_travel_cards_journeys
FOREIGN KEY travel_cards(journey_id)
REFERENCES journeys(id)
);
/*3.Insert*/
INSERT INTO travel_cards (card_number,job_during_journey,colonist_id, journey_id)
SELECT 
(
CASE
WHEN  c.birth_date > '1980-01-01' 
THEN concat_ws('', YEAR(c.birth_date),DAY(c.birth_date),substring(c.ucn,1,4))
ELSE concat_ws('', YEAR(c.birth_date),MONTH(c.birth_date),substring(c.ucn,7,10))
END
) AS card_number,
(
CASE
 WHEN c.id % 2 = 0 THEN 'Pilot'
 WHEN c.id % 3 = 0 THEN 'Cook'
 ELSE 'Engineer'
 END
 ) AS job_during_journey,
 c.id,
substring(c.ucn,1,1) AS journey_id
FROM colonists AS c
WHERE c.id BETWEEN 96 and 100;


/*Update*/
UPDATE journeys 
SET `purpose`= CASE
WHEN id % 2 = 0 THEN 'Medical'
WHEN id % 3 = 0 THEN 'Technical'
WHEN id % 5 = 0 THEN 'Educational'
WHEN id % 7 = 0 THEN 'Military'
ELSE `purpose`
END;
        
/*DELETE*/
DELETE c FROM colonists AS c
LEFT JOIN travel_cards AS tc
ON c.id = tc.colonist_id
WHERE tc.journey_id IS NULL;

DELETE FROM colonists
  WHERE id NOT IN (
    SELECT tc.colonist_id FROM travel_cards tc
  );
  
 /* 04.Extract all travel cards*/
 SELECT card_number, job_during_journey
 FROM travel_cards
 ORDER BY card_number asc;
 
 /*5Extract all colonists*/
 SELECT c.id, concat_ws(' ', c.first_name, c.last_name) full_name, c.ucn
FROM colonists c
ORDER BY c.first_name, c.last_name, c.id;

/*06.Extract all military journeys*/
SELECT j.id ,j.journey_start, j.journey_end 
FROM journeys AS j
WHERE purpose = 'Military'
ORDER BY j.journey_start;


/*07.	Extract all pilots*/
SELECT c.id, concat(c.first_name, ' ',c.last_name) AS full_name
FROM colonists AS c
JOIN travel_cards AS tc
ON c.id = colonist_id
WHERE tc.job_during_journey = 'Pilot'
ORDER BY c.id asc;

/*08.	Count all colonists that are on technical journey*/
SELECT count(tc.colonist_id) AS count
FROM travel_cards AS tc
JOIN journeys AS j
ON tc.journey_id = j.id
WHERE purpose = 'Technical';

/*09.Extract the fastest spaceship*/
SELECT * from spaceships;
SELECT sp.`name` AS spaceship_name , s.`name` AS spaceport_name
FROM spaceships AS sp
JOIN journeys AS j
ON sp.id = j.spaceship_id
JOIN spaceports AS s
ON j.destination_spaceport_id = s.id
ORDER BY light_speed_rate DESC
LIMIT 1;

/*10.Extract spaceships with pilots younger than 30 years*/
SELECT s.name, s.manufacturer
FROM colonists c
JOIN travel_cards tc
ON tc.colonist_id = c.id
JOIN journeys j
on tc.journey_id = j.id
JOIN spaceships s
on j.spaceship_id = s.id
WHERE year(c.birth_date) > year(DATE_SUB('2019-01-01', INTERVAL 30 YEAR)) and tc.job_during_journey = 'Pilot'
ORDER BY s.name;

/*11.Extract all educational mission planets and spaceports*/
SELECT p.name planet_name, sp.name spaceport_name
FROM planets p
JOIN spaceports sp
on p.id = sp.planet_id
JOIN journeys j on sp.id = j.destination_spaceport_id
WHERE j.purpose = 'Educational'
ORDER BY spaceport_name DESC ;

/*12. Extract all planets and their journey count*/
SELECT pl.planet_name, count(pl.planet_name) AS journeys_count
FROM (
        SELECT p.name planet_name
        FROM planets p
        JOIN spaceports sp
        on p.id = sp.planet_id
        JOIN journeys j
        on sp.id = j.destination_spaceport_id
     ) AS pl
GROUP BY planet_name
ORDER BY journeys_count DESC, planet_name;

/*13.Extract the shortest journey*/
SELECT j.id, p.`name` AS planet_name, s.`name` AS spaceport_name, j.purpose AS journey_purpose
FROM journeys AS j
JOIN spaceports AS s
ON j.destination_spaceport_id = s.id
JOIN planets AS p
ON s.planet_id = p.id
ORDER BY DATEDIFF(j.journey_end, j.journey_start) ASC
LIMIT 1;

/*14.Extract the less popular job*/

SELECT tc.job_during_journey
FROM travel_cards  AS tc
WHERE tc.journey_id =  (
  SELECT j.id
  FROM journeys AS  j
  ORDER BY DATEDIFF(j.journey_end, j.journey_start) DESC
  LIMIT 1
)
GROUP BY tc.job_during_journey
ORDER BY count(tc.job_during_journey)
LIMIT 1;

/*15. Get colonists count*/
DELIMITER $$                                             
CREATE FUNCTION udf_count_colonists_by_destination_planet (planet_name VARCHAR (30))  
RETURNS INT
BEGIN
   DECLARE result INTEGER;
SET result := (
SELECT count(tc.colonist_id) AS count
FROM travel_cards AS tc
JOIN journeys AS j
ON tc.journey_id = j.id
JOIN spaceports AS sp
ON j.destination_spaceport_id = sp.id
JOIN planets AS pl
ON sp.planet_id = pl.id
WHERE pl.`name` = planet_name);

RETURN result;
END $$

SELECT p.`name`, udf_count_colonists_by_destination_planet('Otroyphus') AS count
FROM planets AS p
WHERE p.`name` = 'Otroyphus';

/*16. Modify spaceship*/
DELIMITER $$
CREATE PROCEDURE udp_modify_spaceship_light_speed_rate(spaceship_name VARCHAR(50), light_speed_rate_increse INT(11))
  BEGIN
    IF (SELECT count(ss.`name`) FROM spaceships AS ss 
    WHERE ss.`name` = spaceship_name > 0) THEN
      UPDATE spaceships ss
        SET ss.light_speed_rate = ss.light_speed_rate + light_speed_rate_increse
        WHERE ss.`name` = spaceship_name;
    ELSE
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Spaceship you are trying to modify does not exists.';
      ROLLBACK;
    END IF;
  END$$
  
  CALL udp_modify_spaceship_light_speed_rate2('NaPesho koraba', 1914);
  
 
