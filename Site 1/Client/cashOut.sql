-- Agent sending money to share holders --
-- sendMoneyAM(id,pass,amount,to)
-- sendMoneAM('01758000001','4561',500,'01758069883')

CREATE OR REPLACE FUNCTION cashOutC(id in client.cid%TYPE, pass in client.cpass%TYPE,amount in client.camount%TYPE, to_w in chistory.to_whom%TYPE)
 RETURN number
 IS
	c_amount integer;
	a_amount integer;
	pass1 client.cpass%TYPE;
	date1 varchar2(20);
	tableName varchar2(25) := 'null';
	charge integer := amount * .02;
 BEGIN
	FOR R in ( Select cid from client@site_2 where cid = id ) LOOP
		tableName := 'client@site_2';
	END LOOP;
	FOR R in ( Select cid from client where cid = id ) LOOP
		tableName := 'client';
	END LOOP;
	IF tableName = 'null' then
		DBMS_OUTPUT.PUT_LINE('User ID not Found.');
		return 2;
	END IF;
 
	EXECUTE IMMEDIATE 'select cpass from ' || tableName || ' where cid = ' || id into  pass1;
	IF pass = pass1 then
		select to_char(systimestamp,'DD-MON-YYYY HH24:MI:SS') into date1 from dual;
		select aamount into a_amount from agent@site_2 where aid = to_w;
		EXECUTE IMMEDIATE 'select camount from ' || tableName || ' where cid = ' || id into  c_amount;
		IF (amount + charge <= c_amount ) THEN
			a_amount := a_amount + amount;
			c_amount := c_amount - amount - charge;
			EXECUTE IMMEDIATE 'update ' || tableName || ' set camount = ' || c_amount || ' where cid = ' || id;
			UPDATE agent@site_2 set aamount = a_amount where aid = to_w;
			insert into ahistory@site_2(ah_id,aid,ah_date,to_whom,ah_amount,ah_type) values(ah_id.nextval@site_2,to_w,date1,id,amount,'Cash In From ');
			insert into chistory(ch_id,cid,ch_date,to_whom,ch_amount,ch_type) values(ch_id.nextval,id,date1,to_w,amount,'Cash Out To  ');
			insert into profit(pid, pfrom, pamount,pdate) values(pid.nextval,id,charge,date1);
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
 
 END cashOutC;
 /
 Set SERVEROUTPUT ON;
 SET VERIFY OFF;

 DECLARE
	n number;
 BEGIN
	n := cashOutC('&user_id', '&password', &amount, '&SendTo');
	IF n = 1 then
		DBMS_OUTPUT.PUT_LINE('Cash Out successful.');
	END IF;
 END;
 /
