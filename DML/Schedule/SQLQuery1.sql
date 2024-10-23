USE PD_311_DDL;
GO

DECLARE @start_date			AS DATE =		'2024-10-02'
DECLARE @date				AS DATE =		@start_date
DECLARE @first_class_time 	AS TIME =		'13:30'
DECLARE @second_class_time 	AS TIME =		'15:00'
DECLARE @group				AS INT =		(SELECT group_id FROM Groups WHERE group_name = 'PD_321');
DECLARE @discipline			AS SMALLINT =	(SELECT discipline_id FROM Disciplines WHERE discipline_name LIKE '%MS_SQL Server%');
DECLARE @lesson AS SMALLINT = 0;
DECLARE @number_of_lessons	AS SMALLINT =	(SELECT number_of_lessons FROM Disciplines WHERE discipline_name LIKE '%MS_SQL Server');
DECLARE @teacher			AS INT =		(SELECT teacher_id FROM Teachers WHERE last_name = 'Покидюк');

WHILE @lesson < @number_of_lessons
BEGIN
	IF @lesson < @number_of_lessons
	BEGIN
		--PRINT FORMATMESSAGE('%i. %s %s %i %i %i %i', @lesson, CAST(@date AS NVARCHAR(50)), CAST(@first_class_time AS NVARCHAR(50)), @group, @discipline, @teacher, CASE
																																										--WHEN DATEDIFF(DAY, @date, GETDATE()) > 0
																																										--OR (DATEDIFF(DAY, @date, GETDATE()) = 0 AND DATEDIFF(MINUTE, @first_class_time, GETDATE()) >= 0) THEN 1
																																										--ELSE 0
																																										--END)
		INSERT Schedule([date], [time], [group], discipline, teacher, spent)
		VALUES (@date, @first_class_time, @group, @discipline, @teacher, CASE
																				WHEN DATEDIFF(DAY, @date, GETDATE()) > 0
																				OR (DATEDIFF(DAY, @date, GETDATE()) = 0 AND DATEDIFF(MINUTE, @first_class_time, GETDATE()) >= 0) THEN 1
																				ELSE 0
																				END)
	END
	SET @lesson = @lesson + 1;
	IF @lesson < @number_of_lessons
	BEGIN
		--PRINT FORMATMESSAGE('%i. %s %s %i %i %i %i', @lesson, CAST(@date AS NVARCHAR(50)), CAST(@second_class_time AS NVARCHAR(50)), @group, @discipline, @teacher, CASE
																																										--WHEN DATEDIFF(DAY, @date, GETDATE()) > 0
																																										--OR (DATEDIFF(DAY, @date, GETDATE()) = 0 AND DATEDIFF(MINUTE, @second_class_time, GETDATE()) >= 0) THEN 1
																																										--ELSE 0
																																										--END)
		INSERT Schedule([date], [time], [group], discipline, teacher, spent)
		VALUES (@date, @second_class_time, @group, @discipline, @teacher, CASE
																				WHEN DATEDIFF(DAY, @date, GETDATE()) > 0
																				OR (DATEDIFF(DAY, @date, GETDATE()) = 0 AND DATEDIFF(MINUTE, @second_class_time, GETDATE()) >= 0) THEN 1
																				ELSE 0
																				END)

	END
	SET @lesson = @lesson + 1;
	SET @date = DATEADD(DAY, CASE 
									WHEN DATEPART(WEEKDAY, @date) = 2 THEN 2  --Понедельник -> Среда
									WHEN DATEPART(WEEKDAY, @date) = 4 THEN 2  --Среда -> Пятница
									WHEN DATEPART(WEEKDAY, @date) = 6 THEN 3  --Пятница -> Понедельник
									END, @date)
END