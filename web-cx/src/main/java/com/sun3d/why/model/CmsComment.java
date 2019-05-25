package com.sun3d.why.model;

import com.sun3d.why.util.Pagination;

import java.io.Serializable;
import java.util.Date;

public class CmsComment extends Pagination implements Serializable {
    private String commentId;

    //评论类型 1-场馆 2-活动 20-动态资讯 21-联盟成员
    private Integer commentType;

    private String commentRkId;

    private String commentRemark;

    private Date commentTime;
    
    //按时间查询
    private String commentStartTime;
    
    private String commentEndTime;

    private String commentUserId;

    private Integer commentIsTop;

    private Date commentTopTime;

    private String commentImgUrl;
    //评论人昵称
    private  String commentUserNickName;

    public String getCommentUserNickName() {
        return commentUserNickName;
    }

    public void setCommentUserNickName(String commentUserNickName) {
        this.commentUserNickName = commentUserNickName;
    }

    // 列表显示评论人名称
    private String commentUserName;
    // 评论的对象的名称
    private String commentRkName;
    // 会员图像路径
    private String userHeadImgUrl;
    // 会员性别
    private Integer userSex;
    //评论星级
    private String commentStar;

    private String activityId;

    private String activityName;

    private String activitySite;

    private String venueId;

    private String venueName;

    /**
     * 评论状态 0：待审核 1：审核通过 2：未通过
     */
    private Integer commentState ;

    public Integer getCommentState() {
        return commentState;
    }

    public void setCommentState(Integer commentState) {
        this.commentState = commentState;
    }

    public String getActivitySite() {
        return activitySite;
    }

    public void setActivitySite(String activitySite) {
        this.activitySite = activitySite == null ? null : activitySite.trim();
    }

    public String getActivityId() {
        return activityId;
    }

    public void setActivityId(String activityId) {
        this.activityId = activityId == null ? null : activityId.trim();
    }

    public String getVenueId() {
        return venueId;
    }

    public void setVenueId(String venueId) {
        this.venueId = venueId == null ? null : venueId.trim();
    }

    public String getActivityName() {
        return activityName;
    }

    public void setActivityName(String activityName) {
        this.activityName = activityName == null ? null : activityName.trim();
    }

    public String getVenueName() {
        return venueName;
    }

    public void setVenueName(String venueName) {
        this.venueName = venueName == null ? null : venueName.trim();
    }

    public Integer getUserSex() {
        return userSex;
    }

    public void setUserSex(Integer userSex) {
        this.userSex = userSex;
    }

    public String getCommentImgUrl() {
        return commentImgUrl;
    }

    public void setCommentImgUrl(String commentImgUrl) {
        this.commentImgUrl = commentImgUrl == null ? null : commentImgUrl.trim();
    }

    public Integer getCommentIsTop() {
        return commentIsTop;
    }

    public void setCommentIsTop(Integer commentIsTop) {
        this.commentIsTop = commentIsTop;
    }

    public Date getCommentTopTime() {
        return commentTopTime;
    }

    public void setCommentTopTime(Date commentTopTime) {
        this.commentTopTime = commentTopTime;
    }

    public String getUserHeadImgUrl() {
        return userHeadImgUrl;
    }

    public void setUserHeadImgUrl(String userHeadImgUrl) {
        this.userHeadImgUrl = userHeadImgUrl == null ? null :userHeadImgUrl.trim();
    }

    public String getCommentRkName() {
        return commentRkName = commentRkName == null ? null : commentRkName.trim();
    }

    public void setCommentRkName(String commentRkName) {
        this.commentRkName = commentRkName;
    }

    public String getCommentUserName() {
        return commentUserName = commentUserName == null ? null : commentUserName.trim();
    }

    public void setCommentUserName(String commentUserName) {
        this.commentUserName = commentUserName;
    }

    public String getCommentId() {
        return commentId;
    }

    public void setCommentId(String commentId) {
        this.commentId = commentId == null ? null : commentId.trim();
    }

    public Integer getCommentType() {
        return commentType;
    }

    public void setCommentType(Integer commentType) {
        this.commentType = commentType;
    }

    public String getCommentRkId() {
        return commentRkId;
    }

    public void setCommentRkId(String commentRkId) {
        this.commentRkId = commentRkId == null ? null : commentRkId.trim();
    }

    public String getCommentRemark() {
        return commentRemark;
    }

    public void setCommentRemark(String commentRemark) {
        this.commentRemark = commentRemark == null ? null : commentRemark.trim();
    }

    public Date getCommentTime() {
        return commentTime;
    }

    public void setCommentTime(Date commentTime) {
        this.commentTime = commentTime;
    }

    public String getCommentUserId() {
        return commentUserId;
    }

    public void setCommentUserId(String commentUserId) {
        this.commentUserId = commentUserId == null ? null : commentUserId.trim();
    }

	public String getCommentStartTime() {
		return commentStartTime;
	}

	public void setCommentStartTime(String commentStartTime) {
		this.commentStartTime = commentStartTime;
	}

	public String getCommentEndTime() {
		return commentEndTime;
	}

	public void setCommentEndTime(String commentEndTime) {
		this.commentEndTime = commentEndTime;
	}

	public String getCommentStar() {
		return commentStar;
	}

	public void setCommentStar(String commentStar) {
		this.commentStar = commentStar;
	}
	
}