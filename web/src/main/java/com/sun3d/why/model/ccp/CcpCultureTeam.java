package com.sun3d.why.model.ccp;

import java.util.Date;

public class CcpCultureTeam {
    private String cultureTeamId;

    private String cultureTeamTown;

    private String cultureTeamName;

    private String cultureTeamCount;

    private Integer cultureTeamType;

    private String cultureTeamRule;

    private String cultureTeamSite;

    private String cultureTeamAddress;

    private String cultureTeamAddressUrl;

    private String cultureTeamIntro;

    private String cultureTeamContent;

    private Date createTime;

    private String createUser;

    private String cultureTeamFamily;

    private String cultureTeamPrize;

    private String cultureTeamMedia;
    //虚拟属性
    private String [] worksNames;
    
    private String [] worksManuscripts;
    
    private String [] worksStages;

	public String getCultureTeamId() {
        return cultureTeamId;
    }

    public void setCultureTeamId(String cultureTeamId) {
        this.cultureTeamId = cultureTeamId == null ? null : cultureTeamId.trim();
    }

    public String getCultureTeamTown() {
        return cultureTeamTown;
    }

    public void setCultureTeamTown(String cultureTeamTown) {
        this.cultureTeamTown = cultureTeamTown == null ? null : cultureTeamTown.trim();
    }

    public String getCultureTeamName() {
        return cultureTeamName;
    }

    public void setCultureTeamName(String cultureTeamName) {
        this.cultureTeamName = cultureTeamName == null ? null : cultureTeamName.trim();
    }

    public String getCultureTeamCount() {
        return cultureTeamCount;
    }

    public void setCultureTeamCount(String cultureTeamCount) {
        this.cultureTeamCount = cultureTeamCount == null ? null : cultureTeamCount.trim();
    }

    public Integer getCultureTeamType() {
        return cultureTeamType;
    }

    public void setCultureTeamType(Integer cultureTeamType) {
        this.cultureTeamType = cultureTeamType;
    }

    public String getCultureTeamRule() {
        return cultureTeamRule;
    }

    public void setCultureTeamRule(String cultureTeamRule) {
        this.cultureTeamRule = cultureTeamRule == null ? null : cultureTeamRule.trim();
    }

    public String getCultureTeamSite() {
        return cultureTeamSite;
    }

    public void setCultureTeamSite(String cultureTeamSite) {
        this.cultureTeamSite = cultureTeamSite == null ? null : cultureTeamSite.trim();
    }

    public String getCultureTeamAddress() {
        return cultureTeamAddress;
    }

    public void setCultureTeamAddress(String cultureTeamAddress) {
        this.cultureTeamAddress = cultureTeamAddress == null ? null : cultureTeamAddress.trim();
    }

    public String getCultureTeamAddressUrl() {
        return cultureTeamAddressUrl;
    }

    public void setCultureTeamAddressUrl(String cultureTeamAddressUrl) {
        this.cultureTeamAddressUrl = cultureTeamAddressUrl == null ? null : cultureTeamAddressUrl.trim();
    }

    public String getCultureTeamIntro() {
        return cultureTeamIntro;
    }

    public void setCultureTeamIntro(String cultureTeamIntro) {
        this.cultureTeamIntro = cultureTeamIntro == null ? null : cultureTeamIntro.trim();
    }

    public String getCultureTeamContent() {
        return cultureTeamContent;
    }

    public void setCultureTeamContent(String cultureTeamContent) {
        this.cultureTeamContent = cultureTeamContent == null ? null : cultureTeamContent.trim();
    }

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }

    public String getCreateUser() {
        return createUser;
    }

    public void setCreateUser(String createUser) {
        this.createUser = createUser == null ? null : createUser.trim();
    }

    public String getCultureTeamFamily() {
        return cultureTeamFamily;
    }

    public void setCultureTeamFamily(String cultureTeamFamily) {
        this.cultureTeamFamily = cultureTeamFamily == null ? null : cultureTeamFamily.trim();
    }

    public String getCultureTeamPrize() {
        return cultureTeamPrize;
    }

    public void setCultureTeamPrize(String cultureTeamPrize) {
        this.cultureTeamPrize = cultureTeamPrize == null ? null : cultureTeamPrize.trim();
    }

    public String getCultureTeamMedia() {
        return cultureTeamMedia;
    }

    public void setCultureTeamMedia(String cultureTeamMedia) {
        this.cultureTeamMedia = cultureTeamMedia == null ? null : cultureTeamMedia.trim();
    }

	public String[] getWorksNames() {
		return worksNames;
	}

	public void setWorksNames(String[] worksNames) {
		this.worksNames = worksNames;
	}

	public String[] getWorksManuscripts() {
		return worksManuscripts;
	}

	public void setWorksManuscripts(String[] worksManuscripts) {
		this.worksManuscripts = worksManuscripts;
	}

	public String[] getWorksStages() {
		return worksStages;
	}

	public void setWorksStages(String[] worksStages) {
		this.worksStages = worksStages;
	}
}