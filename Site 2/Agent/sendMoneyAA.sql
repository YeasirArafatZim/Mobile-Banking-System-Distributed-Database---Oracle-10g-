-- Agent sending money to share holders --
-- sendMoneyAM(id,pass,amount,to)
-- sendMoneAM('01758000001','4561',500,'01758069883')

CREATE OR REPLACE FUNCTION sendMoneyAA(id in main.m_id%TYPE, pass in main.mpass%TYPE,amount in main.mamount%TYPE, to_w in mhistory.to_whom%TYPE)
 RETURN number
 IS
	a_amount integer;
	a1_amount integer;
	pass1 main.mpass%TYPE;
	date1 varchar2(20);
 BEGIN
	select apass into pass1 from agent where aid = id;
	IF pass = pass1 then
		select to_char(systimestamp,'DD-MON-YYYY HH24:MI:SS') into date1 from dual;
		select aamount into a_amount from agent where aid = id;
		select aamount into a1_amount from agent where aid = to_w;
		IF (amount + 5 <= a_amount ) THEN
			a_amount := a_amount - amount - 5;
			a1_amount := a1_amount + amount;
			UPDATE agent set aamount = a1_amount where aid = to_w;
			UPDATE agent set aamount = a_amount where aid = id;
			insert into ahistory(ah_id,aid,ah_date,to_whom,ah_amount,ah_type) values(ah_id.nextval,id,date1,to_w,amount,'Send To      ');
			insert into ahistory(ah_id,aid,ah_date,to_whom,ah_amount,ah_type) values(ah_id.nextval,to_w,date1,id,amount,'Received From');
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
 
 END sendMoneyAA;
 /
 
 SET VERIFY OFF;

 DECLARE
	n number;
 BEGIN
	n := sendMoneyAA('&user_id', '&password', &amount, '&SendTo');
	IF n = 1 then
		DBMS_OUTPUT.PUT_LINE('Send Money successful.');
	END IF;
 END;
 /


 