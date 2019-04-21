USE `db_course_lesson_3`;

-- 1. Создать VIEW на основе запросов, которые вы сделали в ДЗ к уроку 3.
CREATE VIEW `average_salary` AS
SELECT `departments`.`name`, AVG(`salary`) AS 'average salary' FROM  `staff`
	LEFT JOIN `departments`
	ON `staff`.`department_id` = `departments`.`id`
	GROUP BY `department_id`;
-- -----------------------------------------------------------------------
CREATE VIEW `max_salary` AS
SELECT `name`, `lastname`, `salary` FROM `staff`
	WHERE `salary` = (SELECT MAX(`salary`) FROM `staff`);
-- -----------------------------------------------------------------------
CREATE VIEW `department_list` AS
SELECT `departments`.`name`, 
		COUNT(*) AS 'employees number', 
		SUM(`salary`) AS 'total salary' 
		FROM `staff`
	LEFT JOIN `departments`
	ON `staff`.`department_id` = `departments`.`id`
	GROUP BY `department_id`;


-- 2. Создать функцию, которая найдет менеджера по имени и фамилии.
delimiter //

CREATE PROCEDURE `employee_search` (first_name VARCHAR(25), surname VARCHAR(30), position_name VARCHAR(40))
BEGIN
	SELECT 
		`staff`.`name`, 
        `staff`.`lastname`, 
        `departments`.`name` AS `department`, 
        `positions`.`name` AS `position` 
	FROM `staff` 
    LEFT JOIN `departments` ON `staff`.`department_id` = `departments`.`id`
    LEFT JOIN `positions` ON `staff`.`position_id` = `positions`.`id`
    WHERE `staff`.`name` = first_name AND 
		`staff`.`lastname` = surname AND 
		`positions`.`name` = position_name;
END//

delimiter ;

-- проверка работы созданной процедуры
CALL `employee_search` ('Samuel', 'Kolt', 'Advertising manager');

-- 3. Создать триггер, который при добавлении нового сотрудника будет выплачивать ему вступительный бонус, занося запись об этом в таблицу salary.
-- создаем таблицу зарплат
CREATE TABLE IF NOT EXISTS `salaries` (
	`id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `employee_id` INT NOT NULL,
    `salary` FLOAT(11,2) DEFAULT 0
);

-- создаем триггер
CREATE TRIGGER `add_entrance_bonus`
	AFTER INSERT ON `staff`
	FOR EACH ROW
	INSERT INTO `salaries` (`employee_id`, bonus) VALUES (NEW.`id`, NEW.`salary`);

-- проверка работы триггера
INSERT INTO `staff` (`name`, `lastname`, `department_id`, `position_id`, `salary`) 
	VALUES ('Donald', 'Trump', 2, 2, 100000);
