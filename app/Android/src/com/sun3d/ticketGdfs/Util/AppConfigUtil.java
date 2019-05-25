package com.sun3d.ticketGdfs.Util;

/**
 * 
 * @author liningkang 常量
 */
public class AppConfigUtil {
	public static final int APPVersionNumber = 0;

	public static final String FILE_NAME = "CulturalSh";
	public static final String FILE_USER = "user";
	public static final String USER_LOCAT_PATH = "user_locat_path";
	public static final int USER_REQUEST_CODE = 100;
	public static final int RESULT_LOCAT_CODE = 101;
	public static final int PERSONAL_RESULT_USER_CODE = 201;
	public static final int PERSONAL_RESULT_VENUE_CODE = 202;
	public static final int PERSONAL_RESULT_MESSGE_CODE = 203;
	public static final String PRE_FILE_USER = "save_user";
	public static final String PRE_FILE_NAME = "save_name";
	public static final String PRE_FILE_NAME_KEY = "save_name_key";
	public static final String APP_LOAD = "app_load";
	public static final String INTENT_TYPE = "intent_type";
	public static final String APP_ENCODING = "utf-8";
	public static final String APP_MIMETYPE = "text/html";

	public static final int LOADING_LOGIN_BACK = 102;
	
	public static final String INTENT_SHAREINFO ="shareInfo";
	

	/**
	 * 用户常量
	 */
	public static class User {
		public static final String USER_IS_LOGIN = "isLogin";
		public static final String USER_ICON = "userIcon.jpg";

	}

	public static class Page {
		public static final int PageDefaHight = 200;
	}

	public static class List {
		public static String pageNum = "20";
		public static final String PAGE_INDEX = "0";
	}

	public static class UploadImage {
		public static String KEY = "file";
	}
}
