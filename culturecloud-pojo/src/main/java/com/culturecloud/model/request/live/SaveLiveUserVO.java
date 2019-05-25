package com.culturecloud.model.request.live;



import com.culturecloud.bean.BaseRequest;

public class SaveLiveUserVO extends BaseRequest {

	private String liveUserId;

	private String userId;

	private String liveActivity;

	private String userRealName;

	private String userTelephone;

	private String userUploadImg;

	private Integer userIsLike;

	public String getLiveUserId() {
		return liveUserId;
	}

	public void setLiveUserId(String liveUserId) {
		this.liveUserId = liveUserId;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getLiveActivity() {
		return liveActivity;
	}

	public void setLiveActivity(String liveActivity) {
		this.liveActivity = liveActivity;
	}

	public String getUserRealName() {
		return userRealName;
	}

	public void setUserRealName(String userRealName) {
		this.userRealName = userRealName;
	}

	public String getUserTelephone() {
		return userTelephone;
	}

	public void setUserTelephone(String userTelephone) {
		this.userTelephone = userTelephone;
	}

	public String getUserUploadImg() {
		return userUploadImg;
	}

	public void setUserUploadImg(String userUploadImg) {
		this.userUploadImg = userUploadImg;
	}

	public Integer getUserIsLike() {
		return userIsLike;
	}

	public void setUserIsLike(Integer userIsLike) {
		this.userIsLike = userIsLike;
	}
	
	
}
