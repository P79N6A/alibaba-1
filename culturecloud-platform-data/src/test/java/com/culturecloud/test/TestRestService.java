package com.culturecloud.test;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

import javax.ws.rs.core.MediaType;

import org.codehaus.jackson.JsonEncoding;
import org.codehaus.jackson.JsonGenerator;
import org.codehaus.jackson.map.ObjectMapper;


public class TestRestService {

	protected static final String BASE_URL = "http://127.0.0.1:10019";
	protected static URL url = null;
	protected static HttpURLConnection connection = null;

	/**
	 * 方法描述：初始化环境，并且进行与服务器连接。
	 * 
	 * @param subUrl
	 *            需要访问的服务子路径，例如：/corporation/create
	 * @param method
	 *            例如：post get put delete
	 * @throws Exception
	 */
	public static void setUpBeforeClass(String subUrl, String method)
			throws Exception {
		url = new URL(BASE_URL + subUrl);
		connection = (HttpURLConnection) url.openConnection();
		connection.setDoOutput(true);
		connection.setDoInput(true);
		connection.setRequestMethod(method);
		connection.setUseCaches(false);
		connection.setInstanceFollowRedirects(true);
		connection.setRequestProperty("Content-Type", MediaType.APPLICATION_JSON);
		connection.connect();

	}

	/**
	 * 方法描述：子类需要调用的执行方法，主要功能包括：封装JSON全局对象，并且利用工厂构建JSON对象。
	 * 
	 * @param obj
	 *            需要传递执行的业务对象，根据领域模型驱动设计的理念，该对象就是一个领域模型，例如：Corporation类封装好的对象。
	 */
	@SuppressWarnings("unused")
	public void execute(Object obj) {
		try {

			DataOutputStream out = new DataOutputStream(
					connection.getOutputStream());

			JsonGenerator jg = null;
			ObjectMapper objectMapper = new ObjectMapper();
			jg = objectMapper.getJsonFactory().createJsonGenerator(System.out,
					JsonEncoding.UTF8);
			objectMapper.writeValue(System.out, obj);
			objectMapper.writeValue(out, obj);
			out.flush();
			out.close();

			BufferedReader reader = new BufferedReader(new InputStreamReader(
					connection.getInputStream()));
			String lines = null;
			StringBuffer sb = new StringBuffer("");
			while ((lines = reader.readLine()) != null) {
				lines = new String(lines.getBytes(), "utf-8");
				sb.append(lines);
			}
			System.out.println("respose: " + sb.toString());
			reader.close();

			connection.disconnect();
		} catch (Exception e) {
			e.printStackTrace();
		}

	}
}
