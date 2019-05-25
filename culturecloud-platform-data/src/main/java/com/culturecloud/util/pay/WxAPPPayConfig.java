package com.culturecloud.util.pay;

public class WxAPPPayConfig {

	private String partnerId;
	
	private String prepayId;
	
	private String noncestr;
	
	private String timestamp;
	
	private String pack_age;
	
	private String sign;

	public String getPartnerId() {
		return partnerId;
	}

	public void setPartnerId(String partnerId) {
		this.partnerId = partnerId;
	}

	public String getPrepayId() {
		return prepayId;
	}

	public void setPrepayId(String prepayId) {
		this.prepayId = prepayId;
	}

	public String getNoncestr() {
		return noncestr;
	}

	public void setNoncestr(String noncestr) {
		this.noncestr = noncestr;
	}

	public String getTimestamp() {
		return timestamp;
	}

	public void setTimestamp(String timestamp) {
		this.timestamp = timestamp;
	}

	public String getPack_age() {
		return pack_age;
	}

	public void setPack_age(String pack_age) {
		this.pack_age = pack_age;
	}

	public String getSign() {
		return sign;
	}

	public void setSign(String sign) {
		this.sign = sign;
	}

	
}
