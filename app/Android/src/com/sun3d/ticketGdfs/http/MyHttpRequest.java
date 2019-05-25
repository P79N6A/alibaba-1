package com.sun3d.ticketGdfs.http;

import java.io.UnsupportedEncodingException;
import java.util.Map;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.json.JSONObject;


import android.util.Log;

/**
 * Http 请求线程
 * 
 * @author yangyoutao
 * 
 */
public class MyHttpRequest {
	private static String TAG = "MyHttpRequest";
	private static HttpGet httpGet;

	private static void initHttpGET(String url, Map<String, String> params) {
		httpGet = null;
		if (null == url) {
			Log.i(TAG, "url is null!");
			return;
		}
		if (params == null) {
			httpGet = new HttpGet(url);
			Log.i(TAG, url);
		} else {
			Log.i(TAG, getParams(url, params));
			httpGet = new HttpGet(getParams(url, params));
		}
	}

	/**
	 * url服务器地址 ，params发送参数列表，mCallback回调接口
	 * 
	 * @param url
	 * @param params
	 * @param mCallback
	 */

	@SuppressWarnings("unused")
	public static void onStartHttpGET(String url, Map<String, String> params,
			HttpRequestCallback mCallback) {
		if (mCallback == null) {
			Log.i(TAG, " mCallback is null!");
			return;
		}
		initHttpGET(url, params);
		if (null != httpGet) {
			httpGet.addHeader("Accept-Encoding", "gzip");
			new HttpTask(HttpCode.HTTP_RequestType_Get, httpGet, mCallback).execute();
		}
	}

	/**
	 * url服务器地址 ，jSONObject发送参数对象，mCallback回调接口
	 * 
	 * @param url
	 * @param jSONObject
	 * @param mCallback
	 */
	public static void onStartHttpPost(String url, JSONObject jSONObject,
			HttpRequestCallback mCallback) {
		HttpPost httpost;
		if (null == url || null == mCallback) {
			Log.i(TAG, "url or mCallback is null!");
			return;
		}

		httpost = new HttpPost(url);
		Log.i(TAG, url);
		if (jSONObject != null) {
			Log.d(TAG, jSONObject.toString());
			try {
				httpost.setEntity(new StringEntity(jSONObject.toString(), "utf-8"));
			} catch (UnsupportedEncodingException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				Log.i(TAG, e.toString());
			}
		}
		httpost.addHeader("Accept-Encoding", "gzip");
		new HttpTask(HttpCode.HTTP_RequestType_Post, httpost, mCallback).execute();
	}

	/**
	 * 拼接get多个参数
	 * 
	 * @param path
	 * @param params
	 * @return
	 */
	public static String getParams(String path, Map<String, String> params) {
		StringBuffer sb = new StringBuffer();
		sb.append(path);
		sb.append("?");
		for (Map.Entry<String, String> entry : params.entrySet()) {
			sb.append(entry.getKey());
			sb.append("=");
			sb.append(entry.getValue());
			sb.append("&");
		}
		sb.deleteCharAt(sb.length() - 1);
		return sb.toString();
	}

}
