/*
@author lijing
@version 1.0 2015年8月3日 下午5:59:05
定义添加消息类型，定义错误信息
*/
package com.sun3d.why.webservice.api.model;

import com.sun3d.why.webservice.api.util.CmsApiStatusConstant;

public class CmsApiMessage {
	private Integer Code;
	private String text;
	private boolean status;
	
	
	public CmsApiMessage(){
		this.Code=CmsApiStatusConstant.ERROR;
		this.text="未知错误,初始化未成功。";
		this.status=false;
		
	}
	public Integer getCode() {
		return Code;
	}
	public void setCode(Integer code) {
		Code = code;
	}
	public String getText() {
		return text;
	}
	public void setText(String text) {
		this.text = text;
	}
	
	public boolean getStatus() {
		return status;
	}
	public void setStatus(boolean status) {
		this.status = status;
	}
	
	
}

