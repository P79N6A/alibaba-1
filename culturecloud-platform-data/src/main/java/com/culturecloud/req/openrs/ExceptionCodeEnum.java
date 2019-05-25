package com.culturecloud.req.openrs;

/**
 * 系统来源
 * 
 * @author zhangshun
 *
 */
public enum ExceptionCodeEnum {

	SYS_SOURCE_ERROR(41001);
	
	private Integer code;
	
	private ExceptionCodeEnum(Integer code) {
		this.code= code;
	}

	public Integer getCode() {
		return code;
	}
	
	
}
