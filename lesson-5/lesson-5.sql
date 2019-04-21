# Сделать транзакцию, которая найдет сотрудника с минимальной зарплатой, переведет его в
# отдел с id = 1 и увеличит его зарплату на четверть.

BEGIN;
# На случай, если сотрудников несколько, создаю временную таблицу
# и записываю в нее id найденных сотрудников.
DROP TEMPORARY TABLE IF EXISTS `temp`;
CREATE TEMPORARY TABLE `temp`
    SELECT `id` FROM `staff` WHERE `salary` = (SELECT MIN(`salary`) FROM `staff`);
UPDATE `staff` SET `department_id` = 1, `salary` = `salary` * 1.25
WHERE `id` IN (SELECT `id` FROM `temp`);
COMMIT;

-- ------------------------------------------------------------------------------------------
# Kate Bishop вышла замуж. Сделать транзакцию, в которой ее фамилия будет изменена на Parker,
# а к зарплате будет добавлен бонус на медовый месяц.

BEGIN;
SET @kate_id = (SELECT `id` FROM `staff` WHERE `name` = 'Kate' AND `lastname` = 'Bishop');
UPDATE `staff` SET `lastname` = 'Parker' WHERE `id` = @kate_id;
INSERT INTO `salaries` (`employee_id`, `bonus`, `comment`)
VALUES (@kate_id, 10000, 'Honeymoon');
COMMIT;

-- -------------------------------------------------------------------------------------------

# Для демонстрации команды EXPLAIN и использования консоли
# копирую то, что выдал терминал (из первой транзакции):

mysql> SELECT `id` FROM `staff` WHERE `salary` = (SELECT MIN(`salary`) FROM `staff`);
+----+
| id |
+----+
|  4 |
|  5 |
+----+
2 rows in set (0.00 sec)

mysql> EXPLAIN SELECT `id` FROM `staff` WHERE `salary` = (SELECT MIN(`salary`) FROM `staff`);
+----+-------------+-------+------------+------+---------------+------+---------+------+------+----------+-------------+
| id | select_type | table | partitions | type | possible_keys | key  | key_len | ref  | rows | filtered | Extra       |
+----+-------------+-------+------------+------+---------------+------+---------+------+------+----------+-------------+
|  1 | PRIMARY     | staff | NULL       | ALL  | NULL          | NULL | NULL    | NULL |    5 |    20.00 | Using where |
|  2 | SUBQUERY    | staff | NULL       | ALL  | NULL          | NULL | NULL    | NULL |    5 |   100.00 | NULL        |
+----+-------------+-------+------------+------+---------------+------+---------+------+------+----------+-------------+
2 rows in set, 1 warning (0.00 sec)

-- ---------------------------------------------------------------------------------------------------------------------

mysql> UPDATE `staff` SET `department_id` = 1, `salary` = `salary` * 1.25 IN (4, 5);
Query OK, 6 rows affected (0.00 sec)
Rows matched: 6  Changed: 6  Warnings: 0

mysql> EXPLAIN UPDATE `staff` SET `department_id` = 1, `salary` = `salary` * 1.25 IN (4, 5);
+----+-------------+-------+------------+-------+---------------+---------+---------+------+------+----------+-------+
| id | select_type | table | partitions | type  | possible_keys | key     | key_len | ref  | rows | filtered | Extra |
+----+-------------+-------+------------+-------+---------------+---------+---------+------+------+----------+-------+
|  1 | UPDATE      | staff | NULL       | index | NULL          | PRIMARY | 4       | NULL |    5 |   100.00 | NULL  |
+----+-------------+-------+------------+-------+---------------+---------+---------+------+------+----------+-------+
1 row in set (0.00 sec)


