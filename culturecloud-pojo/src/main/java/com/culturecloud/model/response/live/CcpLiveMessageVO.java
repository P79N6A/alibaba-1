package com.culturecloud.model.response.live;

import java.lang.reflect.InvocationTargetException;
import java.util.Date;

import org.apache.commons.beanutils.PropertyUtils;

import com.culturecloud.model.bean.live.CcpLiveMessage;

public class CcpLiveMessageVO extends CcpLiveMessage{

	private static final long serialVersionUID = 4560659970655199135L;
	
	private Date date;
	
	private String userName;
	
	private String userHeadImgUrl;

	public CcpLiveMessageVO(CcpLiveMessage ccpLiveMessage) {
	
		try {
			PropertyUtils.copyProperties(this, ccpLiveMessage);
		} catch (IllegalAccessException | InvocationTargetException | NoSuchMethodException e) {
			e.printStackTrace();
		}
	}


	public Date getDate() {
		return date;
	}



	public void setDate(Date date) {
		this.date = date;
	}



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
