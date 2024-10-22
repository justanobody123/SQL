--5. Выбрать расписание для группы 'PD_321' с указанием даты, времени, дня недели и статусом занятия (Проведено или запланировано);
SELECT
[Предмет] = discipline_name,
[Дата занятия] = [date],
[Время начала занятия] = [time],
[День недели] = CASE
					WHEN DATEPART(WEEKDAY, [date]) = 2 THEN 'Понедельник'
					WHEN DATEPART(WEEKDAY, [date]) = 4 THEN 'Среда'
					WHEN DATEPART(WEEKDAY, [date]) = 6 THEN 'Пятница'
					END,
[Статус занятия] = CASE
				WHEN spent = 1 THEN 'Проведено'
				WHEN spent = 0 THEN 'Запланировано'
				END
FROM Schedule, Disciplines
WHERE [group] = (SELECT group_id FROM Groups WHERE group_name = 'PD_321') AND discipline = discipline_id