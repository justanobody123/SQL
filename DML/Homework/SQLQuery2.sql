--2. Для каждого препода вывести возраст и опыт преподавания;
USE PD_311_DDL;
GO

SELECT birth_date, works_since,
[Ф.И.О] = last_name + ' ' + first_name + ' ' + middle_name,
--Я пыталась посчитать сразу по годам, но там тупо вычитаются год из года.
[Возраст] = DATEDIFF(DAY, birth_date, GETDATE()) / 365,
[Опыт работы] = FORMATMESSAGE('%i %s', DATEDIFF(DAY, works_since, GETDATE()) / 365, 'лет')
FROM Teachers