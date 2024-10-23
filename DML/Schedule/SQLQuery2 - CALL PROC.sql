USE PD_311_DDL;
GO

--EXEC PrintStudent;
--EXEC PrintSchedule;
EXEC PrintScheduleForGroup 'PD_212';
--EXEC sp_AddScheduleForStationarGroup '2024-01-10', '14:30', 'PD_212', '%ADO.NET%', 'Покидюк'