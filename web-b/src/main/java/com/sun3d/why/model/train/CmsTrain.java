package com.sun3d.why.model.train;

import com.sun3d.why.util.Pagination;

import java.util.Date;

public class CmsTrain extends Pagination {
    private String id;

    private String trainTitle;

    private String trainImgUrl;

    private String trainIntroduce;

    private Integer trainStatus;

    private Integer isDelete;

    private Date createTime;

    private String createUser;

    private String trainProvince;

    private String trainCity;

    private String trainArea;

    private String trainLocation;

    private String trainAddress;

    private String venueType;

    private String venueId;

    private String trainType;

    private String trainTag;

    private Integer admissionType;

    private Integer maxPeople;

    private Integer trainField;

    private Double lon;

    private Double lat;

    private String interviewTime;

    private String interviewAddress;

    private String reminder;

    private String consultingPhone;

    private String contactInformation;

    private String registrationRequirements;

    private String courseIntroduction;

    private String teachersIntroduction;

    private String registrationStartTime;

    private String registrationEndTime;

    private String trainStartTime;

    private String trainEndTime;

    private String updateUser;

    private Date updateTime;

    //课程类型 新春班 春季班 暑期班 秋季班
    private String courseType;

    //报名次数
    private Integer registrationCount;
    //男性最低年龄限制
    private Integer maleMinAge;
    //男性最高年龄限制
    private Integer maleMaxAge;
    //女性最低年龄限制
    private Integer femaleMinAge;
    //女性最高年龄限制
    private Integer femaleMaxAge;

    public Integer getMaleMinAge() {
        return maleMinAge;
    }

    public void setMaleMinAge(Integer maleMinAge) {
        this.maleMinAge = maleMinAge;
    }

    public Integer getMaleMaxAge() {
        return maleMaxAge;
    }

    public void setMaleMaxAge(Integer maleMaxAge) {
        this.maleMaxAge = maleMaxAge;
    }

    public Integer getFemaleMinAge() {
        return femaleMinAge;
    }

    public void setFemaleMinAge(Integer femaleMinAge) {
        this.femaleMinAge = femaleMinAge;
    }

    public Integer getFemaleMaxAge() {
        return femaleMaxAge;
    }

    public void setFemaleMaxAge(Integer femaleMaxAge) {
        this.femaleMaxAge = femaleMaxAge;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id == null ? null : id.trim();
    }

    public String getTrainTitle() {
        return trainTitle;
    }

    public void setTrainTitle(String trainTitle) {
        this.trainTitle = trainTitle == null ? null : trainTitle.trim();
    }

    public String getTrainImgUrl() {
        return trainImgUrl;
    }

    public void setTrainImgUrl(String trainImgUrl) {
        this.trainImgUrl = trainImgUrl == null ? null : trainImgUrl.trim();
    }

    public String getTrainIntroduce() {
        return trainIntroduce;
    }

    public void setTrainIntroduce(String trainIntroduce) {
        this.trainIntroduce = trainIntroduce == null ? null : trainIntroduce.trim();
    }

    public Integer getTrainStatus() {
        return trainStatus;
    }

    public void setTrainStatus(Integer trainStatus) {
        this.trainStatus = trainStatus;
    }

    public Integer getIsDelete() {
        return isDelete;
    }

    public void setIsDelete(Integer isDelete) {
        this.isDelete = isDelete;
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

    public String getTrainProvince() {
        return trainProvince;
    }

    public void setTrainProvince(String trainProvince) {
        this.trainProvince = trainProvince == null ? null : trainProvince.trim();
    }

    public String getTrainCity() {
        return trainCity;
    }

    public void setTrainCity(String trainCity) {
        this.trainCity = trainCity == null ? null : trainCity.trim();
    }

    public String getTrainArea() {
        return trainArea;
    }

    public void setTrainArea(String trainArea) {
        this.trainArea = trainArea == null ? null : trainArea.trim();
    }

    public String getTrainLocation() {
        return trainLocation;
    }

    public void setTrainLocation(String trainLocation) {
        this.trainLocation = trainLocation == null ? null : trainLocation.trim();
    }

    public String getTrainAddress() {
        return trainAddress;
    }

    public void setTrainAddress(String trainAddress) {
        this.trainAddress = trainAddress == null ? null : trainAddress.trim();
    }

    public String getVenueType() {
        return venueType;
    }

    public void setVenueType(String venueType) {
        this.venueType = venueType == null ? null : venueType.trim();
    }

    public String getVenueId() {
        return venueId;
    }

    public void setVenueId(String venueId) {
        this.venueId = venueId == null ? null : venueId.trim();
    }

    public String getTrainType() {
        return trainType;
    }

    public void setTrainType(String trainType) {
        this.trainType = trainType == null ? null : trainType.trim();
    }

    public String getTrainTag() {
        return trainTag;
    }

    public void setTrainTag(String trainTag) {
        this.trainTag = trainTag == null ? null : trainTag.trim();
    }

    public Integer getMaxPeople() {
        return maxPeople;
    }

    public void setMaxPeople(Integer maxPeople) {
        this.maxPeople = maxPeople;
    }

    public Double getLon() {
        return lon;
    }

    public void setLon(Double lon) {
        this.lon = lon;
    }

    public Double getLat() {
        return lat;
    }

    public void setLat(Double lat) {
        this.lat = lat;
    }

    public String getInterviewTime() {
        return interviewTime;
    }

    public void setInterviewTime(String interviewTime) {
        this.interviewTime = interviewTime == null ? null : interviewTime.trim();
    }

    public String getInterviewAddress() {
        return interviewAddress;
    }

    public void setInterviewAddress(String interviewAddress) {
        this.interviewAddress = interviewAddress == null ? null : interviewAddress.trim();
    }

    public String getReminder() {
        return reminder;
    }

    public void setReminder(String reminder) {
        this.reminder = reminder == null ? null : reminder.trim();
    }

    public String getConsultingPhone() {
        return consultingPhone;
    }

    public void setConsultingPhone(String consultingPhone) {
        this.consultingPhone = consultingPhone == null ? null : consultingPhone.trim();
    }

    public String getContactInformation() {
        return contactInformation;
    }

    public void setContactInformation(String contactInformation) {
        this.contactInformation = contactInformation == null ? null : contactInformation.trim();
    }

    public String getRegistrationRequirements() {
        return registrationRequirements;
    }

    public void setRegistrationRequirements(String registrationRequirements) {
        this.registrationRequirements = registrationRequirements == null ? null : registrationRequirements.trim();
    }

    public String getCourseIntroduction() {
        return courseIntroduction;
    }

    public void setCourseIntroduction(String courseIntroduction) {
        this.courseIntroduction = courseIntroduction == null ? null : courseIntroduction.trim();
    }

    public String getTeachersIntroduction() {
        return teachersIntroduction;
    }

    public void setTeachersIntroduction(String teachersIntroduction) {
        this.teachersIntroduction = teachersIntroduction == null ? null : teachersIntroduction.trim();
    }

    public String getRegistrationStartTime() {
        return registrationStartTime;
    }

    public void setRegistrationStartTime(String registrationStartTime) {
        this.registrationStartTime = registrationStartTime == null ? null : registrationStartTime.trim();
    }

    public String getRegistrationEndTime() {
        return registrationEndTime;
    }

    public void setRegistrationEndTime(String registrationEndTime) {
        this.registrationEndTime = registrationEndTime == null ? null : registrationEndTime.trim();
    }

    public String getTrainStartTime() {
        return trainStartTime;
    }

    public void setTrainStartTime(String trainStartTime) {
        this.trainStartTime = trainStartTime == null ? null : trainStartTime.trim();
    }

    public String getTrainEndTime() {
        return trainEndTime;
    }

    public void setTrainEndTime(String trainEndTime) {
        this.trainEndTime = trainEndTime == null ? null : trainEndTime.trim();
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

    public Integer getAdmissionType() {
        return admissionType;
    }

    public void setAdmissionType(Integer admissionType) {
        this.admissionType = admissionType;
    }

    public Integer getTrainField() {
        return trainField;
    }

    public void setTrainField(Integer trainField) {
        this.trainField = trainField;
    }

    public String getCourseType() {
        return courseType;
    }

    public void setCourseType(String courseType) {
        this.courseType = courseType;
    }

    public Integer getRegistrationCount() {
        return registrationCount;
    }

    public void setRegistrationCount(Integer registrationCount) {
        this.registrationCount = registrationCount;
    }
}