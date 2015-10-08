create or replace and compile java source named xt_http as
package org.orasql.xt_http;

import javax.net.ssl.HttpsURLConnection;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.HttpURLConnection;

import java.sql.Connection;
import oracle.jdbc.driver.*;
import oracle.sql.CLOB;
 

public class XT_HTTP {

   /**
    * Function getPage
    * @param String Page URL
    * @return String
    */
    public static CLOB getPage(java.lang.String sURL)
    throws java.sql.SQLException
     {
        OracleDriver driver = new OracleDriver();
        Connection conn     = driver.defaultConnection();
        CLOB result         = CLOB.createTemporary(conn, false, CLOB.DURATION_CALL);
        result.setString(1," ");
        try {
            URL url = new URL(sURL);
            HttpURLConnection con = (HttpURLConnection)url.openConnection();
            //HttpsURLConnection con = (HttpsURLConnection)url.openConnection();
            if(con!=null){
                BufferedReader br =
                        new BufferedReader(
                                new InputStreamReader(con.getInputStream()));
                StringBuilder sb = new StringBuilder();
                String line;
                while ((line = br.readLine()) != null){
                    sb.append(line);
                }
                br.close();
                result.setString(1,sb.toString());
            }
        } catch (MalformedURLException e) {
            result.setString(1, e.getMessage());
        } catch (IOException e) {
            result.setString(1, e.getMessage());
        }
        return result;
    }
    
    public static java.lang.String getString(java.lang.String sURL) {
        String result="";
        try {
            URL url = new URL(sURL);
            HttpURLConnection con = (HttpURLConnection)url.openConnection();
            if(con!=null){
                BufferedReader br =
                        new BufferedReader(
                                new InputStreamReader(con.getInputStream()));
                StringBuilder sb = new StringBuilder();
                String line;
                while ((line = br.readLine()) != null){
                    sb.append(line);
                }
                br.close();
                result = sb.toString().substring(0,3999);
            }
        } catch (MalformedURLException e) {
            return e.getMessage();
        } catch (IOException e) {
            return e.getMessage();
        }
        return result;
    }
}
/
