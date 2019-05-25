package com.culturecloud.model.response.live;

import java.lang.reflect.InvocationTargetException;

import org.apache.commons.beanutils.PropertyUtils;

import com.culturecloud.model.bean.live.CcpLiveMessage;
import com.culturecloud.model.bean.live.CcpLiveUser;

public class CcpLiveUserVO extends CcpLiveUser {

	private static final long serialVersionUID = -2575485457545007815L;
	
	private String userName;

	private String userHeadImgUrl;
	
	private int isLikeSum;
	
	public CcpLiveUserVO() {
	}

	public CcpLiveUserVO(CcpLiveUser user) {

		try {
			PropertyUtils.copyProperties(this, user);
		} catch (IllegalAccessException | InvocationTargetException | NoSuchMethodException e) {
			e.printStackTrace();
		}
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

	public int getIsLikeSum() {
		return isLikeSum;
	}

	public void setIsLikeSum(int isLikeSum) {
		this.isLikeSum = isLikeSum;
	}
	
	
}
