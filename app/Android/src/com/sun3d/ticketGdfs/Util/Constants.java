package com.sun3d.ticketGdfs.Util;

public class Constants {
	public static class Http {

	}

	public static class CODE_STATE {
		public static final int SUCCESS = 1;
		public static final int FAIL = 0;
		/*
		 * 活动验证
		 * */
		public static final int ACTIVITY_VERIFICATION = 11;
		/*
		 * 场馆验证
		 * */
		public static final int VENUE_VERIFICATION = 22;
		
		/*
		 * 活动验证陈功
		 * */
		public static final int ACTIVITY_SUCCESS = 101;
		/*
		 * 场馆验证成功
		 * */
		public static final int VENUE_SUCCESS = 202;
	}
	
	/**
	 * 意图传输时用到的常数
	 * */
	public static class INTENT_TRANSFER{
		/**
		 * 选择毛玻璃效果界面
		 * */
		public static final String CHOICE = "choice";
		/**
		 * 什么情况下跳至登录
		 * */
		public static final String CHOICE_LOGIN = "choice_login";
		/**
		 * 主界面跳转登录
		 * */
		public static final int INTENT_MAIN = 0000;
		/**
		 * 验证跳转
		 * */
		public static final int INTENT_VERI = 1111;
		/**
		 * 扫描检测时登录
		 * */
		public static final int INTENT_TESTING_S = 2222;
		/**
		 * 输入检测时登录
		 * */
		public static final int INTENT_TESTING_I = 3333;
		
	}
	
}
