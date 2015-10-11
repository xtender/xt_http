doc
USAGE example:
declare
  c clob;
  s varchar2(8000);
begin
  --- HTTPS - CLOB:
  c := xt_http.get_page(
           pURL     => 'https://google.com',
           pTimeout => 3000/* 3 seconds */
           );
  
  --- HTTPS - varchar2:
  s := xt_http.get_page_as_string(
           pURL     => 'https://google.com',
           pTimeout => 3000/* 3 seconds */
           );
end;
/
-- Return matched expressions:
select * 
from table(
           xt_http.get_matches(
                    pUrl     => 'https://google.com',
                    pPattern => 're..rn',
                    pTimeout => 3000
                    )
           );
/
-- Return matched SUBexpressions:
select * 
from table(
           xt_http.get_matches(
                    pUrl     => 'https://google.com',
                    pPattern => 're(..)rn',
                    pTimeout => 3000,
                    pGroup   => 1 -- subexpression regexp group
                    )
           );
/
#
