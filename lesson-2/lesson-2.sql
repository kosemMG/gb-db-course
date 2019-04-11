USE `db_course_lesson_1`;

-- Удаляю предыдущие внешние ключи, которые мешают изменить столбцы.
ALTER TABLE `regions` 
	DROP FOREIGN KEY `fk_country_region`,
	DROP INDEX `fk_country_region_idx` ;

ALTER TABLE `countries` 
	RENAME TO `_countries`,
	CHANGE COLUMN `id` `id` INT NOT NULL AUTO_INCREMENT,
    CHANGE COLUMN `name` `title` VARCHAR(150) NOT NULL,
    DROP COLUMN `population`;

CREATE INDEX `countries_title_index` ON `_countries`(`title`);

-- Удаляю предыдущие внешние ключи, которые мешают изменить столбцы.
ALTER TABLE `cities` 
	DROP FOREIGN KEY `fk_region_cities`, 
	DROP INDEX `fk_region_cities_idx` ;

ALTER TABLE `regions`
	RENAME TO `_regions`,
	CHANGE COLUMN `id` `id` INT NOT NULL AUTO_INCREMENT,
	CHANGE COLUMN `country_id` `country_id` INT NOT NULL,
	ADD CONSTRAINT `fk_country_region` FOREIGN KEY (`country_id`)
		REFERENCES `_countries`(`id`)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
	CHANGE COLUMN `name` `title` VARCHAR(150) NOT NULL,
	DROP COLUMN `population`;

CREATE INDEX `regions_title_index` ON `_regions`(`title`);
    
ALTER TABLE `cities` 
	RENAME TO `_cities`,
	CHANGE COLUMN `id` `id` INT NOT NULL AUTO_INCREMENT,
    ADD COLUMN `country_id` INT NOT NULL AFTER `id`,
    ADD COLUMN `important` TINYINT(1) NOT NULL AFTER `country_id`,
    CHANGE COLUMN `region_id` `region_id` INT NOT NULL,
    ADD CONSTRAINT `fk_region_city` FOREIGN KEY (`region_id`)
		REFERENCES `_regions`(`id`)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CHANGE COLUMN `name` `title` VARCHAR(150) NOT NULL,
    DROP COLUMN `population`;

ALTER TABLE `_cities`
	ADD CONSTRAINT `fk_country_city` FOREIGN KEY (`country_id`)
		REFERENCES `_countries`(`id`)
        ON UPDATE CASCADE
        ON DELETE RESTRICT;

CREATE INDEX `cities_title_index` ON `_cities`(`title`);
