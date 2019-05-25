package com.culturecloud.util;

import com.alibaba.fastjson.JSONObject;

public class JSONResponse {
	
	//封装接口数据
	public static JSONObject getResultFormat(int code, Object data) {
		JSONObject jsonObj = new JSONObject();
		jsonObj.put("status", code);
		jsonObj.put("data", data);
		return jsonObj;
	}
}
