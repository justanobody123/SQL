USE PD_311_DDL
GO

SELECT
[�.�.�] = FORMATMESSAGE('%s %s %s', last_name, first_name, middle_name),
[������] = group_name,
[�����������] = direction_name
FROM Students 
JOIN Groups ON ([group] = group_id)
right JOIN Directions ON (Groups.direction = direction_id)
