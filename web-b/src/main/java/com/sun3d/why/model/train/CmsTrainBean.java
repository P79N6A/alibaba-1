package com.sun3d.why.model.train;

public class CmsTrainBean extends CmsTrain {
     private String venueName; //场馆名称

     private String state;

     private String isBalance;

     private String typeName;

     private String tagName; //

     private Integer peopleCount; //已报名人数

     private Integer surplusPeoples; //剩余录取人数

     private Integer admissionsPeoples;//已录取人数

    private Integer isCollect;

    private Integer trainTimeDetails;

    private Integer trainCommentCount;

    private String userName;

    private String area;

    private String venueType;

    @Override
    public String getVenueType() {
        return venueType;
    }

    @Override
    public void setVenueType(String venueType) {
        this.venueType = venueType;
    }

    public String getArea() {
        return area;
    }

    public void setArea(String area) {
        this.area = area;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public Integer getTrainCommentCount() {
        return trainCommentCount;
    }

    public void setTrainCommentCount(Integer trainCommentCount) {
        this.trainCommentCount = trainCommentCount;
    }

    public Integer getTrainTimeDetails() {
        return trainTimeDetails;
    }

    public void setTrainTimeDetails(Integer trainTimeDetails) {
        this.trainTimeDetails = trainTimeDetails;
    }

    public String getVenueName() {
        return venueName;
    }

    public void setVenueName(String venueName) {
        this.venueName = venueName;
    }

    public String getState() {
        return state;
    }

    public void setState(String state) {
        this.state = state;
    }

    public String getIsBalance() {
        return isBalance;
    }

    public void setIsBalance(String isBalance) {
        this.isBalance = isBalance;
    }

    public String getTypeName() {
        return typeName;
    }

    public void setTypeName(String typeName) {
        this.typeName = typeName;
    }

    public String getTagName() {
        return tagName;
    }

    public void setTagName(String tagName) {
        this.tagName = tagName;
    }

    public Integer getAdmissionsPeoples() {
        return admissionsPeoples;
    }

    public void setAdmissionsPeoples(Integer admissionsPeoples) {
        this.admissionsPeoples = admissionsPeoples;
    }

    public Integer getSurplusPeoples() {

        return surplusPeoples;
    }

    public void setSurplusPeoples(Integer surplusPeoples) {
        this.surplusPeoples = surplusPeoples;
    }

    public Integer getPeopleCount() {

        return peopleCount;
    }

    public void setPeopleCount(Integer peopleCount) {
        this.peopleCount = peopleCount;
    }

    public Integer getIsCollect() {
        return isCollect;
    }

    public void setIsCollect(Integer isCollect) {
        this.isCollect = isCollect;
    }
}