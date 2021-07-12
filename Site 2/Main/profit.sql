CREATE OR REPLACE PROCEDURE profitM(id1 in main.m_id%TYPE, pass in main.mpass%TYPE)
 IS
	pass1 main.mpass%TYPE;
    tProfit main.mamount%TYPE;
 BEGIN
	select mpass into pass1 from main where m_id = id1;
	IF pass = pass1 then
		DBMS_OUTPUT.PUT_LINE('ID    Date      Time        From         Amount');
		DBMS_OUTPUT.PUT_LINE('--  --------   -----        ----         ------');
		FOR R IN(select * from profit@site_1) LOOP
			DBMS_OUTPUT.PUT_LINE(R.pid || '  '||R.pdate|| '     '||R.pfrom||'    '||R.pamount);
		END LOOP;
		SELECT SUM(PAMOUNT) INTO tProfit FROM PROFIT@SITE_1;
		DBMS_OUTPUT.PUT_LINE('
			Total Profit : ' || tProfit);
	ELSE
		DBMS_OUTPUT.PUT_LINE('Wrong Password.');
	END IF;
	
 EXCEPTION
	WHEN NO_DATA_FOUND THEN
		DBMS_OUTPUT.PUT_LINE('Mobile Number is incorrect.');
 END profitM;
 /
 
 SET VERIFY OFF;
 SET SERVEROUTPUT ON;

 BEGIN
	profitM('&user_id', '&password');
 END;
 /