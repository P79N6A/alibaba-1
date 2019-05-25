package com.sun3d.why.enumeration;

/**
 * 系统来源
 * 
 * @author zhangshun
 *
 */
public enum SystemSourceEnum {

	PC("pc"),
	H5("h5"),
	IOS("ios"),
	ANDROID("android");
	
	private String source;
	
	private SystemSourceEnum(String source) {
		this.source= source;
	}

	public String getSource() {
		return source;
	}
	
	
}
