package com.sun3d.why.model;

import java.util.Date;
import java.util.List;

public class CmsCulturalSquare {
    private String squareId;

    private String headUrl;

    private String userName;

    private Date publishTime;

    private String contextDec;

    private Integer type;	//1-活动 2-专题活动(1-城市名片、2-我在现场) 3-通知

    private String outId;

    private String ext0;

    private String ext1;

    private String ext2;

    private String ext3;

    private String ext4;
    
    //虚拟属性
    private Integer wantCount;
    
    private Integer userIsWant;
    
    List<CmsComment> commentList;
    
    private Integer commentCount;
    
	public String getSquareId() {
        return squareId;
    }

    public void setSquareId(String squareId) {
        this.squareId = squareId == null ? null : squareId.trim();
    }

    public String getHeadUrl() {
        return headUrl;
    }

    public void setHeadUrl(String headUrl) {
        this.headUrl = headUrl == null ? null : headUrl.trim();
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName == null ? null : userName.trim();
    }

    public Date getPublishTime() {
        return publishTime;
    }

    public void setPublishTime(Date publishTime) {
        this.publishTime = publishTime;
    }

    public String getContextDec() {
        return contextDec;
    }

    public void setContextDec(String contextDec) {
        this.contextDec = contextDec == null ? null : contextDec.trim();
    }

    public Integer getType() {
        return type;
    }

    public void setType(Integer type) {
        this.type = type;
    }

    public String getOutId() {
        return outId;
    }

    public void setOutId(String outId) {
        this.outId = outId == null ? null : outId.trim();
    }

    public String getExt0() {
        return ext0;
    }

    public void setExt0(String ext0) {
        this.ext0 = ext0 == null ? null : ext0.trim();
    }

    public String getExt1() {
        return ext1;
    }

    public void setExt1(String ext1) {
        this.ext1 = ext1 == null ? null : ext1.trim();
    }

    public String getExt2() {
        return ext2;
    }

    public void setExt2(String ext2) {
        this.ext2 = ext2 == null ? null : ext2.trim();
    }

    public String getExt3() {
        return ext3;
    }

    public void setExt3(String ext3) {
        this.ext3 = ext3 == null ? null : ext3.trim();
    }

    public String getExt4() {
        return ext4;
    }

    public void setExt4(String ext4) {
        this.ext4 = ext4 == null ? null : ext4.trim();
    }

	public Integer getWantCount() {
		return wantCount;
	}

	public void setWantCount(Integer wantCount) {
		this.wantCount = wantCount;
	}

	public List<CmsComment> getCommentList() {
		return commentList;
	}

	public void setCommentList(List<CmsComment> commentList) {
		this.commentList = commentList;
	}

	public Integer getCommentCount() {
		return commentCount;
	}

	public void setCommentCount(Integer commentCount) {
		this.commentCount = commentCount;
	}

	public Integer getUserIsWant() {
		return userIsWant;
	}

	public void setUserIsWant(Integer userIsWant) {
		this.userIsWant = userIsWant;
	}
    
}