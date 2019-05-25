/**
 * 
 */
package com.sun3d.why.aop;

import com.sdicons.json.mapper.JSONMapper;
import com.sdicons.json.mapper.MapperException;
import com.sdicons.json.model.JSONValue;

/**************************************
 * @Description：（请用一简短的话描述业务功能。）
 * @author Zhangchenxi
 * @since 2016年3月8日
 * @version 1.0
 **************************************/

public class ObjectToJson {

	
	public static String ObjectToJsonString(Object o)
	{
		String jsonString=null;
		JSONValue jsonValueLog;
		try {
			jsonValueLog = JSONMapper.toJSON(o);
			jsonString=jsonValueLog.render(true);
			return jsonString;
		} catch (MapperException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return jsonString;
	}
}
