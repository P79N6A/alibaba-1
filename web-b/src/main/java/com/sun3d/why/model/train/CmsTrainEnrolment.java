package com.sun3d.why.model.train;

import java.util.Date;

public class CmsTrainEnrolment {
    private String id;

    private String springEnrolment;

    private String autumnEnrolment;

    private String createUser;

    private Date createTime;

    private String springImg;

    private String autumnImg;

    private Integer newSpringCount;

    private Integer springCount;

    private Integer summerCount;

    private Integer autumnCount;

    public Integer getNewSpringCount() {
        return newSpringCount;
    }

    public void setNewSpringCount(Integer newSpringCount) {
        this.newSpringCount = newSpringCount;
    }

    public Integer getSpringCount() {
        return springCount;
    }

    public void setSpringCount(Integer springCount) {
        this.springCount = springCount;
    }

    public Integer getSummerCount() {
        return summerCount;
    }

    public void setSummerCount(Integer summerCount) {
        this.summerCount = summerCount;
    }

    public Integer getAutumnCount() {
        return autumnCount;
    }

    public void setAutumnCount(Integer autumnCount) {
        this.autumnCount = autumnCount;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id == null ? null : id.trim();
    }

    public String getSpringEnrolment() {
        return springEnrolment;
    }

    public void setSpringEnrolment(String springEnrolment) {
        this.springEnrolment = springEnrolment == null ? null : springEnrolment.trim();
    }

    public String getAutumnEnrolment() {
        return autumnEnrolment;
    }

    public void setAutumnEnrolment(String autumnEnrolment) {
        this.autumnEnrolment = autumnEnrolment == null ? null : autumnEnrolment.trim();
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

    public String getSpringImg() {
        return springImg;
    }

    public void setSpringImg(String springImg) {
        this.springImg = springImg == null ? null : springImg.trim();
    }

    public String getAutumnImg() {
        return autumnImg;
    }

    public void setAutumnImg(String autumnImg) {
        this.autumnImg = autumnImg == null ? null : autumnImg.trim();
    }
}