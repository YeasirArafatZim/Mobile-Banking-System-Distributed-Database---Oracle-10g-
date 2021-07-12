clear screen;

--delete existing table
drop table agent cascade constraints;
drop table main cascade constraints;
drop table ahistory cascade constraints;
drop table mhistory cascade constraints;
drop table client cascade constraints;
drop sequence ah_id;
drop sequence mh_id;

--Create Table agent, main
create table agent(
aid      varchar2(15) not null, 
aname    varchar2(30) not null, 
apass    varchar2(30) not null, 
aamount  integer not null,
aaddress varchar2(30) not null, 
		 PRIMARY KEY (aid)
);

-- Share Holders table
create table main(
m_id      varchar2(15) not null, 
mname    varchar2(30) not null, 
mpass    varchar2(30) not null, 
mamount  integer not null,
maddress varchar2(30) not null, 
		 PRIMARY KEY (m_id)
);

-- fragment of Client table
create table client(
cid      varchar2(15) not null,
cname    varchar2(30) not null, 
cpass    varchar2(30) not null, 
camount  integer not null,
caddress varchar2(30) not null,
		 PRIMARY KEY (cid)
);

-- insert into main table
insert into main values('01758069883','Yeasir Arafat','1002001',200000,'Malotinagar, Bogra');

-- insert into agent table
insert into agent values('01758000001','Kabir Sigh','4561',0,'Vat kandi, Rajshahi');
insert into agent values('01758000002','Ramim Mahbub','4562',0,'Koshai potti, Dhaka');
insert into agent values('01758000003','Ranbir shartho','4563',0,'Fultola, Bogra');
insert into agent values('01758000004','Hosne Mubarak','4564',0,'Rohoman Nogor,Bogra');
insert into agent values('01758000005','Salil Chakma','4565',0,'sholalpara, Chittagang');

-- insert into client
insert into client values('01751000004','Shahabuddin Shaon','1234',0,'Bogra');
insert into client values('01751000005','Sadat Sadik','1235',0,'Sylhet');
insert into client values('01751000006','Sadat Sadik','1236',0,'Rajshahi');




-- Agent History
create table ahistory(
ah_id      number,
aid        varchar2(15) not null,
ah_date    varchar2(20) not null,
to_whom      varchar2(15) not null,
ah_amount  integer not null,
ah_type    varchar2(15) not null,
		PRIMARY KEY (ah_id),
		FOREIGN KEY(aid) REFERENCES agent(aid)
);
-- for identity value of ach_id
create sequence ah_id minvalue 1 start with 1; 


-- Main History
create table mhistory(
mh_id      number,
m_id        varchar2(15) not null,
mh_date    varchar2(20) not null,
to_whom      varchar2(15) not null,
mh_amount  integer not null,
mh_type    varchar2(15) not null,
		PRIMARY KEY (mh_id),
		FOREIGN KEY(m_id) REFERENCES main(m_id)
);
-- for identity value of amh_id
create sequence mh_id minvalue 1 start with 1;
commit;
