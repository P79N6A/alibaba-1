package com.culturecloud.util;
/*
**
**@author lijing
**@version 1.0 2015年8月27日 上午11:17:32
*/
public class HttpResponseText {
	private int httpCode;
	private String data="";
	public int getHttpCode() {
		return httpCode;
	}
	public void setHttpCode(int httpCode) {
		this.httpCode = httpCode;
	}
	public String getData() {
		return data;
	}
	public void setData(String data) {
		this.data = data;
	}
	
	
}
