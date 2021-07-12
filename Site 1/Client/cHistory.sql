SET VERIFY OFF;
SET SERVEROUTPUT ON;
CREATE OR REPLACE PROCEDURE clientHistory(id in client.cid%TYPE, pass in client.cpass%TYPE)
 IS
	pass1 client.cpass%TYPE;
	tableNameF varchar2(25) :='null';
 BEGIN
	FOR R in ( Select cid from client@site_2 where cid = id ) LOOP
		tableNameF := 'client@site_2';
	END LOOP;
	FOR R in ( Select cid from client where cid = id ) LOOP
		tableNameF := 'client';
	END LOOP;
	IF tableNameF = 'null' THEN
		DBMS_OUTPUT.PUT_LINE('Wrong user_id');
		return ;
	END IF;
 

	EXECUTE IMMEDIATE 'select cpass from ' || tableNameF || ' where cid = ' || id into  pass1;
	DBMS_OUTPUT.PUT_LINE('Type          AccountNo      Date	 Time       Amount');
	DBMS_OUTPUT.PUT_LINE('----          ---------      ----	 ----       ------');
	IF pass = pass1 then
		FOR R IN(SELECT CH_TYPE,TO_WHOM,CH_AMOUNT,CH_DATE FROM CHISTORY WHERE CID = id ORDER BY CH_DATE DESC) LOOP
			DBMS_OUTPUT.PUT_LINE(R.CH_TYPE || ' '||R.TO_WHOM|| '    '||R.CH_DATE||'    '||R.CH_AMOUNT);
		END LOOP;	
		
	ELSE
		DBMS_OUTPUT.PUT_LINE('Wrong Password.');
	END IF;
	
 END clientHistory;
 /
 
 

 BEGIN
	clientHistory('&User_ID', '&Password');
 END;
 /