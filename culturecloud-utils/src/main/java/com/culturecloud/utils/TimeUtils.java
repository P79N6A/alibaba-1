package com.culturecloud.utils;

import java.util.Calendar;

/**
 * ʱ�䴦�?����
 * 
 * @author gaoyr
 * 
 */
public class TimeUtils {

	/**
	 * ��ȡ��ʼ����ʱ�����
	 * @return {@link java.util.Calendar}
	 */
	private static Calendar getInitedCalendar(){
		Calendar c = Calendar.getInstance();
		c.set(c.getActualMinimum(Calendar.YEAR), c.getActualMinimum(Calendar.MONTH),
				c.getActualMinimum(Calendar.DAY_OF_YEAR), 0, 0, 0);
		c.set(Calendar.MILLISECOND, 0);
		return c;
	}
	
	/**
	 * ִ������ʱ��
	 * @param c {@link java.util.Calendar}
	 * @param field ��ֵ����
	 * @param value ������ֵ
	 */
	private static void setTime(Calendar c, int field, long value) {
		value = Math.abs(value);
		while (value != 0){
			if (value > Integer.MAX_VALUE) {
				c.add(field, Integer.MAX_VALUE);
				value -= Integer.MAX_VALUE;
			} else {
				c.add(field, (int) value);
				value = 0;
			}
		}
	}

	/**
	 * ��ʽ��ʱ�䣬��xxxxx�롢xxxxxСʱ������ת����x��x��xСʱx��
	 * @param field ��ֵ���ͣ���Calender.SECEND
	 * @param value ������ֵ
	 * @return {@link String}
	 */
	public static String formatTimeFull(int field, long value) {
		Calendar c = getInitedCalendar();
		setTime(c, field, value);
		return new StringBuilder().append(value < 0 ? "��":"").append(c.get(Calendar.YEAR) - c.getActualMinimum(Calendar.YEAR)).append("��")
				.append(c.get(Calendar.DAY_OF_YEAR) - c.getActualMinimum(Calendar.DAY_OF_YEAR)).append("��")
				.append(c.get(Calendar.HOUR_OF_DAY)).append("Сʱ").append(c.get(Calendar.MINUTE)).append("��")
				.append(c.get(Calendar.SECOND)).append("��").append(c.get(Calendar.MILLISECOND)).append("����").toString();
	}

	/**
	 * ��ʽ��ʱ�䣬��xxxxx�롢xxxxxСʱ������ת����x��x��xСʱx�룬����ʱֻ������ֵ�Ĳ���
	 * @param field ��ֵ���ͣ���Calender.SECEND
	 * @param value ������ֵ
	 * @return {@link String}
	 */
	public static String formatTimeShort(int field, long value) {
		Calendar c = getInitedCalendar();
		setTime(c, field, value);
		StringBuilder sb = new StringBuilder();
		if (c.get(Calendar.MILLISECOND) > 0) {
			sb.append(c.get(Calendar.MILLISECOND)).append("����");
		}
		if (c.get(Calendar.SECOND) > 0) {
			sb.insert(0, "��").insert(0, c.get(Calendar.SECOND));
		}
		if (c.get(Calendar.MINUTE) > 0) {
			sb.insert(0, "��").insert(0, c.get(Calendar.MINUTE));
		}
		if (c.get(Calendar.HOUR_OF_DAY) > 0) {
			sb.insert(0, "Сʱ").insert(0, c.get(Calendar.HOUR_OF_DAY));
		}
		if (c.get(Calendar.DAY_OF_YEAR) - c.getActualMinimum(Calendar.DAY_OF_YEAR) > 0) {
			sb.insert(0, "��").insert(0, c.get(Calendar.DAY_OF_YEAR) - c.getActualMinimum(Calendar.DAY_OF_YEAR));
		}
		if (c.get(Calendar.YEAR) - c.getActualMinimum(Calendar.YEAR) > 0) {
			sb.insert(0, "��").insert(0, c.get(Calendar.YEAR) - c.getActualMinimum(Calendar.YEAR));
		}
		if (value < 0){
			sb.insert(0, "��");
		}
		return sb.toString();
	}
}