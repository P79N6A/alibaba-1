package com.sun3d.why.model.weixin;

import java.io.Serializable;

public class Access_token implements Serializable {

	/**
	 * @Description: access_token属性获取
	 * @author lujun
	 * @date 2014年9月26日17:14:50
	 * 
	 */
	private static final long serialVersionUID = 1244526198548038069L;

	private String access_token; //网页授权接口调用凭证
	private String expires_in; //access_token接口调用凭证超时时间,单位(秒)
	private String refresh_token; //用户刷新网页授权接口调用凭证
	private String openid; //用户唯一标示
	private String scope;//用户授权的作用域
	public String getAccess_token() {
		return access_token;
	}
	public void setAccess_token(String access_token) {
		access_token = access_token;
	}
	public String getExpires_in() {
		return expires_in;
	}
	public void setExpires_in(String expires_in) {
		expires_in = expires_in;
	}
	public String getRefresh_token() {
		return refresh_token;
	}
	public void setRefresh_token(String refresh_token) {
		this.refresh_token = refresh_token;
	}
	public String getOpen_id() {
		return openid;
	}
	public void setOpen_id(String open_id) {
		this.openid = open_id;
	}
	public String getScope() {
		return scope;
	}
	public void setScope(String scope) {
		this.scope = scope;
	}
	public static long getSerialversionuid() {
		return serialVersionUID;
	}
	@Override
	public String toString() {
		return "Access_token [Access_token=" + access_token + ", Expires_in="
				+ expires_in + ", refresh_token=" + refresh_token
				+ ", open_id=" + openid + ", scope=" + scope + "]";
	}
	
	
}
