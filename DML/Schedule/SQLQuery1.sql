USE PD_311_DDL;
GO

DECLARE @start_date AS DATE = '2024-10-02'
DECLARE @date AS DATE = @start_date
DECLARE @time AS TIME = '13:30'
DECLARE @group AS INT = (SELECT group_id FROM Groups WHERE group_name = 'PD_321');
DECLARE @discipline AS SMALLINT = (SELECT discipline_id FROM Disciplines WHERE discipline_name LIKE '%MS_SQL Server%');
DECLARE @number_of_lessons AS SMALLINT = (SELECT number_of_lessons FROM Disciplines WHERE discipline_name LIKE 'MA_SQL Server');
DECLARE @teacher AS INT = (SELECT teacher_id FROM Teachers WHERE last_name = 'Покидюк');
PRINT (@group)
PRINT (@discipline)
PRINT @teacher

DECLARE @lesson AS SMALLINT = 0;
WHILE @lesson < @number_of_lessons
BEGIN
	PRINT (FORMATMESSAGE('%s %s', 'Дата:\t', CAST(@date AS NVARCHAR(50))));
	PRINT (FORMATMESSAGE('%s %s', 'Время:\t', CAST(@time AS NVARCHAR(50))));
	PRINT (FORMATMESSAGE('%s %i', 'Урок №:\t', @lesson));
	SET @lesson = @lesson + 1;
END
--INSERT Schedule
--([date], [time], [group], discipline, teacher, spent)
--VALUES ('2024-10-21', '13:30', )

SELECT * FROM Teachers;
SELECT * FROM Disciplines;