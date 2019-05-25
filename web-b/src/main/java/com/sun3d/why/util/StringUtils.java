/*
@author lijing
@version 1.0 2015年8月3日 下午6:14:01
*/
package com.sun3d.why.util;

public class StringUtils {
	public static boolean isNull(String str) {
		return str == null || str.trim().length() == 0;
	}
	public static boolean isNotNull(String str) {
		return !isNull(str);
	}
	public static boolean isNaN(String str) {
		return isNull(str)||"NaN".equals(str);
	}



}

