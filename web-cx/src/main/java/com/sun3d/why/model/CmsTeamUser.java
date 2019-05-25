package com.sun3d.why.model;

import com.sun3d.why.util.Pagination;

import java.io.Serializable;
import java.util.Date;

public class CmsTeamUser extends Pagination implements Serializable {
   
	private static final long serialVersionUID = 4817052758535360316L;

	private String tuserId;

    private String tuserName;

    private Integer tuserIsVenue;

    private Integer tuserIsActiviey;

    private Integer tuserIsDisplay;

    private String tuserProvince;

    private String tuserCity;

    private String tuserCounty;

    private String tuserTeamType;

    private String tuserPicture;

    private String tCreateUser;

    private Date tCreateTime;

    private String tUpdateUser;

    private Date tUpdateTime;

    private String tDept;

    private String tuserTeamRemark;

    private Integer tuserLimit;

    private String tuserCrowdTag;

    private String tuserPropertyTag;

    private String tuserSiteTag;

    private String tuserLocationDict;

    // 年收藏量
    private Integer yearCollectCount;

    // 年浏览量
    private Integer yearBrowseCount;

    private String dictName;
    // 申请id
    private String applyId;

    // 审核消息个数
    private Integer checkCount;

    // 管理员名称
    private String managerName;

    // 申请状态
    private Integer applyCheckState;

    //会员id
    private String userId;

    // 加入时间
    private Date applyUpdateTime;

    // 管理员类型
    private Integer applyIsState;

    //用户性别
    private Integer userSex;

    // 联系电话
    private String userMobileNo;
    
    // 标签描述
    private String tuserTag;
    
    // 年限
    private Integer tuserYear;
    
    // 使用者类型 0社团 1个人 2公司
    private Integer tuserUserType;
    
    private String userTelephone;

    public Integer getUserSex() {
        return userSex;
    }

    public void setUserSex(Integer userSex) {
        this.userSex = userSex;
    }

    public Integer getApplyIsState() {
        return applyIsState;
    }

    public void setApplyIsState(Integer applyIsState) {
        this.applyIsState = applyIsState;
    }

    public Date getApplyUpdateTime() {
        return applyUpdateTime;
    }

    public void setApplyUpdateTime(Date applyUpdateTime) {
        this.applyUpdateTime = applyUpdateTime;
    }

    public String getTuserCrowdTag() {
        return tuserCrowdTag;
    }

    public void setTuserCrowdTag(String tuserCrowdTag) {
        this.tuserCrowdTag = tuserCrowdTag == null ? null : tuserCrowdTag.trim();
    }

    public String getTuserPropertyTag() {
        return tuserPropertyTag;
    }

    public void setTuserPropertyTag(String tuserPropertyTag) {
        this.tuserPropertyTag = tuserPropertyTag == null ? null : tuserPropertyTag.trim();
    }

    public String getTuserSiteTag() {
        return tuserSiteTag;
    }

    public void setTuserSiteTag(String tuserSiteTag) {
        this.tuserSiteTag = tuserSiteTag == null ? null :tuserSiteTag.trim();
    }

    public String getTuserLocationDict() {
        return tuserLocationDict;
    }

    public void setTuserLocationDict(String tuserLocationDict) {
        this.tuserLocationDict = tuserLocationDict == null ? null : tuserLocationDict.trim();
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId == null ? null : userId.trim();
    }

    public Integer getApplyCheckState() {
        return applyCheckState;
    }

    public void setApplyCheckState(Integer applyCheckState) {
        this.applyCheckState = applyCheckState;
    }

    public String getManagerName() {
        return managerName;
    }

    public void setManagerName(String managerName) {
        this.managerName = managerName == null ? null : managerName.trim();
    }

    public Integer getCheckCount() {
        return checkCount;
    }

    public void setCheckCount(Integer checkCount) {
        this.checkCount = checkCount;
    }

    public String getApplyId() {
        return applyId;
    }

    public void setApplyId(String applyId) {
        this.applyId = applyId == null ? null : applyId.trim();
    }

    public Integer getTuserLimit() {
        return tuserLimit;
    }

    public void setTuserLimit(Integer tuserLimit) {
        this.tuserLimit = tuserLimit;
    }

    public String getDictName() {
        return dictName;
    }

    public void setDictName(String dictName) {
        this.dictName = dictName == null ? null : dictName.trim();
    }

    public Integer getYearCollectCount() {
        return yearCollectCount;
    }

    public void setYearCollectCount(Integer yearCollectCount) {
        this.yearCollectCount = yearCollectCount;
    }

    public Integer getYearBrowseCount() {
        return yearBrowseCount;
    }

    public void setYearBrowseCount(Integer yearBrowseCount) {
        this.yearBrowseCount = yearBrowseCount;
    }

    public String getTuserId() {
        return tuserId;
    }

    public void setTuserId(String tuserId) {
        this.tuserId = tuserId == null ? null : tuserId.trim();
    }

    public String getTuserName() {
        return tuserName;
    }

    public void setTuserName(String tuserName) {
        this.tuserName = tuserName == null ? null : tuserName.trim();
    }

    public Integer getTuserIsVenue() {
        return tuserIsVenue;
    }

    public void setTuserIsVenue(Integer tuserIsVenue) {
        this.tuserIsVenue = tuserIsVenue;
    }

    public Integer getTuserIsActiviey() {
        return tuserIsActiviey;
    }

    public void setTuserIsActiviey(Integer tuserIsActiviey) {
        this.tuserIsActiviey = tuserIsActiviey;
    }

    public Integer getTuserIsDisplay() {
        return tuserIsDisplay;
    }

    public void setTuserIsDisplay(Integer tuserIsDisplay) {
        this.tuserIsDisplay = tuserIsDisplay;
    }

    public String getUserMobileNo() {
        return userMobileNo;
    }

    public void setUserMobileNo(String userMobileNo) {
        this.userMobileNo = userMobileNo == null ? null : userMobileNo.trim();
    }

    public String getTuserProvince() {
        return tuserProvince;
    }

    public void setTuserProvince(String tuserProvince) {
        this.tuserProvince = tuserProvince == null ? null : tuserProvince.trim();
    }

    public String getTuserCity() {
        return tuserCity;
    }

    public void setTuserCity(String tuserCity) {
        this.tuserCity = tuserCity == null ? null : tuserCity.trim();
    }

    public String getTuserCounty() {
        return tuserCounty;
    }

    public void setTuserCounty(String tuserCounty) {
        this.tuserCounty = tuserCounty == null ? null : tuserCounty.trim();
    }

    public String getTuserTeamType() {
        return tuserTeamType;
    }

    public void setTuserTeamType(String tuserTeamType) {
        this.tuserTeamType = tuserTeamType == null ? null : tuserTeamType.trim();
    }

    public String getTuserPicture() {
        return tuserPicture;
    }

    public void setTuserPicture(String tuserPicture) {
        this.tuserPicture = tuserPicture == null ? null : tuserPicture.trim();
    }

    public String gettCreateUser() {
        return tCreateUser;
    }

    public void settCreateUser(String tCreateUser) {
        this.tCreateUser = tCreateUser == null ? null : tCreateUser.trim();
    }

    public Date gettCreateTime() {
        return tCreateTime;
    }

    public void settCreateTime(Date tCreateTime) {
        this.tCreateTime = tCreateTime;
    }

    public String gettUpdateUser() {
        return tUpdateUser;
    }

    public void settUpdateUser(String tUpdateUser) {
        this.tUpdateUser = tUpdateUser == null ? null : tUpdateUser.trim();
    }

    public Date gettUpdateTime() {
        return tUpdateTime;
    }

    public void settUpdateTime(Date tUpdateTime) {
        this.tUpdateTime = tUpdateTime;
    }

    public String gettDept() {
        return tDept;
    }

    public void settDept(String tDept) {
        this.tDept = tDept == null ? null : tDept.trim();
    }

    public String getTuserTeamRemark() {
        return tuserTeamRemark;
    }

    public void setTuserTeamRemark(String tuserTeamRemark) {
        this.tuserTeamRemark = tuserTeamRemark == null ? null : tuserTeamRemark.trim();
    }

	public String getTuserTag() {
		return tuserTag;
	}

	public void setTuserTag(String tuserTag) {
		this.tuserTag = tuserTag;
	}

	public Integer getTuserYear() {
		return tuserYear;
	}

	public void setTuserYear(Integer tuserYear) {
		this.tuserYear = tuserYear;
	}

	public Integer getTuserUserType() {
		return tuserUserType;
	}

	public void setTuserUserType(Integer tuserUserType) {
		this.tuserUserType = tuserUserType;
	}

	public String getUserTelephone() {
		return userTelephone;
	}

	public void setUserTelephone(String userTelephone) {
		this.userTelephone = userTelephone;
	}


	
    
    
}