CREATE OR REPLACE VIEW mProfile(id,name,pass,amount,address) as
SELECT * from main;

CREATE OR REPLACE PROCEDURE profileM(id1 in main.m_id%TYPE, pass in main.mpass%TYPE)
 IS
	pass1 main.mpass%TYPE;
 BEGIN
	select mpass into pass1 from main where m_id = id1;
	IF pass = pass1 then
		DBMS_OUTPUT.PUT_LINE('AccountNo    Password     Name           Balance      Address');
		DBMS_OUTPUT.PUT_LINE('---------    --------     ----           -------      -------');
		FOR R IN(SELECT * FROM mProfile WHERE id = id1) LOOP
			DBMS_OUTPUT.PUT_LINE(R.id || '  '||R.pass|| '      '||R.name||'  '||R.amount||'        '||R.address);
		END LOOP;
			
	ELSE
		DBMS_OUTPUT.PUT_LINE('Wrong Password.');
	END IF;
	
 EXCEPTION
	WHEN NO_DATA_FOUND THEN
		DBMS_OUTPUT.PUT_LINE('Mobile Number is incorrect.');
 END profileM;
 /
 
 SET VERIFY OFF;
 SET SERVEROUTPUT ON;

 BEGIN
	profileM('&user_id', '&password');
 END;
 /