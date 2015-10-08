create or replace package XT_HTTP is

  -- Author  : Sayan MALAKSHINOV aka xtender
  -- Mailto  : sayan@orasql.org
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
    
    
end XT_HTTP;
/
