# XT_HTTP

XT_HTTP is a package for oracle database with java stored procedures for convenient work with HTTPS as HTTP.

### Functions
####  xt_http.get_page(URL in varchar2) return clob
Returns page by URL as CLOB;

#### xt_http.get_string(URL in varchar2) return varchar2
Returns first 4000 chars of page by URL as varchar2. 


  - Type some Markdown on the left
  - See HTML in the right
  - Magic

Markdown is a lightweight markup language based on the formatting conventions that people naturally use in email.  As [John Gruber] writes on the [Markdown site][df1]

### Installation

Execute install.sql within SQL*Plus:

```sql
SQL> @install.sql
```
or manually execute:
```sql
SQL> @xt_http.jsp;
SQL> @xt_http.package.sql;
```

You need to grant "java.net.SocketPermission" for users for each site or for all sites. 
For https: 

```sql
dbms_java.grant_permission(
   grantee           => 'XTENDER'                       -- username
 , permission_type   => 'SYS:java.net.SocketPermission' -- connection permission
 , permission_name   => 'ya.ru:443'                     -- connection address and port
 , permission_action => 'connect,resolve'               -- types
);
```

[orasql.org][1]

[1]:http://orasql.org
