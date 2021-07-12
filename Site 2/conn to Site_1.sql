drop database link site_1;

create database link site_1
 connect to system identified by "1002001"
 using '(DESCRIPTION =
       (ADDRESS_LIST =
         (ADDRESS = (PROTOCOL = TCP)
		 (HOST = 192.168.0.5)
		 (PORT = 1522))
       )
       (CONNECT_DATA =
         (SID = XE)
       )
     )'
;  
