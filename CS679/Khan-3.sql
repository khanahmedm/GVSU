CS679 : Assignment 3(ORDBMS)
Author: Ahmed M Khan

---------------------------------------------------
-- DROP all TYPEs and TABLEs ...
-- ... they may or may not exist; but just in case!
---------------------------------------------------
DROP TYPE NameType FORCE;
/
DROP TYPE GradeType FORCE;
/
DROP TYPE CourseType FORCE;
/
DROP TYPE FacultyType FORCE;
/
--DROP TYPE CommitteeType FORCE;
/
--DROP TYPE TranscriptType FORCE;
/
DROP TYPE StudentType FORCE;
/
DROP TYPE GstudentType FORCE;
/
DROP TYPE UGstudentType FORCE;
/
DROP TABLE StudentsTab CASCADE CONSTRAINTS; 
DROP TABLE FacultyTab CASCADE CONSTRAINTS;
DROP TABLE CoursesTab CASCADE CONSTRAINTS;
select type_name from user_types;
select * from cat;


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
CREATE OR REPLACE TYPE GradeType AS OBJECT (
   grade		CHAR,
   semester		CHAR(2),
   year		NUMBER(4),
   cNum	      REF CourseType,
   teacher        REF FacultyType
);
/
CREATE OR REPLACE TYPE CourseType AS OBJECT (
  cNum		VARCHAR2(5),
  cName		VARCHAR2(50),
  crHrs		NUMBER
);
/
CREATE OR REPLACE TYPE FacultyType AS OBJECT(
  fNum		NUMBER,
  fName		NameType,
  specialty		VARCHAR2(20)
);
/
----
DROP TYPE CommitteeType FORCE;
/
DROP TYPE TranscriptType FORCE;
/
----
CREATE OR REPLACE TYPE CommitteeType AS VARRAY(3) OF REF FacultyType;
/
CREATE OR REPLACE TYPE TranscriptType AS TABLE OF GradeType;
/
CREATE OR REPLACE TYPE StudentType AS OBJECT(
sNum			NUMBER,
sName			NameType,						
yearEnrolled 	NUMBER(4),			
transcript        TranscriptType
) NOT FINAL;
/
-- two subtypes of the supertype studentType 
CREATE OR REPLACE TYPE GstudentType UNDER StudentType(
    researchArea	VARCHAR2(30),
    committee     CommitteeType
);
/   
CREATE OR REPLACE TYPE UGstudentType UNDER StudentType(
    classification	VARCHAR2(10),
    advisor             REF FacultyType,
    mentor              REF StudentType
);
/
---------------------------------------------------   
---------------- TABLES ---------------------------
---------------------------------------------------   
--
CREATE TABLE FacultyTab OF FacultyType (fNum  PRIMARY KEY);

CREATE TABLE CoursesTab OF CourseType (cNum  PRIMARY KEY);

CREATE TABLE StudentsTab OF StudentType (PRIMARY KEY (sNum))
  NESTED TABLE Transcript STORE AS nestedRecords;
   
---------------------------------------------------



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
DESCRIBE NameType;
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
select type_name from user_types;
select * from cat;

--DATA INSERTION

--FACULTY TABLE: DATA

INSERT INTO FacultyTab
 VALUES(
      300,
      NameType('Fanning','Albert'),
      'AI'
       ); 


INSERT INTO FacultyTab
 VALUES(
      305,
      NameType('Farris','Bob'),
      'DBMS'
       );



INSERT INTO FacultyTab
 VALUES(
      310,
      NameType('Fedder','Clark'),
      'SE'
       );

-------------------------------------------------------------------------------


--COURSES TABLE: DATA

INSERT INTO CoursesTab
 VALUES(
      'CS162',
      'Comp Sci-1',
      4
      );


INSERT INTO CoursesTab
 VALUES(
      'CS262',
      'Comp Sci-2',
       3
      );


INSERT INTO CoursesTab
 VALUES(
      'CS351',
      'Computer Org',
       3
      );


INSERT INTO CoursesTab
 VALUES(
      'CS500',
      'Fund of Comp Sci',
       3
      );

INSERT INTO CoursesTab
 VALUES(
      'CS673',
      'Prin of Comp Sci',
       3
      );

--------------------------------------------------------------------------------------

--STUDENTS TABLE: DATA




--first insert for the graduate table--- working one below

INSERT INTO StudentsTab 
VALUES(GstudentType(200,NameType('Garland','Betty'),2000,
                 TranscriptType(),'AI',CommitteeType(
 						     (SELECT REF(F) FROM FacultyTab F WHERE F.fNum=300),
						     (SELECT REF(F) FROM FacultyTab F WHERE F.fNum=305),
						     (SELECT REF(F) FROM FacultyTab F WHERE F.fNum=310))));



------------------------------------------------------------------------------------------

---  second insert for the graduate table -->working one below;
INSERT INTO StudentsTab VALUES
(GstudentType(205,NameType('Garrett','Barry'),2001,
   TranscriptType(),'DBMS',
			   CommitteeType()));



-------------------------------------------------------------------------------------

--third insert for the graduate table --- NOT WORKING 

INSERT INTO StudentsTab VALUES
(GstudentType(210,NameType('Gates','Linda'),2000,
  TranscriptType(),'SE',
		           CommitteeType()));


  
INSERT INTO TABLE(
    SELECT S.transcript FROM StudentsTab S WHERE S.sNum=210
                 )

VALUES('A','Fa',2000,
                     (SELECT REF(C) FROM CoursesTab C WHERE C.cNum='CS500'),  
		     (SELECT REF(F) FROM FacultyTab F WHERE F.fNum=300)
                      
       );	
  
 


----------------------------------------------------------------------------




--- first insert into Ug table

INSERT INTO StudentsTab VALUES(
   UGstudentType(100, NameType('Underwood','Mike'),
    2000, TranscriptType(),'junior',
     (SELECT REF(F) FROM FacultyTab F WHERE F.fNum=300),
      (SELECT REF(S) FROM StudentsTab S WHERE S.sNum=200)
                )
                       );


INSERT INTO TABLE(
  SELECT S.transcript FROM StudentsTab S WHERE S.sNum=100
                 )

 VALUES('A','Fa',2000,
        (SELECT REF(C) FROM CoursesTab C WHERE C.cNum='CS162'),
        (SELECT REF(F) FROM FacultyTab F WHERE F.fNum=305)
       );





--- second insert into ug table--- working

INSERT INTO StudentsTab VALUES(
   UGstudentType(105, NameType('Urban','Linda'),
    2001, TranscriptType(),'sophomore',
     (SELECT REF(F) FROM FacultyTab F WHERE F.fNum=305),
      (SELECT REF(S) FROM StudentsTab S WHERE S.sNum=205)
                       )
                       );


--- third insert into ug table:


INSERT INTO StudentsTab VALUES(
   UGstudentType(110, NameType('Ullman','Jim'),
    2000, TranscriptType(),'sophomore',
     (SELECT REF(F) FROM FacultyTab F WHERE F.fNum=300),
      (SELECT REF(S) FROM StudentsTab S WHERE S.sNum=210)
                )
                       );

INSERT INTO TABLE(
  SELECT S.transcript FROM StudentsTab S WHERE S.sNum=110
                 )

 VALUES('B','Wi',2001,
        (SELECT REF(C) FROM CoursesTab C WHERE C.cNum='CS262'),
        (SELECT REF(F) FROM FacultyTab F WHERE F.fNum=305)
       );





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
/
DROP TYPE GradeType FORCE;
/
DROP TYPE CourseType FORCE;
/
DROP TYPE FacultyType FORCE;
/
DROP TYPE CommitteeType FORCE;
/
DROP TYPE TranscriptType FORCE;
/
DROP TYPE StudentType FORCE;
/
DROP TYPE GstudentType FORCE;
/
DROP TYPE UGstudentType FORCE;
/
DROP TABLE StudentsTab CASCADE CONSTRAINTS; 
DROP TABLE FacultyTab CASCADE CONSTRAINTS;
DROP TABLE CoursesTab CASCADE CONSTRAINTS;
select type_name from user_types;
select * from cat;


























































