--Khan-2.sql
--author :    Ahmed M Khan
--CS679 Assignment 2  (PL/SQL)

------------------------------------------------------------------------------
SET SERVEROUTPUT ON
SET VERIFY OFF
------------------------------------------------------------------------------


PROMPT 'Enter a sailors sid and I'll find his/her trainer and their trainers.'
ACCEPT traineeID1 NUMBER PROMPT 'Enter a sailors id:'

DECLARE
   traineeID2 sailors.trainee%TYPE;
   trainerID sailors.sid%TYPE;
   status char(8);

----------------------------------------------------------------------------------- 


PROCEDURE getTrainerId(traineeID4 IN  sailors.trainee%TYPE) IS
  	  sr sailors%ROWTYPE; 
  	  traineeID3 sailors.trainee%TYPE;
       
     CURSOR sCursor(traineeID5 sailors.trainee%TYPE) IS
         SELECT sid,sname,rating,age,trainee 
	 FROM sailors 
 	 WHERE trainee=traineeID5;
     

     BEGIN
        OPEN sCursor(traineeID4);
        LOOP

          FETCH sCursor INTO sr;
          EXIT WHEN sCursor%NOTFOUND; 
          DBMS_OUTPUT.PUT_LINE
          ('+++++ '|| sr.trainee || ' is trained by ' || sr.sid);
          traineeID3:=sr.sid;   
          getTrainerId(traineeID3);
       
        END LOOP;

        IF sCursor%ROWCOUNT=0 THEN
     	   DBMS_OUTPUT.PUT_LINE
           ('+++++ '||traineeID4||' is trained by nobody.');
        END IF;
      
        CLOSE sCursor;

END getTrainerId;
  

-----------------------------------------------------------------

FUNCTION checkId(sailorsSid IN sailors.sid%TYPE) 
     RETURN VARCHAR2 AS
     status CHAR(8):='not ok';

BEGIN
    SELECT sid INTO trainerID 
    FROM sailors 
    WHERE sid=sailorsSid;
    
    status:='ok';
    RETURN(status);

   EXCEPTION
   WHEN NO_DATA_FOUND THEN
      DBMS_OUTPUT.PUT_LINE('+++++No such sailor found: '||sailorsSid);
      RETURN(status);
   WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('+++++'||SQLCODE||'+++'||SQLERRM);
      RETURN(status);
END checkId;

-------------------------------------------------------------------
BEGIN

   traineeID2:=&traineeID1;
   status:=checkId(traineeID2);

   IF status='ok' THEN
      getTrainerId(traineeID2);
   END IF;

END;
.
RUN;

   

  
 
  
