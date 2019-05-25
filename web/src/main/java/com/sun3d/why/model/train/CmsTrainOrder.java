package com.sun3d.why.model.train;

import com.sun3d.why.util.Pagination;

import java.util.Date;

public class CmsTrainOrder extends Pagination {
    private String id;

    private String trainId;

    private String orderNum;

    private String name;

    private String birthday;

    private Integer sex;

    private String idCard;

    private String phoneNum;

    private Integer state;

    private String createUser;

    private Date createTime;

    private Date updateTime;

    private String updateUser;

    private String homeAddress;

    private String homeConnector;

    private String connectorRelationship;

    private String connectorPhoneNum;

    private Integer age;

    private String trainTitle;

    private String trainImgUrl;

    private String trainStartTime;

    private String trainEndTime;

    private String trainAddress;

    private String trainRemark;

    public String getTrainTitle() {
        return trainTitle;
    }

    public void setTrainTitle(String trainTitle) {
        this.trainTitle = trainTitle;
    }

    public String getTrainImgUrl() {
        return trainImgUrl;
    }

    public void setTrainImgUrl(String trainImgUrl) {
        this.trainImgUrl = trainImgUrl;
    }

    public String getTrainStartTime() {
        return trainStartTime;
    }

    public void setTrainStartTime(String trainStartTime) {
        this.trainStartTime = trainStartTime;
    }

    public String getTrainEndTime() {
        return trainEndTime;
    }

    public void setTrainEndTime(String trainEndTime) {
        this.trainEndTime = trainEndTime;
    }

    public String getTrainAddress() {
        return trainAddress;
    }

    public void setTrainAddress(String trainAddress) {
        this.trainAddress = trainAddress;
    }

    public String getHomeAddress() {
        return homeAddress;
    }

    public void setHomeAddress(String homeAddress) {
        this.homeAddress = homeAddress;
    }

    public String getHomeConnector() {
        return homeConnector;
    }

    public void setHomeConnector(String homeConnector) {
        this.homeConnector = homeConnector;
    }

    public String getConnectorRelationship() {
        return connectorRelationship;
    }

    public void setConnectorRelationship(String connectorRelationship) {
        this.connectorRelationship = connectorRelationship;
    }

    public String getConnectorPhoneNum() {
        return connectorPhoneNum;
    }

    public void setConnectorPhoneNum(String connectorPhoneNum) {
        this.connectorPhoneNum = connectorPhoneNum;
    }

    public Integer getAge() {
        return age;
    }

    public void setAge(Integer age) {
        this.age = age;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id == null ? null : id.trim();
    }

    public String getTrainId() {
        return trainId;
    }

    public void setTrainId(String trainId) {
        this.trainId = trainId == null ? null : trainId.trim();
    }

    public String getOrderNum() {
        return orderNum;
    }

    public void setOrderNum(String orderNum) {
        this.orderNum = orderNum == null ? null : orderNum.trim();
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name == null ? null : name.trim();
    }

    public String getBirthday() {
        return birthday;
    }

    public void setBirthday(String birthday) {
        this.birthday = birthday == null ? null : birthday.trim();
    }

    public Integer getSex() {
        return sex;
    }

    public void setSex(Integer sex) {
        this.sex = sex;
    }

    public String getIdCard() {
        return idCard;
    }

    public void setIdCard(String idCard) {
        this.idCard = idCard == null ? null : idCard.trim();
    }

    public String getPhoneNum() {
        return phoneNum;
    }

    public void setPhoneNum(String phoneNum) {
        this.phoneNum = phoneNum == null ? null : phoneNum.trim();
    }

    public Integer getState() {
        return state;
    }

    public void setState(Integer state) {
        this.state = state;
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

    public Date getUpdateTime() {
        return updateTime;
    }

    public void setUpdateTime(Date updateTime) {
        this.updateTime = updateTime;
    }

    public String getUpdateUser() {
        return updateUser;
    }

    public void setUpdateUser(String updateUser) {
        this.updateUser = updateUser;
    }

    public String getTrainRemark() {
        return trainRemark;
    }

    public void setTrainRemark(String trainRemark) {
        this.trainRemark = trainRemark;
    }
}