package com.culturecloud.dao.dto.live;


import java.util.Date;

import com.culturecloud.model.bean.live.CcpLiveMessage;

public class CcpLiveMessageDto extends CcpLiveMessage{

	private static final long serialVersionUID = 7396170190749473521L;
	
	private String userName;
	
	private String userHeadImgUrl;

	private Date date;

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

	public Date getDate() {
		return date;
	}

	public void setDate(Date date) {
		this.date = date;
	}

	

}
