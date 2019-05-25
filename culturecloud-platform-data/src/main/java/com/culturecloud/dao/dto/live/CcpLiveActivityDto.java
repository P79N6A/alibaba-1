package com.culturecloud.dao.dto.live;

import com.culturecloud.model.bean.live.CcpLiveActivity;

public class CcpLiveActivityDto extends CcpLiveActivity{
	
	private static final long serialVersionUID = 3498697247404832095L;
	
	private String userName;
	
	private String userHeadImgUrl;

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getUserHeadImgUrl() {
		return userHeadImgUrl;
	}

	public void setUserHeadImgUrl(String userHeadImgUrl) {
		this.userHeadImgUrl = userHeadImgUrl;
	}
	
	

}
