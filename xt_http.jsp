create or replace and compile java source named xt_http as
package org.orasql.xt_http;

import java.io.DataOutputStream;
import java.sql.SQLException;
import java.util.*;
import java.util.regex.*;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.HttpURLConnection;

import java.sql.Connection;
import oracle.jdbc.driver.*;
import oracle.sql.*;


public class XT_HTTP {

    private static Connection   CONNECTION      = getConnection();
    private static String       USER_AGENT      = "Mozilla/5.0";
    private static String       ACCEPT_LANGUAGE = "en-US,en;q=0.5";
    private static int          lastResponse    = 0;

    public static void main(String[] args) {
        // write your code here
        //System.out.println(get("https://community.oracle.com/voting-history.jspa?ideaID=6899&start=0&numResults=1000"));
        try {
            System.out.println(getPage("http://ya.ru",3000,null,null));
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }


    /** Helpers: */
    private static CLOB strToClob(String str)
            throws java.sql.SQLException {
        CLOB result         = CLOB.createTemporary(CONNECTION, false, CLOB.DURATION_CALL);
        result.setString(1,str);
        return result;
    }

    private static CLOB[] strToClobArray ( java.lang.String str)
            throws java.sql.SQLException {
        CLOB[] clobTable = new CLOB[1];
        clobTable[0].setString(1, str);
        return clobTable;
    }

    private static CLOB[] strArrayToClobArray ( java.lang.String[] strArray )
            throws java.sql.SQLException {
        CLOB[] clobTable = new CLOB[strArray.length];
        for(int i=0; i < strArray.length; i++) {
            clobTable[i] = CLOB.createTemporary(CONNECTION, false, CLOB.DURATION_CALL);
            clobTable[i].setString(1, strArray[i]);
        }
        return clobTable;
    }

    private static oracle.sql.ARRAY strArrayToVarchar2Table( java.lang.String[] strArray )
            throws java.sql.SQLException {
        ArrayDescriptor descriptor = ArrayDescriptor.createDescriptor("VARCHAR2_TABLE", CONNECTION );
        return new oracle.sql.ARRAY(descriptor,CONNECTION,strArray);
    }

    private static oracle.sql.ARRAY strArrayToClobTable( java.lang.String[] strArray )
            throws java.sql.SQLException {
        ArrayDescriptor descriptor = ArrayDescriptor.createDescriptor("CLOB_TABLE", CONNECTION );

        oracle.sql.ARRAY outArray = new oracle.sql.ARRAY(descriptor,CONNECTION,strArrayToClobArray(strArray));
        return outArray;
    }

    /**
     * Return default oracle connection.
     * @return default oracle connection
     */
    private static Connection getConnection() {
        try {
            return new OracleDriver().defaultConnection();
        } catch (SQLException e) {
            return null;
        }
    }

    /** get Page as String */
    private static String get(String sURL, int timeout, String httpMethod, String urlParameters) {
        String result="";
        try {
            URL url = new URL(sURL);
            HttpURLConnection con = (HttpURLConnection)url.openConnection();

            con.setConnectTimeout(timeout);
            if(httpMethod != null) {
                con.setRequestMethod(httpMethod);
            }else{
                con.setRequestMethod("GET");
            }
            con.setRequestProperty("User-Agent", USER_AGENT);
            con.setRequestProperty("Accept-Language", ACCEPT_LANGUAGE);

            if(httpMethod == "POST" && urlParameters != null) {
                // Send post request
                con.setDoOutput(true);
                DataOutputStream wr = new DataOutputStream(con.getOutputStream());
                wr.writeBytes(urlParameters);
                wr.flush();
                wr.close();
            }

            lastResponse = con.getResponseCode();

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
                result = sb.toString();
            }
        } catch (MalformedURLException e) {
            return e.getMessage();
        } catch (IOException e) {
            return e.getMessage();
        }
        return result;
    }

    public static int getLastResponse(){
        return lastResponse;
    }

    /**
     * Function getPage
     * @param sURL Page URL
     * @return String
     */
    public static CLOB getPage(java.lang.String sURL, int timeout, java.lang.String httpMethod, java.lang.String urlParameters)
            throws java.sql.SQLException {
        return strToClob( get( sURL, timeout, httpMethod, urlParameters ));
    }

    public static java.lang.String getPageAsString(java.lang.String sUrl, int timeout, java.lang.String httpMethod, java.lang.String urlParameters) {
        return get(sUrl,timeout,httpMethod,urlParameters).substring(0,3999);
    }

    /**
     * Simple regexp split with count - java.lang.String.split
     */
    public static oracle.sql.ARRAY split(
            java.lang.String pUrl,
            java.lang.String pDelim,
            int              pMaxCount,
            int              timeout,
            java.lang.String httpMethod,
            java.lang.String urlParameters)
            throws java.sql.SQLException {
        try{
            if (pDelim==null)  pDelim="";
            java.lang.String[] retArray = new java.lang.String[0];

            java.lang.String   pStr     = get(pUrl,timeout,httpMethod,urlParameters);
            if (pStr == null)
                return strArrayToVarchar2Table(retArray);
            retArray = pStr.split(pDelim,pMaxCount);

            //if (retArray.length==1)
            //   return null;
            return strArrayToVarchar2Table(retArray);
        }catch(java.sql.SQLException e) {
            java.lang.String[] retArray = new java.lang.String[1];
            retArray[0] = e.getMessage();
            return strArrayToVarchar2Table(retArray);
        }
    }

    public static oracle.sql.ARRAY splitClob(
            java.lang.String    pUrl,
            java.lang.String    pDelim,
            int                 pMaxCount,
            int                 timeout,
            java.lang.String    httpMethod,
            java.lang.String    urlParameters)
            throws java.sql.SQLException
    {
        try{
            java.lang.String pStr = get(pUrl,timeout,httpMethod,urlParameters);
            java.lang.String[] retArray = new java.lang.String[0];
            if (pDelim==null) pDelim="";
            if (pStr!=null)
                retArray = pStr.split(pDelim,pMaxCount);

            return strArrayToClobTable(retArray);
        } catch(Exception e) {
            java.lang.String[] retArray = new java.lang.String[0];
            retArray[0] = e.getMessage();
            return strArrayToClobTable(retArray);
        }
    }

    /**
     * Function returns regexp matches with limit
     */
    public static oracle.sql.ARRAY getMatches(
            java.lang.String sUrl,
            int              timeout,
            java.lang.String httpMethod,
            java.lang.String urlParameters,
            java.lang.String pPattern,
            int              pGroup,
            int              pFlags,
            int              pMaxCount)
            throws java.sql.SQLException
    {
        java.lang.String pStr = get(sUrl,timeout,httpMethod,urlParameters);
        List list = new ArrayList();
        if(pPattern==null) pPattern="";
        if(pStr==null) pStr="";
        Pattern p = Pattern.compile(pPattern,pFlags);
        Matcher m = p.matcher(pStr);
        StringBuffer sb = new StringBuffer();
        int i=0;
        while(m.find() && (pMaxCount==0 || i++<pMaxCount)){
            list.add(m.group(pGroup));
        }

        ArrayDescriptor descriptor =
                ArrayDescriptor.createDescriptor("VARCHAR2_TABLE", CONNECTION );
        oracle.sql.ARRAY outArray = new oracle.sql.ARRAY(descriptor,CONNECTION,list.toArray());

        return outArray;
    }

    /**
     * Function returns joined regexp matches
     */
    public static java.lang.String joinMatches(
            java.lang.String sUrl,
            int              timeout,
            java.lang.String httpMethod,
            java.lang.String urlParameters,
            java.lang.String pPattern,
            int              pGroup,
            int              pFlags,
            java.lang.String pDelim)
            throws java.sql.SQLException
    {
        String pStr = get(sUrl,timeout,httpMethod,urlParameters);
        if(pPattern==null) pPattern="";
        if(pStr==null) pStr="";
        Pattern p = Pattern.compile(pPattern,pFlags);
        Matcher m = p.matcher(pStr);
        StringBuffer sb = new StringBuffer();

        boolean b=m.find();
        while(b){
            sb.append(m.group(pGroup));
            b=m.find();
            if (b) sb.append(pDelim);
        }
        return sb.toString();
    }
}
/
