USE PD_311_DDL
GO

SELECT 
    [�.�.�] = last_name + ' ' + first_name + ' ' + middle_name,
    [������] = rate,
    [���������� ���] = COUNT(lesson_id),
    [��������] = COUNT(lesson_id) * rate
FROM 
    Schedule
JOIN 
    Teachers ON teacher = teacher_id
WHERE 
    DATEPART(MONTH, [date]) = 10 
    AND DATEPART(YEAR, [date]) = 2024
GROUP BY 
    last_name, first_name, middle_name, rate;