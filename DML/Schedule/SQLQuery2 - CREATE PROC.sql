USE PD_311_DDL;
GO

--PrintStudent
----------------------------------------------
--CREATE PROCEDURE PrintStudents
--AS
--BEGIN
--	SELECT
--			[Ф.И.О]	=		FORMATMESSAGE('%s %s %s', last_name, first_name, middle_name),
--			[Возраст] =		DATEDIFF(DAY, birth_date, GETDATE()) / 365,
--			[Группа] =		group_name
--	FROM Students, Groups
--	WHERE [group] =			group_id;
--END

--GO

--PrintSchedule
--CREATE PROCEDURE PrintSchedule AS
--BEGIN
--SELECT
--	[Дата занятия] =			[date],
--	[Время начала занятия] =	[time],
--	[День недели] =				DATENAME(WEEKDAY, [date]),
--	[Группа] =					group_name,
--	[Предмет] =					discipline_name,
--	[Преподаватель] =			FORMATMESSAGE('%s %s %s', last_name, first_name, middle_name),
--	[Статус занятия] =			IIF(spent=1, 'Проведено', 'Запланировано')
--FROM Schedule, Groups, Disciplines, Teachers
--	WHERE	[group]=group_id
--	AND		discipline=discipline_id
--	AND		teacher=teacher_id
--END

--GO

--PrintScheduleForGroup
--CREATE PROCEDURE PrintScheduleForGroup
--@group NVARCHAR(50)
--AS
--BEGIN
--	SELECT
--			[Дата занятия] =			[date],
--			[Время начала занятия] =	[time],
--			[День недели] =				DATENAME(WEEKDAY, [date]),
--			[Группа] =					group_name,
--			[Предмет] =					discipline_name,
--			[Преподаватель] =			FORMATMESSAGE('%s %s %s', last_name, first_name, middle_name),
--			[Статус занятия] =			IIF(spent=1, 'Проведено', 'Запланировано')
--FROM Schedule, Disciplines, Teachers, Groups
--WHERE		[group]=group_id
--	AND		discipline=discipline_id
--	AND		teacher=teacher_id
--	AND		group_name=@group
--END

--GO

--ALTER PROC sp_AddScheduleForStacionarGroup
--@start_date			DATE,
--@group_time			TIME,
--@group_name			NVARCHAR(50),
--@discipline_name	NVARCHAR(256),
--@teacher_last_name	NVARCHAR(150)
--AS
--BEGIN
--		DECLARE @date		AS	DATE	= @start_date;
--		DECLARE @time		AS	TIME	= @group_time;
--		DECLARE @group		AS	INT		= (SELECT group_id FROM Groups WHERE group_name=@group_name);
--		DECLARE @discipline	AS	SMALLINT = (SELECT discipline_id FROM Disciplines WHERE discipline_name LIKE @discipline_name);
--		DECLARE @number_of_lessons AS SMALLINT = (SELECT number_of_lessons FROM Disciplines WHERE discipline_id=@discipline);
--		DECLARE @teacher	AS	INT		= (SELECT teacher_id FROM Teachers WHERE last_name=@teacher_last_name);
--		DECLARE @lesson AS SMALLINT = 0;
--		WHILE @lesson < @number_of_lessons
--		BEGIN
--		IF NOT EXISTS (SELECT 1 FROM Schedule WHERE @date = [date] AND @time = [time] AND @group = [group])
--		BEGIN
--			INSERT 
--			Schedule	([date], [time], [group], discipline, teacher, spent)
--			VALUES		(@date, @time, @group, @discipline, @teacher, IIF(@date<GETDATE(), 1, 0))
--			SET @lesson = @lesson + 1;
--		END
--			IF @lesson < @number_of_lessons
--			BEGIN
--				IF NOT EXISTS (SELECT 1 FROM Schedule WHERE @date = [date] AND DATEADD(MINUTE, 90, @time) = [time] AND @group = [group])
--				BEGIN
--					INSERT 
--					Schedule	([date], [time], [group], discipline, teacher, spent)
--					VALUES		(@date, DATEADD(MINUTE, 90, @time), @group, @discipline, @teacher, IIF(@date < GETDATE(), 1, 0))
--					SET @lesson = @lesson + 1;
--				END
--			END
--			SET @date = DATEADD(DAY, IIF(DATEPART(WEEKDAY, @date)=6,3,2), @date);
--		END
--END
--GO
CREATE PROCEDURE sp_AddScheduleForBaseStacionar
@start_date						DATE,
@group_name						NVARCHAR(50),
@start_time						TIME,
@programming_teacher_last_name	NVARCHAR(256),
@hardware_teacher_last_name		NVARCHAR(256)

AS
BEGIN
		DECLARE @date							AS	DATE			= @start_date; 
		DECLARE @group							AS	INT				= (SELECT group_id FROM Groups WHERE group_name = @group_name);
		DECLARE @hardware_discipline			AS	SMALLINT		= (SELECT discipline_id FROM Disciplines WHERE discipline_name = 'Hardware-PC');
		DECLARE @programming_discipline			AS	SMALLINT		= (SELECT discipline_id FROM Disciplines WHERE discipline_name = 'Процедурное программирование на языке C++')
		DECLARE @system_administration			AS	SMALLINT		= (SELECT discipline_id FROM Disciplines WHERE discipline_name = 'Администрирование Window XP/7/8/10/11');
		DECLARE @hardware_lessons				AS	SMALLINT		= (SELECT number_of_lessons FROM Disciplines WHERE discipline_id = @hardware_discipline);
		DECLARE @programming_lessons			AS	SMALLINT		= (SELECT number_of_lessons FROM Disciplines WHERE discipline_id = @programming_discipline);
		DECLARE @system_administration_lessons	AS	SMALLINT		= (SELECT number_of_lessons FROM Disciplines WHERE discipline_id = @system_administration);
		DECLARE @programming_teacher			AS	INT				= (SELECT teacher_id FROM Teachers WHERE last_name = @programming_teacher_last_name);
		DECLARE @hardware_teacher				AS	INT				= (SELECT teacher_id FROM Teachers WHERE last_name = @hardware_teacher_last_name)
		DECLARE @lesson							AS	SMALLINT		= 0;
		DECLARE @change_discipline				AS	BIT				= 1;
		DECLARE @current_discipline				AS	SMALLINT		= 0;
		DECLARE @current_teacher				AS	INT				= 0;
		DECLARE @date_correction				AS	TINYINT			= 0;
		DECLARE @programming_counter			AS	SMALLINT		= 0;
		--Первый цикл с полным заполнением железа и частичным заполнением программирования
		WHILE @lesson < @hardware_lessons
		BEGIN
			IF (DATENAME(WEEKDAY, @date) = 'Monday' OR DATENAME(WEEKDAY, @date) = 'Tuesday')
			BEGIN
					SET @current_discipline = @hardware_discipline;
					SET @current_teacher = @hardware_teacher;
					IF NOT EXISTS(SELECT 1 FROM Schedule WHERE @date = [date] AND @start_time = [time] AND @group = [group])
					BEGIN
						SET @lesson = @lesson + 2;
					END
					SET @date_correction = 2;
			END
			ELSE IF (DATENAME(WEEKDAY, @date) = 'Wednesday' OR DATENAME(WEEKDAY, @date) = 'Thursday')
			BEGIN
					IF (@change_discipline = 1)
					BEGIN
							IF NOT EXISTS(SELECT 1 FROM Schedule WHERE @date = [date] AND @start_time = [time] AND @group = [group])
							BEGIN
								SET @current_discipline = @programming_discipline;
								SET @current_teacher = @programming_teacher;
								SET @change_discipline = 0;
								SET @programming_counter = @programming_counter + 2;
							END
					END
					ELSE
					BEGIN
							IF NOT EXISTS(SELECT 1 FROM Schedule WHERE @date = [date] AND @start_time = [time] AND @group = [group])
							BEGIN

								SET @lesson = @lesson + 2;
								SET @change_discipline = 1;
							END
					END
					SET @date_correction = 2;
			END
			ELSE IF (DATENAME(WEEKDAY, @date) = 'Friday' OR DATENAME(WEEKDAY, @date) = 'Saturday')
			BEGIN 	
				IF NOT EXISTS(SELECT 1 FROM Schedule WHERE @date = [date] AND @start_time = [time] AND @group = [group])
				BEGIN
					SET @current_discipline = @programming_discipline;
					SET @current_teacher = @programming_teacher;
					SET @programming_counter = @programming_counter + 2; 
				END
				SET @date_correction = 3;
			END
			--PRINT FORMATMESSAGE('%i %i %s %s %i %s %i', @current_discipline, @current_teacher, CAST(@date AS NVARCHAR(50)), CAST(@start_time AS NVARCHAR(50)), @group, DATENAME(WEEKDAY, @date), CASE
																					--WHEN DATEDIFF(DAY, @date, GETDATE()) > 0
																					--OR (DATEDIFF(DAY, @date, GETDATE()) = 0 AND DATEDIFF(MINUTE, @start_time, GETDATE()) >= 0) THEN 1
																					--ELSE 0
																					--END);
			IF NOT EXISTS(SELECT 1 FROM Schedule WHERE @date = [date] AND @start_time = [time] AND @group = [group])
			BEGIN
					--ИНСЕРТ
					INSERT 
					Schedule	([date], [time], [group], discipline, teacher, spent)
					VALUES		(@date, @start_time, @group, @current_discipline, @current_teacher, IIF(@date < GETDATE(), 1, 0))
					--PRINT('ПРОБЛЕМ НЕТ')
			END
			--PRINT FORMATMESSAGE('%i %i %s %s %i %s %i', @current_discipline, @current_teacher, CAST(@date AS NVARCHAR(50)), CAST(DATEADD(MINUTE, 90, @start_time) AS NVARCHAR(50)), @group, DATENAME(WEEKDAY, @date), CASE
																					--WHEN DATEDIFF(DAY, @date, GETDATE()) > 0
																					--OR (DATEDIFF(DAY, @date, GETDATE()) = 0 AND DATEDIFF(MINUTE, DATEADD(MINUTE, 90, @start_time), GETDATE()) >= 0) THEN 1
																					--ELSE 0
																					--END);
			IF NOT EXISTS(SELECT 1 FROM Schedule WHERE @date = [date] AND DATEADD(MINUTE, 90, @start_time) = [time] AND @group = [group])
			BEGIN
					--ИНСЕРТ
					INSERT 
					Schedule	([date], [time], [group], discipline, teacher, spent)
					VALUES		(@date, DATEADD(MINUTE, 90, @start_time), @group, @current_discipline, @current_teacher, IIF(@date < GETDATE(), 1, 0))
					--PRINT('ПРОБЛЕМ НЕТ')
			END
			SET @date = DATEADD(DAY, @date_correction, @date);
			--PRINT FORMATMESSAGE('%i железо, %i С++', @lesson, @programming_counter);
		END
		--ВТОРОЙ ЦИКЛ С ПОЛНЫМ ЗАПОЛНЕНИЕМ АДМИНИСТРИРОВАНИЯ И ЧАСТИЧНЫМ ЗАПОЛНЕНИЕМ ПРОГРАММИРОВАНИЯ
		WHILE @lesson < (@hardware_lessons + @system_administration_lessons)
		BEGIN
			IF (DATENAME(WEEKDAY, @date) = 'Monday' OR DATENAME(WEEKDAY, @date) = 'Tuesday')
				BEGIN
					IF NOT EXISTS(SELECT 1 FROM Schedule WHERE @date = [date] AND @start_time = [time] AND @group = [group])
					BEGIN
						SET @current_discipline = @system_administration;
						SET @current_teacher = @hardware_teacher;
						SET @lesson = @lesson + 2;
					END
					SET @date_correction = 2;
				END
				ELSE IF (DATENAME(WEEKDAY, @date) = 'Wednesday' OR DATENAME(WEEKDAY, @date) = 'Thursday')
				BEGIN
						IF (@change_discipline = 1)
						BEGIN
							IF NOT EXISTS(SELECT 1 FROM Schedule WHERE @date = [date] AND @start_time = [time] AND @group = [group])
							BEGIN
								SET @current_discipline = @programming_discipline;
								SET @current_teacher = @programming_teacher;
								SET @change_discipline = 0;
								SET @programming_counter = @programming_counter + 2;
							END
						END
						ELSE
						BEGIN
							IF NOT EXISTS(SELECT 1 FROM Schedule WHERE @date = [date] AND @start_time = [time] AND @group = [group])
							BEGIN
								SET @current_discipline = @system_administration;
								SET @current_teacher = @hardware_teacher;
								SET @lesson = @lesson + 2;
								SET @change_discipline = 1;
							END
						END
						SET @date_correction = 2;
				END
				ELSE IF (DATENAME(WEEKDAY, @date) = 'Friday' OR DATENAME(WEEKDAY, @date) = 'Saturday')
				BEGIN
					IF NOT EXISTS(SELECT 1 FROM Schedule WHERE @date = [date] AND @start_time = [time] AND @group = [group])
					BEGIN
						SET @current_discipline = @programming_discipline;
						SET @current_teacher = @programming_teacher;
						SET @programming_counter = @programming_counter + 2;
					END
					SET @date_correction = 3;
				END
				--PRINT FORMATMESSAGE('%i %i %s %s %i %s %i', @current_discipline, @current_teacher, CAST(@date AS NVARCHAR(50)), CAST(@start_time AS NVARCHAR(50)), @group, DATENAME(WEEKDAY, @date), CASE
																						--WHEN DATEDIFF(DAY, @date, GETDATE()) > 0
																						--OR (DATEDIFF(DAY, @date, GETDATE()) = 0 AND DATEDIFF(MINUTE, @start_time, GETDATE()) >= 0) THEN 1
																						--ELSE 0
																						--END);
				IF NOT EXISTS(SELECT 1 FROM Schedule WHERE @date = [date] AND @start_time = [time] AND @group = [group])
				BEGIN
						--ИНСЕРТ
						INSERT 
						Schedule	([date], [time], [group], discipline, teacher, spent)
						VALUES		(@date, @start_time, @group, @current_discipline, @current_teacher, IIF(@date < GETDATE(), 1, 0))
					
						--PRINT('ПРОБЛЕМ НЕТ')
				END
				--PRINT FORMATMESSAGE('%i %i %s %s %i %s %i', @current_discipline, @current_teacher, CAST(@date AS NVARCHAR(50)), CAST(DATEADD(MINUTE, 90, @start_time) AS NVARCHAR(50)), @group, DATENAME(WEEKDAY, @date), CASE
																						--WHEN DATEDIFF(DAY, @date, GETDATE()) > 0
																						--OR (DATEDIFF(DAY, @date, GETDATE()) = 0 AND DATEDIFF(MINUTE, DATEADD(MINUTE, 90, @start_time), GETDATE()) >= 0) THEN 1
																						--ELSE 0
																						--END);
				IF NOT EXISTS(SELECT 1 FROM Schedule WHERE @date = [date] AND DATEADD(MINUTE, 90, @start_time) = [time] AND @group = [group])
				BEGIN
						--ИНСЕРТ
						INSERT 
						Schedule	([date], [time], [group], discipline, teacher, spent)
						VALUES		(@date, DATEADD(MINUTE, 90, @start_time), @group, @current_discipline, @current_teacher, IIF(@date < GETDATE(), 1, 0))
					
						--PRINT('ПРОБЛЕМ НЕТ')
				END
				SET @date = DATEADD(DAY, @date_correction, @date);
				--PRINT FORMATMESSAGE('%i железо, %i С++', @lesson, @programming_counter);
		END
		--ТРЕТИЙ ЦИКЛ С ОСТАТКАМИ ПРОГРАММИРОВАНИЯ
		SET @current_discipline = @programming_discipline;
		SET @current_teacher = @programming_teacher;
		SET @lesson = @programming_counter;
		WHILE @lesson < @programming_lessons
		BEGIN
				--PRINT FORMATMESSAGE('%i %i %s %s %i %s %i', @current_discipline, @current_teacher, CAST(@date AS NVARCHAR(50)), CAST(@start_time AS NVARCHAR(50)), @group, DATENAME(WEEKDAY, @date), CASE
																						--WHEN DATEDIFF(DAY, @date, GETDATE()) > 0
																						--OR (DATEDIFF(DAY, @date, GETDATE()) = 0 AND DATEDIFF(MINUTE, @start_time, GETDATE()) >= 0) THEN 1
																						--ELSE 0
																						--END);
				IF NOT EXISTS(SELECT 1 FROM Schedule WHERE @date = [date] AND @start_time = [time] AND @group = [group])
				BEGIN
						--ИНСЕРТ
						INSERT 
						Schedule	([date], [time], [group], discipline, teacher, spent)
						VALUES		(@date, @start_time, @group, @current_discipline, @current_teacher, IIF(@date < GETDATE(), 1, 0))
					
						--PRINT('ПРОБЛЕМ НЕТ')
				END
				--PRINT FORMATMESSAGE('%i %i %s %s %i %s %i', @current_discipline, @current_teacher, CAST(@date AS NVARCHAR(50)), CAST(DATEADD(MINUTE, 90, @start_time) AS NVARCHAR(50)), @group, DATENAME(WEEKDAY, @date), CASE
																						--WHEN DATEDIFF(DAY, @date, GETDATE()) > 0
																						--OR (DATEDIFF(DAY, @date, GETDATE()) = 0 AND DATEDIFF(MINUTE, DATEADD(MINUTE, 90, @start_time), GETDATE()) >= 0) THEN 1
																						--ELSE 0
																						--END);
				IF NOT EXISTS(SELECT 1 FROM Schedule WHERE @date = [date] AND DATEADD(MINUTE, 90, @start_time) = [time] AND @group = [group])
				BEGIN
						--ИНСЕРТ
						INSERT 
						Schedule	([date], [time], [group], discipline, teacher, spent)
						VALUES		(@date, DATEADD(MINUTE, 90, @start_time), @group, @current_discipline, @current_teacher, IIF(@date < GETDATE(), 1, 0))
					
						--PRINT('ПРОБЛЕМ НЕТ')
				END
				SET @date_correction = CASE
											WHEN DATENAME(WEEKDAY, @date) = 'Friday' OR DATENAME(WEEKDAY, @date) = 'Saturday' THEN 3
											ELSE 2
											END;
				SET @date = DATEADD(day, @date_correction, @date);
				SET @lesson = @lesson + 2;
				--PRINT FORMATMESSAGE('%i С++', @lesson);
		END
END

GO
