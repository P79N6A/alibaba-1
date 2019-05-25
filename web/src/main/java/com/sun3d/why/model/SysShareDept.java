package com.sun3d.why.model;

import java.util.Date;

public class SysShareDept {
    private String shareId;

    private String sourceDeptid;	//来源的部门id

    private String targetDeptid;	//目标部门id

    private Integer isShare;	//是否已经分享1:分享 2:不分享

    private String updateUserId;	//更新人用户id

    private Date updateTime;	//更新时间

    private String shareDepthPath;		//来源的部门路径
    
    private String updateUserName;    //更新人用户name
    
    private String targetDeptname;		//目标部门名

    public String getShareId() {
        return shareId;
    }

    public void setShareId(String shareId) {
        this.shareId = shareId == null ? null : shareId.trim();
    }

    public String getSourceDeptid() {
        return sourceDeptid;
    }

    public void setSourceDeptid(String sourceDeptid) {
        this.sourceDeptid = sourceDeptid == null ? null : sourceDeptid.trim();
    }

    public String getTargetDeptid() {
        return targetDeptid;
    }

    public void setTargetDeptid(String targetDeptid) {
        this.targetDeptid = targetDeptid == null ? null : targetDeptid.trim();
    }

    public Integer getIsShare() {
        return isShare;
    }

    public void setIsShare(Integer isShare) {
        this.isShare = isShare;
    }

    public String getUpdateUserId() {
		return updateUserId;
	}

	public void setUpdateUserId(String updateUserId) {
		this.updateUserId = updateUserId;
	}

	public String getUpdateUserName() {
		return updateUserName;
	}

	public void setUpdateUserName(String updateUserName) {
		this.updateUserName = updateUserName;
	}

	public Date getUpdateTime() {
        return updateTime;
    }

    public void setUpdateTime(Date updateTime) {
        this.updateTime = updateTime;
    }

    public String getShareDepthPath() {
        return shareDepthPath;
    }

    public void setShareDepthPath(String shareDepthPath) {
        this.shareDepthPath = shareDepthPath == null ? null : shareDepthPath.trim();
    }

	public String getTargetDeptname() {
		return targetDeptname;
	}

	public void setTargetDeptname(String targetDeptname) {
		this.targetDeptname = targetDeptname;
	}
    
}