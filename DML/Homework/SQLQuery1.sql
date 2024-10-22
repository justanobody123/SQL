--1. Выбрать все дисциплины, зависящие от Процедурного программирования на C++;
USE PD_311_DDL;
GO

SELECT
[Зависимые дисциплины] = discipline_name
FROM Disciplines, DependentDisciplines
WHERE target_discipline = (SELECT discipline_id FROM Disciplines WHERE discipline_name LIKE '%Процедурное%') AND required_discipline = discipline_id;