package com.culturecloud.util.pay;

public class WxPayConfig {

	private String nonce_str;
	
	private String timestamp;
	
	private String appId;
	
	private String signType;
	
	private String pack_age;
	
	private String paySign;

	public String getNonce_str() {
		return nonce_str;
	}

	public void setNonce_str(String nonce_str) {
		this.nonce_str = nonce_str;
	}

	public String getTimestamp() {
		return timestamp;
	}

	public void setTimestamp(String timestamp) {
		this.timestamp = timestamp;
	}

	public String getAppId() {
		return appId;
	}

	public void setAppId(String appId) {
		this.appId = appId;
	}

	public String getSignType() {
		return signType;
	}

	public void setSignType(String signType) {
		this.signType = signType;
	}

	public String getPack_age() {
		return pack_age;
	}

	public void setPack_age(String pack_age) {
		this.pack_age = pack_age;
	}

	public String getPaySign() {
		return paySign;
	}

	public void setPaySign(String paySign) {
		this.paySign = paySign;
	}
	
	
}
