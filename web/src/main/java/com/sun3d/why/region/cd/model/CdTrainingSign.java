package com.sun3d.why.region.cd.model;

import java.util.Date;

public class CdTrainingSign {
    private String signId;

    private String userId;

    private String signCourse;

    private Integer signType;

    private String signName;

    private Integer signSex;

    private String signIdcard;

    private String signMobile;
    
    private Integer signSmsType;
    
    private Date createTime;
    
    //虚拟属性
    private Integer limitNum;	//限制人数

    public String getSignId() {
        return signId;
    }

    public void setSignId(String signId) {
        this.signId = signId == null ? null : signId.trim();
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId == null ? null : userId.trim();
    }

    public String getSignCourse() {
        return signCourse;
    }

    public void setSignCourse(String signCourse) {
        this.signCourse = signCourse == null ? null : signCourse.trim();
    }

    public Integer getSignType() {
        return signType;
    }

    public void setSignType(Integer signType) {
        this.signType = signType;
    }

    public String getSignName() {
        return signName;
    }

    public void setSignName(String signName) {
        this.signName = signName == null ? null : signName.trim();
    }

    public Integer getSignSex() {
        return signSex;
    }

    public void setSignSex(Integer signSex) {
        this.signSex = signSex;
    }

    public String getSignIdcard() {
        return signIdcard;
    }

    public void setSignIdcard(String signIdcard) {
        this.signIdcard = signIdcard == null ? null : signIdcard.trim();
    }

    public String getSignMobile() {
        return signMobile;
    }

    public void setSignMobile(String signMobile) {
        this.signMobile = signMobile == null ? null : signMobile.trim();
    }
    
    public Integer getSignSmsType() {
		return signSmsType;
	}

	public void setSignSmsType(Integer signSmsType) {
		this.signSmsType = signSmsType;
	}

	public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }

	public Integer getLimitNum() {
		return limitNum;
	}

	public void setLimitNum(Integer limitNum) {
		this.limitNum = limitNum;
	}
    
}