-- Agent sending money to share holders --
-- sendMoneyAM(id,pass,amount,to)
-- sendMoneAM('01758000001','4561',500,'01758069883')

CREATE OR REPLACE FUNCTION sendMoney(id in client.cid%TYPE, pass in client.cpass%TYPE,amount in client.camount%TYPE, to_w in chistory.to_whom%TYPE)
 RETURN number
 IS
	pass1 client.cpass%TYPE;
	c_amount client.camount%TYPE;
	a_amount client.camount%TYPE;
	date1 varchar2(20);
	tableNameF varchar2(25) := 'null';
	tableNameT varchar2(25) := 'null';
	tableNameH varchar2(25);
	rowNameI varchar2(25);
	rowNameA varchar2(25);
	
 BEGIN
 
	FOR R in ( Select cid from client@site_2 where cid = id ) LOOP
		tableNameF := 'client@site_2';
	END LOOP;
	FOR R in ( Select cid from client where cid = id ) LOOP
		tableNameF := 'client';
	END LOOP;
	
	IF tableNameF = 'null' THEN
		DBMS_OUTPUT.PUT_LINE('Wrong user_id');
		return 2;
	END IF;
	
	FOR R in ( Select cid from client@site_2 where cid = to_w ) LOOP
		tableNameT := 'client@site_2';
		tableNameH := 'chistory';
		rowNameI := 'cid';
		rowNameA := 'camount';
	END LOOP;
	FOR R in ( Select cid from client where cid = to_w ) LOOP
		tableNameT := 'client';
		rowNameI := 'cid';
		rowNameA := 'camount';
		tableNameH := 'chistory';
	END LOOP;
	FOR R in ( Select aid from agent@site_2 where aid = to_w ) LOOP
		tableNameT := 'agent@site_2';
		tableNameH := 'ahistory@site_2';
		rowNameI := 'aid';
		rowNameA := 'aamount';
	END LOOP;
	IF tableNameT = 'null' THEN
		DBMS_OUTPUT.PUT_LINE('Wrong Customer ID.');
		return 2;
	END IF;

	
	
	EXECUTE IMMEDIATE 'select cpass from ' || tableNameF || ' where cid = ' || id into  pass1;
	IF pass = pass1 then
		select to_char(systimestamp,'DD-MON-YYYY HH24:MI:SS') into date1 from dual;
		EXECUTE IMMEDIATE 'select camount from ' || tableNameF || ' where cid = ' || id into  c_amount;
		EXECUTE IMMEDIATE 'select ' || rowNameA ||' from ' || tableNameT || ' where ' || rowNameI ||' = ' || to_w into  a_amount;
		IF (amount + 5 <= c_amount ) THEN
			a_amount := a_amount + amount;
			c_amount := c_amount - amount - 5;
			EXECUTE IMMEDIATE 'update ' || tableNameF || ' set camount = ' || c_amount || ' where cid = ' || id;
			EXECUTE IMMEDIATE 'update ' || tableNameT || ' set ' || rowNameA || ' = ' || a_amount || ' where ' || rowNameI ||' = ' || to_w;
			insert into chistory(ch_id,cid,ch_date,to_whom,ch_amount,ch_type) values(ch_id.nextval,id,date1,to_w,amount,'Send To      ');
			
			IF tableNameH = 'ahistory@site_2' then
				insert into ahistory@site_2(ah_id,aid,ah_date,to_whom,ah_amount,ah_type) values(ah_id.nextval@site_2,to_w,date1,id,amount,'Received From');
			ELSE
				insert into chistory(ch_id,cid,ch_date,to_whom,ch_amount,ch_type) values(ch_id.nextval,to_w,date1,id,amount,'Received From');
			END IF;
			insert into profit(pid, pfrom, pamount,pdate) values(pid.nextval,id,5,date1);
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
	
	
 
 
 END sendMoney;
 /
 
 SET VERIFY OFF;
 SET SERVEROUTPUT ON;

 DECLARE
	n number;
 BEGIN
	n := sendMoney('&user_id', '&password', &amount, '&SendTo');
	IF n = 1 then
		DBMS_OUTPUT.PUT_LINE('Send Money successful.');
	END IF;
 END;
 /


 