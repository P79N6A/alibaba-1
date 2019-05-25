package com.sun3d.why.model.volunteer;

import org.springframework.format.annotation.DateTimeFormat;

import java.util.Date;

public class VolunteerActivity {
    private String uuid; //主键

    private String name;// 招募活动名字

    private String picUrl;// 封面图片

    private String serviceType;// 服务类型，对应于字典表

    private Integer recruitmentStatus;// 招募状态，即是否启用招募 1:招募  2:暂停招募

    private Integer recruitObjectType;// 招募类型 1:个人  2:团队

    private String respectiveRegion;//区域,存省市区，逗号,间隔

    private String address;//活动具体地址

    private String coordinate;//地图坐标，经度和维度，以,分隔

    private String phone;//联系电话

    private Integer limitNum;//允许报名人数
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date startTime;//活动开始时间
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date endTime;//活动结束时间

    private String serviceTime;//服务时长，单位小时

    private Integer publish;//上下架  1: 上架  2: 下架

    private String description;//活动描述

    private String attachment;//附件地址

    private Integer status;//状态：1:草稿 2:未审核 3:正常 4:驳回 9:删除

    private String createId;//创建人id

    private Date createTime;//创建时间

    private String updateId;//修改人id

    private Date updateTime;//修改时间

    private Integer firstResult;//分页参数

    private Integer rows; //分页参数

    public String getUuid() {
        return uuid;
    }

    public void setUuid(String uuid) {
        this.uuid = uuid == null ? null : uuid.trim();
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name == null ? null : name.trim();
    }

    public String getPicUrl() {
        return picUrl;
    }

    public void setPicUrl(String picUrl) {
        this.picUrl = picUrl == null ? null : picUrl.trim();
    }

    public String getServiceType() {
        return serviceType;
    }

    public void setServiceType(String serviceType) {
        this.serviceType = serviceType == null ? null : serviceType.trim();
    }

    public Integer getRecruitmentStatus() {
        return recruitmentStatus;
    }

    public void setRecruitmentStatus(Integer recruitmentStatus) {
        this.recruitmentStatus = recruitmentStatus;
    }

    public Integer getRecruitObjectType() {
        return recruitObjectType;
    }

    public void setRecruitObjectType(Integer recruitObjectType) {
        this.recruitObjectType = recruitObjectType;
    }

    public String getRespectiveRegion() {
        return respectiveRegion;
    }

    public void setRespectiveRegion(String respectiveRegion) {
        this.respectiveRegion = respectiveRegion == null ? null : respectiveRegion.trim();
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address == null ? null : address.trim();
    }

    public String getCoordinate() {
        return coordinate;
    }

    public void setCoordinate(String coordinate) {
        this.coordinate = coordinate == null ? null : coordinate.trim();
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone == null ? null : phone.trim();
    }

    public Integer getLimitNum() {
        return limitNum;
    }

    public void setLimitNum(Integer limitNum) {
        this.limitNum = limitNum;
    }

    public Date getStartTime() {
        return startTime;
    }

    public void setStartTime(Date startTime) {
        this.startTime = startTime;
    }

    public Date getEndTime() {
        return endTime;
    }

    public void setEndTime(Date endTime) {
        this.endTime = endTime;
    }

    public String getServiceTime() {
        return serviceTime;
    }

    public void setServiceTime(String serviceTime) {
        this.serviceTime = serviceTime == null ? null : serviceTime.trim();
    }

    public Integer getPublish() {
        return publish;
    }

    public void setPublish(Integer publish) {
        this.publish = publish;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description == null ? null : description.trim();
    }

    public String getAttachment() {
        return attachment;
    }

    public void setAttachment(String attachment) {
        this.attachment = attachment == null ? null : attachment.trim();
    }

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }

    public String getCreateId() {
        return createId;
    }

    public void setCreateId(String createId) {
        this.createId = createId == null ? null : createId.trim();
    }

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }

    public String getUpdateId() {
        return updateId;
    }

    public void setUpdateId(String updateId) {
        this.updateId = updateId == null ? null : updateId.trim();
    }

    public Date getUpdateTime() {
        return updateTime;
    }

    public void setUpdateTime(Date updateTime) {
        this.updateTime = updateTime;
    }

    public Integer getFirstResult() {
        return firstResult;
    }

    public void setFirstResult(Integer firstResult) {
        this.firstResult = firstResult;
    }

    public Integer getRows() {
        return rows;
    }

    public void setRows(Integer rows) {
        this.rows = rows;
    }
}