USE PD_311_DDL;
GO

SELECT
--last_name AS N'�������', first_name AS N'���', middle_name AS N'��������'
--last_name + ' ' + first_name + ' ' + middle_name N'�.�.�'
--[�.�.�] = last_name + ' ' + first_name + ' ' + middle_name,
[�.�.�.] = FORMATMESSAGE('%s %s %s', last_name, first_name, middle_name),
birth_date AS N'���� ��������'
FROM Teachers
WHERE first_name = '������'
ORDER BY birth_date DESC; -- ASC (ASCENDING) - ���������� �� �����������
						 -- DESC (DESCENDING) - ���������� �� ��������
