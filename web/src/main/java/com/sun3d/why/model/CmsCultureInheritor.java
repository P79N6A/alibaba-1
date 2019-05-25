package com.sun3d.why.model;

import com.sun3d.why.util.Pagination;

import java.io.Serializable;
import java.util.Date;

public class CmsCultureInheritor extends Pagination implements Serializable {
    private String inheritorId;

    private String cultureId;

    private String inheritorName;

    private Integer inheritorSex;

    private Integer inheritorAge;

    private String inheritorNation;

    private String inheritorHeadImgUrl;

    private Date inheritorCreateTime;

    private String inheritorCreateUser;

    private Date inheritorUpdateTime;

    private String inheritorUpdateUser;

    private String inheritorRemark;

    // 非遗名称
    private String cultureName;

    // 字典-民族名称
    private String dictName;

    public String getCultureName() {
        return cultureName;
    }

    public void setCultureName(String cultureName) {
        this.cultureName = cultureName == null ? null : cultureName.trim();
    }

    public String getDictName() {
        return dictName;
    }

    public void setDictName(String dictName) {
        this.dictName = dictName == null ? null : dictName.trim();
    }

    public String getInheritorId() {
        return inheritorId;
    }

    public void setInheritorId(String inheritorId) {
        this.inheritorId = inheritorId == null ? null : inheritorId.trim();
    }

    public String getCultureId() {
        return cultureId;
    }

    public void setCultureId(String cultureId) {
        this.cultureId = cultureId == null ? null : cultureId.trim();
    }

    public String getInheritorName() {
        return inheritorName;
    }

    public void setInheritorName(String inheritorName) {
        this.inheritorName = inheritorName == null ? null : inheritorName.trim();
    }

    public Integer getInheritorSex() {
        return inheritorSex;
    }

    public void setInheritorSex(Integer inheritorSex) {
        this.inheritorSex = inheritorSex;
    }

    public Integer getInheritorAge() {
        return inheritorAge;
    }

    public void setInheritorAge(Integer inheritorAge) {
        this.inheritorAge = inheritorAge;
    }

    public String getInheritorNation() {
        return inheritorNation;
    }

    public void setInheritorNation(String inheritorNation) {
        this.inheritorNation = inheritorNation == null ? null : inheritorNation.trim();
    }

    public String getInheritorHeadImgUrl() {
        return inheritorHeadImgUrl;
    }

    public void setInheritorHeadImgUrl(String inheritorHeadImgUrl) {
        this.inheritorHeadImgUrl = inheritorHeadImgUrl == null ? null : inheritorHeadImgUrl.trim();
    }

    public Date getInheritorCreateTime() {
        return inheritorCreateTime;
    }

    public void setInheritorCreateTime(Date inheritorCreateTime) {
        this.inheritorCreateTime = inheritorCreateTime;
    }

    public String getInheritorCreateUser() {
        return inheritorCreateUser;
    }

    public void setInheritorCreateUser(String inheritorCreateUser) {
        this.inheritorCreateUser = inheritorCreateUser == null ? null : inheritorCreateUser.trim();
    }

    public Date getInheritorUpdateTime() {
        return inheritorUpdateTime;
    }

    public void setInheritorUpdateTime(Date inheritorUpdateTime) {
        this.inheritorUpdateTime = inheritorUpdateTime;
    }

    public String getInheritorUpdateUser() {
        return inheritorUpdateUser;
    }

    public void setInheritorUpdateUser(String inheritorUpdateUser) {
        this.inheritorUpdateUser = inheritorUpdateUser == null ? null : inheritorUpdateUser.trim();
    }

    public String getInheritorRemark() {
        return inheritorRemark;
    }

    public void setInheritorRemark(String inheritorRemark) {
        this.inheritorRemark = inheritorRemark == null ? null : inheritorRemark.trim();
    }
}