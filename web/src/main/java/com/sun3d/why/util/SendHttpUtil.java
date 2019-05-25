package com.sun3d.why.util;


import com.fasterxml.jackson.databind.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Map;

/**
 * TODO: Must write comments.
 *
 * @author <a href="mailto:dwzhang@xunton.com">dwzhang</a>
 * @version 1.0 16-4-12 上午10:41
 */
public class SendHttpUtil
{
	private static final Logger log = LoggerFactory.getLogger(SendHttpUtil.class);
	private static ObjectMapper objectMapper = new ObjectMapper();

	/**
	 * 发送HTTP请求
	 * @param method     请求类型
	 * @param url        请求路径
	 * @param request    参数
	 * @return
	 */
	public static String sendPostHttp(String method, String url,  Object request)
	{
		String message = "";
		try {
			//传递参数转换
			String content = SendHttpUtil.objectMapper.writeValueAsString(request);
			URL url_con = new URL(url);
			HttpURLConnection conn = (HttpURLConnection)url_con
					.openConnection();
			conn.setRequestMethod(method);
			conn.setRequestProperty("Content-Type",
					"application/x-www-form-urlencoded");
			conn.setDoOutput(true);
			conn.setDoInput(true);
			conn.setUseCaches(false);
			conn.setConnectTimeout(30000);
			conn.setReadTimeout(30000);
			conn.connect();
			if ("POST".equalsIgnoreCase(method)) {
				OutputStream output = conn.getOutputStream();
				output.write(content.getBytes("UTF-8"));
				output.flush();
				output.close();
			}
			InputStream input = conn.getInputStream();
			int size = input.available();
			byte[] bytes = new byte[size];
			input.read(bytes);
			message = new String(bytes, "UTF-8");
			input.close();
		} catch (Exception e) {
			log.error("HTTP请求失败!", e);
		}
		return message;
	}


	public static String sendGetHttp(String method, String url, Map<String, Object> paramMap)
	{
		String message = "";
		try {
			//传递参数转换
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
			URL url_con = new URL(url);
			HttpURLConnection conn = (HttpURLConnection)url_con
					.openConnection();
			conn.setRequestMethod(method);
			conn.setRequestProperty("Content-Type",
					"application/x-www-form-urlencoded");
			conn.setDoOutput(true);
			conn.setDoInput(true);
			conn.setUseCaches(false);
			conn.setConnectTimeout(30000);
			conn.setReadTimeout(30000);
			conn.connect();
			InputStream input = conn.getInputStream();
			int size = input.available();
			byte[] bytes = new byte[size];
			input.read(bytes);
			message = new String(bytes, "UTF-8");
			input.close();
		} catch (Exception e) {
			log.error("HTTP请求失败!", e);
		}
		return message;
	}


	/**
	 * 向指定 URL 发送请求
	 *
	 * @param method  请求方式 GET/POST
	 * @param url     发送请求的 URL
	 * @param content 请求参数 JSON对象的形式。
	 * @return 所代表远程资源的响应结果
	 */
	public static String sendHttp(String method, String url, String content) {
		String message = "";
		HttpURLConnection conn = null;
		InputStreamReader input = null;
		try {
			System.out.println("请求的URL：" + url);
			System.out.println("请求的CONTENT：" + content);
			URL url_con = new URL(url);
			conn = (HttpURLConnection) url_con
					.openConnection();
			conn.setRequestMethod(method.toUpperCase());
			conn.setRequestProperty("accept", "*/*");
			conn.setRequestProperty("connection", "Keep-Alive");
			conn.setRequestProperty("user-agent",
					"Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1;SV1)");
			conn.setRequestProperty("Content-Type", "application/json");
			conn.setRequestProperty("platform", "test");
			conn.setRequestProperty("version", "test");

			conn.setDoOutput(true);
			conn.setDoInput(true);
			conn.setUseCaches(false);
			conn.setConnectTimeout(30000);
			conn.setReadTimeout(30000);
			conn.connect();
			if ("POST".equalsIgnoreCase(method)) {
				OutputStream output = conn.getOutputStream();
				output.write(content.getBytes("UTF-8"));
				output.flush();
				output.close();
			}
			input = new InputStreamReader(conn.getInputStream(),"UTF-8");

			BufferedReader br = new BufferedReader(input);

			String readerLine = null;
			while ((readerLine = br.readLine()) != null) {
				message += readerLine;
			}
			//int size = input.available();
			//byte[] bytes = new byte[size*1000];
			//input.read(bytes);
			//message = new String(bytes, "UTF-8");
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("发送请求异常：" + e);
		}finally {
			try {
				input.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
			conn.disconnect();
		}
		System.out.println("请求的结果：" + message);
		return message;
	}
}