/*
@author lijing
@version 1.0 2015年8月6日 下午2:14:10
*/
package com.culturecloud.util;

import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;

import com.alibaba.fastjson.JSONObject;

public class HttpConnectonPost {
	public static HttpResponseText post(String strUrl, JSONObject json) {
		HttpResponseText text=new HttpResponseText();
		HttpURLConnection conn=null;
		String result="";
		try {
			URL url = new URL(strUrl);
			conn = (HttpURLConnection) url.openConnection();
			
			conn.setRequestProperty("Content-Type", "plain/text; charset=UTF-8");  
			conn.setDoOutput(true);
			conn.setDoInput(true);
			conn.setConnectTimeout(10000);
			conn.setRequestMethod("POST");
			conn.connect();
			
			String contentData=URLEncoder.encode(json.toString(),"UTF-8");
			conn.getOutputStream().write(contentData.getBytes());  
		    conn.getOutputStream().flush();  
		    conn.getOutputStream().close(); 
		    
		    InputStream in = conn.getInputStream();  
		    int httpCode = conn.getResponseCode();  
		    text.setHttpCode(httpCode);
		    if(httpCode==200){
		    	byte[] buffer = new byte[1024];  
				StringBuffer sb = new StringBuffer();  
			   
		    	while(in.read(buffer,0,1024) != -1) {  
			        sb.append(new String(buffer));  
			    }
			    result=sb.toString();
			    
		    }
		    
		    in.close();  
		} catch (Exception e) {
			// e.printStackTrace();
			result = "http error";
		}
		finally{
			if(conn!=null){
				conn.disconnect();
			}
		}
		
		return text;
	}
}
