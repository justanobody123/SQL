USE PD_311_DDL;
GO
--SELECT COUNT(student_id) AS 'Количество студентов'
--FROM Students;

--SELECT
--		group_name AS 'Группа',
--		COUNT(student_id) AS 'Количество студентов'
--FROM Students, Groups
--WHERE [group] = group_id
--GROUP BY group_name
--ORDER BY 'Количество студентов';

SELECT
		[Направление обучения] = direction_name,
		[Количество студентов] = COUNT(student_id)
FROM	Students, Groups, Directions
WHERE [group] = group_id AND direction = direction_id
GROUP BY direction_name;