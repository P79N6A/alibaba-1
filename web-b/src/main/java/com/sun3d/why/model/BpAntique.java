package com.sun3d.why.model;

import java.util.Date;

public class BpAntique {

    private String antiqueId;

    private String antiqueName;

    private String antiqueImgUrl;

    private String antiqueSource;

    private String antiqueVideoUrl;

    private Integer antiqueSort;

    private Integer antiqueIsDel;

    private Date antiqueCreateTime;

    private Date antiqueUpdateTime;

    private String antiqueCreateUser;

    private String antiqueUpdateUser;

    private String antiqueType;
    
    private String antiqueDynasty;

    private String antiqueSpecification;

    private String antiqueInfo;

    private String antiqueRemark;

    /**后台搜索关键词*/
    private String searchKey;
    
    public String getAntiqueId() {
        return antiqueId;
    }

    public void setAntiqueId(String antiqueId) {
        this.antiqueId = antiqueId;
    }

    public String getAntiqueName() {
        return antiqueName;
    }

    public void setAntiqueName(String antiqueName) {
        this.antiqueName = antiqueName;
    }

    public String getAntiqueImgUrl() {
        return antiqueImgUrl;
    }

    public void setAntiqueImgUrl(String antiqueImgUrl) {
        this.antiqueImgUrl = antiqueImgUrl;
    }

    public String getAntiqueSource() {
        return antiqueSource;
    }

    public void setAntiqueSource(String antiqueSource) {
        this.antiqueSource = antiqueSource;
    }

    public String getAntiqueVideoUrl() {
        return antiqueVideoUrl;
    }

    public void setAntiqueVideoUrl(String antiqueVideoUrl) {
        this.antiqueVideoUrl = antiqueVideoUrl;
    }

    public Integer getAntiqueSort() {
        return antiqueSort;
    }

    public void setAntiqueSort(Integer antiqueSort) {
        this.antiqueSort = antiqueSort;
    }

    public Integer getAntiqueIsDel() {
        return antiqueIsDel;
    }

    public void setAntiqueIsDel(Integer antiqueIsDel) {
        this.antiqueIsDel = antiqueIsDel;
    }

    public Date getAntiqueCreateTime() {
        return antiqueCreateTime;
    }

    public void setAntiqueCreateTime(Date antiqueCreateTime) {
        this.antiqueCreateTime = antiqueCreateTime;
    }

    public Date getAntiqueUpdateTime() {
        return antiqueUpdateTime;
    }

    public void setAntiqueUpdateTime(Date antiqueUpdateTime) {
        this.antiqueUpdateTime = antiqueUpdateTime;
    }

    public String getAntiqueCreateUser() {
        return antiqueCreateUser;
    }

    public void setAntiqueCreateUser(String antiqueCreateUser) {
        this.antiqueCreateUser = antiqueCreateUser;
    }

    public String getAntiqueUpdateUser() {
        return antiqueUpdateUser;
    }

    public void setAntiqueUpdateUser(String antiqueUpdateUser) {
        this.antiqueUpdateUser = antiqueUpdateUser;
    }

    public String getAntiqueType() {
        return antiqueType;
    }

    public void setAntiqueType(String antiqueType) {
        this.antiqueType = antiqueType;
    }

    public String getAntiqueDynasty() {
        return antiqueDynasty;
    }

    public void setAntiqueDynasty(String antiqueDynasty) {
        this.antiqueDynasty = antiqueDynasty;
    }

    public String getAntiqueSpecification() {
        return antiqueSpecification;
    }

    public void setAntiqueSpecification(String antiqueSpecification) {
        this.antiqueSpecification = antiqueSpecification;
    }

    public String getAntiqueInfo() {
        return antiqueInfo;
    }

    public void setAntiqueInfo(String antiqueInfo) {
        this.antiqueInfo = antiqueInfo;
    }

    public String getAntiqueRemark() {
        return antiqueRemark;
    }

    public void setAntiqueRemark(String antiqueRemark) {
        this.antiqueRemark = antiqueRemark;
    }

	public String getSearchKey() {
		return searchKey;
	}

	public void setSearchKey(String searchKey) {
		this.searchKey = searchKey;
	}
    
}