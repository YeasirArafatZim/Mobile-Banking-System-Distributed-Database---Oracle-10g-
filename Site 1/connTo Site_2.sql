drop database link site_2;

create database link site_2
 connect to system identified by "1002001"
 using '(DESCRIPTION =
       (ADDRESS_LIST =
         (ADDRESS = (PROTOCOL = TCP)
		 (HOST = 192.168.0.4)
		 (PORT = 1522))
       )
       (CONNECT_DATA =
         (SID = XE)
       )
     )'
;  
