-- Agent sending money to share holders --
-- sendMoneyAM(id,pass,amount,to)
-- sendMoneAM('01758000001','4561',500,'01758069883')

CREATE OR REPLACE FUNCTION sendMoney(id in client.cid%TYPE, pass in client.cpass%TYPE,amount in client.camount%TYPE, to_w in mhistory.to_whom%TYPE)
 RETURN number
 IS
	pass1 client.cpass%TYPE;
	c_amount client.camount%TYPE;
	a_amount client.camount%TYPE;
	date1 varchar2(20);
	tableNameT varchar2(25) := 'null';
	tableNameH varchar2(25);
	rowNameI varchar2(25);
	rowNameA varchar2(25);
	
 BEGIN
	
	FOR R in ( Select cid from client@site_1 where cid = to_w ) LOOP
		tableNameT := 'client@site_1';
		tableNameH := 'chistory@site_1';
		rowNameI := 'cid';
		rowNameA := 'camount';
	END LOOP;
	FOR R in ( Select cid from client where cid = to_w ) LOOP
		tableNameT := 'client';
		tableNameH := 'chistory@site_1';
		rowNameI := 'cid';
		rowNameA := 'camount';
	END LOOP;
	FOR R in ( Select aid from agent where aid = to_w ) LOOP
		tableNameT := 'agent';
		tableNameH := 'ahistory';
		rowNameI := 'aid';
		rowNameA := 'aamount';
	END LOOP;
	FOR R in ( Select m_id from main where m_id = to_w ) LOOP
		tableNameT := 'main';
		tableNameH := 'mhistory';
		rowNameI := 'm_id';
		rowNameA := 'mamount';
	END LOOP;
	IF tableNameT = 'null' THEN
		DBMS_OUTPUT.PUT_LINE('Wrong Customer ID.');
		return 2;
	END IF;

	select apass into pass1 from agent where aid = id;
	
	IF pass = pass1 then
		select to_char(systimestamp,'DD-MON-YYYY HH24:MI:SS') into date1 from dual;
		select aamount into a_amount from agent where aid = id;
		EXECUTE IMMEDIATE 'select ' || rowNameA ||' from ' || tableNameT || ' where ' || rowNameI ||' = ' || to_w into  c_amount;
		IF (amount + 5 <= a_amount ) THEN
			IF tableNameH != 'mhistory' then
				a_amount := a_amount - amount -5;
			ELSE
				a_amount := a_amount - amount;
			END IF;
			c_amount := c_amount + amount;
			update agent set aamount = a_amount where aid = id;
			EXECUTE IMMEDIATE 'update ' || tableNameT || ' set ' || rowNameA || ' = ' || c_amount || ' where ' || rowNameI ||' = ' || to_w;
			insert into ahistory(ah_id,aid,ah_date,to_whom,ah_amount,ah_type) values(ah_id.nextval,id,date1,to_w,amount,'Send To      ');
			
			IF tableNameH = 'chistory@site_1' then
				insert into chistory@site_1(ch_id,cid,ch_date,to_whom,ch_amount,ch_type) values(ch_id.nextval@site_1,to_w,date1,id,amount,'Received From');
			ELSIF tableNameH = 'ahistory' then
				insert into ahistory(ah_id,aid,ah_date,to_whom,ah_amount,ah_type) values(ah_id.nextval,to_w,date1,id,amount,'Received From');
			ELSIF tableNameH = 'mhistory' then
				insert into mhistory(mh_id,m_id,mh_date,to_whom,mh_amount,mh_type) values(mh_id.nextval,to_w,date1,id,amount,'Received From');
			END IF;
			
			IF tableNameH != 'mhistory' then
				insert into profit@site_1(pid, pfrom, pamount,pdate) values(pid.nextval@site_1,id,5,date1);
			END IF;
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
		DBMS_OUTPUT.PUT_LINE('Invalid User ID.');
		return 3;
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


 