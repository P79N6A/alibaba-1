package com.sun3d.why.util;

import net.sf.json.JSONObject;
import org.apache.commons.lang3.StringUtils;

import java.util.HashMap;
import java.util.Map;

public class JSONResponse {
	static String result;
	public static String toResultFormat(int code, Object data, Pagination page) {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("page",page);
		resultMap.put("data", data);
		resultMap.put("status", code);
		JSONObject jsonObj = JSONObject.fromObject(resultMap);
		result = jsonObj.toString();
		return result;
	}
	//封装app接口数据
	public static String toAppResultFormat(int code, Object data) {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("data", data);
		resultMap.put("status", code);
		JSONObject jsonObj = JSONObject.fromObject(resultMap);
		result = jsonObj.toString();
		return result;
	}
	//app针对获取藏品列表接口数据 Three parameters
	public static String toFourParamterResult(int code, Object data,Object data1,Object data2,Object data3) {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("data", data);
		resultMap.put("status", code);
		if(data1!=null){
			resultMap.put("data1", data1);
		}
		resultMap.put("data2", data2);
		if(data3!=null) {
			resultMap.put("data3", data3);
		}
		JSONObject jsonObj = JSONObject.fromObject(resultMap);
		result = jsonObj.toString();
		return result;
	}
	//三个返回参数
	public static String toThreeParamterResult(int code, Object data,Object data1,Object data2) {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("data", data);
		resultMap.put("status", code);
		if(data1!=null){
			resultMap.put("data1", data1);
		}
		if(data2!=null) {
			resultMap.put("data2", data2);
		}
		JSONObject jsonObj = JSONObject.fromObject(resultMap);
		result = jsonObj.toString();
		return result;
	}
	//app针对获取列表接口数据
	public static String toAppResultObject(int code, Object data,Object data1) {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("status", code);
		resultMap.put("data",data);
		resultMap.put("data1", data1);
		JSONObject jsonObj = JSONObject.fromObject(resultMap);
		result = jsonObj.toString();
		return result;
	}
	//app封装活动列表接口
	public static String toAppActivityResultFormat(int code, Object data,Integer total) {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("data", data);
		resultMap.put("status", code);
		resultMap.put("pageTotal",total);
		JSONObject jsonObj = JSONObject.fromObject(resultMap);
		result = jsonObj.toString();
		return result;
	}
	/*
	 *  app封装公共json数据
	 */
	public static String commonResultFormat(int code, String data,String terminalUserId) {
		JSONObject json = new JSONObject();
		json.put("status", code);
		json.put("data", data);
		if(terminalUserId!=null && StringUtils.isNotBlank(terminalUserId)){
			json.put("userId",terminalUserId);
		}
		return json.toString();
	}

	//封装app接口数据
	public static String toAppResultFormat(int code, String type, Object data) {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("data", data);
		resultMap.put("status", code);
		resultMap.put("orderValidateCodeType", type);
		JSONObject jsonObj = JSONObject.fromObject(resultMap);
		result = jsonObj.toString();
		return result;
	}

	public static String getResult(int i, String s) {
		JSONObject json = new JSONObject();
		json.put("status", i);
		json.put("data", s);
		return json.toString();
	}
}
