package com.culturecloud.utils;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

public abstract class DateUtil {

		public static final String	YYYYMM					= "yyyyMM";
		public static final String	YYYYMMDD				= "yyyyMMdd";
		public static final String	YYYYMMDDHHMMSS			= "yyyyMMddHHmmss";
		public static final String	YYYY_MM					= "yyyy-MM";
		public static final String	YYYY_MM_DD				= "yyyy-MM-dd";
		public static final String	YYYY_MM_DD_HH_MM		= "yyyy-MM-dd HH:mm";
		public static final String	YY_MM_DD_HH_MM			= "yy-MM-dd HH:mm";
		public static final String	YYYY_MM_DD_HH_MM_SS		= "yyyy-MM-dd HH:mm:ss";
		public static final String	YYYY_MM_DD_HH_MM_SSS	= "yyyy-MM-dd HH:mm:ss.SSS";
		public static final String	YYYYg_MMg_DD_HH_MM		= "yyyy/MM/dd HH:mm";
		public static final String	YYYYg_MMg_DD_HH_MM_SS	= "yyyy/MM/dd HH:mm:ss";
		public static final String	YYYYg_MMg_DD_HH_MM_SSS	= "yyyy/MM/dd HH:mm:ss.SSS";
		public static final String	YYYY_MM_DD_HH_MM_ZH		= "yyyy年MM月dd日HH时mm分";
		public static final String	YYYY_MM_DD_HH_MM_SS_ZH	= "yyyy年MM月dd日HH时mm分ss秒";
		
		private static DateFormat	DEFAULT_FORMAT;
		
			static {
				DEFAULT_FORMAT = SimpleDateFormatFactory.getInstance(YYYY_MM_DD_HH_MM_SS);
			}
			
			
			/**
			 * 将日期对象转换为字符串
			 * 
			 * @param date
			 *            时间对象
			 * @return java.lang.String 字符串对象
			 */
			public static String getDateStr(Date date) {
				SimpleDateFormat formatter = new SimpleDateFormat(YYYY_MM_DD_HH_MM_SS);
				return formatter.format(date);
			}
			
			/**
			 * 获取当前日期
			 * 
			 */
			public static String getDateNow() {
				java.text.SimpleDateFormat d = new java.text.SimpleDateFormat();
				d.applyPattern("yyyy-MM-dd");
				java.util.Date nowdate = new java.util.Date();
				String str_date = d.format(nowdate);
				return str_date;
			}
}
