SET VERIFY OFF;
SET SERVEROUTPUT ON;
CREATE OR REPLACE PROCEDURE mainHistory(id in main.m_id%TYPE, pass in main.mpass%TYPE)
 IS
	pass1 main.mpass%TYPE;
 BEGIN
	select mpass into pass1 from main where m_id = id;
	DBMS_OUTPUT.PUT_LINE('Type          AccountNo      Date	 Time       Amount');
	DBMS_OUTPUT.PUT_LINE('----          ---------      ----	 ----       ------');
	IF pass = pass1 then
		FOR R IN(SELECT MH_TYPE,TO_WHOM,MH_AMOUNT,MH_DATE FROM MHISTORY WHERE M_ID = id ORDER BY MH_DATE DESC) LOOP
			DBMS_OUTPUT.PUT_LINE(R.MH_TYPE || ' '||R.TO_WHOM|| '    '||R.MH_DATE||'    '||R.MH_AMOUNT);
		END LOOP;	
		
	ELSE
		DBMS_OUTPUT.PUT_LINE('Wrong Password.');
	END IF;
	
 EXCEPTION
	WHEN NO_DATA_FOUND THEN
		DBMS_OUTPUT.PUT_LINE('Mobile Number is incorrect.');
 END mainHistory;
 /
 
 


 BEGIN
	mainHistory('&User_ID', '&Password');
 END;
 /