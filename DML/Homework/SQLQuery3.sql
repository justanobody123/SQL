--3. ������� �������� � ������ ������������ ������ ������ ���;
USE PD_311_DDL;
GO

SELECT works_since,
[�.�.�] = last_name + ' ' + first_name + ' ' + middle_name,
[���� ������] = FORMATMESSAGE('%i %s', DATEDIFF(DAY, works_since, GETDATE()) / 365, '���')
FROM Teachers
WHERE DATEDIFF(DAY, works_since, GETDATE()) / 365 > 10