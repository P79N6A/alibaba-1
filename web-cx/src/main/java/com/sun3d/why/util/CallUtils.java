package com.sun3d.why.util;

import com.alibaba.fastjson.JSON;
import com.sun3d.why.webservice.api.util.HttpResponseText;

import javax.net.ssl.HttpsURLConnection;
import javax.ws.rs.core.MediaType;
import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Map;
/**
 * @Description: 请求访问工具类
 * @author ChenXinjie
 * @date 2014年7月31日 下午1:34:11
 * 
 */
@SuppressWarnings("deprecation")
public class CallUtils {
	/**
	  * @Description: POST 方式请求数据
	  * @param @param url 目标URL
	  * @param @param data 参数
	  * @param @return
	  * @param @throws Exception  
	  * @return String  
	  * @throws
	  */
	public static String callUrl(String url, String data) throws Exception {
		System.out.println(data);
		HttpURLConnection conn = (HttpURLConnection) new URL(url).openConnection();
		String content = "";

		conn.setDoOutput(true);
		conn.setDoInput(true);
		conn.setRequestMethod("POST");
		conn.setUseCaches(false);
		conn.setInstanceFollowRedirects(true);
		conn.setRequestProperty("Content-Type", "text/xml");

		byte[] bdata = data.getBytes("utf-8");
		conn.setRequestProperty("Content-Length", String.valueOf(bdata.length));
		conn.connect();
		DataOutputStream out = new DataOutputStream(conn.getOutputStream());
		out.write(bdata);
		out.flush();
		out.close();

		BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
		String inputLine;

		while ((inputLine = reader.readLine()) != null) {
			content += inputLine;
		}
		reader.close();
		conn.disconnect();

		return content;
	}
	
	private static final int connectionTimeOut = 2000;

	private static final int soTimeout = 40000;

	/**
	  * @Description: Get 方式调用接口
	  * @param @param url
	  * @param @param paramMap
	  * @param @return  
	  * @return String  
	  * @throws
	  */
	public static String callUrl3(String url, Map<String, Object> paramMap) {
		try {
			if (paramMap != null) {
				// 构建请求参数
				StringBuffer paramStr = new StringBuffer("?");
				for (String key : paramMap.keySet()) {
					paramStr.append(key);
					paramStr.append("=");
					//paramStr.append(URLEncoder.encode(paramMap.get(key).toString(), "UTF-8"));
					paramStr.append(paramMap.get(key).toString());
					paramStr.append("&");
				}
				url = url + paramStr.substring(0, paramStr.length() - 1);
			}
			URL realUrl = new URL(url);
			BufferedReader in = new BufferedReader(new InputStreamReader(realUrl.openStream()));
			StringBuffer retBuffer = new StringBuffer();
			String inputLine;
			while ((inputLine = in.readLine()) != null) {
				retBuffer.append(inputLine.trim());
			}
			in.close();
			String message = retBuffer.toString();
			message =  new String(message.getBytes("GBK") , "utf-8");
			return message;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	/**
	 * 	  * @Description: 绑定接口
	  * @param @param url
	  * @param @param paramMap
	  * @param @return  
	  * @return String  
	  * @throws
	 */
	public static String callUrl4(String url, Map<String, String> params) {
		try {
			if (params != null) {
				// 构建请求参数
				StringBuffer paramStr = new StringBuffer("?");
				for (String key : params.keySet()) {
					paramStr.append(key);
					paramStr.append("=");
//					paramStr.append(URLEncoder.encode(paramMap.get(key).toString(), "UTF-8"));
					paramStr.append(params.get(key).toString());
					paramStr.append("&");
				}
				url = url + paramStr.substring(0, paramStr.length() - 1);
			}
			URL realUrl = new URL(url);
			BufferedReader in = new BufferedReader(new InputStreamReader(realUrl.openStream()));
			StringBuffer retBuffer = new StringBuffer();
			String inputLine;
			while ((inputLine = in.readLine()) != null) {
				retBuffer.append(inputLine.trim());
			}
			in.close();
			return retBuffer.toString();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	/**
	  * @Description: POST https方式请求数据
	  * @param strUrl 目标URL
	  * @param jsonStr 参数
	  */
	public static HttpResponseText callUrlHttpsPost(String strUrl, String jsonStr) throws Exception {
       HttpResponseText text=new HttpResponseText();
       HttpsURLConnection conn=null;
       String result="";
       BufferedReader reader=null;
       try {
           URL url = new URL(strUrl);
           conn = (HttpsURLConnection) url.openConnection();
           conn.setRequestProperty("Content-Type", "plain/text; charset=UTF-8");
           conn.setDoOutput(true);
           conn.setDoInput(true);
           conn.setConnectTimeout(10000);
           conn.setRequestMethod("POST");
           conn.setRequestProperty("Connection","keep-alive");

           conn.connect();
		   String contentData=jsonStr.toString();
		   conn.getOutputStream().write(contentData.getBytes());
		   conn.getOutputStream().flush();
		   conn.getOutputStream().close();
           
           reader = new BufferedReader(new InputStreamReader(conn.getInputStream(),"UTF-8"));

           InputStream in = conn.getInputStream();
           int httpCode = conn.getResponseCode();
           text.setHttpCode(httpCode);
           StringBuffer sb = new StringBuffer();
           String line=null;
           while((line = reader.readLine())!=null){
               sb.append(line);
           }
           result=sb.toString();
           text.setData(result);
           in.close();
       } catch (Exception e) {
           e.printStackTrace();
           result = "http error";
           text.setData(e.toString());
       }
       finally{
           if(conn!=null){
               conn.disconnect();
           }
       }
       return text;
	}  
	
	/**
	  * @Description: POST http方式请求数据
	  * @param strUrl 目标URL
	  * @param jsonStr 参数
	  */
	public static HttpResponseText callUrlHttpPost(String strUrl, String jsonStr){
      HttpResponseText text=new HttpResponseText();
      HttpURLConnection conn=null;
      String result="";
      BufferedReader reader=null;
      try {
          URL url = new URL(strUrl);
          conn = (HttpURLConnection) url.openConnection();
          conn.setRequestProperty("Content-Type", MediaType.APPLICATION_JSON);
          conn.setDoOutput(true);
          conn.setDoInput(true);
          conn.setRequestMethod("POST");
          conn.setRequestProperty("Connection","keep-alive");
          conn.setRequestProperty("platform","h5");
		  conn.setReadTimeout(6000);
		  conn.setConnectTimeout(8000);
          conn.connect();
          
    	  String contentData=jsonStr!=null?jsonStr.toString():"{}";
          conn.getOutputStream().write(contentData.getBytes("UTF-8"));
          conn.getOutputStream().flush();
          conn.getOutputStream().close();
          
          reader = new BufferedReader(new InputStreamReader(conn.getInputStream(),"UTF-8"));
          StringBuffer sb = new StringBuffer();
          String line=null;
          while((line = reader.readLine())!=null){
              sb.append(line);
          }
          result=sb.toString();
          
          //封装response对象
          int httpCode = conn.getResponseCode();
          text.setHttpCode(httpCode);
          result=sb.toString();
          text.setData(result);
      } catch (Exception e) {
          e.printStackTrace();
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
	
	/**
	  * @Description: POST http方式请求数据
	  * @param url 目标URL
	  */
	public static HttpResponseText callUrlHttpPost(String url, Object o) {
		HttpResponseText text = new HttpResponseText();
		try {
			String jsonStr = JSON.toJSONString(o);
			text = callUrlHttpPost(url, jsonStr);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return text;
	}
}
