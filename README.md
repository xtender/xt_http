# XT_HTTP

XT_HTTP is a package for oracle database with java stored procedures for convenient work with HTTPS as HTTP.

### Functions
####  xt_http.get_page (pURL in varchar2, pTimeout in number) return clob
Returns page by URL as CLOB.
pTimeout - timeout in milliseconds;

#### xt_http.get_page_as_string (pURL in varchar2, pTimeout in number) return varchar2
Returns first 4000 chars of page by URL as varchar2. 

#### xt_http.get_page_as_string (pURL in varchar2, pTimeout in number) return varchar2
Returns first 4000 chars of page by URL as varchar2. 

####   function get_matches(...)
Returns matches by PCRE regular expression

Parameters:
  -    pUrl      varchar2                 -- Page URL
  -    pPattern  varchar2                 -- Regular expression
  -    pTimeout  number default 5 seconds -- Timeout in milliseconds,
  -    pGroup    number default 0         -- Subexpression group, 0 - whole matched expression
  -    pMaxCount number default 0         -- Max number of matched groups. 0 - return all.
  -        pCANON_EQ                         regexp modifier
  -        pCASE_INSENSITIVE                 regexp modifier
  -        pCOMMENTS                         regexp modifier
  -        pDOTALL                           regexp modifier
  -        pMULTILINE                        regexp modifier
  -        pUNICODE_CAS                      regexp modifier
  -        pUNIX_LINES                       regexp modifier


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

### DeInstallation

Execute deinstall.sql within SQL*Plus:

```sql
SQL> @deinstall.sql
```

[orasql.org][1]

[1]:http://orasql.org
