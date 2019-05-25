package com.culturecloud.model.bean.pdfengcai;

import java.util.Date;

public class PdOffer {
    private String offerId;

    private String userId;

    private String exhibitionPosName;

    private String exhibitionPosNameEn;

    private String personInCharge;

    private String personInChargePhoneNo;

    private String linkman;

    private String linkmanPhoneNo;

    private String companyAddress;

    private String companyTelephoneNo;

    private String email;

    private String natureOfEnterprise;

    private String exhibitionType;

    private String duration;

    private String recommendWay;

    private String timeRequirement;

    private String siteRequirement;

    private String specRequirement;

    private String createuser;

    private Date createdate;

    private String updateuser;

    private Date updatedate;

    private Byte status;
    
    private Integer offerIndex;
    
    private String headPortrait;
    
    private Integer top;

    public String getOfferId() {
        return offerId;
    }

    public void setOfferId(String offerId) {
        this.offerId = offerId == null ? null : offerId.trim();
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId == null ? null : userId.trim();
    }

    public String getExhibitionPosName() {
        return exhibitionPosName;
    }

    public void setExhibitionPosName(String exhibitionPosName) {
        this.exhibitionPosName = exhibitionPosName == null ? null : exhibitionPosName.trim();
    }

    public String getExhibitionPosNameEn() {
        return exhibitionPosNameEn;
    }

    public void setExhibitionPosNameEn(String exhibitionPosNameEn) {
        this.exhibitionPosNameEn = exhibitionPosNameEn == null ? null : exhibitionPosNameEn.trim();
    }

    public String getPersonInCharge() {
        return personInCharge;
    }

    public void setPersonInCharge(String personInCharge) {
        this.personInCharge = personInCharge == null ? null : personInCharge.trim();
    }

    public String getPersonInChargePhoneNo() {
        return personInChargePhoneNo;
    }

    public void setPersonInChargePhoneNo(String personInChargePhoneNo) {
        this.personInChargePhoneNo = personInChargePhoneNo == null ? null : personInChargePhoneNo.trim();
    }

    public String getLinkman() {
        return linkman;
    }

    public void setLinkman(String linkman) {
        this.linkman = linkman == null ? null : linkman.trim();
    }

    public String getLinkmanPhoneNo() {
        return linkmanPhoneNo;
    }

    public void setLinkmanPhoneNo(String linkmanPhoneNo) {
        this.linkmanPhoneNo = linkmanPhoneNo == null ? null : linkmanPhoneNo.trim();
    }

    public String getCompanyAddress() {
        return companyAddress;
    }

    public void setCompanyAddress(String companyAddress) {
        this.companyAddress = companyAddress == null ? null : companyAddress.trim();
    }

    public String getCompanyTelephoneNo() {
        return companyTelephoneNo;
    }

    public void setCompanyTelephoneNo(String companyTelephoneNo) {
        this.companyTelephoneNo = companyTelephoneNo == null ? null : companyTelephoneNo.trim();
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email == null ? null : email.trim();
    }

    public String getNatureOfEnterprise() {
        return natureOfEnterprise;
    }

    public void setNatureOfEnterprise(String natureOfEnterprise) {
        this.natureOfEnterprise = natureOfEnterprise == null ? null : natureOfEnterprise.trim();
    }

    public String getExhibitionType() {
        return exhibitionType;
    }

    public void setExhibitionType(String exhibitionType) {
        this.exhibitionType = exhibitionType == null ? null : exhibitionType.trim();
    }

    public String getDuration() {
        return duration;
    }

    public void setDuration(String duration) {
        this.duration = duration == null ? null : duration.trim();
    }

    public String getRecommendWay() {
        return recommendWay;
    }

    public void setRecommendWay(String recommendWay) {
        this.recommendWay = recommendWay == null ? null : recommendWay.trim();
    }

    public String getTimeRequirement() {
        return timeRequirement;
    }

    public void setTimeRequirement(String timeRequirement) {
        this.timeRequirement = timeRequirement == null ? null : timeRequirement.trim();
    }

    public String getSiteRequirement() {
        return siteRequirement;
    }

    public void setSiteRequirement(String siteRequirement) {
        this.siteRequirement = siteRequirement == null ? null : siteRequirement.trim();
    }

    public String getSpecRequirement() {
        return specRequirement;
    }

    public void setSpecRequirement(String specRequirement) {
        this.specRequirement = specRequirement == null ? null : specRequirement.trim();
    }

    public String getCreateuser() {
        return createuser;
    }

    public void setCreateuser(String createuser) {
        this.createuser = createuser == null ? null : createuser.trim();
    }

    public Date getCreatedate() {
        return createdate;
    }

    public void setCreatedate(Date createdate) {
        this.createdate = createdate;
    }

    public String getUpdateuser() {
        return updateuser;
    }

    public void setUpdateuser(String updateuser) {
        this.updateuser = updateuser == null ? null : updateuser.trim();
    }

    public Date getUpdatedate() {
        return updatedate;
    }

    public void setUpdatedate(Date updatedate) {
        this.updatedate = updatedate;
    }

    public Byte getStatus() {
        return status;
    }

    public void setStatus(Byte status) {
        this.status = status;
    }

	public Integer getOfferIndex() {
		return offerIndex;
	}

	public void setOfferIndex(Integer offerIndex) {
		this.offerIndex = offerIndex;
	}

	public String getHeadPortrait() {
		return headPortrait;
	}

	public void setHeadPortrait(String headPortrait) {
		this.headPortrait = headPortrait;
	}

	public Integer getTop() {
		return top;
	}

	public void setTop(Integer top) {
		this.top = top;
	}
    
}