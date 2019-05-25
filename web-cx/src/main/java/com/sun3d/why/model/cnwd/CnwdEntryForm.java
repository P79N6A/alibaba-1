package com.sun3d.why.model.cnwd;

import java.util.Date;

public class CnwdEntryForm {
    private String entryId;

    private String agencyName;

    private String agencyType;

    private String teamName;

    private String dateOfEstablishment;

    private Integer memberNumber;

    private Integer avgAge;

    private String leaderName;

    private String telephone;

    private String email;

    private String faxaphone;

    private String address;

    private String matchType;

    private String programName;

    private String programDuration;

    private String producerAndId;

    private Integer participatingNumber;

    private Integer checkStatus;

    private String createUser;

    private Date createTime;

    private String updateUser;

    private Date updateTime;

    private String teamProfile;

    private String videoUrl;

    private String videoCoverImg;
    
    private Integer entryIndex;
    
    
    //拒绝理由
    private  String refusalReason;
    
    
    
    public String getRefusalReason() {
		return refusalReason;
	}

	public void setRefusalReason(String refusalReason) {
		this.refusalReason = refusalReason;
	}

	/*虚拟字段*/
    private String danceType;

    public String getDanceType() {
		return danceType;
	}

	public void setDanceType(String danceType) {
		this.danceType = danceType;
	}

	public String getEntryId() {
        return entryId;
    }

    public void setEntryId(String entryId) {
        this.entryId = entryId == null ? null : entryId.trim();
    }

    public String getAgencyName() {
        return agencyName;
    }

    public void setAgencyName(String agencyName) {
        this.agencyName = agencyName == null ? null : agencyName.trim();
    }

    public String getAgencyType() {
        return agencyType;
    }

    public void setAgencyType(String agencyType) {
        this.agencyType = agencyType == null ? null : agencyType.trim();
    }

    public String getTeamName() {
        return teamName;
    }

    public void setTeamName(String teamName) {
        this.teamName = teamName == null ? null : teamName.trim();
    }

    public String getDateOfEstablishment() {
        return dateOfEstablishment;
    }

    public void setDateOfEstablishment(String dateOfEstablishment) {
        this.dateOfEstablishment = dateOfEstablishment == null ? null : dateOfEstablishment.trim();
    }

    public Integer getMemberNumber() {
        return memberNumber;
    }

    public void setMemberNumber(Integer memberNumber) {
        this.memberNumber = memberNumber;
    }

    public Integer getAvgAge() {
        return avgAge;
    }

    public void setAvgAge(Integer avgAge) {
        this.avgAge = avgAge;
    }

    public String getLeaderName() {
        return leaderName;
    }

    public void setLeaderName(String leaderName) {
        this.leaderName = leaderName == null ? null : leaderName.trim();
    }

    public String getTelephone() {
        return telephone;
    }

    public void setTelephone(String telephone) {
        this.telephone = telephone == null ? null : telephone.trim();
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email == null ? null : email.trim();
    }

    public String getFaxaphone() {
        return faxaphone;
    }

    public void setFaxaphone(String faxaphone) {
        this.faxaphone = faxaphone == null ? null : faxaphone.trim();
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address == null ? null : address.trim();
    }

    public String getMatchType() {
        return matchType;
    }

    public void setMatchType(String matchType) {
        this.matchType = matchType == null ? null : matchType.trim();
    }

    public String getProgramName() {
        return programName;
    }

    public void setProgramName(String programName) {
        this.programName = programName == null ? null : programName.trim();
    }

    public String getProgramDuration() {
        return programDuration;
    }

    public void setProgramDuration(String programDuration) {
        this.programDuration = programDuration == null ? null : programDuration.trim();
    }

    public String getProducerAndId() {
        return producerAndId;
    }

    public void setProducerAndId(String producerAndId) {
        this.producerAndId = producerAndId == null ? null : producerAndId.trim();
    }

    public Integer getParticipatingNumber() {
        return participatingNumber;
    }

    public void setParticipatingNumber(Integer participatingNumber) {
        this.participatingNumber = participatingNumber;
    }

    public Integer getCheckStatus() {
        return checkStatus;
    }

    public void setCheckStatus(Integer checkStatus) {
        this.checkStatus = checkStatus;
    }

    public String getCreateUser() {
        return createUser;
    }

    public void setCreateUser(String createUser) {
        this.createUser = createUser == null ? null : createUser.trim();
    }

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }

    public String getUpdateUser() {
        return updateUser;
    }

    public void setUpdateUser(String updateUser) {
        this.updateUser = updateUser == null ? null : updateUser.trim();
    }

    public Date getUpdateTime() {
        return updateTime;
    }

    public void setUpdateTime(Date updateTime) {
        this.updateTime = updateTime;
    }

    public String getTeamProfile() {
        return teamProfile;
    }

    public void setTeamProfile(String teamProfile) {
        this.teamProfile = teamProfile == null ? null : teamProfile.trim();
    }

    public String getVideoUrl() {
        return videoUrl;
    }

    public void setVideoUrl(String videoUrl) {
        this.videoUrl = videoUrl == null ? null : videoUrl.trim();
    }

    public String getVideoCoverImg() {
        return videoCoverImg;
    }

    public void setVideoCoverImg(String videoCoverImg) {
        this.videoCoverImg = videoCoverImg == null ? null : videoCoverImg.trim();
    }

	public Integer getEntryIndex() {
		return entryIndex;
	}

	public void setEntryIndex(Integer entryIndex) {
		this.entryIndex = entryIndex;
	}
    
}