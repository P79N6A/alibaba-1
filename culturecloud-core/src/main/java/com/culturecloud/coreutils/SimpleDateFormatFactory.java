package com.culturecloud.coreutils;

import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.Map;

public class SimpleDateFormatFactory {

	private static final Map<String, SimpleDateFormat> sdfMap = new HashMap<String, SimpleDateFormat>();
	
		public static SimpleDateFormat getInstance() {
			return getInstance(DateUtil.YYYY_MM_DD_HH_MM_SS);
		}
	
		public static synchronized SimpleDateFormat getInstance(String format) {
			SimpleDateFormat sdf = sdfMap.get(format);
			if (null == sdf) {
				sdf = new SimpleDateFormat(format);
				sdfMap.put(format, sdf);
			}
			return sdf;
		}
}
