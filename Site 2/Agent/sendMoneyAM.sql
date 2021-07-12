-- Agent sending money to share holders --
-- sendMoneyAM(id,pass,amount,to)
-- sendMoneAM('01758000001','4561',500,'01758069883')

CREATE OR REPLACE FUNCTION sendMoneyAM(id in main.m_id%TYPE, pass in main.mpass%TYPE,amount in main.mamount%TYPE, to_w in mhistory.to_whom%TYPE)
 RETURN number
 IS
	m_amount integer;
	a_amount integer;
	pass1 main.mpass%TYPE;
	date1 varchar2(20);
 BEGIN
	select apass into pass1 from agent where aid = id;
	IF pass = pass1 then
		select to_char(systimestamp,'DD-MON-YYYY HH24:MI:SS') into date1 from dual;
		select aamount into a_amount from agent where aid = id;
		select mamount into m_amount from main where m_id = to_w;
		IF (amount <= a_amount) THEN
			a_amount := a_amount - amount;
			m_amount := m_amount + amount;
			UPDATE main set mamount = m_amount where m_id = to_w;
			UPDATE agent set aamount = a_amount where aid = id;
			insert into ahistory(ah_id,aid,ah_date,to_whom,ah_amount,ah_type) values(ah_id.nextval,id,date1,to_w,amount,'Send To      ');
			insert into mhistory(mh_id,m_id,mh_date,to_whom,mh_amount,mh_type) values(mh_id.nextval,to_w,date1,id,amount,'Received From');
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
 
 END sendMoneyAM;
 /
 
 SET VERIFY OFF;

 DECLARE
	n number;
 BEGIN
	n := sendMoneyAM('&user_id', '&password', &amount, '&SendTo');
	IF n = 1 then
		DBMS_OUTPUT.PUT_LINE('Send Money successful.');
	END IF;
 END;
 /


 