package com.culturecloud.dao.dto.live;

import com.culturecloud.model.bean.live.CcpLiveUser;

public class CcpLiveUserDto extends CcpLiveUser {

	private static final long serialVersionUID = -405970746566990798L;

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
