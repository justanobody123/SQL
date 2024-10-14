USE PD_311_DDL;
CREATE TABLE ReportTypes
(
	report_type_id		TINYINT			PRIMARY KEY,
	report_type_name	NVARCHAR(50)	NOT NULL
);
CREATE TABLE Disciplines
(
	discipline_id		SMALLINT		PRIMARY KEY,
	discipline_name		NVARCHAR(150)	NOT NULL,
	number_of_lessons	SMALLINT		NOT NULL,
	report_type			TINYINT			NOT NULL
	CONSTRAINT FK_Disciplines_ReportTypes FOREIGN KEY REFERENCES ReportTypes(report_type_id)
);
CREATE TABLE DependentDisciplines
(
	target_discipline		SMALLINT,
	dependent_discipline	SMALLINT,
	PRIMARY KEY (target_discipline, dependent_discipline),
	CONSTRAINT FK_DependentDisciplines_Disciplines_TargetDiscipline FOREIGN KEY (target_discipline) REFERENCES Disciplines(discipline_id),
	CONSTRAINT FK_DependentDisciplines_Disciplines_DependentDiscipline FOREIGN KEY (dependent_discipline) REFERENCES Disciplines(discipline_id)
);
CREATE TABLE RequiredDisciplines
(
	target_discipline		SMALLINT,
	required_discipline		SMALLINT,
	PRIMARY KEY (target_discipline, required_discipline),
	CONSTRAINT FK_RequiredDisciplines_Disciplines_Target FOREIGN KEY (target_discipline) REFERENCES Disciplines(discipline_id),
	CONSTRAINT FK_RequiredDisciplines_Disciplines_Required FOREIGN KEY (required_discipline) REFERENCES Disciplines(discipline_id)
);
CREATE TABLE CompletedDisciplines
(
	[group]			INT,
	discipline		SMALLINT,
	PRIMARY KEY ([group], discipline),
	CONSTRAINT FK_CompletedDisciplines_Groups FOREIGN KEY ([group]) REFERENCES Groups(group_id),
	CONSTRAINT FK_CompletedDisciplines_Disciplines FOREIGN KEY (discipline) REFERENCES Disciplines(discipline_id)
);
CREATE TABLE DirectionsDisciplines
(
	direction		SMALLINT,
	discipline		SMALLINT,
	PRIMARY KEY (direction, discipline),
	CONSTRAINT FK_DirectionsDisciplines_Directions FOREIGN KEY (direction) REFERENCES Directions(direction_id),
	CONSTRAINT FK_DirectionsDisciplines_Disciplines FOREIGN KEY (discipline) REFERENCES Disciplines(discipline_id)
);

