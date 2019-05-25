package com.culturecloud.bean;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.xml.bind.annotation.adapters.XmlAdapter;

/**
 * @Description: 实体Bean日期序列化、反序列化辅助类
 * @author zhangchenxi
 * @since 2015-04-22
 * @version 1.0
 */
public class DateAdapter extends XmlAdapter<String, Date> {
	/*
	 * 反序列化日期类型
	 */
	@Override
	public Date unmarshal(String v) throws Exception {
		if (v == null) {
			return null;
		}
		
		DateFormat dd = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS");
		
		try {
			Long s = Long.parseLong(v);
			v = dd.format(new java.util.Date(s));
		} catch (NumberFormatException e) {

		}

		Date date = null;
		try {
			date = dd.parse(v);
		} catch (ParseException e) {
			e.printStackTrace();
		}
		return date;
	}

	/*
	 * 序列化日期类型
	 */
	@Override
	public String marshal(Date v) throws Exception {
		
		if(v == null)
			return null;
		
		Long timeLong = v.getTime();
		
		return timeLong.toString();
	}
}