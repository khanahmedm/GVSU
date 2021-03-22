-- Khan-4.sql
-- Author : Ahmed M Khan
-- CS 679 Assignment 4
/* (1)
For every student who enrolled in 1999, find his/her number and last name .
Order the resuls by student number.
*/


	 SELECT S.sNum AS StuNum, S.sName.LName AS Stu_LName
	 FROM StudentsTab S
	 WHERE S.yearEnrolled=1999
	 ORDER BY S.sNum;


---------------------------------------------------------------------------------------------------------
/* (2)
For every *undergraduate* student who enrolled in 1999, find his/her number and last name .
Order the resuls by student number.
*/

	SELECT S.sNum AS StuNum, S.sName.LName AS UGStu_LName
	FROM StudentsTab S
	WHERE VALUE(S) IS OF (UGstudentType) AND S.yearEnrolled=1999
	ORDER BY S.sNum;  


---------------------------------------------------------------------------------------------------------      
/* (3)
For every *undergraduate* student who enrolled in 1999, find his/her number and last name, and the number and last name of his/her faculty advisor. Order the resuls by student number.
*/

	SELECT S.sNum AS StuNum, S.sName.LName AS UGStu_LName,
	DEREF(TREAT(VALUE(S) AS UGstudentType).advisor).fNum AS F_Num,
	DEREF(TREAT(VALUE(S) AS UGstudentType).advisor).fName.LName AS F_Name  
	FROM StudentsTab S
	WHERE VALUE(S) IS OF (UGstudentType) AND S.yearEnrolled=1999
	ORDER BY S.sNum;  

---------------------------------------------------------------------------------------------------------      
/* (4)
For every *undergraduate* student who enrolled in 1999, find his/her number and last name, and the number and last name of his/her graduate student mentor. Order the resuls by student number.
*/

	SELECT S.sNum AS StuNum, S.sName.LName AS UGStu_LName,
	DEREF(TREAT(VALUE(S) AS UGstudentType).mentor).sNum AS Mtr_Num,
	DEREF(TREAT(VALUE(S) AS UGstudentType).mentor).sName.LName AS Mtr_LName   
	FROM StudentsTab S
	WHERE VALUE(S) IS OF (UGstudentType) AND S.yearEnrolled=1999
	ORDER BY S.sNum;  

---------------------------------------------------------------------------------------------------------      
/* (5)
For every *undergraduate* student who enrolled in 1999, find his/her number and last name, and the number and last name of his/her graduate student mentor. Order the resuls by *mentor* number.
*/

	SELECT S.sNum AS StuNum, S.sName.LName AS UGStu_LName,
	DEREF(TREAT(VALUE(S) AS UGstudentType).mentor).sNum AS Mtr_Num,
	DEREF(TREAT(VALUE(S) AS UGstudentType).mentor).sName.LName AS Mtr_LName  
	FROM StudentsTab S
	WHERE VALUE(S) IS OF (UGstudentType) AND S.yearEnrolled=1999
	ORDER BY DEREF(TREAT(VALUE(S) AS UGstudentType).mentor).sNum;  

---------------------------------------------------------------------------------------------------------      
/* (6)
For every *undergraduate* student who enrolled in 1999, and whose mentor's research area is the same as his advisors specialty; find his/her number, mentor's number, advisor's number, and the advisor's specialty. Order the resuls by student number.
*/

	SELECT S.sNum AS StuNum, S.sName.LName AS UGStu_LName,
	DEREF(TREAT(VALUE(S) AS UGstudentType).mentor).sNum AS Mtr_Num,
	DEREF(TREAT(VALUE(S) AS UGstudentType).advisor).fNum AS Adv_Num,
	DEREF(TREAT(VALUE(S) AS UGstudentType).advisor).specialty AS Adv_Spec
	FROM StudentsTab S
	WHERE VALUE(S) IS OF (UGstudentType) AND S.yearEnrolled=1999 AND 
	DEREF(TREAT(VALUE(S) AS UGstudentType).mentor).researchArea=
	DEREF(TREAT(VALUE(S) AS UGstudentType).advisor).specialty
	ORDER BY S.sNum;  


---------------------------------------------------------------------------------------------------------      
/* (7)
For student number 100, print all the courses he/she has taken. Each line must contain: Student's number (which is 100), grade, semester, year, course number, course name, teacher's number, and teacher's last name.
*/

	SELECT S.sNum AS StuNum,L.grade AS Grade,L.semester AS Sem,L.year AS Year,DEREF(L.cNum).cNum AS CourseNum,DEREF(L.cNum).cName AS CourseName,DEREF(L.teacher).fNum AS Faculty_No, DEREF(L.teacher).fName.LName AS F_LName
	FROM StudentsTab S,TABLE(S.transcript) L
	WHERE VALUE(S) IS OF (studentType) AND S.sNum=100;

---------------------------------------------------------------------------------------------------------      
/* (8)
For every 'W' grade on record for an undergraduate student, print one line. The line must contain: Student's number, grade (which is a 'W'), semester, year, course number, course name, teacher's number, and teacher's last name.
*/

	SELECT S.sNum AS StuNum,L.grade AS Grade,L.semester AS Sem,L.year AS Year,DEREF(L.cNum).cNum AS CourseNum,DEREF(L.cNum).cName AS CourseName,DEREF(L.teacher).fNum AS F_Num, DEREF(L.teacher).fName.LName AS F_LName
	FROM StudentsTab S, TABLE(S.transcript) L
	WHERE L.grade='W' AND  VALUE(S) IS OF (UGstudentType);

---------------------------------------------------------------------------------------------------------      
/* (9)
For every 'D' grade on record for any student, print one line. The line must contain: Student's number, grade (which is a 'D'), semester, year, course number, course name, teacher's number, and teacher's last name.
*/

	SELECT S.sNum AS StuNum,L.grade AS Grade,L.semester AS Sem,L.year AS Year,DEREF(L.cNum).cNum AS CourseNum,DEREF(L.cNum).cName AS CourseName,DEREF(L.teacher).fNum AS Faculty_No, DEREF(L.teacher).fName.LName AS F_LName
	FROM StudentsTab S, TABLE(S.transcript) L
	WHERE L.grade='D' AND  VALUE(S) IS OF (studentType);

---------------------------------------------------------------------------------------------------------      



  
  

