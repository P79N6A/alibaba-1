package com.sun3d.why.model.extmodel;

public class WxInfo {
	private static String wxToken;
	private static String appId;
	private static String appSecret;
	public static String getWxToken() {
		return wxToken;
	}
	public static void setWxToken(String wxToken) {
		WxInfo.wxToken = wxToken;
	}
	public static String getAppId() {
		return appId;
	}
	public static void setAppId(String appId) {
		WxInfo.appId = appId;
	}
	public static String getAppSecret() {
		return appSecret;
	}
	public static void setAppSecret(String appSecret) {
		WxInfo.appSecret = appSecret;
	}


}
