--3. Вывести преподов с опытом преподавания больше десяти лет;
USE PD_311_DDL;
GO

SELECT works_since,
[Ф.И.О] = last_name + ' ' + first_name + ' ' + middle_name,
[Опыт работы] = FORMATMESSAGE('%i %s', DATEDIFF(DAY, works_since, GETDATE()) / 365, 'лет')
FROM Teachers
WHERE DATEDIFF(DAY, works_since, GETDATE()) / 365 > 10