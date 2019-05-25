package com.culturecloud.utils.pay;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLEncoder;
import java.util.Arrays;
import java.util.Map;
import java.util.Properties;
import java.util.Set;

import javax.net.ssl.HttpsURLConnection;

import sun.misc.BASE64Decoder;
import sun.misc.BASE64Encoder;

/**
 * 微信支付工具类 Date:2015-1-12 zhangchenxi
 */
public class WeixinPayUtil {

//	private static Properties properties = new Properties();
//	static {
//		try {
//			properties.load(WeixinPayUtil.class.getClassLoader().getResourceAsStream("weixinpay.properties"));
//		} catch (IOException e) {
//			e.printStackTrace();
//		}
//	}
//
//	public static String readValue(String key) {
//		return (String) properties.get(key);
//	}

	/**
	 * post XML请求微信方式
	 */
	public static String post(String httpsUrl, String xmlStr) {

		HttpsURLConnection urlCon = null;
		try {
			urlCon = (HttpsURLConnection) (new URL(httpsUrl)).openConnection();
			urlCon.setDoInput(true);
			urlCon.setDoOutput(true);
			urlCon.setRequestMethod("POST");
			urlCon.setRequestProperty("Content-Length", String.valueOf(xmlStr.getBytes().length));
			urlCon.setUseCaches(false);
			// 设置为UTF-8字符编码可以解决服务器接收时读取的数据中文乱码问题
			urlCon.getOutputStream().write(xmlStr.getBytes("UTF-8"));
			urlCon.getOutputStream().flush();
			urlCon.getOutputStream().close();
			BufferedReader in = new BufferedReader(new InputStreamReader(urlCon.getInputStream()));
			String line;
			String result = "";
			while ((line = in.readLine()) != null) {
				result += line;
				System.out.println(line);
			}
			return result;
		} catch (MalformedURLException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	/** 计算微信支付金额 单位分 */
	public static String getPayMoney(String amt) {
		int money = (int) (Double.valueOf(amt) * 100);
		return String.valueOf(money);
	}

	/** 将字符串加密BASE64 */
	public static String getBase64(String str) {
		byte[] b = null;
		String s = null;
		try {
			b = str.getBytes("utf-8");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		if (b != null) {
			s = new BASE64Encoder().encode(b);
		}
		return s;
	}

	/** 将 BASE64 编码的字符串 s 进行解码 */
	public static String getFromBASE64(String s) {
		if (s == null)
			return null;
		BASE64Decoder decoder = new BASE64Decoder();
		try {
			byte[] b = decoder.decodeBuffer(s);
			return new String(b);
		} catch (Exception e) {
			return null;
		}
	}

	/** sign */

	public static String createSign(Map<String, String> params, boolean encode) throws UnsupportedEncodingException {
		Set keysSet = params.keySet();
		Object[] keys = keysSet.toArray();
		Arrays.sort(keys);
		StringBuffer temp = new StringBuffer();
		boolean first = true;
		for (Object key : keys) {
			if (first)
				first = false;
			else {
				temp.append("&");
			}
			temp.append(key).append("=");
			Object value = params.get(key);
			String valueString = "";
			if (null != value) {
				valueString = value.toString();
			}
			if (encode)
				temp.append(URLEncoder.encode(valueString, "UTF-8"));
			else {
				temp.append(valueString);
			}
		}
		return temp.toString();
	}
}
