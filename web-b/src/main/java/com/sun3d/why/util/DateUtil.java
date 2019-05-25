package com.sun3d.why.util;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

/**
 * 日期工具类
 * @version 	1.0 2018-4-26
 * @author		liunima
 * @history	
 */
public class DateUtil
{
	/**
	 * 生成日期解析对象
	 * @param 	pattern		转换格式
	 * @return	DateFormat	日期解析对象
	 */
	private static DateFormat doDateFormat(String pattern)
	{
		return new SimpleDateFormat(pattern);
	}
	
	/**
	 * 日期转换到字符串
	 * @param 	paramDate		要转换的日期
	 * @param 	pattern			转换格式：例：yyyy-MM-dd
	 * @return	String			日期字符串
	 */
	public static String dateToString(Date paramDate, String pattern)
	{
		return doDateFormat(pattern).format(paramDate);
	}
	
	/**
	 * 字符串转换到日期
	 * @param 	dateStr		日期字符串
	 * @param 	pattern		转换格式：例：yyyy-MM-dd
	 * @return	Date		转换后的日期
	 */
	public static Date stringToDate(String dateStr, String pattern)
	{
		try
		{
			return doDateFormat(pattern).parse(dateStr);
		}
		catch(Exception e)
		{
			System.out.println("字符串转换到日期出错！");
			throw new RuntimeException();
		}
	}
	
	/**
	 * 获取当前日期(字符串格式)
	 * @param 	pattern		转换格式：例：yyyy-MM-dd
	 * @return	String		日期字符串
	 */
	public static String getCurrDate(String pattern)
	{
		return dateToString(new Date(), pattern);
	}
	
	/**
	 * 获取当前日期(日期格式)
	 * @param 	pattern		转换格式：例：yyyy-MM-dd
	 * @return	Date		日期
	 */
	public static Date getCurrDateOfDate(String pattern)
	{
		return stringToDate(dateToString(new Date(), pattern), pattern);
	}
	
	/**
	 * 将分钟数转换为HH:mm格式的时间字符串
	 * @param 	paramMinutes 	分钟数
	 * @return	String			HH:mm格式的时间字符串
	 */
	public static String minsToTime(int paramMinutes) 
	{
		int hh = paramMinutes / 60;
		int mm = paramMinutes % 60;
		
		String retStr = "";
		if(hh < 10)
			retStr += "0" + hh + ":";
		else
			retStr += hh + ":";
		
		if (mm < 10) 
			retStr += "0" + mm;
		else 
			retStr += String.valueOf(mm);
	
		return retStr;
	}
	
	/**
	 * 将HH:mm格式的时间字符串转换为分钟数
	 * @param	paramTime	时间字符串
	 * @return	String
	 */
	public static int timeToMins(String paramTime)
	{
		String hhTime = paramTime.split(":")[0];
		String mmTime = paramTime.split(":")[1];
		
		return Integer.parseInt(hhTime) * 60 + Integer.parseInt(mmTime);
	}
	
	/**
	 * 判断当前系统时间是否在经营时间内
	 * @param 	busiStartTime	经营开始时间：格式为：HH:MM
	 * @param 	busiEndTime		经营结束时间：格式为：HH:MM
	 * @return	String			0、不在经营时间内 1、在经营时间内	
	 */
	public static String isInBusiTime(String busiStartTime, String busiEndTime)
	{
		//经营开始时间分钟数
		int startMinutes = timeToMins(busiStartTime);
		//经营结束时间分钟数
		int endMinutes = timeToMins(busiEndTime);
		
		//当前时间分钟数
		int currMinutes = timeToMins(dateToString(new Date(), "HH:mm"));
		
		if(currMinutes >= startMinutes && currMinutes <= endMinutes)
			return "1";

		return "0";
	}
	
	/**
     * 获取日期是星期几
     * @param 	paramDate	参数日期
     * @param 	retFormat 	返回格式：0、表示返回数字格式 1、表示返回中文格式
     * @return	String		星期几
     */
    public static String getDayOfWeek(Date paramDate, int retFormat)
    {
    	Calendar c = Calendar.getInstance();
    	c.setTime(paramDate);
    	int dayOfWeek = (c.get(Calendar.DAY_OF_WEEK) == 1) ? 7 : c.get(Calendar.DAY_OF_WEEK) - 1;
    	String dayOfWeekStr = null;
    	switch (dayOfWeek) 
    	{
    		case 1:
    			dayOfWeekStr = (0 == retFormat) ? "1" : "一";
    			break;
    		case 2:
    			dayOfWeekStr = (0 == retFormat) ? "2" : "二";
    			break;
    		case 3:
    			dayOfWeekStr = (0 == retFormat) ? "3" : "三";
    			break;
    		case 4:
    			dayOfWeekStr = (0 == retFormat) ? "4" : "四";
    			break;
    		case 5:
    			dayOfWeekStr = (0 == retFormat) ? "5" : "五";
    			break;
    		case 6:
    			dayOfWeekStr = (0 == retFormat) ? "6" : "六";
    			break;
    		case 7:
    			dayOfWeekStr = (0 == retFormat) ? "7" : "日";
    			break;
		}
    	return dayOfWeekStr;
    }
    
    /**
     * 指定日期几天后或者几天前的日期
     * @param 	paramDate	指定日期
     * @param 	days		天数
     * @return	Date		几天后或者几天前的日期
     */
    public static Date addDate(Date paramDate, int days)
    {
    	Calendar calendar = Calendar.getInstance();
    	calendar.setTime(paramDate);
    	calendar.add(Calendar.DATE, days);
    	return calendar.getTime();
    }
    
    /**
     * 指定日期几月后或者几月前的日期
     * @param 	paramDate	指定日期
     * @param 	months		月数
     * @return	Date		几月后或者几月前的日期	
     */
    public static Date addDateOfMonth(Date paramDate, int months)
    {
    	Calendar calendar = Calendar.getInstance();
    	calendar.setTime(paramDate);
    	calendar.add(Calendar.MONTH, months);
    	return calendar.getTime();
    }
    
    /**
     * 根据指定日期获取指定日期所在周的开始日期和结束日期(星期一、星期天)
     * @param 	paramDate	指定日期
     * @return	String[]	开始日期和结束日期数组
     */
    public static String[] getWeekStartAndEndDate(Date paramDate)
    {
    	String[] retAry = new String[2];

    	Calendar calendar = Calendar.getInstance();
    	calendar.setTime(paramDate);
    	//以周一为一周的开始
		calendar.setFirstDayOfWeek(Calendar.MONDAY);
		calendar.set(Calendar.DAY_OF_WEEK, 2);
		retAry[0] = dateToString(calendar.getTime(), "yyyy-MM-dd");
		calendar.set(Calendar.DAY_OF_WEEK, 1);
		retAry[1] = dateToString(calendar.getTime(), "yyyy-MM-dd");
		
		return retAry;
    }
    
    /**
	 * 根据指定日期获取指定日期所在月的第一天和最后一天
	 * @param	paramDate	指定日期
	 * @return	String[]	第一天和最后一天数组
	 */
	public static String[] getMonthStartAndEndDate(Date paramDate)
	{
		String[] retAry = new String[2];
		
		Calendar calendar = Calendar.getInstance();
		calendar.setTime(paramDate);
		calendar.set(Calendar.DAY_OF_MONTH, 1);
		retAry[0] = dateToString(calendar.getTime(), "yyyy-MM-dd");
		calendar.add(Calendar.MONTH, 1);
		calendar.set(Calendar.DAY_OF_MONTH, 0);
		retAry[1] = dateToString(calendar.getTime(), "yyyy-MM-dd");
		
		return retAry;
	}
	
	/**
	 * 获取指定两个日期相差的天数
	 * @param 	paramDate1		指定日期1
	 * @param 	paramDate2		指定日期2
	 * @return	int				相差天数
	 */
	public static int getDiffDaysOfTwoDate(String paramDate1, String paramDate2)
	{
		Date date1 = stringToDate(paramDate1, "yyyy-MM-dd");
		Date date2 = stringToDate(paramDate2, "yyyy-MM-dd");
		
		Long diffTimes = date1.getTime() - date2.getTime();
		Long diffDays = diffTimes / (3600 * 1000 * 24);
		
		return Math.abs(diffDays.intValue());
	}
	
	/**
	 * 获取指定日期相差月份数
	 * @param 	paramDate1	指定日期1
	 * @param 	paramDate2	指定日期2
	 * @return 	int			相差月份数
	 * 注：日期所在月都算一月
	 */
	public static int getDiffMonthsOfTwoDate(String paramDate1, String paramDate2)
	{
		//指定日期1的年份、月份
		int tempYear1 = Integer.parseInt(paramDate1.substring(0, 4));
		int tempMonth1 = Integer.parseInt(paramDate1.substring(5, 7));
		
		//指定日期2的年份、月份
		int tempYear2 = Integer.parseInt(paramDate2.substring(0, 4));
		int tempMonth2 = Integer.parseInt(paramDate2.substring(5, 7));
		
		return Math.abs((tempYear1 * 12 + tempMonth1) - (tempYear2 * 12 + tempMonth2)) + 1;
	}
	
	/**
	 * 获取指定日期所在月有多少天
	 * @param 	paramDate	指定日期(yyyy-MM格式)
	 * @return	int			指定日期所在月有多少天
	 */
	public static int getDaysOfMonths(String paramDate)
	{
		int days = 0;
		try
		{
			Date date = doDateFormat("yyyy-MM").parse(paramDate);	
			Calendar calendar = Calendar.getInstance();
			calendar.setTime(date);
			days = calendar.getActualMaximum(Calendar.DAY_OF_MONTH);
		}
		catch(Exception e)
		{
			System.out.println("字符串转换到日期出错");
			throw new RuntimeException();
		}
		return days;
	}
	
	/**
	 * 计算开始日期和结束日期之间相差的天数
	 * @param 	startDate			开始日期
	 * @param 	endDate				结束日期
	 * @param	useMonthControl		使用月份控制字符串
	 * @return	int					相差天数
	 * 注：相差天数等于开始日期和结束日期相差的天数并剔除不包含的月份的天数
	 */
	public static int computeDiffDaysOfTwoDate(String startDate, String endDate, String useMonthControl)
	{
		//两个日期实际相差的天数
		int diffDays = DateUtil.getDiffDaysOfTwoDate(startDate, endDate) + 1;
		if(useMonthControl == null || useMonthControl.split(",").length == 12)//没有月份限制
			return diffDays;
		else//有月份限制
		{
			useMonthControl = "," + useMonthControl + ",";
			int startYear = Integer.parseInt(startDate.substring(0, 4));
			int startMonth = Integer.parseInt(startDate.substring(5, 7));
			int startDay = Integer.parseInt(startDate.substring(8, 10));
			int endYear = Integer.parseInt(endDate.substring(0, 4));
			int endMonth = Integer.parseInt(endDate.substring(5, 7));
			int endDay = Integer.parseInt(endDate.substring(8, 10));
			int daysOfMonth = 0;//一月的天数
			
			for(int i = startYear; i <= endYear; i++)
			{
				int tmp1 = 0;
				int tmp2 = 0;
				if(i == startYear)
					tmp1 = startMonth;
				else
					tmp1 = 1;
				if(i == endYear)
					tmp2 = endMonth;
				else
					tmp2 = 12;
				for(int j = tmp1; j <= tmp2; j++)
				{
					if(!useMonthControl.contains("," + j + ","))
					{
						//如果开始日期和结束日期是同年同月
						if(startYear == endYear && startMonth == endMonth) return 0;
						if(i == startYear && j == startMonth)//和开始日期是同一月
						{
							daysOfMonth = DateUtil.getDaysOfMonths(startDate.substring(0, 7));
							diffDays = diffDays - (daysOfMonth - startDay + 1);
						}
						else if(i == endYear && j == endMonth)//和结束日期是同一月
							diffDays = diffDays - endDay;
						else
						{
							daysOfMonth = DateUtil.getDaysOfMonths(i + "-" + (j >9 ? j : "0" + j));
							diffDays = diffDays - daysOfMonth;
						}
					}
				}
			}
		}
		
		return diffDays;
	}

	/**
	 * 获取指定日期相差小时数
	 * @param 	startTime	指定日期1
	 * @param 	endTime	指定日期2
	 * @return 	int			相差月份数
	 * 注：日期所在月都算一月
	 */
	public static int getDiffHoursOfTwoDate(String startTime, String endTime) throws ParseException {
		Date date1 = doDateFormat("yyyy-MM-dd HH:mm:ss").parse(endTime);
		Date date2 = doDateFormat("yyyy-MM-dd HH:mm:ss").parse(startTime);
		long l= date1.getTime()-date2.getTime();
		long day=l/(24*60*60*1000);
		long hour=(l/(60*60*1000)-day*24);
		long min=((l/(60*1000))-day*24*60-hour*60);
		long s=(l/1000-day*24*60*60-hour*60*60-min*60);
		System.out.println(""+day+"天"+hour+"小时"+min+"分"+s+"秒");
		return (int) (day*24+hour);
	}
}

