--------------------------------------------------
---------------USEFUL COMMANDS -------------------
--------------------------------------------------
-- select type_name from user_types;
-- describe <yourTypeName>;
-- show error type <yourTypeName>;
---------------------------------------------------  
-- Inspecting the TYPEs and TABLEs
---------------------------------------------------
-- SHOW any errors
SHOW ERROR TYPE NameType;
SHOW ERROR TYPE GradeType;
SHOW ERROR TYPE CourseType;
SHOW ERROR TYPE FacultyType;
SHOW ERROR TYPE CommitteeType;
SHOW ERROR TYPE TranscriptType;
SHOW ERROR TYPE StudentType;
SHOW ERROR TYPE GstudentType;
SHOW ERROR TYPE UGstudentType;
-- DESCRIBING the types
DESCRIBE  NameType;
DESCRIBE  GradeType;
DESCRIBE  CourseType;
DESCRIBE  FacultyType;
DESCRIBE  CommitteeType;
DESCRIBE  TranscriptType;
DESCRIBE  StudentType;
DESCRIBE  GstudentType;
DESCRIBE  UGstudentType;
-- DESCRIBING the tables
DESCRIBE  StudentsTab; 
DESCRIBE  FacultyTab;
DESCRIBE  CoursesTab;
-- Printing the tables
SELECT * FROM StudentsTab;
SELECT * FROM FacultyTab;
SELECT * FROM CoursesTab;
---------------------------------------------------

---------------------------------------------------
-- DROP all TYPEs and TABLEs ...
-- ... they may or may not exist; but just in case!
---------------------------------------------------
DROP TYPE NameType FORCE;
DROP TYPE GradeType FORCE;
DROP TYPE CourseType FORCE;
DROP TYPE FacultyType FORCE;
DROP TYPE CommitteeType FORCE;
DROP TYPE TranscriptType FORCE;
DROP TYPE StudentType FORCE;
DROP TYPE GstudentType FORCE;
DROP TYPE UGstudentType FORCE;
DROP TABLE StudentsTab CASCADE CONSTRAINTS; 
DROP TABLE FacultyTab CASCADE CONSTRAINTS;
DROP TABLE CoursesTab CASCADE CONSTRAINTS;
select type_name from user_types;
select * from cat;

--*************************************************
--*************************************************
-- Now the actual SCHEMA creation begins
--*************************************************
--*************************************************

---------------------------------------------------  
-- Creating 'Place holders';  just to allow ...
-- ... out-of-order declaration of types
---------------------------------------------------
CREATE OR REPLACE TYPE NameType;
/
CREATE OR REPLACE TYPE GradeType;
/
CREATE OR REPLACE TYPE CourseType;
/
CREATE OR REPLACE TYPE FacultyType;
/
CREATE OR REPLACE TYPE CommitteeType;
/
CREATE OR REPLACE TYPE TranscriptType;
/
CREATE OR REPLACE TYPE StudentType;
/
CREATE OR REPLACE TYPE GstudentType;
/
CREATE OR REPLACE TYPE UGstudentType;
/
---------------------------------------------------  
-------------- TYPES ------------------------------
---------------------------------------------------  
CREATE OR REPLACE TYPE NameType AS OBJECT (
   LName		VARCHAR2(20),
   FName		VARCHAR2(20)
);
/
show err;
CREATE OR REPLACE TYPE GradeType AS OBJECT (
   grade		CHAR,
   semester		CHAR(2),
   year		NUMBER(4),
   cNum	      REF CourseType,
   teacher        REF FacultyType
);
/
show err;
CREATE OR REPLACE TYPE CourseType AS OBJECT (
  cNum		VARCHAR2(5),
  cName		VARCHAR2(50),
  crHrs		NUMBER
);
/
show err;
CREATE OR REPLACE TYPE FacultyType AS OBJECT(
  fNum		NUMBER,
  fName		NameType,
  specialty		VARCHAR2(20),
  MEMBER FUNCTION countCommittees RETURN NUMBER 
);
/
show err;
---- notice these two DROP commands ------ 
DROP TYPE CommitteeType FORCE;
DROP TYPE TranscriptType FORCE;
----
CREATE OR REPLACE TYPE CommitteeType AS VARRAY(3) OF REF FacultyType;
/
show err;
CREATE OR REPLACE TYPE TranscriptType AS TABLE OF GradeType;
/
show err;
CREATE OR REPLACE TYPE StudentType AS OBJECT(
sNum			NUMBER,
sName			NameType,						
yearEnrolled 	NUMBER(4),			
transcript        TranscriptType,
MEMBER FUNCTION getAttempted RETURN NUMBER,
MEMBER FUNCTION getCompleted RETURN NUMBER,
MEMBER FUNCTION computeGPA RETURN NUMBER,
-- The next method will be implemented only in the subtypes.
NOT INSTANTIABLE MEMBER FUNCTION findAvgGPA RETURN NUMBER
) NOT INSTANTIABLE NOT FINAL;
/
show err;
-- two subtypes of the supertype studentType 
CREATE OR REPLACE TYPE GstudentType UNDER StudentType(
    researchArea	VARCHAR2(30),
    committee     CommitteeType,
OVERRIDING MEMBER FUNCTION findAvgGPA RETURN NUMBER
);
/
show err;   
CREATE OR REPLACE TYPE UGstudentType UNDER StudentType(
    classification	VARCHAR2(10),
    advisor             REF FacultyType,
    mentor              REF GstudentType,
 OVERRIDING MEMBER FUNCTION findAvgGPA RETURN NUMBER
);
/
show err;
---------------------------------------------------   
---------------- TABLES ---------------------------
---------------------------------------------------   
CREATE TABLE FacultyTab OF FacultyType (fNum  PRIMARY KEY);

CREATE TABLE CoursesTab OF CourseType (cNum  PRIMARY KEY);

CREATE TABLE StudentsTab OF StudentType (PRIMARY KEY (sNum))
  NESTED TABLE Transcript STORE AS nestedRecords;

---------------------------------------------------   
----------------  METHODS -------------------------
--------------------------------------------------- 

CREATE OR REPLACE TYPE BODY StudentType AS

-------- METHOD getAttempted() IN StudentType ----------------
/*
Find the number of courses attempted by a given student.
An attempted course is a course for which the grade is: A, B, C,
D, F, I or W.
*/


  MEMBER FUNCTION getAttempted  RETURN NUMBER is
   Cnt_Attempt INTEGER;
   BEGIN
    
    SELECT  COUNT(*) INTO  Cnt_Attempt
    FROM StudentsTab S,TABLE(S.Transcript) T
    WHERE  T.grade IN ('A', 'B', 'C','D', 'F', 'I','W')
    AND   S.SNum = Self.SNum
    AND T.grade IS NOT NULL;

    RETURN (Cnt_Attempt);
  END;


-------- METHOD getCompleted() IN StudentType ----------------
/*
Find the number of courses completed by a given student.
A completed course is a course for which the grade is:A, B, C,
D, or F (but not an I or a W).
*/
  MEMBER FUNCTION getCompleted RETURN NUMBER is
 
   Cnt_Complete INTEGER;
   BEGIN
     SELECT  COUNT(*) INTO  Cnt_Complete
     FROM StudentsTab S,TABLE(S.Transcript) T
     WHERE  T.grade IN ('A','B','C','D','F')
     AND   S.SNum = Self.SNum;

     RETURN ( Cnt_Complete);
   END;

-------- METHOD computeGPA() IN StudentType ----------------
/*
Computes the GPA of a given student using a 4.0 scale and
accounting for the credit hours of courses.
*/
  MEMBER FUNCTION computeGPA RETURN NUMBER is
  
     gradePoint NUMBER(5,2)  :=0;       
     cumGrade  NUMBER(5,2) := 0;
     creditHrs NUMBER(5) := 0; 
     creditHrsTotal NUMBER(5)  :=0;
     Grade CHAR; 


    CURSOR s1 IS
     SELECT  deref( T.cNum).crHrs HOURS , TO_CHAR(LTRIM(RTRIM( 
T.grade)))
    FROM StudentsTab S,TABLE(S.Transcript) T
    WHERE  S.SNum = Self.SNum;

    BEGIN
    OPEN s1;
 
    LOOP
      -- Fetch the qualifying rows one by one
      FETCH s1 INTO   creditHrs, Grade;
      dbms_output.put_line( 'Output is ' || creditHrs || Grade);
      EXIT WHEN  s1%NOTFOUND ;
           
     IF Grade = 'A'
    THEN    
       gradePoint := 4.0;
    ELSIF Grade = 'B'
   THEN
      gradePoint := 3.0;
    ELSIF Grade = 'C'
    THEN
        gradePoint := 2.0;
     ELSIF Grade = 'D'
    THEN
        gradePoint := 1.0;
   ELSIF Grade ='F'
   THEN
        gradePoint:=0.0;
      END IF;
   IF Grade NOT IN ('W','I')
  THEN
    cumGrade  := cumGrade  + ( gradePoint *  creditHrs ) ;
    creditHrsTotal := creditHrsTotal + creditHrs;
END IF;

END LOOP;

 CLOSE s1;

 IF cumGrade > 0 THEN 
  gradePoint := cumGrade / creditHrsTotal ;
 END IF;

   RETURN (gradePoint);

END;

END;    -- notice this END ...  it ends the CREATE TYPE BODY
/  
show err;

-------- METHOD findAvgGPA() IN UGstudentType ----------------
/*
Compute the Average GPA of Undergraduate students. Excludes 
a GPAif it is a zero. The implementation is practically the 
same as method GstudentType.findAvgGPA(). Also, it uses the
method StudentType.computeGPA()
*/
CREATE OR REPLACE TYPE BODY UGStudentType AS
  OVERRIDING MEMBER FUNCTION findAvgGPA RETURN NUMBER is

   ugCount INTEGER:=0; 
   AvgGPA NUMBER(5,2):=0;
   TotalAvgGPA NUMBER(5,2):=0;
   Grade CHAR; 
 
 
CURSOR uCr IS
  SELECT S.ComputeGPA() 
        FROM StudentsTab S
       WHERE  VALUE(S) is of (UGStudentType)
      AND S.ComputeGPA() IS NOT NULL;

   BEGIN
 	   OPEN uCr;
   	LOOP
    		FETCH uCr INTO AvgGPA;
	EXIT WHEN uCr%NOTFOUND;
	IF AvgGPA<>0.0
	THEN
		ugCount := ugCount + 1;
	END IF;
	TotalAvgGPA:=TotalAvgGPA+AvgGPA;
	END LOOP;
	CLOSE uCr;
	RETURN (TotalAvgGPA/ugCount);
  
END;

END;       
/  
show err;

-------- METHOD findAvgGPA() IN GstudentType ----------------
/*
Compute the Average GPA of Graduate students. Excludes a GPA
if it is a zero. The implementation is practically the same 
as method UGstudentType.findAvgGPA(). Also, it uses the
method StudentType.computeGPA()
*/
CREATE OR REPLACE TYPE BODY GStudentType AS
  OVERRIDING MEMBER FUNCTION findAvgGPA RETURN NUMBER is     

  gCount INTEGER:=0;
  AvgGPA NUMBER(5,2):=0;
  TotalAvgGPA NUMBER(5,2):=0;
  Grade CHAR;

  CURSOR gCr IS
  SELECT S.ComputeGPA() 
        FROM StudentsTab S
       WHERE  VALUE(S) is of (GStudentType)
      AND S.ComputeGPA() IS NOT NULL;

   BEGIN
 	OPEN gCr;
  	LOOP
    		FETCH gCr INTO AvgGPA;
	EXIT WHEN gCr%NOTFOUND;
	IF AvgGPA<>0.0
	THEN
		gCount := gCount + 1;
	END IF;
	TotalAvgGPA:=TotalAvgGPA+AvgGPA;
	END LOOP;
	CLOSE gCr;
	RETURN (TotalAvgGPA/gCount);

   END;

END;
/  
show err;

-------- METHOD countCommittees() IN FacultyType ------- ------
/*
Find the number of graduate student committees that a faculty
memeber serves on.

HINT-1: 
We can't use VALUE, REF, or DEREF in PL/SQL; they
can only appear in a SQL statement (which can be embedded in
a PL/SQL program). 

HINT-2: 
The system-defined dummy table DUAL is useful when you have to write a SQL query but there is no table of your own in the FROM clause.

HINT-3:
The above two hints are based upon the implementation that I came up with.
You may of course come up with a more clever solution that doesn't even need
the hints!
*/
CREATE OR REPLACE TYPE BODY FacultyType AS  
   MEMBER FUNCTION countCommittees RETURN NUMBER is

	cnt_Comm Integer;
	BEGIN
		SELECT  COUNT(deref(T.COLUMN_VALUE ).Fnum) INTO cnt_Comm 
		FROM StudentsTab S,TABLE((TREAT(REF(S) AS REF GstudentType).committee)) 
		(+) T
		WHERE VALUE(S) IS OF (ONLY GstudentType)
		AND deref(T.COLUMN_VALUE ).Fnum = Self.fNum;

		RETURN(cnt_Comm);
	END;

END;
/  
show err;

