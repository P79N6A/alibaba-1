package com.culturecloud.model.request.heritage;

import java.util.Date;
import java.util.List;

import com.culturecloud.bean.BaseRequest;
import com.culturecloud.model.bean.heritage.CcpHeritageImg;

public class CcpHeritageReqVO extends BaseRequest{

	private String heritageId;

    private String heritageName;
	
    private String heritageCoverImg;

    private String heritageType;

    private String heritageLevel;

    private String heritageArea;

    private String heritageDynasty;

    private String heritageIntroduce;

    private Date createTime;

    private String createUser;

    private Date updateTime;

    private String updateUser;
	
	private List<CcpHeritageImg> CcpHeritageImgList;
	
	private String userId;


	public String getHeritageId() {
		return heritageId;
	}

	public void setHeritageId(String heritageId) {
		this.heritageId = heritageId;
	}

	public String getHeritageName() {
		return heritageName;
	}

	public void setHeritageName(String heritageName) {
		this.heritageName = heritageName;
	}

	public String getHeritageCoverImg() {
		return heritageCoverImg;
	}

	public void setHeritageCoverImg(String heritageCoverImg) {
		this.heritageCoverImg = heritageCoverImg;
	}

	public String getHeritageType() {
		return heritageType;
	}

	public void setHeritageType(String heritageType) {
		this.heritageType = heritageType;
	}

	public String getHeritageLevel() {
		return heritageLevel;
	}

	public void setHeritageLevel(String heritageLevel) {
		this.heritageLevel = heritageLevel;
	}

	public String getHeritageArea() {
		return heritageArea;
	}

	public void setHeritageArea(String heritageArea) {
		this.heritageArea = heritageArea;
	}

	public String getHeritageDynasty() {
		return heritageDynasty;
	}

	public void setHeritageDynasty(String heritageDynasty) {
		this.heritageDynasty = heritageDynasty;
	}

	public String getHeritageIntroduce() {
		return heritageIntroduce;
	}

	public void setHeritageIntroduce(String heritageIntroduce) {
		this.heritageIntroduce = heritageIntroduce;
	}

	public Date getCreateTime() {
		return createTime;
	}

	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
	}

	public String getCreateUser() {
		return createUser;
	}

	public void setCreateUser(String createUser) {
		this.createUser = createUser;
	}

	public Date getUpdateTime() {
		return updateTime;
	}

	public void setUpdateTime(Date updateTime) {
		this.updateTime = updateTime;
	}

	public String getUpdateUser() {
		return updateUser;
	}

	public void setUpdateUser(String updateUser) {
		this.updateUser = updateUser;
	}

	public List<CcpHeritageImg> getCcpHeritageImgList() {
		return CcpHeritageImgList;
	}

	public void setCcpHeritageImgList(List<CcpHeritageImg> ccpHeritageImgList) {
		CcpHeritageImgList = ccpHeritageImgList;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	} 
	
}