CREATE OR REPLACE VIEW aProfile(id,name,pass,amount,address) as
SELECT * from agent;

CREATE OR REPLACE PROCEDURE profileA(ida in main.m_id%TYPE, pass in main.mpass%TYPE)
 IS
	pass1 main.mpass%TYPE;
 BEGIN
	select apass into pass1 from agent where aid = ida;
	IF pass = pass1 then
		DBMS_OUTPUT.PUT_LINE('AccountNo    Password     Name        Balance      Address');
		DBMS_OUTPUT.PUT_LINE('---------    --------     ----        -------      -------');
		FOR R IN(SELECT * FROM aProfile WHERE id = ida) LOOP
			DBMS_OUTPUT.PUT_LINE(R.id || '  '||R.pass|| '         '||R.name||'  '||R.amount||'        '||R.address);
		END LOOP;
			
	ELSE
		DBMS_OUTPUT.PUT_LINE('Wrong Password.');
	END IF;
	
 EXCEPTION
	WHEN NO_DATA_FOUND THEN
		DBMS_OUTPUT.PUT_LINE('Mobile Number is incorrect.');
 END profileA;
 /
 
 SET VERIFY OFF;
 SET SERVEROUTPUT ON;

 BEGIN
	profileA('&user_id', '&password');
 END;
 /