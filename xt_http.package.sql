create or replace package XT_HTTP is

  -- Author  : Sayan MALAKSHINOV aka xtender
  -- Mailto  : sayan@orasql.org
  
  CANON_EQ          constant number := 128;
  CASE_INSENSITIVE  constant number := 2;
  COMMENTS          constant number := 4;
  DOTALL            constant number := 32;
   MULTILINE         constant number := 8;
	UNICODE_CAS       constant number := 64;
	UNIX_LINES        constant number := 1;
   

  E_STRING_TOO_BIG exception;
    pragma EXCEPTION_INIT(E_STRING_TOO_BIG, -932);
/**
 * Get page as CLOB
 */
  function get_page(pURL varchar2)
    return clob
    IS LANGUAGE JAVA
    name 'org.orasql.xt_http.XT_HTTP.getPage(java.lang.String) return oracle.sql.CLOB';

/**
 * Get page as varchar2(max=4000 chars)
 */
  function get_string(pURL varchar2)
    return varchar2
    IS LANGUAGE JAVA
    name 'org.orasql.xt_http.XT_HTTP.getString(java.lang.String) return java.lang.String';
    
/**
 * function split. Split string by regexp and returns 
 */
  function split_j(pURL varchar2, pDelimRegexp varchar2, pMaxCount number)
    return varchar2_table
    IS LANGUAGE JAVA
    name 'org.orasql.xt_http.XT_HTTP.split(java.lang.String,java.lang.String,int) return oracle.sql.ARRAY';

  function split(pURL varchar2,pDelimRegexp varchar2,pMaxCount number default 0)
    return varchar2_table;

end XT_HTTP;
/
create or replace package body XT_HTTP is

  function split(pURL varchar2,pDelimRegexp varchar2,pMaxCount number default 0)
    return varchar2_table is
      res varchar2_table;
    begin
       res:= split_j(pURL, pDelimRegexp, pMaxCount);
       return res;
    exception 
       when E_STRING_TOO_BIG then
          raise_application_error(20000 , 'One of the strings is too big for varchar2(4000). Use split_clob instead.');
    end split;
    
end XT_HTTP;
