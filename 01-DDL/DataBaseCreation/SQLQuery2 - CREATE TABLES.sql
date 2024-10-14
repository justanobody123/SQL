USE PD_311_DDL; --ÂÛÁÈÐÀÅÌ ÁÀÇÓ ÄÀÍÍÛÕ
/*CREATE TABLE Directions
(
	direction_id	SMALLINT		PRIMARY KEY,
	direction_name	NVARCHAR(150)	NOT NULL
);
CREATE TABLE Groups
(
	group_id		INT				PRIMARY KEY,
	group_name		NVARCHAR(16)	NOT NULL,
	direction		SMALLINT		NOT NULL
	CONSTRAINT FK_Groups_Directions FOREIGN KEY REFERENCES Directions(direction_id)
);
CREATE TABLE Students
(
	student_id		INT				PRIMARY KEY		IDENTITY(1, 1),
	last_name		NVARCHAR(150)	NOT NULL,
	first_name		NVARCHAR(150)	NOT NULL,
	middle_name		NVARCHAR(150),	
	brith_date		DATE			NOT NULL,
	[group]			INT
	CONSTRAINT FK_Students_Groups FOREIGN KEY REFERENCES Groups(group_id)
);*/
/*CREATE TABLE ReportTypes
(
	report_type_id		TINYINT			PRIMARY KEY,
	report_type_name	NVARCHAR(150)	NOT NULL
);
CREATE TABLE Disciplines
(
	discipline_id		SMALLINT		PRIMARY KEY,
	discipline_name		NVARCHAR(150)	NOT NULL,
	number_of_lessons	SMALLINT		NOT NULL,
	report_type			TINYINT			NOT NULL
	CONSTRAINT FK_Disciplines_ReportTypes FOREIGN KEY REFERENCES ReportTypes(report_type_id)
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
CREATE TABLE RequiredDisciplines
(
	target_discipline		SMALLINT,
	required_discipline		SMALLINT,
	PRIMARY KEY (target_discipline, required_discipline),
	CONSTRAINT FK_RequiredDisciplines_Disciplines_Target FOREIGN KEY (target_discipline) REFERENCES Disciplines(discipline_id),
	CONSTRAINT FK_RequiredDisciplines_Disciplines_Required FOREIGN KEY (required_discipline) REFERENCES Disciplines(discipline_id)
);
CREATE TABLE DependentDisciplines
(
	target_discipline		SMALLINT,
	dependent_discipline	SMALLINT,
	PRIMARY KEY (target_discipline, dependent_discipline),
	CONSTRAINT FK_DependentDisciplines_Disciplines_Target FOREIGN KEY (target_discipline) REFERENCES Disciplines(discipline_id),
	CONSTRAINT FK_DependentDisciplines_Disciplines_Dependent FOREIGN KEY (dependent_discipline) REFERENCES Disciplines(discipline_id)
);
CREATE TABLE Teachers
(
	teacher_id		INT				PRIMARY KEY		IDENTITY(1, 1),		
	last_name		NVARCHAR(150)	NOT NULL,
	first_name		NVARCHAR(150)	NOT NULL,
	middle_name		NVARCHAR(150),
	birth_date		DATE			NOT NULL,
	works_since		DATE			NOT NULL,
	rate			MONEY			NOT NULL
);
CREATE TABLE DisciplinesTeachers
(
	discipline		SMALLINT,
	teacher			INT,
	PRIMARY KEY (discipline, teacher),
	CONSTRAINT FK_DisciplinesTeachers_Disciplines FOREIGN KEY (discipline) REFERENCES Disciplines(discipline_id),
	CONSTRAINT FK_DisciplinesTeachers_Teachers FOREIGN KEY (teacher) REFERENCES Teachers(teacher_id)
);
CREATE TABLE Schedule
(
	lesson_id		BIGINT			PRIMARY KEY,
	[date]			DATE			NOT NULL,
	[time]			TIME(0)			NOT NULL,
	[group]			INT				NOT NULL
	CONSTRAINT FK_Schedule_Groups	FOREIGN KEY REFERENCES Groups(group_id),
	discipline		SMALLINT		NOT NULL
	CONSTRAINT FK_Schedule_Disciplines	FOREIGN KEY REFERENCES Disciplines(discipline_id),
	teacher			INT				NOT NULL
	CONSTRAINT FK_Schedule_Teachers	FOREIGN KEY REFERENCES Teachers(teacher_id),
	[subject]		NVARCHAR(256),
	spent			BIT				NOT NULL,
);
--ÄÀËÜØÅ ÏÎÅÄÓÒ ÒÀÁËÈÖÛ Ñ ÎÖÅÍÊÀÌÈ, ÍÀÄÎ ÏÎÑÌÎÒÐÅÒÜ Â ÈÍÒÅÐÍÅÒÅ, ÊÀÊ ÂÛÑÒÀÂÈÒÜ ÎÃÐÀÍÈ×ÅÍÈÅ ÍÀ ÄÈÀÏÀÇÎÍ ÇÍÀ×ÅÍÈÉ
CREATE TABLE Grades
(
	student		INT,
	lesson		BIGINT,
	PRIMARY KEY (student, lesson),
	CONSTRAINT FK_Grades_Students FOREIGN KEY (student) REFERENCES Students(student_id),
	CONSTRAINT FK_Grades_Schedule FOREIGN KEY (lesson) REFERENCES Schedule(lesson_id),
	grade_1		TINYINT
	CONSTRAINT CK_grade_1 CHECK (grade_1 > 0 AND grade_1 <= 12),
	grade_2		TINYINT
	CONSTRAINT CK_grade_2 CHECK (grade_2 > 0 AND grade_2 <= 12),
);
CREATE TABLE Exams
(
	student		INT,
	lesson		BIGINT,
	PRIMARY KEY (student, lesson),
	CONSTRAINT FK_Exams_Students FOREIGN KEY (student) REFERENCES Students(student_id),
	CONSTRAINT FK_Exams_Schedule FOREIGN KEY (lesson) REFERENCES Schedule(lesson_id),
	grade		TINYINT
	CONSTRAINT CK_grade CHECK (grade >= 0 AND grade <= 12)
);*/