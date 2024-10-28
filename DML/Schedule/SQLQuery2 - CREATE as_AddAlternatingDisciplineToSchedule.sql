USE PD_311_DDL;
GO

ALTER PROCEDURE sp_AddAlternatingDisciplineToSchedule
@group_name			NVARCHAR(50),
@discipline_name	NVARCHAR(256),
@start_date			DATE,
@start_time			TIME,
@teacher_last_name	NVARCHAR(150),
@constant_day		INT,
@alternate_day		INT
AS
BEGIN
		DECLARE @group				AS INT = (SELECT group_id FROM Groups WHERE group_name = @group_name)
		DECLARE @discipline			AS SMALLINT = (SELECT discipline_id FROM Disciplines WHERE discipline_name LIKE @discipline_name)
		DECLARE @date				AS DATE = @start_date
		DECLARE @teacher AS INT =	(SELECT teacher_id FROM Teachers WHERE @teacher_last_name = last_name)
		DECLARE @number_of_lessons	AS SMALLINT = (SELECT number_of_lessons FROM Disciplines WHERE discipline_name LIKE @discipline_name)
		DECLARE @lesson_number		AS SMALLINT = 0
		DECLARE @alternate_present	AS BIT = 0;
		DECLARE @ca_interval		AS INT = ABS(@constant_day - @alternate_day)
		DECLARE @date_correction	AS INT


		PRINT (@group)
		PRINT(@discipline)
		PRINT(@number_of_lessons)
		PRINT(@date)
		PRINT(@teacher)
		PRINT(@ca_interval)

		DECLARE @prelast_date AS DATE
		--Подгонка текущей даты к нужному дню недели.
		WHILE (DATEPART(WEEKDAY, @date) != @constant_day AND DATEPART(WEEKDAY, @date) != @alternate_day)
		BEGIN
				SET @date = DATEADD(DAY, 1, @date);
		END
		WHILE @lesson_number < @number_of_lessons
		BEGIN
				--PRINT(@lesson_number)
				--PRINT(@date)
				--PRINT(DATENAME(WEEKDAY, @date))
				--IF(DATEPART(WEEKDAY, @date) = @constant_day)
				--BEGIN
				--		IF(@constant_day < @alternate_day)
				--		BEGIN
				--				SET @prelast_date = (SELECT MAX([date]) FROM Schedule WHERE [date] < @date)
				--				SET @date = DATEADD(DAY, IIF(DATEPART(WEEKDAY, @prelast_date) = @constant_day, @ca_interval, 7), @date)
				--		END
				--		ELSE
				--		BEGIN
				--			SET @prelast_date = (SELECT MAX([date]) FROM Schedule WHERE [date] < @date AND DATEPART(WEEKDAY, [date]) = @alternate_day)
				--			SET @date = DATEADD(DAY, IIF(DATEDIFF(DAY, @prelast_date, @date) > 7, 7 - @ca_interval, 7), @date);
				--		END
				--		--SET @date =  DATEADD(DAY, @ca_interval, @date);
				--		--SET @alternate_present = 0
				--END
				--ELSE
				--BEGIN
				--		SET @date = DATEADD(DAY, 7, @date);
				--		SET @alternate_present = 1
				--END
				--SET @lesson_number = @lesson_number + 2;

				
				--Если день недели постоянный, то проверяем, было ли занятие по этой дисциплине 7 - ABS(constant - alternate) дней назад.
					--Если занятие было, меняем дату на неделю. Если занятия не было, меняем дату на 2 дня.
				--Инсерт пар
				--Автоинкремент +2
				--Коррекция даты
				PRINT 'Current day = ' + DATENAME(WEEKDAY, @date)
				IF (DATEPART(WEEKDAY, @date) = @constant_day)
				BEGIN
						PRINT DATEADD(DAY, -(7 - ABS(@constant_day - @alternate_day)), @date)
						IF EXISTS (SELECT 1 FROM Schedule WHERE discipline = @discipline AND [date] = DATEADD(DAY, -(7 - ABS(@constant_day - @alternate_day)), @date))
						BEGIN
								PRINT 'TRUE'
								SET @date_correction = 7;
								SET @alternate_present = 0;
						END
						ELSE
						BEGIN
								PRINT 'FALSE'
								SET @date_correction = ABS(@constant_day - @alternate_day);
								SET @alternate_present = 1;
						END
				END
				ELSE IF (DATEPART(WEEKDAY, @date) = @alternate_day AND @alternate_present = 1)
				BEGIN
						SET @date_correction = 7 - ABS(@constant_day - @alternate_day);
				END
				IF NOT EXISTS(SELECT 1 FROM Schedule WHERE @date = [date] AND @start_time = [time] AND @group = [group])
				BEGIN
						PRINT FORMATMESSAGE('%i %i %s %s %i %s %i', @discipline, @teacher, CAST(@date AS NVARCHAR(50)), CAST(@start_time AS NVARCHAR(50)), @group, DATENAME(WEEKDAY, @date), CASE
																								WHEN DATEDIFF(DAY, @date, GETDATE()) > 0
																								OR (DATEDIFF(DAY, @date, GETDATE()) = 0 AND DATEDIFF(MINUTE, @start_time, GETDATE()) >= 0) THEN 1
																								ELSE 0
																								END);
						INSERT 
						Schedule	([date], [time], [group], discipline, teacher, spent)
						VALUES		(@date, @start_time, @group, @discipline, @teacher, IIF(@date < GETDATE(), 1, 0))
						PRINT FORMATMESSAGE('%i %i %s %s %i %s %i', @discipline, @teacher, CAST(@date AS NVARCHAR(50)), CAST(DATEADD(MINUTE, 90, @start_time) AS NVARCHAR(50)), @group, DATENAME(WEEKDAY, @date), CASE
																												WHEN DATEDIFF(DAY, @date, GETDATE()) > 0
																												OR (DATEDIFF(DAY, @date, GETDATE()) = 0 AND DATEDIFF(MINUTE, DATEADD(MINUTE, 90, @start_time), GETDATE()) >= 0) THEN 1
																												ELSE 0
																												END);

						INSERT 
						Schedule	([date], [time], [group], discipline, teacher, spent)
						VALUES		(@date, DATEADD(MINUTE, 90, @start_time), @group, @discipline, @teacher, IIF(@date < GETDATE(), 1, 0))
						SET @lesson_number = @lesson_number + 2
				END
				SET @date = DATEADD(DAY, @date_correction, @date)
		END

END