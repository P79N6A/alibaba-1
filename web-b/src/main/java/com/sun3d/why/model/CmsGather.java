package com.sun3d.why.model;

import java.util.Date;

public class CmsGather {
    private String gatherId;

    private String gatherName;

    private String gatherTag;
    
    private Integer gatherType;

    private String gatherAddress;
    
    private Double gatherAddressLat;
    
    private Double gatherAddressLon;

    private String gatherTime;

    private String gatherHost;

    private String gatherPrice;

    private String gatherStartDate;

    private String gatherEndDate;

    private String gatherImg;

    private String gatherMovieType;

    private String gatherMovieTime;

    private String gatherMovieActor;

    private String gatherMovieDirector;

    private String gatherGrade;
    
    private String gatherLink;

    private Integer gatherStatus;

    private String gatherCreateUser;

    private Date gatherCreateTime;

    private String gatherUpdateUser;

    private Date gatherUpdateTime;
    
    //虚拟字段
    private Integer sortType=1;	//1：创建时间；2：更新时间；3：开始时间；4：结束时间
    
    private String gatherAddressId;

    public String getGatherId() {
        return gatherId;
    }

    public void setGatherId(String gatherId) {
        this.gatherId = gatherId == null ? null : gatherId.trim();
    }

    public String getGatherName() {
        return gatherName;
    }

    public void setGatherName(String gatherName) {
        this.gatherName = gatherName == null ? null : gatherName.trim();
    }

	public String getGatherTag() {
		return gatherTag;
	}

	public void setGatherTag(String gatherTag) {
		this.gatherTag = gatherTag;
	}

	public Integer getGatherType() {
        return gatherType;
    }

    public void setGatherType(Integer gatherType) {
        this.gatherType = gatherType;
    }

    public String getGatherAddress() {
        return gatherAddress;
    }

    public void setGatherAddress(String gatherAddress) {
        this.gatherAddress = gatherAddress == null ? null : gatherAddress.trim();
    }

    public String getGatherTime() {
        return gatherTime;
    }

    public void setGatherTime(String gatherTime) {
        this.gatherTime = gatherTime == null ? null : gatherTime.trim();
    }

    public String getGatherHost() {
        return gatherHost;
    }

    public void setGatherHost(String gatherHost) {
        this.gatherHost = gatherHost == null ? null : gatherHost.trim();
    }

    public String getGatherPrice() {
        return gatherPrice;
    }

    public void setGatherPrice(String gatherPrice) {
        this.gatherPrice = gatherPrice == null ? null : gatherPrice.trim();
    }

    public String getGatherStartDate() {
        return gatherStartDate;
    }

    public void setGatherStartDate(String gatherStartDate) {
        this.gatherStartDate = gatherStartDate == null ? null : gatherStartDate.trim();
    }

    public String getGatherEndDate() {
        return gatherEndDate;
    }

    public void setGatherEndDate(String gatherEndDate) {
        this.gatherEndDate = gatherEndDate == null ? null : gatherEndDate.trim();
    }

    public String getGatherImg() {
        return gatherImg;
    }

    public void setGatherImg(String gatherImg) {
        this.gatherImg = gatherImg == null ? null : gatherImg.trim();
    }

    public String getGatherMovieType() {
        return gatherMovieType;
    }

    public void setGatherMovieType(String gatherMovieType) {
        this.gatherMovieType = gatherMovieType == null ? null : gatherMovieType.trim();
    }

    public String getGatherMovieTime() {
        return gatherMovieTime;
    }

    public void setGatherMovieTime(String gatherMovieTime) {
        this.gatherMovieTime = gatherMovieTime == null ? null : gatherMovieTime.trim();
    }

    public String getGatherMovieActor() {
        return gatherMovieActor;
    }

    public void setGatherMovieActor(String gatherMovieActor) {
        this.gatherMovieActor = gatherMovieActor == null ? null : gatherMovieActor.trim();
    }

    public String getGatherMovieDirector() {
        return gatherMovieDirector;
    }

    public void setGatherMovieDirector(String gatherMovieDirector) {
        this.gatherMovieDirector = gatherMovieDirector == null ? null : gatherMovieDirector.trim();
    }

    public String getGatherGrade() {
        return gatherGrade;
    }

    public void setGatherGrade(String gatherGrade) {
        this.gatherGrade = gatherGrade == null ? null : gatherGrade.trim();
    }

    public Integer getGatherStatus() {
        return gatherStatus;
    }

    public void setGatherStatus(Integer gatherStatus) {
        this.gatherStatus = gatherStatus;
    }

    public String getGatherCreateUser() {
        return gatherCreateUser;
    }

    public void setGatherCreateUser(String gatherCreateUser) {
        this.gatherCreateUser = gatherCreateUser == null ? null : gatherCreateUser.trim();
    }

    public Date getGatherCreateTime() {
        return gatherCreateTime;
    }

    public void setGatherCreateTime(Date gatherCreateTime) {
        this.gatherCreateTime = gatherCreateTime;
    }

    public String getGatherUpdateUser() {
        return gatherUpdateUser;
    }

    public void setGatherUpdateUser(String gatherUpdateUser) {
        this.gatherUpdateUser = gatherUpdateUser == null ? null : gatherUpdateUser.trim();
    }

    public Date getGatherUpdateTime() {
        return gatherUpdateTime;
    }

    public void setGatherUpdateTime(Date gatherUpdateTime) {
        this.gatherUpdateTime = gatherUpdateTime;
    }

	public Integer getSortType() {
		return sortType;
	}

	public void setSortType(Integer sortType) {
		this.sortType = sortType;
	}

	public Double getGatherAddressLat() {
		return gatherAddressLat;
	}

	public void setGatherAddressLat(Double gatherAddressLat) {
		this.gatherAddressLat = gatherAddressLat;
	}

	public Double getGatherAddressLon() {
		return gatherAddressLon;
	}

	public void setGatherAddressLon(Double gatherAddressLon) {
		this.gatherAddressLon = gatherAddressLon;
	}

	public String getGatherAddressId() {
		return gatherAddressId;
	}

	public void setGatherAddressId(String gatherAddressId) {
		this.gatherAddressId = gatherAddressId;
	}

	public String getGatherLink() {
		return gatherLink;
	}

	public void setGatherLink(String gatherLink) {
		this.gatherLink = gatherLink;
	}
	
}