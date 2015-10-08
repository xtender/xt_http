doc
Grants example:
begin
   dbms_java.grant_permission( 'XTENDER', 'SYS:java.net.SocketPermission', 'ya.ru:443', 'connect,resolve' );
   --dbms_java.grant_permission( 'XTENDER', 'SYS:java.net.SocketPermission', '*', 'connect,resolve' );
end;
/
#