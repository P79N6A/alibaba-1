package com.sun3d.ticketGdfs.http;

import org.apache.http.HttpResponse;
import org.apache.http.HttpStatus;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import android.os.AsyncTask;
import android.util.Log;

public class HttpTask extends AsyncTask<String, Integer, String> {
	private String TAG = "HttpTask";
	private Object httpRequest;
	private HttpRequestCallback mCallback;
	private int code;
	private int type;

	public HttpTask(int mtype, Object mhttpRequest, HttpRequestCallback mCallback) {
		this.type = mtype;
		this.mCallback = mCallback;
		this.httpRequest = mhttpRequest;
	}

	@Override
	protected String doInBackground(String... arg0) {
		// TODO Auto-generated method stub
		HttpResponse httpResponse = null;
		String result = null;
		try {
			switch (this.type) {
			case HttpCode.HTTP_RequestType_Get:
				HttpGet httpget = (HttpGet) httpRequest;
				httpResponse = HttpClientHelper.getHttpClient().execute(httpget);
				result = onStart(httpResponse);
				break;
			case HttpCode.HTTP_RequestType_Post:
				HttpPost httpost = (HttpPost) httpRequest;
				httpResponse = HttpClientHelper.getHttpClient().execute(httpost);
				result = onStart(httpResponse);
				break;
			default:
				result = "TYPE is error!!";
				code = HttpCode.HTTP_Request_Failure_CODE;
				break;
			}

		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			result = e.toString();
			Log.d(TAG, e.toString());
			code = HttpCode.HTTP_Request_Failure_CODE;
		}
		return result;
	}
	
	private String onStart(HttpResponse httpResponse) {
		String result;
		String result1 = HttpGetGzip.getJsonStringFromGZIP(httpResponse);
		Log.d(TAG, result1);
		if (httpResponse.getStatusLine().getStatusCode() == HttpStatus.SC_OK) {
			result = result1;
			code = HttpCode.HTTP_Request_Success_CODE;
		} else {
			result = httpResponse.getEntity().toString();
			code = HttpCode.HTTP_Request_Failure_CODE;
		}
		return result;
	}

	@Override
	protected void onPostExecute(String result) {
		// TODO Auto-generated method stub
		super.onPostExecute(result);
		try {
			mCallback.onPostExecute(code, result);
		}catch (Exception e){

		}

	}
}
