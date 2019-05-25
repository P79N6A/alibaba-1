package com.sun3d.why.enumeration.redis;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

import org.apache.commons.lang3.StringUtils;
import org.jsoup.helper.StringUtil;

/**
 * 积分 redis key枚举
 * 
 * @author zhangshun
 *
 */
public enum IntegralRedisKeyEnum {

	WEEK_LOGIN_INTEGRAL_ID_SET("week_login_integral_id_set"),
	USER_INTEGRAL_MODEL("user_integral_model");
	
	private String key;
	
	private static SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
	
	
	private IntegralRedisKeyEnum(String key)
	{
		this.key=key;
	}
	
	/**
	 * 获取redis 用户积分保存信息 对象key 
	 * @param userId
	 * @param date
	 * @return
	 */
	public static String getUserIntegralModelKey(String userId,String date)
	{
		if(StringUtils.isNotBlank(userId) && StringUtils.isNotBlank(date))
		{
			return USER_INTEGRAL_MODEL.key+"_"+userId+"_"+date;
		}
		else
			return null;
	}
	
	/**
	 * 获取 redis 
	 * @param date 格式：yyyyMMdd
	 * @return
	 */
	public static String getWeekLoginSetKey(String date){
		
		if(StringUtils.isNotBlank(date))
		{
			return  WEEK_LOGIN_INTEGRAL_ID_SET.key+"_"+date;
		}
		else
			return null;
	}
	
	
	public String getKey() {
		return key;
	}

	/**
	 * 获取本周最后一天 格式 yyyyMMdd
	 * @return
	 */
	public static String getEndOfThisWeek() {
		  
	      Calendar calendar = Calendar.getInstance();
	      calendar.set(Calendar.DAY_OF_WEEK, Calendar.SUNDAY);
	      calendar.add(Calendar.WEEK_OF_YEAR, 1);
	        
		return sdf.format(calendar.getTime()); 
	}
	
	/**
	 * 获取今日日期 格式 yyyyMMdd
	 * @return
	 */
	public static String getToday() {
		  
		return sdf.format(new Date());
	}
	
	/**
	 * 获取上周最后一天
	 * @return
	 */
	public static String getLastWeekEnd()
	{
		Calendar calendar = Calendar.getInstance();
		
		int dayOfWeek=calendar.get(Calendar.DAY_OF_WEEK)-1;
		
		int offset=7-dayOfWeek;
		
		calendar.add(Calendar.DATE, offset-7);
		
	      return sdf.format(calendar.getTime()); 
	}
	
}
