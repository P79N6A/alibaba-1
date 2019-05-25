package com.culturecloud.model.bean.wrpx;

import java.io.Serializable;
import java.util.Date;

public class WrpxCourseOrder implements Serializable{
	/**
	 * 
	 */
	private static final long serialVersionUID = 6716934945214207313L;

	private String wrpxCourseOrderId;

    private String wrpxCourseId;

    private String wrpxUserId;

    private Integer orderStatus;

    private Boolean allMsgStatus;

    private Boolean singleMsgStatus;

    private Boolean attendStatus;

    private Integer score;

    private Date createDate;

    private String updateUser;

    private Date updateDate;

    private String createUser;

    private String courseCatpchaId;

    private String refuseReason;

    private Date checkTime;

    private Date signTime;
    
    //铏氭嫙灞炴�鍏宠仈鍏朵粬琛ㄩ噷闈㈢殑灞炴�
    private String verificationCode;
	private String courseTitle;
	private String batchId;
	private Integer checkStatus;
	private String courseField;
	private String realName;
    private String phoneNo;
    private Integer sex;
    private String jobPosition;
    private String jobTitle;
    private String engagedField; 
    private Boolean activity;
    private String unitArea;
    private String unitName;
    private Integer userScore;
    private String trainAddress;
	private String targetUser;
	private String teacherInfo;
	private Date courseStart;
	private Date courseEnd;
	private String courseDesc;
	private Integer credit;//瀛﹀垎
	private String year;
	private Integer totalScore;
	private Integer remain;
	private Integer start;
	private String trainTime;
	private String trainingMethodName;
	private String batchTitle;
	private String tranningMethodId;
	private Integer count;//是否评过课
	
	
	
	
	
	public Integer getCount() {
		return count;
	}

	public void setCount(Integer count) {
		this.count = count;
	}


	public String getTranningMethodId() {
		return tranningMethodId;
	}

	public void setTranningMethodId(String tranningMethodId) {
		this.tranningMethodId = tranningMethodId;
	}

	
	
	
	public String getBatchTitle() {
		return batchTitle;
	}

	public void setBatchTitle(String batchTitle) {
		this.batchTitle = batchTitle;
	}

	public String getTrainingMethodName() {
		return trainingMethodName;
	}

	public void setTrainingMethodName(String trainingMethodName) {
		this.trainingMethodName = trainingMethodName;
	}

	public String getTrainTime() {
		return trainTime;
	}

	public void setTrainTime(String trainTime) {
		this.trainTime = trainTime;
	}

	public Integer getRemain() {
		return remain;
	}

	public void setRemain(Integer remain) {
		this.remain = remain;
	}

	public Integer getStart() {
		return start;
	}

	public void setStart(Integer start) {
		this.start = start;
	}

	public Integer getTotalScore() {
		return totalScore;
	}

	public void setTotalScore(Integer totalScore) {
		this.totalScore = totalScore;
	}

	public String getYear() {
		return year;
	}

	public void setYear(String year) {
		this.year = year;
	}

	public Integer getCredit() {
		return credit;
	}

	public void setCredit(Integer credit) {
		this.credit = credit;
	}

	public String getTrainAddress() {
		return trainAddress;
	}

	public void setTrainAddress(String trainAddress) {
		this.trainAddress = trainAddress;
	}

	public String getTargetUser() {
		return targetUser;
	}

	public void setTargetUser(String targetUser) {
		this.targetUser = targetUser;
	}

	public String getTeacherInfo() {
		return teacherInfo;
	}

	public void setTeacherInfo(String teacherInfo) {
		this.teacherInfo = teacherInfo;
	}

	public Date getCourseStart() {
		return courseStart;
	}

	public void setCourseStart(Date courseStart) {
		this.courseStart = courseStart;
	}

	public Date getCourseEnd() {
		return courseEnd;
	}

	public void setCourseEnd(Date courseEnd) {
		this.courseEnd = courseEnd;
	}

	public String getCourseDesc() {
		return courseDesc;
	}

	public void setCourseDesc(String courseDesc) {
		this.courseDesc = courseDesc;
	}

	public Integer getUserScore() {
		return userScore;
	}

	public void setUserScore(Integer userScore) {
		this.userScore = userScore;
	}

	public String getUnitArea() {
		return unitArea;
	}

	public void setUnitArea(String unitArea) {
		this.unitArea = unitArea;
	}

	public String getUnitName() {
		return unitName;
	}

	public void setUnitName(String unitName) {
		this.unitName = unitName;
	}

	public String getVerificationCode() {
		return verificationCode;
	}

	public void setVerificationCode(String verificationCode) {
		this.verificationCode = verificationCode;
	}

	public String getCourseTitle() {
		return courseTitle;
	}

	public void setCourseTitle(String courseTitle) {
		this.courseTitle = courseTitle;
	}

	public String getBatchId() {
		return batchId;
	}

	public void setBatchId(String batchId) {
		this.batchId = batchId;
	}

	public Integer getCheckStatus() {
		return checkStatus;
	}

	public void setCheckStatus(Integer checkStatus) {
		this.checkStatus = checkStatus;
	}

	public String getCourseField() {
		return courseField;
	}

	public void setCourseField(String courseField) {
		this.courseField = courseField;
	}

	public String getRealName() {
		return realName;
	}

	public void setRealName(String realName) {
		this.realName = realName;
	}

	public String getPhoneNo() {
		return phoneNo;
	}

	public void setPhoneNo(String phoneNo) {
		this.phoneNo = phoneNo;
	}

	public Integer getSex() {
		return sex;
	}

	public void setSex(Integer sex) {
		this.sex = sex;
	}

	public String getJobPosition() {
		return jobPosition;
	}

	public void setJobPosition(String jobPosition) {
		this.jobPosition = jobPosition;
	}

	public String getJobTitle() {
		return jobTitle;
	}

	public void setJobTitle(String jobTitle) {
		this.jobTitle = jobTitle;
	}

	public String getEngagedField() {
		return engagedField;
	}

	public void setEngagedField(String engagedField) {
		this.engagedField = engagedField;
	}

	public Boolean getActivity() {
		return activity;
	}

	public void setActivity(Boolean activity) {
		this.activity = activity;
	}

	public String getWrpxCourseOrderId() {
        return wrpxCourseOrderId;
    }

    public void setWrpxCourseOrderId(String wrpxCourseOrderId) {
        this.wrpxCourseOrderId = wrpxCourseOrderId == null ? null : wrpxCourseOrderId.trim();
    }

    public String getWrpxCourseId() {
        return wrpxCourseId;
    }

    public void setWrpxCourseId(String wrpxCourseId) {
        this.wrpxCourseId = wrpxCourseId == null ? null : wrpxCourseId.trim();
    }

    public String getWrpxUserId() {
        return wrpxUserId;
    }

    public void setWrpxUserId(String wrpxUserId) {
        this.wrpxUserId = wrpxUserId == null ? null : wrpxUserId.trim();
    }

    public Integer getOrderStatus() {
        return orderStatus;
    }

    public void setOrderStatus(Integer orderStatus) {
        this.orderStatus = orderStatus;
    }

    public Boolean getAllMsgStatus() {
        return allMsgStatus;
    }

    public void setAllMsgStatus(Boolean allMsgStatus) {
        this.allMsgStatus = allMsgStatus;
    }

    public Boolean getSingleMsgStatus() {
        return singleMsgStatus;
    }

    public void setSingleMsgStatus(Boolean singleMsgStatus) {
        this.singleMsgStatus = singleMsgStatus;
    }

    public Boolean getAttendStatus() {
        return attendStatus;
    }

    public void setAttendStatus(Boolean attendStatus) {
        this.attendStatus = attendStatus;
    }

    public Integer getScore() {
        return score;
    }

    public void setScore(Integer score) {
        this.score = score;
    }

    public Date getCreateDate() {
        return createDate;
    }

    public void setCreateDate(Date createDate) {
        this.createDate = createDate;
    }

    public String getUpdateUser() {
        return updateUser;
    }

    public void setUpdateUser(String updateUser) {
        this.updateUser = updateUser == null ? null : updateUser.trim();
    }

    public Date getUpdateDate() {
        return updateDate;
    }

    public void setUpdateDate(Date updateDate) {
        this.updateDate = updateDate;
    }

    public String getCreateUser() {
        return createUser;
    }

    public void setCreateUser(String createUser) {
        this.createUser = createUser == null ? null : createUser.trim();
    }

    public String getCourseCatpchaId() {
        return courseCatpchaId;
    }

    public void setCourseCatpchaId(String courseCatpchaId) {
        this.courseCatpchaId = courseCatpchaId == null ? null : courseCatpchaId.trim();
    }

    public String getRefuseReason() {
        return refuseReason;
    }

    public void setRefuseReason(String refuseReason) {
        this.refuseReason = refuseReason == null ? null : refuseReason.trim();
    }

    public Date getCheckTime() {
        return checkTime;
    }

    public void setCheckTime(Date checkTime) {
        this.checkTime = checkTime;
    }

    public Date getSignTime() {
        return signTime;
    }

    public void setSignTime(Date signTime) {
        this.signTime = signTime;
    }
}