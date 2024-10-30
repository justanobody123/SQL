USE PD_311_DDL
GO

SELECT
[Ф.И.О] = FORMATMESSAGE('%s %s %s', last_name, first_name, middle_name),
[Группа] = group_name,
[Направление] = direction_name
FROM Students 
JOIN Groups ON ([group] = group_id)
right JOIN Directions ON (Groups.direction = direction_id)
