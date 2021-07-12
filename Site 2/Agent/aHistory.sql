SET VERIFY OFF;
SET SERVEROUTPUT ON;
CREATE OR REPLACE PROCEDURE agentHistory(id in main.m_id%TYPE, pass in main.mpass%TYPE)
 IS
	pass1 main.mpass%TYPE;
 BEGIN
	select apass into pass1 from agent where aid = id;
	DBMS_OUTPUT.PUT_LINE('Type          AccountNo      Date	 Time       Amount');
	DBMS_OUTPUT.PUT_LINE('----          ---------      ----	 ----       ------');
	IF pass = pass1 then
		FOR R IN(SELECT AH_TYPE,TO_WHOM,AH_AMOUNT,AH_DATE FROM AHISTORY WHERE AID = id ORDER BY AH_DATE DESC) LOOP
			DBMS_OUTPUT.PUT_LINE(R.AH_TYPE || ' '||R.TO_WHOM|| '    '||R.AH_DATE||'    '||R.AH_AMOUNT);
		END LOOP;	
		
	ELSE
		DBMS_OUTPUT.PUT_LINE('Wrong Password.');
	END IF;
	
 EXCEPTION
	WHEN NO_DATA_FOUND THEN
		DBMS_OUTPUT.PUT_LINE('Mobile Number is incorrect.');
 END agentHistory;
 /
 
 

 BEGIN
	agentHistory('&User_ID', '&Password');
 END;
 /