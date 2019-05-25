package com.sun3d.ticketGdfs.http;

public interface HttpRequestCallback {
	/**
	 * 完成之后回调
	 * @param statusCode
	 * @param resultStr
	 */
	public void onPostExecute(int statusCode,String resultStr);
}
