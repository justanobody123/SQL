--2. ��� ������� ������� ������� ������� � ���� ������������;
USE PD_311_DDL;
GO

SELECT birth_date, works_since,
[�.�.�] = last_name + ' ' + first_name + ' ' + middle_name,
--� �������� ��������� ����� �� �����, �� ��� ���� ���������� ��� �� ����.
[�������] = DATEDIFF(DAY, birth_date, GETDATE()) / 365,
[���� ������] = FORMATMESSAGE('%i %s', DATEDIFF(DAY, works_since, GETDATE()) / 365, '���')
FROM Teachers