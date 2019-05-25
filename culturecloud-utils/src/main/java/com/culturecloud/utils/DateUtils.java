package com.culturecloud.utils;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.LinkedList;
import java.util.logging.Logger;

/**
 * 日期工具类
 * 
 * @see 对日期的验证
 * @version 1.0
 * @author gaoyr
 */
public class DateUtils extends org.apache.commons.lang3.time.DateUtils{
	/**
	 * 给日期加月
	 * @param date 日期
	 * @param month 月数
	 * @return 加后日期
	 */
	public static Date addMonths(Date date,int month){
          Calendar calender = Calendar.getInstance();
          calender.setTime(date);
          calender.add(Calendar.MONTH, month);
          return calender.getTime();
	}
	/**
	 * 获取日期所在月的天数
	 * @param date date
	 * @return 天数
	 */
	public static int getTotalDaysOfMonth(Date date){
		Calendar calendar = Calendar.getInstance();
		calendar.setTime(date);
		return calendar.getActualMaximum(Calendar.DAY_OF_MONTH);
	}
	/**
	 * 根据日期判断所在年的天数
	 * @param year 年数
	 * @return 天数
	 */
//	public static int getYearDays(int year)
//	{
//		if((year % 4 == 0 && year % 100 != 0) || year % 400 == 0){
//			return 366;
//		}
//		return 365;
//	}
	/**
	 * 获取日期所在天数(年)a
	 * 
	 * @param date
	 *            日期对象
	 * @return int 天数
	 */
	public static int getDayOfYear(Date date) {
		Calendar calendar = Calendar.getInstance();
		calendar.setTime(date);

		return calendar.get(Calendar.DAY_OF_YEAR);
	}

	/**
	 * 获取日期所在天数(月)
	 * 
	 * @param date
	 *            日期对象
	 * @return int 天数
	 */
	public static int getDayOfMonth(Date date) {
		Calendar calendar = Calendar.getInstance();
		calendar.setTime(date);

		return calendar.get(Calendar.DAY_OF_MONTH);
	}

	/**
	 * 获取日期所在天数(周)
	 * 
	 * @param date
	 *            日期对象
	 * @return int 天数
	 */
	public static int getDayOfWeek(Date date) {
		Calendar calendar = Calendar.getInstance();
		calendar.setTime(date);

		int week = calendar.get(Calendar.DAY_OF_WEEK);
		return week == 1 ? WEEK_END : week - 1;
	}

	/**
	 * 增加指定日期对象的天数
	 * 
	 * @param date
	 *            日期对象
	 * @param days
	 *            天数 可以为负数 这样的话就是减少天数
	 * @return java.util.Date 添加完天数后的日期对象
	 */
	public static Date addDays(Date date, int days) {
		Calendar calendar = Calendar.getInstance();

		calendar.setTime(date);
		calendar.add(Calendar.DATE, days);

		return calendar.getTime();
	}

	/**
	 * 判断日期1是否早于日期2
	 * 
	 * @param d1
	 *            日期1
	 * @param d2
	 *            日期2
	 * @return boolean 比较结果
	 */
	public static boolean earlierThan(Date d1, Date d2) {
		return d1.getTime() < d2.getTime();
	}

	/**
	 * 测试日期1是否在日期2和日期3之间
	 * 
	 * @param d1
	 *            日期1
	 * @param d2
	 *            日期2
	 * @param d3
	 *            日期3
	 * @return boolean 比较结果
	 */
	public static boolean isBetween(Date d1, Date d2, Date d3) {
		return d1.getTime() > d2.getTime() && d1.getTime() < d3.getTime();
	}

	/**
	 * 判断两个日期是否在同一个月份中
	 * 
	 * @param d1
	 *            日期1
	 * @param d2
	 *            日期2
	 * @return boolean 比较结果
	 */
	public static boolean isSameMonth(Date d1, Date d2) {
		Calendar c1 = Calendar.getInstance();
		Calendar c2 = Calendar.getInstance();

		c1.setTime(d1);
		c2.setTime(d2);

		return c1.get(Calendar.YEAR) == c2.get(Calendar.YEAR) && c1.get(Calendar.MONTH) == c2.get(Calendar.MONTH);
	}

	/**
	 * 判断两个日期是否在同一个天
	 * 
	 * @param d1
	 *            日期1
	 * @param d2
	 *            日期2
	 * @return boolean 比较结果
	 */
	public static boolean isSameDay(Date d1, Date d2) {
		Calendar c1 = Calendar.getInstance();
		Calendar c2 = Calendar.getInstance();

		c1.setTime(d1);
		c2.setTime(d2);

		return c1.get(Calendar.YEAR) == c2.get(Calendar.YEAR) && c1.get(Calendar.MONTH) == c2.get(Calendar.MONTH)
				&& c1.get(Calendar.DATE) == c2.get(Calendar.DATE);
	}

	/**
	 * 测试日期1与日期2之间相差的天数
	 * 
	 * @param d1
	 *            日期1
	 * @param d2
	 *            日期2
	 * @return int 相差天数
	 */
	public static int between(Date d1, Date d2) {
		return Math.abs((int) ((d1.getTime() / A_DAY_OF_MILL) - (d2.getTime() / A_DAY_OF_MILL)));
	}

	/**
	 * 获取两个日期中间隔的月份集合
	 * 
	 * @param start
	 *            起始日期
	 * @param end
	 *            结束日期
	 * @return java.util.LinkedList&lt;String&gt; 月份集合 格式为yyyy-MM
	 */
	public static LinkedList<String> getBetweenMonths(Date start, Date end) {
		assert start.getTime() < end.getTime();

		LinkedList<String> result = new LinkedList<String>();
		Calendar index = Calendar.getInstance();

		index.setTime(start);
		index.setTime(DateFormatUnit.YEAR_AND_MONTH.getDateByStr(index.get(Calendar.YEAR) + "-" + (index.get(Calendar.MONTH) + 1)));

		while (true) {
			if (index.getTimeInMillis() > end.getTime()) {
				break;
			} else {
				result.add(DateFormatUnit.YEAR_AND_MONTH.getDateStr(index.getTime()));
				index.add(Calendar.MONTH, 1);
			}
		}
		return result;
	}

	/**
	 * 获取两个日期中间隔的日期集合
	 * 
	 * @param start
	 *            起始日期
	 * @param end
	 *            结束日期
	 * @return java.util.LinkedList&lt;String&gt; 日期集合 格式为yyyy-MM-dd
	 */
	public static LinkedList<String> getBetweenDays(Date start, Date end) {
		assert start.getTime() < end.getTime();
		LinkedList<String> result = new LinkedList<String>();
		Calendar index = Calendar.getInstance();

		index.setTime(start);
		index.setTime(DateFormatUnit.DATE.getDateByStr(StringUtils.concat(index.get(Calendar.YEAR), "-", (index.get(Calendar.MONTH) + 1), "-", index
				.get(Calendar.DAY_OF_MONTH))));

		while (true) {
			if (index.getTimeInMillis() > end.getTime()) {
				break;
			} else {
				result.add(DateFormatUnit.DATE.getDateStr(index.getTime()));
				index.add(Calendar.DATE, 1);
			}
		}

		return result;
	}
	
	/**
	 * 某一个月第一天和最后一刻
	 *  @param currDate 当月时间
	 *  @return date
	 *
	 */
	public static Date getLastTimeOfMonth(Date currDate) {
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
		Calendar calendar = Calendar.getInstance();
		calendar.setTime(currDate);
		calendar.add(Calendar.MONTH, 0);

		// 当月最后一天
		calendar.add(Calendar.MONTH, 1); // 加一个月
		calendar.set(Calendar.DATE, 1); // 设置为该月第一天
		calendar.add(Calendar.DATE, -1); // 再减一天即为上个月最后一天
		String dayLast = df.format(calendar.getTime());
		StringBuffer endStr = new StringBuffer().append(dayLast).append(" 23:59:59");
		dayLast = endStr.toString();
		return DateUtils.DateFormatUnit.DATE_TIME.getDateByStr(dayLast);
	}
	

	/** 一周最后一天 */
	public static final int WEEK_END = 7;

	/** 一天单位(毫秒数) */
	public static final int A_DAY_OF_MILL = 1000 * 60 * 60 * 24;

	/**
	 *时间转换 枚举
	 * 
	 * @version 1.0
	 * @author zhaojp
	 */
	public enum DateFormatUnit {
		/** 枚举元素 */
		DAY("dd"),DATE("yyyy-MM-dd"), TIME("HH:mm:ss"),DATE_TIME("yyyy-MM-dd HH:mm:ss"), SHORT_DATE("yyyyMMdd"), SHORT_DATE_TIME("yyyyMMddHHmmss"), YEAR_AND_MONTH("yyyy-MM"), DATE_AND_HOUR(
				"yyyy-MM-dd HH");

		/**
		 * 初始化转换格式
		 * 
		 * @param pattern
		 *            转换格式
		 */
		DateFormatUnit(String pattern) {
			this.pattern = pattern;
			//this.formatter = new SimpleDateFormat(pattern);
		}

		/**
		 * 获得一个新的格式化对象
		 * 
		 * @return java.text.SimpleDateFormat 日期格式化对象
		 */
		public SimpleDateFormat getNewFormatter() {
			return new SimpleDateFormat(pattern);
		}

		/**
		 * 将日期对象转换为字符串
		 * 
		 * @param date
		 *            时间对象
		 * @return java.lang.String 字符串对象
		 */
		public String getDateStr(Date date) {
			SimpleDateFormat formatter = new SimpleDateFormat(pattern);
			return formatter.format(date);
		}

		/**
		 * 将毫秒转换为日期对象的字符串
		 * 
		 * @param mill
		 *            毫秒
		 * @return java.lang.String 字符串对象
		 */
		public String getDateStr(long mill) {
			return getDateStr(new Date(mill));
		}

		/**
		 * 将字符串转换为日期对象
		 * 
		 * @param dateStr
		 *            日期字符串
		 * @return java.util.Date 日期对象
		 */
		public Date getDateByStr(String dateStr) {
			try {
				SimpleDateFormat formatter = new SimpleDateFormat(pattern);
				return formatter.parse(dateStr);
			} catch (ParseException e) {
				e.printStackTrace();
				return null;
			}
		}

		/**
		 * 获得毫秒 获取失败则返回-1L
		 * 
		 * @param dateStr
		 *            日期字符串
		 * @return long 毫秒
		 */
		public long getTimeByStr(String dateStr) {
			return getDateByStr(dateStr).getTime();
		}

		// 对象属性
		/** 转换对象 */
		//formatter不保证线程安全所以是多例的
		//private SimpleDateFormat formatter;

		/** 格式化格式 */
		private String pattern;
	}
}
