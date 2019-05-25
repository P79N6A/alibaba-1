package com.culturecloud.utils;

/**
 * 系统公共常量
 * @author Administrator
 *
 */
public class Constants {

	/** jersey配置项 */
	public static String POJOMAPPER = "com.sun.jersey.api.json.POJOMappingFeature";

	public static String PROPERTY_BASE_URI = "com.sun.jersey.server.impl.container.netty.baseUri";
	
	public static String RESOURCEPACKAGE="com.zh.service.rs";
	public static String RESPONFILTER="com.zh.service.rs.filters.ResponseFilter";
	public static String REQUESTFILTER="com.zh.service.rs.filters.LogRequestFilter";
	//public static String REQUESTFILTER="com.sxiic.core.aop.RequestFilter";
	public static String A_USER_MOBILE_KEY="A_T_USER_MOBILE_"; //注册时redis key前缀
	public static int SMS_DELAY_SECOND=30*60;//短信验证码有效时间 30分钟

}