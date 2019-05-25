/**
 * 
 */
package com.culturecloud.aop;

/**************************************
 * @Description：异常信息显示类
 * @author Zhangchenxi
 * @since 2016年1月18日
 * @version 1.0
 **************************************/

public enum ExceptionDisplay {

	hidden("0"),//隐藏
	display("1");//显示
	private String nCode;
	
	private ExceptionDisplay(String nCode)
	{
		this.nCode = nCode;
	}
	
	public String getValue() {
		return nCode;
	}
}
