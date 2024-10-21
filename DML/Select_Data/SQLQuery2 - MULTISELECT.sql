USE PD_311_DDL;
GO

SELECT
[Ф.И.О] = FORMATMESSAGE('%s %s %s', last_name, first_name, middle_name),
--[Группа] = group_name,
[Дисциплина] = discipline_name
FROM Teachers, Disciplines, DisciplinesTeachers
WHERE teacher = teacher_id 
AND discipline = discipline_id 
AND (discipline_name LIKE '%SQL%'
OR discipline_name LIKE '%Windows%')
--ORDER BY last_name ASC