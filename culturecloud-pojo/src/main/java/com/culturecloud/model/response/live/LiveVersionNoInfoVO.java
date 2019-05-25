package com.culturecloud.model.response.live;

public class LiveVersionNoInfoVO {

	
	/** 更新类型：0-普通更新  1-强制更新 */
	private Integer updateType;
	/** 最新版本 */
	private String updateVersion;
	private String updateDescription;
	private String updateLink;
	public Integer getUpdateType() {
		return updateType;
	}
	public void setUpdateType(Integer updateType) {
		this.updateType = updateType;
	}
	public String getUpdateVersion() {
		return updateVersion;
	}
	public void setUpdateVersion(String updateVersion) {
		this.updateVersion = updateVersion;
	}
	public String getUpdateDescription() {
		return updateDescription;
	}
	public void setUpdateDescription(String updateDescription) {
		this.updateDescription = updateDescription;
	}
	public String getUpdateLink() {
		return updateLink;
	}
	public void setUpdateLink(String updateLink) {
		this.updateLink = updateLink;
	}
	
	
	
}
