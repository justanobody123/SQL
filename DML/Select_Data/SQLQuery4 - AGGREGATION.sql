USE PD_311_DDL;
GO
--SELECT COUNT(student_id) AS '���������� ���������'
--FROM Students;

--SELECT
--		group_name AS '������',
--		COUNT(student_id) AS '���������� ���������'
--FROM Students, Groups
--WHERE [group] = group_id
--GROUP BY group_name
--ORDER BY '���������� ���������';

SELECT
		[����������� ��������] = direction_name,
		[���������� ���������] = COUNT(student_id)
FROM	Students, Groups, Directions
WHERE [group] = group_id AND direction = direction_id
GROUP BY direction_name;