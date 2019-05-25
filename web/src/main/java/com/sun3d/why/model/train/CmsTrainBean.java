package com.sun3d.why.model.train;

public class CmsTrainBean extends CmsTrain {
    private String trainId;

    private String orderNum;

    public String getTrainId() {
        return trainId;
    }

    public void setTrainId(String trainId) {
        this.trainId = trainId;
    }

    public String getOrderNum() {
        return orderNum;
    }

    public void setOrderNum(String orderNum) {
        this.orderNum = orderNum;
    }

    private String venueName; //场馆名称

     private String state;

     private String isBalance;

     private String typeName;

     private String tagName; //

     private Integer peopleCount; //总录取人数

     private Integer surplusPeoples; //剩余录取人数

     private Integer admissionsPeoples;//已录取人数

    private Integer order; //1-智能排序，2-最新发布，3-即将开始，4-即将过期

    private Integer isCollect; //是否收藏

    private Integer isRegistration;//是否报名

    private Integer maleMinAge;

    private Integer maleMaxAge;

    private Integer femaleMinAge;

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

    public Integer getOrder() {
        return order;
    }

    public void setOrder(Integer order) {
        this.order = order;
    }

    public Integer getIsCollect() {
        return isCollect;
    }

    public void setIsCollect(Integer isCollect) {
        this.isCollect = isCollect;
    }

    public Integer getIsRegistration() {
        return isRegistration;
    }

    public void setIsRegistration(Integer isRegistration) {
        this.isRegistration = isRegistration;
    }
}