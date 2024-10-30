USE PD_311_DDL
GO

CREATE PROCEDURE sp_Calculate_Salary
	@month INT,
	@year INT
AS
BEGIN
	SELECT 
    [Ф.И.О] = last_name + ' ' + first_name + ' ' + middle_name,
    [Ставка] = rate,
    [Количество пар] = COUNT(lesson_id),
    [Зарплата] = COUNT(lesson_id) * rate
FROM 
    Schedule
JOIN 
    Teachers ON teacher = teacher_id
WHERE 
    DATEPART(MONTH, [date]) = @month 
    AND DATEPART(YEAR, [date]) = @year
GROUP BY 
    last_name, first_name, middle_name, rate;
END