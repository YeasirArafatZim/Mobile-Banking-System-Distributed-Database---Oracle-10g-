-- Agent sending money to share holders --
-- sendMoneyAM(id,pass,amount,to)
-- sendMoneAM('01758000001','4561',500,'01758069883')

CREATE OR REPLACE FUNCTION sendMoneyAC(id in main.m_id%TYPE, pass in main.mpass%TYPE,amount in main.mamount%TYPE, to_w in mhistory.to_whom%TYPE)
 RETURN number
 IS
	c_amount integer;
	a_amount integer;
	pass1 main.mpass%TYPE;
	date1 varchar2(20);
	tableName varchar2(25);
 BEGIN
 
	FOR R in ( Select cid from client@site_1 where cid = to_w ) LOOP
		tableName := 'client@site_1';
	END LOOP;
	FOR R in ( Select cid from client where cid = to_w ) LOOP
		tableName := 'client';
	END LOOP;
	
	
	select apass into pass1 from agent where aid = id;
	IF pass = pass1 then
		select to_char(systimestamp,'DD-MON-YYYY HH24:MI:SS') into date1 from dual;
		select aamount into a_amount from agent where aid = id;
		EXECUTE IMMEDIATE 'select camount from ' || tableName || ' where cid = ' || to_w into  c_amount;
		IF (amount + 5 <= a_amount ) THEN
			a_amount := a_amount - amount - 5;
			c_amount := c_amount + amount;
			EXECUTE IMMEDIATE 'update ' || tableName || ' set camount = ' || c_amount || ' where cid = ' || to_w;
			UPDATE agent set aamount = a_amount where aid = id;
			insert into ahistory(ah_id,aid,ah_date,to_whom,ah_amount,ah_type) values(ah_id.nextval,id,date1,to_w,amount,'Send To      ');
			insert into chistory@site_1(ch_id,cid,ch_date,to_whom,ch_amount,ch_type) values(ch_id.nextval@site_1,to_w,date1,id,amount,'Received From');
			insert into profit@site_1(pid,pfrom,pamount,pdate) values (pid.nextval@site_1,id,5,date1);
			commit;
			return 1;
		ELSE
			DBMS_OUTPUT.PUT_LINE('You do not have Sufficient Balance.');
			return 4;
		END IF;
	ELSE
		DBMS_OUTPUT.PUT_LINE('Wrong Password.');
		return 2;
	END IF;
	
 EXCEPTION
	WHEN NO_DATA_FOUND THEN
		DBMS_OUTPUT.PUT_LINE('Mobile Number is incorrect.');
		return 3;
 
 END sendMoneyAC;
 /
 
 SET VERIFY OFF;
 SET SERVEROUTPUT ON;

 DECLARE
	n number;
 BEGIN
	n := sendMoneyAC('&user_id', '&password', &amount, '&SendTo');
	IF n = 1 then
		DBMS_OUTPUT.PUT_LINE('Send Money successful.');
	END IF;
 END;
 /


 