package com.culturecloud.model.response.beautycity;

import com.culturecloud.model.bean.beautycity.CcpBeautycity;

public class CcpBeautycityResVO extends CcpBeautycity{
	
	private static final long serialVersionUID = 4572986067541817373L;

	private String createUserName;
	
	private String userHeadImgUrl;
	
	private String venueCount;
	
	private String imgCount;

	public String getCreateUserName() {
		return createUserName;
	}

	public void setCreateUserName(String createUserName) {
		this.createUserName = createUserName;
	}

	public String getVenueCount() {
		return venueCount;
	}

	public void setVenueCount(String venueCount) {
		this.venueCount = venueCount;
	}

	public String getImgCount() {
		return imgCount;
	}

	public void setImgCount(String imgCount) {
		this.imgCount = imgCount;
	}

	public String getUserHeadImgUrl() {
		return userHeadImgUrl;
	}

	public void setUserHeadImgUrl(String userHeadImgUrl) {
		this.userHeadImgUrl = userHeadImgUrl;
	}
	
	
}