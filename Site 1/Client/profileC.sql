CREATE OR REPLACE VIEW cProfile(id,name,pass,amount,address) as
SELECT * from client union select * from client@site_2;

CREATE OR REPLACE PROCEDURE profileC(id1 in client.cid%TYPE, pass in client.cpass%TYPE)
 IS
	pass1 client.cpass%TYPE;
 BEGIN
	select pass into pass1 from cProfile where id = id1;
	IF pass = pass1 then
		DBMS_OUTPUT.PUT_LINE('AccountNo    Password     Name           Balance      Address');
		DBMS_OUTPUT.PUT_LINE('---------    --------     ----           -------      -------');
		FOR R IN(SELECT * FROM cProfile WHERE id = id1) LOOP
			DBMS_OUTPUT.PUT_LINE(R.id || '  '||R.pass|| '         '||R.name||'    '||R.amount||'        '||R.address);
		END LOOP;
			
	ELSE
		DBMS_OUTPUT.PUT_LINE('Wrong Password.');
	END IF;
	
 EXCEPTION
	WHEN NO_DATA_FOUND THEN
		DBMS_OUTPUT.PUT_LINE('Mobile Number is incorrect.');
 END profileC;
 /
 
 SET VERIFY OFF;
 SET SERVEROUTPUT ON;

 BEGIN
	profileC('&user_id', '&password');
 END;
 /