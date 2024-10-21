USE PD_311_DDL;
GO

SELECT
[Требуемая дисциплина] = discipline_name
FROM Disciplines, RequiredDisciplines
WHERE target_discipline = (SELECT discipline_id FROM Disciplines WHERE discipline_name LIKE '%ADO.NET%') AND dependent_discipline = discipline_id;