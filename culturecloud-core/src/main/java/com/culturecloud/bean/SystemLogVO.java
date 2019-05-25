/**
 * 
 */
package com.culturecloud.bean;

/**************************************
 * @Description：系统日志记录VO
 * @author Zhangchenxi
 * @since 2016年3月8日
 * @version 1.0
 **************************************/
public class SystemLogVO {

	/** 包路径*/
	private String classFullName;
	
	/** 方法名*/
	private String methodName;
	
	/** 方法注解*/
	private String logRemark;
	
	/** 请求参数*/
	private String params;
	
	/** 请求时间*/
	private String createTime;
	
	/** 执行时间*/
	private String executeTime;
	
	/** 响应报文*/
	private String response;
	
	/** 系统模块*/
	private String systemTemplate;
	
	/** 系统版本*/
	private String version;
	
	/** 所属运营功能*/
	private String operation;
	
	/** 用户id*/
	private String userId;
	
	/** 经度*/
	private String userLon;
	/** 纬度*/
	private String userLat;

	public String getClassFullName() {
		return classFullName;
	}

	public void setClassFullName(String classFullName) {
		this.classFullName = classFullName;
	}

	public String getMethodName() {
		return methodName;
	}

	public void setMethodName(String methodName) {
		this.methodName = methodName;
	}

	public String getLogRemark() {
		return logRemark;
	}

	public void setLogRemark(String logRemark) {
		this.logRemark = logRemark;
	}

	public String getParams() {
		return params;
	}

	public void setParams(String params) {
		this.params = params;
	}

	public String getCreateTime() {
		return createTime;
	}

	public void setCreateTime(String createTime) {
		this.createTime = createTime;
	}

	public String getExecuteTime() {
		return executeTime;
	}

	public void setExecuteTime(String executeTime) {
		this.executeTime = executeTime;
	}

	public String getResponse() {
		return response;
	}

	public void setResponse(String response) {
		this.response = response;
	}

	public String getSystemTemplate() {
		return systemTemplate;
	}

	public void setSystemTemplate(String systemTemplate) {
		this.systemTemplate = systemTemplate;
	}

	public String getVersion() {
		return version;
	}

	public void setVersion(String version) {
		this.version = version;
	}
	public String getOperation() {
		return operation;
	}

	public void setOperation(String operation) {
		this.operation = operation;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getUserLon() {
		return userLon;
	}

	public void setUserLon(String userLon) {
		this.userLon = userLon;
	}

	public String getUserLat() {
		return userLat;
	}

	public void setUserLat(String userLat) {
		this.userLat = userLat;
	}
	
}
