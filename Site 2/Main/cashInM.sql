CREATE OR REPLACE PROCEDURE cashInM(id in main.m_id%TYPE, pass in main.mpass%TYPE,amount in main.mamount%TYPE)
 IS
	m_amount integer;
	pass1 main.mpass%TYPE;
	date1 varchar2(20);
 BEGIN
	select mpass into pass1 from main where m_id = id;
	IF pass = pass1 then
		select to_char(systimestamp,'DD-MON-YYYY HH24:MI:SS') into date1 from dual;
		select mamount into m_amount from main where m_id = id;
		m_amount := m_amount + amount;
		UPDATE main set mamount = m_amount where m_id = id;
		insert into mhistory(mh_id,m_id,mh_date,to_whom,mh_amount,mh_type) values(mh_id.nextval,id,date1,id,amount,'Cash IN      ');
		commit;
		DBMS_OUTPUT.PUT_LINE('Cash In Successful.');
	ELSE
		DBMS_OUTPUT.PUT_LINE('Wrong Password.');
	END IF;
	
 EXCEPTION
	WHEN NO_DATA_FOUND THEN
		DBMS_OUTPUT.PUT_LINE('Invalid User ID.');
 
 END cashInM;
 /
 
 SET VERIFY OFF;
 BEGIN
	cashInM('&user_id', '&password', &amount);
 END;
 /