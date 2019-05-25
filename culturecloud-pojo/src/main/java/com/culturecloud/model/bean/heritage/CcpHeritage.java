package com.culturecloud.model.bean.heritage;

import java.util.Date;

import javax.persistence.Column;

import com.culturecloud.annotations.Id;
import com.culturecloud.annotations.Table;
import com.culturecloud.bean.BaseEntity;

@Table(value="ccp_heritage")
public class CcpHeritage implements BaseEntity{

	private static final long serialVersionUID = -8657898072687050503L;

	@Id
	@Column(name="HERITAGE_ID")
	private String heritageId;

	@Column(name="HERITAGE_NAME")
    private String heritageName;
	
	@Column(name="HERITAGE_COVER_IMG")
    private String heritageCoverImg;

	@Column(name="HERITAGE_TYPE")
    private String heritageType;

	@Column(name="HERITAGE_LEVEL")
    private String heritageLevel;

	@Column(name="HERITAGE_AREA")
    private String heritageArea;

	@Column(name="HERITAGE_DYNASTY")
    private String heritageDynasty;

	@Column(name="HERITAGE_INTRODUCE")
    private String heritageIntroduce;

	@Column(name="CREATE_TIME")
    private Date createTime;

	@Column(name="CREATE_USER")
    private String createUser;

	@Column(name="UPDATE_TIME")
    private Date updateTime;

	@Column(name="UPDATE_USER")
    private String updateUser;

    public String getHeritageId() {
        return heritageId;
    }

    public void setHeritageId(String heritageId) {
        this.heritageId = heritageId == null ? null : heritageId.trim();
    }

    public String getHeritageName() {
        return heritageName;
    }

    public void setHeritageName(String heritageName) {
        this.heritageName = heritageName == null ? null : heritageName.trim();
    }

    public String getHeritageType() {
        return heritageType;
    }

    public void setHeritageType(String heritageType) {
        this.heritageType = heritageType == null ? null : heritageType.trim();
    }

    public String getHeritageLevel() {
        return heritageLevel;
    }

    public void setHeritageLevel(String heritageLevel) {
        this.heritageLevel = heritageLevel == null ? null : heritageLevel.trim();
    }

    public String getHeritageArea() {
        return heritageArea;
    }

    public void setHeritageArea(String heritageArea) {
        this.heritageArea = heritageArea == null ? null : heritageArea.trim();
    }

    public String getHeritageDynasty() {
        return heritageDynasty;
    }

    public void setHeritageDynasty(String heritageDynasty) {
        this.heritageDynasty = heritageDynasty == null ? null : heritageDynasty.trim();
    }

    public String getHeritageIntroduce() {
        return heritageIntroduce;
    }

    public void setHeritageIntroduce(String heritageIntroduce) {
        this.heritageIntroduce = heritageIntroduce == null ? null : heritageIntroduce.trim();
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
        this.createUser = createUser == null ? null : createUser.trim();
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
        this.updateUser = updateUser == null ? null : updateUser.trim();
    }

	public String getHeritageCoverImg() {
		return heritageCoverImg;
	}

	public void setHeritageCoverImg(String heritageCoverImg) {
		this.heritageCoverImg = heritageCoverImg;
	}
    
}