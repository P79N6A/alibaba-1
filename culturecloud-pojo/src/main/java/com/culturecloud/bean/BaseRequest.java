/**
 * 
 */
package com.culturecloud.bean;

import javax.validation.constraints.NotNull;

import com.culturecloud.bean.ValidatorBean;

/**************************************
 * @Description：（请用一简短的话描述业务功能。）
 * @author Zhangchenxi
 * @since 2016年1月18日
 * @version 1.0
 **************************************/

public class BaseRequest implements ValidatorBean{


	private String sysVersion;
	
	private String sysPlatform;
	
	private String sysUserId;
	
	private String sysUserLon;
	
	private String sysUserLat;

	public String getSysVersion() {
		return sysVersion;
	}

	public void setSysVersion(String sysVersion) {
		this.sysVersion = sysVersion;
	}

	public String getSysPlatform() {
		return sysPlatform;
	}

	public void setSysPlatform(String sysPlatform) {
		this.sysPlatform = sysPlatform;
	}

	public String getSysUserId() {
		return sysUserId;
	}

	public void setSysUserId(String sysUserId) {
		this.sysUserId = sysUserId;
	}

	public String getSysUserLon() {
		return sysUserLon;
	}

	public void setSysUserLon(String sysUserLon) {
		this.sysUserLon = sysUserLon;
	}

	public String getSysUserLat() {
		return sysUserLat;
	}

	public void setSysUserLat(String sysUserLat) {
		this.sysUserLat = sysUserLat;
	}

}
