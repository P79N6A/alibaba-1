package com.sun3d.why.util;

import java.io.File;

public interface SystemContent {
	
	/**
	 * ajax请求响应-状态参数  true或false
	 */
	public static final String AJAX_REQUEST_STATUS = "rtnCode";

	/**
	 * 文件服务器
	 */

	public static final String ACCESS_TOKEN = "ACCESS_TOKEN";
	public static final String JS_TOKEN = "JS_TOKEN";
	public static final String JS_TIME = "JS_TIME";

	public static final String JSL_BAR_IMAGE_PATH = File.separator + "image";
	public static final String XHACTIVITY_UPLOAD_PATH = JSL_BAR_IMAGE_PATH + File.separator + "xh";

}
