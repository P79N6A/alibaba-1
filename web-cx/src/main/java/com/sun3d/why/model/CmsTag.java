package com.sun3d.why.model;

import java.io.Serializable;
import java.util.Date;

public class CmsTag implements Serializable {
    private String tagId;

    private String tagName;

    private String tagType;

    private String tagSearchStr;

    private String tagCreateUser;

    private Date tagCreateTime;

    private String tagUpdateUser;

    private Date tagUpdateTime;

    private String tagDept;

    private Integer tagIsDelete;

    private String tagColor;

    private String tagInitial;

    private Integer tagRecommend;
    private  String dictName;
    private  String dictCode;

    private String tagNames;
    private String updateUserName;


    public String getDictName() {
        return dictName;
    }

    public void setDictName(String dictName) {
        this.dictName = dictName;
    }

    public String getDictCode() {
        return dictCode;
    }

    public void setDictCode(String dictCode) {
        this.dictCode = dictCode;
    }



    public String getTagImageUrl() {
        return tagImageUrl;
    }

    public void setTagImageUrl(String tagImageUrl) {
        this.tagImageUrl = tagImageUrl;
    }

    private String tagImageUrl;

    public String getTagId() {
        return tagId;
    }

    public void setTagId(String tagId) {
        this.tagId = tagId == null ? null : tagId.trim();
    }

    public String getTagName() {
        return tagName;
    }

    public void setTagName(String tagName) {
        this.tagName = tagName == null ? null : tagName.trim();
    }

    public String getTagType() {
        return tagType;
    }

    public void setTagType(String tagType) {
        this.tagType = tagType == null ? null : tagType.trim();
    }

    public String getTagSearchStr() {
        return tagSearchStr;
    }

    public void setTagSearchStr(String tagSearchStr) {
        this.tagSearchStr = tagSearchStr == null ? null : tagSearchStr.trim();
    }

    public String getTagCreateUser() {
        return tagCreateUser;
    }

    public void setTagCreateUser(String tagCreateUser) {
        this.tagCreateUser = tagCreateUser == null ? null : tagCreateUser.trim();
    }

    public Date getTagCreateTime() {
        return tagCreateTime;
    }

    public void setTagCreateTime(Date tagCreateTime) {
        this.tagCreateTime = tagCreateTime;
    }

    public String getTagUpdateUser() {
        return tagUpdateUser;
    }

    public void setTagUpdateUser(String tagUpdateUser) {
        this.tagUpdateUser = tagUpdateUser == null ? null : tagUpdateUser.trim();
    }

    public Date getTagUpdateTime() {
        return tagUpdateTime;
    }

    public void setTagUpdateTime(Date tagUpdateTime) {
        this.tagUpdateTime = tagUpdateTime;
    }

    public String getTagDept() {
        return tagDept;
    }

    public void setTagDept(String tagDept) {
        this.tagDept = tagDept == null ? null : tagDept.trim();
    }

    public Integer getTagIsDelete() {
        return tagIsDelete;
    }

    public void setTagIsDelete(Integer tagIsDelete) {
        this.tagIsDelete = tagIsDelete;
    }

    public Integer getTagRecommend() {
        return tagRecommend;
    }

    public void setTagRecommend(Integer tagRecommend) {
        this.tagRecommend = tagRecommend;
    }

    public String getTagColor() {
        return tagColor;
    }

    public void setTagColor(String tagColor) {
        this.tagColor = tagColor;
    }

    public String getTagInitial() {
        return tagInitial;
    }

    public void setTagInitial(String tagInitial) {
        this.tagInitial = tagInitial;
    }

	public String getTagNames() {
		return tagNames;
	}

	public void setTagNames(String tagNames) {
		this.tagNames = tagNames;
	}

	public String getUpdateUserName() {
		return updateUserName;
	}

	public void setUpdateUserName(String updateUserName) {
		this.updateUserName = updateUserName;
	}
    
    
}