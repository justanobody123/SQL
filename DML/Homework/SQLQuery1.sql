--1. ������� ��� ����������, ��������� �� ������������ ���������������� �� C++;
USE PD_311_DDL;
GO

SELECT
[��������� ����������] = discipline_name
FROM Disciplines, DependentDisciplines
WHERE target_discipline = (SELECT discipline_id FROM Disciplines WHERE discipline_name LIKE '%�����������%') AND required_discipline = discipline_id;