package com.sun3d.why.model;

import java.util.Date;

public class CmsActivityTemplate {
	
    private String templId;
    private String templName;
    private String templDescr;
    private String functions;	//模板功能（虚拟属性）
    private String createUser;
    private Date createTime;
    private String updateUser;
    private Date updateTime;

    public String getTemplId() {
        return templId;
    }

    public void setTemplId(String templId) {
        this.templId = templId == null ? null : templId.trim();
    }

    public String getTemplName() {
        return templName;
    }

    public void setTemplName(String templName) {
        this.templName = templName == null ? null : templName.trim();
    }

    public String getTemplDescr() {
        return templDescr;
    }

    public void setTemplDescr(String templDescr) {
        this.templDescr = templDescr == null ? null : templDescr.trim();
    }

    public String getCreateUser() {
        return createUser;
    }

    public void setCreateUser(String createUser) {
        this.createUser = createUser == null ? null : createUser.trim();
    }

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }

    public String getUpdateUser() {
        return updateUser;
    }

    public void setUpdateUser(String updateUser) {
        this.updateUser = updateUser == null ? null : updateUser.trim();
    }

    public Date getUpdateTime() {
        return updateTime;
    }

    public void setUpdateTime(Date updateTime) {
        this.updateTime = updateTime;
    }

	public String getFunctions() {
		return functions;
	}

	public void setFunctions(String functions) {
		this.functions = functions;
	}
    
}