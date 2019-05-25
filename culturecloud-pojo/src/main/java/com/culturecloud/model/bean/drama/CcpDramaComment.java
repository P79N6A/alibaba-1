package com.culturecloud.model.bean.drama;

import java.util.Date;

import com.culturecloud.bean.BaseEntity;

public class CcpDramaComment implements BaseEntity{
    
	private static final long serialVersionUID = -5499520882361461132L;

	private String dramaCommentId;

    private String dramaId;

    private String userId;

    private String dramaCommentRemark;

    private Integer dramaStatus;

    private Date createTime;

    private Date updateTime;

    public String getDramaCommentId() {
        return dramaCommentId;
    }

    public void setDramaCommentId(String dramaCommentId) {
        this.dramaCommentId = dramaCommentId == null ? null : dramaCommentId.trim();
    }

    public String getDramaId() {
        return dramaId;
    }

    public void setDramaId(String dramaId) {
        this.dramaId = dramaId == null ? null : dramaId.trim();
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId == null ? null : userId.trim();
    }

    public String getDramaCommentRemark() {
        return dramaCommentRemark;
    }

    public void setDramaCommentRemark(String dramaCommentRemark) {
        this.dramaCommentRemark = dramaCommentRemark == null ? null : dramaCommentRemark.trim();
    }

    public Integer getDramaStatus() {
        return dramaStatus;
    }

    public void setDramaStatus(Integer dramaStatus) {
        this.dramaStatus = dramaStatus;
    }

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }

    public Date getUpdateTime() {
        return updateTime;
    }

    public void setUpdateTime(Date updateTime) {
        this.updateTime = updateTime;
    }
}