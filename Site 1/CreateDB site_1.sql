clear screen;

--delete existing table
drop table client cascade constraints;
drop table chistory cascade constraints;
drop table profit cascade constraints;
drop sequence ch_id;
drop sequence pid;

--Create Table Client, Client History database
create table client(
cid      varchar2(15) not null,
cname    varchar2(30) not null, 
cpass    varchar2(30) not null, 
camount  integer not null,
caddress varchar2(30) not null,
		 PRIMARY KEY (cid)
);

-- Customer History table
create table chistory(
ch_id      number,
cid        varchar2(15) not null,
ch_date    varchar2(20) not null,
to_whom    varchar2(15) not null,
ch_amount  integer not null,
ch_type    varchar2(15) not null,
		PRIMARY KEY (ch_id)
);
-- for identity value of ch_id
create sequence ch_id minvalue 1 start with 1;


--Insert data into the Client database
insert into client values('01751000001','Karim Haider','1231',0,'Dhaka');
insert into client values('01751000002','Tazkim Ahmed','1232',0,'Dhaka');
insert into client values('01751000003','Fahim Faisal','1233',0,'Dhaka');



create table profit(
pid number,
pFrom varchar2(15) not null,
pAmount integer not null,
pDate varchar2(20),
		PRIMARY KEY (pid)
);

create sequence pid minvalue 1 start with 1;
commit;

