USE PD_311_DDL
GO

--EXEC PrintSchedule
SELECT TOP (4) * FROM Schedule ORDER BY lesson_id DESC;
PRINT dbo.CompleteLessonsForTeacher('Покидюк', '2024-10-01', '2024-10-31')
