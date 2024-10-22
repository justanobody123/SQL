--5. ������� ���������� ��� ������ 'PD_321' � ��������� ����, �������, ��� ������ � �������� ������� (��������� ��� �������������);
SELECT
[�������] = discipline_name,
[���� �������] = [date],
[����� ������ �������] = [time],
[���� ������] = CASE
					WHEN DATEPART(WEEKDAY, [date]) = 2 THEN '�����������'
					WHEN DATEPART(WEEKDAY, [date]) = 4 THEN '�����'
					WHEN DATEPART(WEEKDAY, [date]) = 6 THEN '�������'
					END,
[������ �������] = CASE
				WHEN spent = 1 THEN '���������'
				WHEN spent = 0 THEN '�������������'
				END
FROM Schedule, Disciplines
WHERE [group] = (SELECT group_id FROM Groups WHERE group_name = 'PD_321') AND discipline = discipline_id