package com.culturecloud.model.request.live;

import javax.validation.constraints.NotNull;

import com.culturecloud.bean.BaseRequest;

public class LiveVersionNoCheckVO extends BaseRequest{

    // mobileType 1-ios 2-android
	@NotNull(message = "移动端版本不能为空")
	private Integer mobileType;
	
	@NotNull(message = "版本号不能为空")
	private String versionNo;


	public String getVersionNo() {
		return versionNo;
	}

	public void setVersionNo(String versionNo) {
		this.versionNo = versionNo;
	}

	public Integer getMobileType() {
		return mobileType;
	}

	public void setMobileType(Integer mobileType) {
		this.mobileType = mobileType;
	}
	
	
	
}
