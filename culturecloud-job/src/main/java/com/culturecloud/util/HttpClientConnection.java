package com.culturecloud.util;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.net.HttpURLConnection;
import java.net.URL;

import com.alibaba.fastjson.JSONObject;

public class HttpClientConnection {

	public static HttpResponseText post(String strUrl, JSONObject json) {
		HttpResponseText text=new HttpResponseText();
		HttpURLConnection conn=null;
		String result="";
		BufferedReader reader=null;
		try {
			String contentData=json.toString();
			
			URL url = new URL(strUrl);
			conn = (HttpURLConnection) url.openConnection();
			
			conn.setRequestProperty("Content-Type", "text/html;charset=UTF-8"); 
			//conn.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
			conn.setDoOutput(true);
			conn.setDoInput(true);
			conn.setConnectTimeout(10000);
			conn.setRequestMethod("POST");
			conn.connect();
			
			PrintWriter out = new PrintWriter(new OutputStreamWriter(conn.getOutputStream(),"utf-8"));
			out.print(contentData);
			out.close();
			
			reader = new BufferedReader(new InputStreamReader(conn.getInputStream(),"UTF-8"));
		    
		    InputStream in = conn.getInputStream();  
		    int httpCode = conn.getResponseCode();  
		    text.setHttpCode(httpCode);

	    	byte[] buffer = new byte[1024];  
			StringBuffer sb = new StringBuffer();  
			String line=null;
			while((line = reader.readLine())!=null){
		        sb.append(line);  
		    }
		    result=sb.toString();
		    text.setData(result);
		    
		    in.close();  
		} catch (Exception e) {
			text.setHttpCode(500);
	        text.setData(e.toString());
		}
		finally{
			if(conn!=null){
				conn.disconnect();
			}
		}
		return text;
	}
	
	public static String post2(String strUrl, JSONObject json) {
		HttpURLConnection conn=null;
		String result="";
		BufferedReader reader=null;
		try {
			URL url = new URL(strUrl);
			conn = (HttpURLConnection) url.openConnection();
			
			conn.setRequestProperty("Content-Type", "text/html;charset=UTF-8");
			conn.setRequestProperty("Charset", "UTF-8");
			conn.setDoOutput(true);
			conn.setDoInput(true);
			conn.setConnectTimeout(10000);
			conn.setRequestMethod("POST");
			conn.connect();
			
			String contentData=json.toJSONString();
			System.out.println("contextData:"+contentData);
			PrintWriter out = new PrintWriter(new OutputStreamWriter(conn.getOutputStream(),"utf-8"));
			out.print(contentData);
			out.close();
			//conn.getOutputStream().write(contentData.getBytes());
		    conn.getOutputStream().flush();  
		    conn.getOutputStream().close(); 
		    reader = new BufferedReader(new InputStreamReader(conn.getInputStream(),"UTF-8"));
		    
		    InputStream in = conn.getInputStream();  
		    int httpCode = conn.getResponseCode();  
		    System.out.println(httpCode);
		    //if(httpCode==200){
		    	byte[] buffer = new byte[1024];  
				StringBuffer sb = new StringBuffer();  
				String line=null;
				while((line = reader.readLine())!=null){
			        sb.append(line);  
			    }
			    result=sb.toString();
			    
		    //}
		    
		    in.close();  
		} catch (Exception e) {
			// e.printStackTrace();
			System.out.println(strUrl + "  HTTP通信失败！");
			result = "error";
		}
		finally{
			if(conn!=null){
				conn.disconnect();
			}
		}
		
		return result;
	}
}
