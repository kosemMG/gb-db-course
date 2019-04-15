-- База данных «Страны и города мира»:

USE `db_course_lesson_1`;

-- 1. Сделать запрос, в котором мы выберем все данные о городе – регион, страна.
SELECT `_cities`.`title`, `_regions`.`title`, `_countries`.`title` FROM `_cities`
	LEFT JOIN `_regions`
	ON `_cities`.`region_id` = `_regions`.`id`
	LEFT JOIN `_countries` 
	ON `_cities`.`country_id` = `_countries`.`id`;

-- 2. Выбрать все города Шотландии.
SELECT `title` FROM `_cities` WHERE id = 
	(SELECT `id` FROM `_regions` WHERE `title` = 'Scotland');


-- База данных «Сотрудники»:

-- Создаем схему db_course_lesson_3.
CREATE DATABASE IF NOT EXISTS `db_course_lesson_3` 
DEFAULT CHARSET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE `db_course_lesson_3`;

CREATE TABLE IF NOT EXISTS `departments` (
`id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
`name` VARCHAR(40) NOT NULL,
`count` INT DEFAULT 0
);

CREATE TABLE IF NOT EXISTS `positions` (
`id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
`name` VARCHAR(40) NOT NULL
);

CREATE TABLE IF NOT EXISTS `staff` (
`id` INT NOT NULL AUTO_INCREMENT,
`name` VARCHAR(25) NOT NULL,
`lastname` VARCHAR(30) NOT NULL,
`department_id` INT,
`position_id` INT,
`salary` FLOAT(11,2),
PRIMARY KEY (`id`)
);

-- Заполняем таблицу departments.
INSERT INTO `departments` (`name`) VALUES 
('Accounting'), 
('IT'),
('Advertising'),
('Marketing');

-- Заполняем таблицу positions.
INSERT INTO `positions` (`name`) VALUES 
('Accountant'), 
('Programmer'),
('Advertising manager'),
('Marketer');

-- Заполняем таблицу staff.
INSERT INTO `staff` (`name`, `lastname`, `department_id`, `position_id`, `salary`) VALUES 
('John', 'Doe', 1, 1, 55000), 
('Dean', 'Winchester', 2, 2, 65000),
('Sam', 'Winchester', 2, 2, 60000),
('Samuel', 'Kolt', 3, 3, 40000),
('Kate', 'Bishop', 1, 1, 40000),
('Donald', 'Trump', 2, 2, 100000);

-- 1. Выбрать среднюю зарплату по отделам.
SELECT `departments`.`name`, AVG(`salary`) AS 'Average salary' FROM  `staff`
	LEFT JOIN `departments`
	ON `staff`.`department_id` = `departments`.`id`
	GROUP BY `department_id`;

-- 2. Выбрать максимальную зарплату у сотрудника.
SELECT `name`, `lastname`, `salary` FROM `staff`
	WHERE `salary` = (SELECT MAX(`salary`) FROM `staff`);

-- 3. Удалить одного сотрудника, у которого максимальная зарплата.
-- Название таблицы staff пришлось заменить на employees из-за ошибки 1093 (нагуглил).
DELETE FROM `staff` WHERE `id` = 
	(SELECT `id` FROM (SELECT * FROM `staff`)  AS `employees` WHERE `salary` = 
	(SELECT MAX(`salary`) FROM (SELECT * FROM `staff`)  AS `employees`));

-- 4. Посчитать количество сотрудников во всех отделах.
SELECT COUNT(*) AS 'Employees number' FROM `staff`;

-- 5. Найти количество сотрудников в отделах и посмотреть, сколько всего денег получает отдел.
SELECT `departments`.`name`, 
		COUNT(*) AS 'employees number', 
		SUM(`salary`) AS 'total salary' 
		FROM `staff`
	LEFT JOIN `departments`
	ON `staff`.`department_id` = `departments`.`id`
	GROUP BY `department_id`;

