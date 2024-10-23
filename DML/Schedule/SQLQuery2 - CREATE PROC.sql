USE PD_311_DDL;
GO

--PrintStudent
----------------------------------------------
--CREATE PROCEDURE PrintStudent
--AS
--BEGIN
--	SELECT
--	[Ф.И.О]		= FORMATMESSAGE('%s %s %s', last_name, first_name, middle_name),
--	[Возраст]	= DATEDIFF(DAY, birth_date, GETDATE()) / 365,
--	[Группа]	= group_name
--	FROM Students, Groups
--	WHERE [group] = group_id;
--END

--PrintSchedule
CREATE PROCEDURE PrintSchedule AS
BEGIN
SELECT
	[Предмет] =					discipline_name,
	[Дата занятия] =			[date],
	[Время начала занятия] =	[time],
	[День недели] =				CASE
									WHEN DATEPART(WEEKDAY, [date]) = 2 THEN 'Понедельник'
									WHEN DATEPART(WEEKDAY, [date]) = 4 THEN 'Среда'
									WHEN DATEPART(WEEKDAY, [date]) = 6 THEN 'Пятница'
									END,
	[Статус занятия] =			CASE
									WHEN spent = 1 THEN 'Проведено'
									WHEN spent = 0 THEN 'Запланировано'
									END,
	[Преподаватель] =			last_name + ' ' + first_name + ' ' + middle_name
FROM Schedule, Groups, Disciplines, Teachers
END