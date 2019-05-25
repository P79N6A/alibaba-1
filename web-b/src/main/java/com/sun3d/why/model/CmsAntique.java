package com.sun3d.why.model;

import com.sun3d.why.util.Pagination;

import java.io.Serializable;
import java.util.Date;

public class CmsAntique extends Pagination implements Serializable{


    private String antiqueId;

    private String venueId;

    private String antiqueTypeId;

    private String antiqueName;

    private String antiqueImgUrl;

    private String antiqueGalleryAddress;

    private String antiqueGalleryAddressUrl;

    private String antiqueYears;

    private String antiqueSource;

    private Integer antiqueIsVoice;

    private String antiqueVoiceUrl;

    private String antiqueVideoUrl;

    private Integer antiqueIs3d;

    private String antique3dUrl;

    private Integer antiqueSort;

    private Integer antiqueTopLevel;

    private Integer antiqueIsDel;

    private Integer antiqueState;

    private Date antiqueCreateTime;

    private Date antiqueUpdateTime;

    private String antiqueCreateUser;

    private String antiqueUpdateUser;

    private String antiqueDept;

    private String antiqueRemark;
    
    private String antiqueDynasty;

    private String dynastyName;
    private  String dictName;
    private  String venueName;
    private  String antiqueTypeName;
    private  String antiqueTypeState;

    private Integer statisticCount;

    private String venueArea;
    private  String antiqueSpecification;
    private String sysId;
    private String sysNo;
    /**后台搜索关键词*/
    private String searchKey;
    
    public String getAntiqueSpecification() {
        return antiqueSpecification;
    }

    public void setAntiqueSpecification(String antiqueSpecification) {
        this.antiqueSpecification = antiqueSpecification;
    }

    public String getAntiqueTypeState() {
        return antiqueTypeState;
    }

    public void setAntiqueTypeState(String antiqueTypeState) {
        this.antiqueTypeState = antiqueTypeState;
    }

    public String getAntiqueTypeName() {
        return antiqueTypeName;
    }

    public void setAntiqueTypeName(String antiqueTypeName) {
        this.antiqueTypeName = antiqueTypeName;
    }

    public String getVenueName() {
        return venueName;
    }

    public void setVenueName(String venueName) {
        this.venueName = venueName;
    }

    public String getDictName() {
        return dictName;
    }

    public void setDictName(String dictName) {
        this.dictName = dictName;
    }

    public String getDynastyName() {
        return dynastyName;
    }

    public void setDynastyName(String dynastyName) {
        this.dynastyName = dynastyName;
    }


    public String getAntiqueId() {
        return antiqueId;
    }

    public void setAntiqueId(String antiqueId) {
        this.antiqueId = antiqueId == null ? null : antiqueId.trim();
    }

    public String getVenueId() {
        return venueId;
    }

    public void setVenueId(String venueId) {
        this.venueId = venueId == null ? null : venueId.trim();
    }

    public String getAntiqueTypeId() {
        return antiqueTypeId;
    }

    public void setAntiqueTypeId(String antiqueTypeId) {
        this.antiqueTypeId = antiqueTypeId;
    }

    public String getAntiqueName() {
        return antiqueName;
    }

    public void setAntiqueName(String antiqueName) {
        this.antiqueName = antiqueName == null ? null : antiqueName.trim();
    }

    public String getAntiqueImgUrl() {
        return antiqueImgUrl;
    }

    public void setAntiqueImgUrl(String antiqueImgUrl) {
        this.antiqueImgUrl = antiqueImgUrl == null ? null : antiqueImgUrl.trim();
    }

    public String getAntiqueGalleryAddress() {
        return antiqueGalleryAddress;
    }

    public void setAntiqueGalleryAddress(String antiqueGalleryAddress) {
        this.antiqueGalleryAddress = antiqueGalleryAddress == null ? null : antiqueGalleryAddress.trim();
    }

    public String getAntiqueGalleryAddressUrl() {
        return antiqueGalleryAddressUrl;
    }

    public void setAntiqueGalleryAddressUrl(String antiqueGalleryAddressUrl) {
        this.antiqueGalleryAddressUrl = antiqueGalleryAddressUrl == null ? null : antiqueGalleryAddressUrl.trim();
    }

    public String getAntiqueYears() {
        return antiqueYears;
    }

    public void setAntiqueYears(String antiqueYears) {
        this.antiqueYears = antiqueYears == null ? null : antiqueYears.trim();
    }

    public String getAntiqueSource() {
        return antiqueSource;
    }

    public void setAntiqueSource(String antiqueSource) {
        this.antiqueSource = antiqueSource == null ? null : antiqueSource.trim();
    }

    public Integer getAntiqueIsVoice() {
        return antiqueIsVoice;
    }

    public void setAntiqueIsVoice(Integer antiqueIsVoice) {
        this.antiqueIsVoice = antiqueIsVoice;
    }

    public String getAntiqueVoiceUrl() {
        return antiqueVoiceUrl;
    }

    public void setAntiqueVoiceUrl(String antiqueVoiceUrl) {
        this.antiqueVoiceUrl = antiqueVoiceUrl == null ? null : antiqueVoiceUrl.trim();
    }

    public String getAntiqueVideoUrl() {
        return antiqueVideoUrl;
    }

    public void setAntiqueVideoUrl(String antiqueVideoUrl) {
        this.antiqueVideoUrl = antiqueVideoUrl == null ? null : antiqueVideoUrl.trim();
    }

    public Integer getAntiqueIs3d() {
        return antiqueIs3d;
    }

    public void setAntiqueIs3d(Integer antiqueIs3d) {
        this.antiqueIs3d = antiqueIs3d;
    }

    public String getAntique3dUrl() {
        return antique3dUrl;
    }

    public void setAntique3dUrl(String antique3dUrl) {
        this.antique3dUrl = antique3dUrl == null ? null : antique3dUrl.trim();
    }

    public Integer getAntiqueSort() {
        return antiqueSort;
    }

    public void setAntiqueSort(Integer antiqueSort) {
        this.antiqueSort = antiqueSort;
    }

    public Integer getAntiqueTopLevel() {
        return antiqueTopLevel;
    }

    public void setAntiqueTopLevel(Integer antiqueTopLevel) {
        this.antiqueTopLevel = antiqueTopLevel;
    }

    public Integer getAntiqueIsDel() {
        return antiqueIsDel;
    }

    public void setAntiqueIsDel(Integer antiqueIsDel) {
        this.antiqueIsDel = antiqueIsDel;
    }

    public Integer getAntiqueState() {
        return antiqueState;
    }

    public void setAntiqueState(Integer antiqueState) {
        this.antiqueState = antiqueState;
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
        this.antiqueCreateUser = antiqueCreateUser == null ? null : antiqueCreateUser.trim();
    }

    public String getAntiqueUpdateUser() {
        return antiqueUpdateUser;
    }

    public void setAntiqueUpdateUser(String antiqueUpdateUser) {
        this.antiqueUpdateUser = antiqueUpdateUser == null ? null : antiqueUpdateUser.trim();
    }

    public String getAntiqueDept() {
        return antiqueDept;
    }

    public void setAntiqueDept(String antiqueDept) {
        this.antiqueDept = antiqueDept == null ? null : antiqueDept.trim();
    }

    public String getAntiqueRemark() {
        return antiqueRemark;
    }

    public void setAntiqueRemark(String antiqueRemark) {
        this.antiqueRemark = antiqueRemark == null ? null : antiqueRemark.trim();
    }

    public Integer getStatisticCount() {
        return statisticCount;
    }

    public void setStatisticCount(Integer statisticCount) {
        this.statisticCount = statisticCount;
    }

    public String getVenueArea() {
        return venueArea;
    }

    public void setVenueArea(String venueArea) {
        this.venueArea = venueArea;
    }

	public String getSysId() {
		return sysId;
	}

	public void setSysId(String sysId) {
		this.sysId = sysId;
	}

	public String getSysNo() {
		return sysNo;
	}

	public void setSysNo(String sysNo) {
		this.sysNo = sysNo;
	}

	public String getSearchKey() {
		return searchKey;
	}

	public void setSearchKey(String searchKey) {
		this.searchKey = searchKey;
	}

	public String getAntiqueDynasty() {
		return antiqueDynasty;
	}

	public void setAntiqueDynasty(String antiqueDynasty) {
		this.antiqueDynasty = antiqueDynasty;
	}
	
	

}