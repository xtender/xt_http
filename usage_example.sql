doc
USAGE example:
declare
  c clob;
  s varchar2(8000);
begin
  --- HTTPS - CLOB:
  c:=xt_http.get_page('https://google.com');
  dbms_output.put_line( substr(c,1,100) );
  --- HTTP - CLOB
  c:=xt_http.get_page('http://ya.ru');
  dbms_output.put_line( substr(c,1,100) );
  
  --- HTTPS - varchar2:
  s:=xt_http.get_string('https://google.com');
  dbms_output.put_line(s);
  --- HTTP - varchar2
  s:=xt_http.get_string('http://ya.ru');
  dbms_output.put_line(s);
end;
/
select length( xt_http.get_page('https://google.com') ) page_size from dual
#