package com.culturecloud.model.bean.pdfengcai;

import java.util.Date;

public class PdDemand {
    private String demandId;

    private String userid;

    private String companyName;

    private String linkman;

    private String linkmanPhoneNo;

    private String email;

    private String natureOfEnterprise;

    private String purchasingCategories;

    private String purchasingTimes;

    private String budget;

    private String timeRequirement;

    private String entryNo;

    private String createuser;

    private Date createdate;

    private String updateuser;

    private Date updatedate;

    private String dispatchExhibitionNo;
    
    private Integer checkStatus;

    public String getDemandId() {
        return demandId;
    }

    public void setDemandId(String demandId) {
        this.demandId = demandId == null ? null : demandId.trim();
    }

    public String getUserid() {
        return userid;
    }

    public void setUserid(String userid) {
        this.userid = userid == null ? null : userid.trim();
    }

    public String getCompanyName() {
        return companyName;
    }

    public void setCompanyName(String companyName) {
        this.companyName = companyName == null ? null : companyName.trim();
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

    public String getPurchasingCategories() {
        return purchasingCategories;
    }

    public void setPurchasingCategories(String purchasingCategories) {
        this.purchasingCategories = purchasingCategories == null ? null : purchasingCategories.trim();
    }

    public String getPurchasingTimes() {
        return purchasingTimes;
    }

    public void setPurchasingTimes(String purchasingTimes) {
        this.purchasingTimes = purchasingTimes == null ? null : purchasingTimes.trim();
    }

    public String getBudget() {
        return budget;
    }

    public void setBudget(String budget) {
        this.budget = budget == null ? null : budget.trim();
    }

    public String getTimeRequirement() {
        return timeRequirement;
    }

    public void setTimeRequirement(String timeRequirement) {
        this.timeRequirement = timeRequirement == null ? null : timeRequirement.trim();
    }

    public String getEntryNo() {
        return entryNo;
    }

    public void setEntryNo(String entryNo) {
        this.entryNo = entryNo == null ? null : entryNo.trim();
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

    public String getDispatchExhibitionNo() {
        return dispatchExhibitionNo;
    }

    public void setDispatchExhibitionNo(String dispatchExhibitionNo) {
        this.dispatchExhibitionNo = dispatchExhibitionNo == null ? null : dispatchExhibitionNo.trim();
    }

	public Integer getCheckStatus() {
		return checkStatus;
	}

	public void setCheckStatus(Integer checkStatus) {
		this.checkStatus = checkStatus;
	}
    
}