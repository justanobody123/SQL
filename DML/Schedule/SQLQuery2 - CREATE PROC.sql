USE PD_311_DDL;
GO

--PrintStudent
----------------------------------------------
--CREATE PROCEDURE PrintStudent
--AS
--BEGIN
--	SELECT
--	[�.�.�]		= FORMATMESSAGE('%s %s %s', last_name, first_name, middle_name),
--	[�������]	= DATEDIFF(DAY, birth_date, GETDATE()) / 365,
--	[������]	= group_name
--	FROM Students, Groups
--	WHERE [group] = group_id;
--END

--PrintSchedule
CREATE PROCEDURE PrintSchedule AS
BEGIN
SELECT
	[�������] =					discipline_name,
	[���� �������] =			[date],
	[����� ������ �������] =	[time],
	[���� ������] =				CASE
									WHEN DATEPART(WEEKDAY, [date]) = 2 THEN '�����������'
									WHEN DATEPART(WEEKDAY, [date]) = 4 THEN '�����'
									WHEN DATEPART(WEEKDAY, [date]) = 6 THEN '�������'
									END,
	[������ �������] =			CASE
									WHEN spent = 1 THEN '���������'
									WHEN spent = 0 THEN '�������������'
									END,
	[�������������] =			last_name + ' ' + first_name + ' ' + middle_name
FROM Schedule, Groups, Disciplines, Teachers
END