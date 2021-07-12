CREATE OR REPLACE PROCEDURE registerC(id in client.cid%TYPE, name in client.cname%TYPE, pass in client.cpass%TYPE, conPass in client.cpass%TYPE, address in client.caddress%TYPE)
 IS
	pass1 client.cpass%TYPE;
	temp varchar2(25) := 'Not Found';
 BEGIN
	FOR R in ( Select cid from client@site_2 where cid = id ) LOOP
		temp := 'client@site_2';
	END LOOP;
	FOR R in ( Select cid from client where cid = id ) LOOP
		temp := 'client';
	END LOOP;
	FOR R in ( Select aid from agent@site_2 where aid = id ) LOOP
		temp := 'agent@site_2';
	END LOOP;
	FOR R in ( Select m_id from main@site_2 where m_id = id ) LOOP
		temp := 'agent@site_2';
	END LOOP;
	
	
	IF temp = 'Not Found' then
		IF pass = conPass then
			IF address = 'Dhaka' then
				insert into client values(id,name,pass,0,address);
				DBMS_OUTPUT.PUT_LINE('Registration SUCCESSFUL.');
			ELSE
				insert into client@site_2 values(id,name,pass,0,address);
				DBMS_OUTPUT.PUT_LINE('Registration SUCCESSFUL.');
			END IF;
			
		ELSE
			DBMS_OUTPUT.PUT_LINE('Password did not match.');
		END IF;
	
	ELSE
		DBMS_OUTPUT.PUT_LINE('Phone Number already exits in ' || temp ||' table.');
	
	END IF;
	
 END registerC;
 /
 
 SET VERIFY OFF;
 SET SERVEROUTPUT ON;

 BEGIN
	registerC('&PhoneNumber', '&Name', '&Password','&Confirm_Password','&Address');
 END;
 /