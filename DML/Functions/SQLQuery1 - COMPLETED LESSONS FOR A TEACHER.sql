USE PD_311_DDL
GO

CREATE FUNCTION CompleteLessonsForTeacher
(@teacher_last_name AS NVARCHAR(256),
@start_date AS DATE,
@end_date AS DATE) RETURNS INT
AS
BEGIN
		DECLARE @teacher AS INT = (SELECT teacher_id FROM Teachers WHERE @teacher_last_name = last_name)
		DECLARE @number_of_lessons AS INT = (SELECT COUNT(lesson_id) FROM Schedule WHERE teacher = @teacher AND spent = 1);
		
		RETURN @number_of_lessons
END