USE PD_311_DDL;
GO

--EXEC PrintStudent;
--EXEC PrintSchedule;
--EXEC sp_AddScheduleForStacionarGroup '2024-01-10', '14:30', 'PD_212', '%ADO.NET%', 'Покидюк'
--EXEC PrintScheduleForGroup 'PD_322';
--EXEC sp_AddAlternatingDisciplineToSchedule 'PD_311', '%Hardware%', '2024-10-01', '13:30', 'Кобылинский', 2, 4
--EXEC sp_AddScheduleForBaseStacionar '2024-10-01', 'PD_322', '14:30', 'Волосова', 'Кобылинский'
EXEC as_Calculate_Salary 10, 2024


