create or replace package XT_HTTP is
  /**
   * @Author  Sayan MALAKSHINOV [ @xtender ] {sayan~[dog]~orasql.org}
   * @version 0.2
   */
  C_DEFAULT_TIMEOUT constant number := 5000; -- 5 seconds
  
  CANON_EQ          constant number := 128;
  CASE_INSENSITIVE  constant number := 2;
  COMMENTS          constant number := 4;
  DOTALL            constant number := 32;
   MULTILINE         constant number := 8;
	UNICODE_CAS       constant number := 64;
	UNIX_LINES        constant number := 1;
   
  /** String is too big for varchar2(4000) */
  E_STRING_TOO_BIG exception;
    pragma EXCEPTION_INIT(E_STRING_TOO_BIG, -932);
 /**
  * Get page as CLOB. 
  * @param pURL       Page URL
  * @param pTimeout   timeout in milliseconds.
  */
  function get_page(
              pURL         varchar2, 
              pTimeout     number   default C_DEFAULT_TIMEOUT,
              pMethod      varchar2 default 'GET',
              pArguments   varchar2 default null)
  return clob;

 /**
  * Get page as varchar2(max=4000 chars)
  * @param pURL       Page URL
  * @param pTimeout   timeout in milliseconds.
  */
  function get_page_as_string(
              pURL         varchar2, 
              pTimeout     number   default C_DEFAULT_TIMEOUT,
              pMethod      varchar2 default 'GET',
              pArguments   varchar2 default null)
  return varchar2;
    
 /**
  * Split page by regexp delimiter. Returns collection( table of varchar2(4000) )
  * @param pURL          Page URL
  * @param pTimeout      timeout in milliseconds.
  * @param pDelimRegexp  delimiter pattern
  * @return varchar2_table
  */
  function split (
              pURL         varchar2, 
              pTimeout     number   default C_DEFAULT_TIMEOUT, 
              pDelimRegexp varchar2 default '\',
              pMaxCount    number   default 0,
              pMethod      varchar2 default 'GET',
              pArguments   varchar2 default null)
    return varchar2_table;

 /**
  * Split page by regexp delimiter. Returns collection( table of CLOB )
  * @param pURL          Page URL
  * @param pTimeout      Timeout in milliseconds.
  * @param pDelimRegexp  Delimiter pattern
  * @return clob_table
  */
  function split_clob(
              pURL         varchar2, 
              pTimeout     number   default C_DEFAULT_TIMEOUT, 
              pDelimRegexp varchar2 default '\n',
              pMaxCount    number   default 0,
              pMethod      varchar2 default 'GET',
              pArguments   varchar2 default null)
    return clob_table;

 /**
  * Returns matches by PCRE regular expression
  * @param pUrl      Page URL
  * @param pPattern  Regular expression
  * @param pTimeout  Timeout in milliseconds.
  * @param pGroup    Subexpression group. 0 - whole matched string
  * @param pMaxCount Max number of matched groups. 0 - return all.
  * @param pCANON_EQ          regexp modifier
  * @param pCASE_INSENSITIVE  regexp modifier
  * @param pCOMMENTS          regexp modifier
  * @param pDOTALL            regexp modifier
  * @param pMULTILINE         regexp modifier
  * @param pUNICODE_CAS       regexp modifier
  * @param pUNIX_LINES        regexp modifier
  */
  function get_matches(
              pUrl         varchar2,
              pPattern     varchar2,
              pTimeout     number default C_DEFAULT_TIMEOUT,
              pMethod      varchar2 default 'GET',
              pArguments   varchar2 default null,
              pGroup       number default 0,
              pMaxCount    number default 0,
                 pCANON_EQ number default 0,
                 pCASE_INSENSITIVE number default 0,
                 pCOMMENTS         number default 0,
                 pDOTALL           number default 0,
                 pMULTILINE        number default 0,
                 pUNICODE_CAS      number default 0,
                 pUNIX_LINES       number default 0)
    return varchar2_table;
 /**
  * Return HTTP response code
  * @return int HTTP response code. 200 - ok, 404 - not found, etc...
  */
  function get_last_response
    return number
    IS LANGUAGE JAVA
    name 'org.orasql.xt_http.XT_HTTP.getLastResponse() return int';

end XT_HTTP;
/
create or replace package body XT_HTTP is
/**
 * java: getPage
 */
  function get_page_j(
              pURL         varchar2, 
              pTimeout     number,
              pMethod      varchar2,
              pArguments   varchar2)
  return clob
    IS LANGUAGE JAVA
    name 'org.orasql.xt_http.XT_HTTP.getPage(java.lang.String, int, java.lang.String, java.lang.String) return oracle.sql.CLOB';

/** With default parameters: */
  function get_page(
              pURL         varchar2, 
              pTimeout     number,
              pMethod      varchar2 default 'GET',
              pArguments   varchar2 default null)
  return clob
  is
  begin
     return get_page_j(pURL, pTimeout, pMethod, pArguments);
  end get_page;

/** JAVA: getPageAsString */
  function get_page_as_string_j(
              pURL         varchar2, 
              pTimeout     number,
              pMethod      varchar2,
              pArguments   varchar2)
  return varchar2
    IS LANGUAGE JAVA
    name 'org.orasql.xt_http.XT_HTTP.getPageAsString(java.lang.String, int, java.lang.String, java.lang.String) return java.lang.String';

  function get_page_as_string(
              pURL         varchar2, 
              pTimeout     number,
              pMethod      varchar2 default 'GET',
              pArguments   varchar2 default null)
  return varchar2 is
  begin
     return get_page_as_string_j(pURL, pTimeout, pMethod, pArguments);
  end get_page_as_string;

/**
 * function split. Split string by regexp and returns 
 */
  function split_j (
              pURL          varchar2, 
              pDelimRegexp  varchar2, 
              pMaxCount     number, 
              pTimeout      number,
              pMethod       varchar2,
              pArguments    varchar2)
  return varchar2_table
    IS LANGUAGE JAVA
    name 'org.orasql.xt_http.XT_HTTP.split(java.lang.String,java.lang.String,int,int,java.lang.String,java.lang.String) return oracle.sql.ARRAY';

/**
 * function split. Split string by regexp and returns 
 */
  function split_j_clob (
              pURL          varchar2, 
              pDelimRegexp  varchar2, 
              pMaxCount     number, 
              pTimeout      number,
              pMethod       varchar2,
              pArguments    varchar2)
   return clob_table
    IS LANGUAGE JAVA
    name 'org.orasql.xt_http.XT_HTTP.splitClob(java.lang.String,java.lang.String,int,int,java.lang.String,java.lang.String) return oracle.sql.ARRAY';

  function split (
              pURL         varchar2, 
              pTimeout     number   default C_DEFAULT_TIMEOUT, 
              pDelimRegexp varchar2 default '\',
              pMaxCount    number   default 0,
              pMethod      varchar2 default 'GET',
              pArguments   varchar2 default null)
    return varchar2_table is
      res varchar2_table;
    begin
       res:= split_j(pURL, pDelimRegexp, pMaxCount, pTimeout, pMethod, pArguments);
       return res;
    exception 
       when E_STRING_TOO_BIG then
          raise_application_error(-20000 , 'One of the strings is too big for varchar2(4000). Use split_clob instead.');
    end split;
    
  function split_clob(
              pURL         varchar2, 
              pTimeout     number   default C_DEFAULT_TIMEOUT, 
              pDelimRegexp varchar2 default '\n',
              pMaxCount    number   default 0,
              pMethod      varchar2 default 'GET',
              pArguments   varchar2 default null)
    return clob_table is
    begin
       return split_j_clob(pURL, pDelimRegexp, pMaxCount, pTimeout, pMethod, pArguments);
    end split_clob;

/**
 * function  get_matches
 */
  function get_matches_j(
              pUrl         varchar2,
              pTimeout     number,
              pMethod      varchar2,
              pArguments   varchar2, 
              pPattern     varchar2,
              pGroup       number, 
              pFlags       number,
              pMaxCount    number)
    return varchar2_table
    IS LANGUAGE JAVA
    name 'org.orasql.xt_http.XT_HTTP.getMatches(java.lang.String,int,java.lang.String,java.lang.String,java.lang.String,int,int,int) return oracle.sql.ARRAY';

/**
 * get_matches
 */
  function get_matches(
              pUrl         varchar2,
              pPattern     varchar2,
              pTimeout     number default C_DEFAULT_TIMEOUT,
              pMethod      varchar2 default 'GET',
              pArguments   varchar2 default null,
              pGroup       number default 0,
              pMaxCount    number default 0,
                 pCANON_EQ number default 0,
                 pCASE_INSENSITIVE number default 0,
                 pCOMMENTS         number default 0,
                 pDOTALL           number default 0,
                 pMULTILINE        number default 0,
                 pUNICODE_CAS      number default 0,
                 pUNIX_LINES       number default 0)
    return varchar2_table is
    lFlags number;
    begin
      lFlags:=case when pCANON_EQ        >0 then CANON_EQ          else 0 end+
               case when pCASE_INSENSITIVE>0 then CASE_INSENSITIVE else 0 end+
               case when pCOMMENTS        >0 then COMMENTS         else 0 end+
               case when pDOTALL          >0 then DOTALL           else 0 end+
               case when pMULTILINE       >0 then MULTILINE        else 0 end+
               case when pUNICODE_CAS     >0 then UNICODE_CAS      else 0 end+
               case when pUNIX_LINES      >0 then UNIX_LINES       else 0 end;
      return get_matches_j(pUrl,pTimeout,pMethod,pArguments,pPattern,pGroup,lFlags,pMaxCount);
    end get_matches; 
    
end XT_HTTP;
/
