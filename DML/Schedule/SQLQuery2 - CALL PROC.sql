USE PD_311_DDL;
GO

--EXEC PrintStudent;
--EXEC PrintSchedule;
--EXEC sp_AddScheduleForStacionarGroup '2024-01-10', '14:30', 'PD_212', '%ADO.NET%', 'Покидюк'
--EXEC PrintScheduleForGroup 'PD_212';
EXEC sp_AddAlternatingDisciplineToSchedule 'PD_311', '%Hardware%', '2023-09-18', '13:30', 'Кобылинский', 2, 4


