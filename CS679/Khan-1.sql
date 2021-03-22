-- Khan-1.sql
-- author: Ahmed M Khan
-- CS679 Assignment 1 (PL/SQL)
-------------------------------------------------------------------
SET SERVEROUTPUT ON 
SET VERIFY OFF
------------------------------------
PROMPT 'Enter a sailor's sid and I'll find his/her trainees and their trainees'
ACCEPT sailorID NUMBER PROMPT 'Enter a sailors id:'

DECLARE
   sr     sailors%ROWTYPE;
   traineeID sailors.trainee%TYPE;
   sailorsSid sailors.sid%TYPE;
		
   CURSOR sCursor IS
          SELECT S.sid, S.sname, S.rating, S.age, S.trainee
          FROM   sailors S
          WHERE  S.sid = traineeID; 


BEGIN

   traineeID := &sailorID;
   
   SELECT sid INTO sailorsSid
   FROM sailors
   WHERE sid=traineeID;
   

   OPEN sCursor;
   LOOP
      -- Fetch the qualifying rows one by one
      FETCH sCursor INTO sr;
      EXIT WHEN sCursor%NOTFOUND;
	
      IF sr.trainee is NULL 
      THEN
           
           DBMS_OUTPUT.PUT_LINE
           ('+++++ Sailor '||sr.sid||' trains nobody'); 

      ELSE
	   DBMS_OUTPUT.PUT_LINE
           ('+++++ Sailor '||sr.sid ||' trains '||sr.trainee); 
           traineeID := sr.trainee;
           CLOSE sCursor;
	   OPEN sCursor;
 
      END IF;

   END LOOP;

   CLOSE sCursor;

EXCEPTION
WHEN NO_DATA_FOUND THEN
      DBMS_OUTPUT.PUT_LINE('+++++No such sailor found: '||traineeID);
WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('+++++'||SQLCODE||'...'||SQLERRM);
END;
.
RUN;

