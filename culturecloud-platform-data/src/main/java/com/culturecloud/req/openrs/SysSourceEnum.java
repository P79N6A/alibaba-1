package com.culturecloud.req.openrs;

/**
 * 系统来源
 * 
 * @author zhangshun
 *
 */
public enum SysSourceEnum {

	FSDL("4a5f5810d7d341b2a94836d0f435b01a");
	private String source;
	
	private SysSourceEnum(String source) {
		this.source= source;
	}

	public String getSource() {
		return source;
	}
	
	
}
