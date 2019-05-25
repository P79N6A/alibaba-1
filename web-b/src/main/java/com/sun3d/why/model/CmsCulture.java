package com.sun3d.why.model;

import com.sun3d.why.util.Pagination;

import java.io.Serializable;
import java.util.Date;

public class CmsCulture  extends Pagination implements Serializable {
    private String cultureId;

    private String cultureName;

    private String cultureImgurl;

    private String cultureProvince;

    private String cultureCity;

    private String cultureArea;

    private Date createTime;

    private String createUser;

    private Date updateTime;

    private String updateUser;
    private  String  dictName;

    public String getDictName() {
        return dictName;
    }

    public void setDictName(String dictName) {
        this.dictName = dictName;
    }

    public String getCultureSystem() {
        return cultureSystem;
    }

    public void setCultureSystem(String cultureSystem) {
        this.cultureSystem = cultureSystem;
    }

    private  String cultureSystem;
    private  String cultureYears;
    private  String cultureType;

    private  String cultureSystemName;
    private  String cultureYearsName;
    private  String cultureTypeName;

    private  String sysUserName;

    private String cultureDes;

    //浏览量
    private Integer  yearBrowseCount;


    public Integer getCultureState() {
        return cultureState;
    }

    public void setCultureState(Integer cultureState) {
        this.cultureState = cultureState;
    }

    private Integer cultureState;


    private  String cultureVediourl;

    public String getCultureId() {
        return cultureId;
    }

    public void setCultureId(String cultureId) {
        this.cultureId = cultureId == null ? null : cultureId.trim();
    }

    public String getCultureName() {
        return cultureName;
    }

    public void setCultureName(String cultureName) {
        this.cultureName = cultureName == null ? null : cultureName.trim();
    }

    public String getCultureImgurl() {
        return cultureImgurl;
    }

    public void setCultureImgurl(String cultureImgurl) {
        this.cultureImgurl = cultureImgurl == null ? null : cultureImgurl.trim();
    }

    public String getCultureProvince() {
        return cultureProvince;
    }

    public void setCultureProvince(String cultureProvince) {
        this.cultureProvince = cultureProvince == null ? null : cultureProvince.trim();
    }

    public String getCultureCity() {
        return cultureCity;
    }

    public void setCultureCity(String cultureCity) {
        this.cultureCity = cultureCity == null ? null : cultureCity.trim();
    }

    public String getCultureArea() {
        return cultureArea;
    }

    public void setCultureArea(String cultureArea) {
        this.cultureArea = cultureArea == null ? null : cultureArea.trim();
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
        this.updateUser = updateUser == null ? null : updateUser.trim();
    }

    public String getCultureYears() {
        return cultureYears;
    }

    public void setCultureYears(String cultureYears) {
        this.cultureYears = cultureYears;
    }

    public String getCultureType() {
        return cultureType;
    }

    public void setCultureType(String cultureType) {
        this.cultureType = cultureType;
    }

    public String getCultureSystemName() {
        return cultureSystemName;
    }

    public void setCultureSystemName(String cultureSystemName) {
        this.cultureSystemName = cultureSystemName;
    }

    public String getCultureYearsName() {
        return cultureYearsName;
    }

    public void setCultureYearsName(String cultureYearsName) {
        this.cultureYearsName = cultureYearsName;
    }

    public String getCultureTypeName() {
        return cultureTypeName;
    }

    public void setCultureTypeName(String cultureTypeName) {
        this.cultureTypeName = cultureTypeName;
    }

    public String getCultureDes() {
        return cultureDes;
    }

    public void setCultureDes(String cultureDes) {
        this.cultureDes = cultureDes;
    }

    public String getSysUserName() {
        return sysUserName;
    }

    public void setSysUserName(String sysUserName) {
        this.sysUserName = sysUserName;
    }

    public String getCultureVediourl() {
        return cultureVediourl;
    }

    public void setCultureVediourl(String cultureVediourl) {
        this.cultureVediourl = cultureVediourl;
    }

    public Integer getYearBrowseCount() {
        return yearBrowseCount;
    }

    public void setYearBrowseCount(Integer yearBrowseCount) {
        this.yearBrowseCount = yearBrowseCount;
    }
}