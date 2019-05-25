package com.sun3d.why.model;

import java.util.Date;

public class CmsFunction {
	
    private String funId;
    private String funName;
    private String funDescr;
    private String funIconUrl;
    private String createUser;
    private Date createTime;
    private String updateUser;
    private Date updateTime;

    public String getFunId() {
        return funId;
    }

    public void setFunId(String funId) {
        this.funId = funId == null ? null : funId.trim();
    }

    public String getFunName() {
        return funName;
    }

    public void setFunName(String funName) {
        this.funName = funName == null ? null : funName.trim();
    }

    public String getFunDescr() {
        return funDescr;
    }

    public void setFunDescr(String funDescr) {
        this.funDescr = funDescr == null ? null : funDescr.trim();
    }

    public String getFunIconUrl() {
        return funIconUrl;
    }

    public void setFunIconUrl(String funIconUrl) {
        this.funIconUrl = funIconUrl == null ? null : funIconUrl.trim();
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
}