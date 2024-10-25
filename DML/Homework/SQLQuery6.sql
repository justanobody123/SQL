USE PD_311_DDL;
GO

DECLARE @start_date						AS	DATE			= '2023-09-15';
DECLARE @date							AS	DATE			= @start_date; 
DECLARE @start_time						AS	TIME			= '13:30';
DECLARE @group							AS	INT				= (SELECT group_id FROM Groups WHERE group_name = 'PD_321');
DECLARE @hardware_discipline			AS	SMALLINT		= (SELECT discipline_id FROM Disciplines WHERE discipline_name = 'Hardware-PC');
DECLARE @programming_discipline			AS	SMALLINT		= (SELECT discipline_id FROM Disciplines WHERE discipline_name = 'Процедурное программирование на языке C++')
DECLARE @system_administration			AS	SMALLINT		= (SELECT discipline_id FROM Disciplines WHERE discipline_name = 'Администрирование Window XP/7/8/10/11');
DECLARE @hardware_lessons				AS	SMALLINT		= (SELECT number_of_lessons FROM Disciplines WHERE discipline_id = @hardware_discipline);
DECLARE @programming_lessons			AS	SMALLINT		= (SELECT number_of_lessons FROM Disciplines WHERE discipline_id = @programming_discipline);
DECLARE @system_administration_lessons	AS	SMALLINT		= (SELECT number_of_lessons FROM Disciplines WHERE discipline_id = @system_administration);
DECLARE @programming_teacher			AS	INT				= (SELECT teacher_id FROM Teachers WHERE last_name = 'Ковтун');
DECLARE @hardware_teacher				AS	INT				= (SELECT teacher_id FROM Teachers WHERE last_name = 'Кобылинский')
DECLARE @lesson							AS	SMALLINT		= 0;
DECLARE @change_discipline				AS	BIT				= 1;
DECLARE @current_discipline				AS	SMALLINT		= 0;
DECLARE @current_teacher				AS	INT				= 0;
DECLARE @date_correction				AS	TINYINT			= 0;
DECLARE @programming_counter			AS	SMALLINT		= 0;

WHILE @lesson < @hardware_lessons
BEGIN
		--ПРОВЕРКА НА ДЕНЬ НЕДЕЛИ
		--ЕСЛИ ПОНЕДЕЛЬНИК(ВТОРНИК), ТО ЖЕЛЕЗО И АВТОИНКРЕМЕНТ НА 2
		--ЕСЛИ СРЕДА(ЧЕТВЕРГ)
			--ЕСЛИ БИТ = 1, ТО С++
			--ЭЛС ЖЕЛЕЗО И АВТОИНКРЕМЕНТ НА 2
		--ЕСЛИ ПЯТНИЦА(СУББОТА), ТО С++
		--ЗАПИХНУТЬ ПЕРВУЮ ПАРУ
		--ЗАПИХНУТЬ ВТОРУЮ ПАРУ
		--КОРРЕКЦИЯ ДАТЫ В ЗАВИСИМОСТИ ОТ ДНЯ НЕДЕЛИ
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
		PRINT FORMATMESSAGE('%i %i %s %s %i %s %i', @current_discipline, @current_teacher, CAST(@date AS NVARCHAR(50)), CAST(@start_time AS NVARCHAR(50)), @group, DATENAME(WEEKDAY, @date), CASE
																				WHEN DATEDIFF(DAY, @date, GETDATE()) > 0
																				OR (DATEDIFF(DAY, @date, GETDATE()) = 0 AND DATEDIFF(MINUTE, @start_time, GETDATE()) >= 0) THEN 1
																				ELSE 0
																				END);
		IF NOT EXISTS(SELECT 1 FROM Schedule WHERE @date = [date] AND @start_time = [time] AND @group = [group])
		BEGIN
				--ИНСЕРТ
				PRINT('ПРОБЛЕМ НЕТ')
		END
		PRINT FORMATMESSAGE('%i %i %s %s %i %s %i', @current_discipline, @current_teacher, CAST(@date AS NVARCHAR(50)), CAST(DATEADD(MINUTE, 90, @start_time) AS NVARCHAR(50)), @group, DATENAME(WEEKDAY, @date), CASE
																				WHEN DATEDIFF(DAY, @date, GETDATE()) > 0
																				OR (DATEDIFF(DAY, @date, GETDATE()) = 0 AND DATEDIFF(MINUTE, DATEADD(MINUTE, 90, @start_time), GETDATE()) >= 0) THEN 1
																				ELSE 0
																				END);
		IF NOT EXISTS(SELECT 1 FROM Schedule WHERE @date = [date] AND DATEADD(MINUTE, 90, @start_time) = [time] AND @group = [group])
		BEGIN
				--ИНСЕРТ
				PRINT('ПРОБЛЕМ НЕТ')
		END
		SET @date = DATEADD(DAY, @date_correction, @date);
		PRINT FORMATMESSAGE('%i железо, %i С++', @lesson, @programming_counter);
END
PRINT 'Конец первого цикла';
--В первом цикле все работает, осталось дописать второй. Или можно подумать, как запихнуть все в один? Не, ну нахер.
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
		PRINT FORMATMESSAGE('%i %i %s %s %i %s %i', @current_discipline, @current_teacher, CAST(@date AS NVARCHAR(50)), CAST(@start_time AS NVARCHAR(50)), @group, DATENAME(WEEKDAY, @date), CASE
																				WHEN DATEDIFF(DAY, @date, GETDATE()) > 0
																				OR (DATEDIFF(DAY, @date, GETDATE()) = 0 AND DATEDIFF(MINUTE, @start_time, GETDATE()) >= 0) THEN 1
																				ELSE 0
																				END);
		IF NOT EXISTS(SELECT 1 FROM Schedule WHERE @date = [date] AND @start_time = [time] AND @group = [group])
		BEGIN
				--ИНСЕРТ
				PRINT('ПРОБЛЕМ НЕТ')
		END
		PRINT FORMATMESSAGE('%i %i %s %s %i %s %i', @current_discipline, @current_teacher, CAST(@date AS NVARCHAR(50)), CAST(DATEADD(MINUTE, 90, @start_time) AS NVARCHAR(50)), @group, DATENAME(WEEKDAY, @date), CASE
																				WHEN DATEDIFF(DAY, @date, GETDATE()) > 0
																				OR (DATEDIFF(DAY, @date, GETDATE()) = 0 AND DATEDIFF(MINUTE, DATEADD(MINUTE, 90, @start_time), GETDATE()) >= 0) THEN 1
																				ELSE 0
																				END);
		IF NOT EXISTS(SELECT 1 FROM Schedule WHERE @date = [date] AND DATEADD(MINUTE, 90, @start_time) = [time] AND @group = [group])
		BEGIN
				--ИНСЕРТ
				PRINT('ПРОБЛЕМ НЕТ')
		END
		SET @date = DATEADD(DAY, @date_correction, @date);
		PRINT FORMATMESSAGE('%i железо, %i С++', @lesson, @programming_counter);
END
PRINT 'Конец второго цикла';
--ОСТАЛОСЬ ДОБИТЬ ПРОГРАММИРОВАНИЕ, ПОТОМУ ЧТО ОНО ДЛИННЕЕ, ЧЕМ ЖЕЛЕЗО И АДМИНИСТРИРОВАНИЕ ВМЕСТЕ ВЗЯТЫЕ
SET @current_discipline = @programming_discipline;
SET @current_teacher = @programming_teacher;
SET @lesson = @programming_counter;
WHILE @lesson < @programming_lessons
BEGIN
		PRINT FORMATMESSAGE('%i %i %s %s %i %s %i', @current_discipline, @current_teacher, CAST(@date AS NVARCHAR(50)), CAST(@start_time AS NVARCHAR(50)), @group, DATENAME(WEEKDAY, @date), CASE
																				WHEN DATEDIFF(DAY, @date, GETDATE()) > 0
																				OR (DATEDIFF(DAY, @date, GETDATE()) = 0 AND DATEDIFF(MINUTE, @start_time, GETDATE()) >= 0) THEN 1
																				ELSE 0
																				END);
		IF NOT EXISTS(SELECT 1 FROM Schedule WHERE @date = [date] AND @start_time = [time] AND @group = [group])
		BEGIN
				--ИНСЕРТ
				PRINT('ПРОБЛЕМ НЕТ')
		END
		PRINT FORMATMESSAGE('%i %i %s %s %i %s %i', @current_discipline, @current_teacher, CAST(@date AS NVARCHAR(50)), CAST(DATEADD(MINUTE, 90, @start_time) AS NVARCHAR(50)), @group, DATENAME(WEEKDAY, @date), CASE
																				WHEN DATEDIFF(DAY, @date, GETDATE()) > 0
																				OR (DATEDIFF(DAY, @date, GETDATE()) = 0 AND DATEDIFF(MINUTE, DATEADD(MINUTE, 90, @start_time), GETDATE()) >= 0) THEN 1
																				ELSE 0
																				END);
		IF NOT EXISTS(SELECT 1 FROM Schedule WHERE @date = [date] AND DATEADD(MINUTE, 90, @start_time) = [time] AND @group = [group])
		BEGIN
				--ИНСЕРТ
				PRINT('ПРОБЛЕМ НЕТ')
		END
		SET @date_correction = CASE
									WHEN DATENAME(WEEKDAY, @date) = 'Friday' OR DATENAME(WEEKDAY, @date) = 'Saturday' THEN 3
									ELSE 2
									END;
		SET @date = DATEADD(day, @date_correction, @date);
		SET @lesson = @lesson + 2;
		PRINT FORMATMESSAGE('%i С++', @lesson);
END
PRINT 'Конец третьего цикла'