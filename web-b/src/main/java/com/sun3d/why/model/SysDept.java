package com.sun3d.why.model;

import java.io.Serializable;
import java.util.Date;

public class SysDept implements Serializable {
    private String deptId;

    private String deptCode;

    private String deptName;

    private String deptShortName;

    private String deptParentId;

    private String deptPhone;

    private String deptRemark;

    private Integer deptSort;

    private Integer deptState;

    private String deptCreateUser;

    private Date deptCreateTime;

    private String deptUpdateUser;

    private Date deptUpdateTime;

    private String deptPath;

    private Integer deptIsFromVenue;

    public Integer getDeptIsFromVenue() {
        return deptIsFromVenue;
    }

    public void setDeptIsFromVenue(Integer deptIsFromVenue) {
        this.deptIsFromVenue = deptIsFromVenue == null ? null : deptIsFromVenue;;
    }

    public String getDeptId() {
        return deptId;
    }

    public void setDeptId(String deptId) {
        this.deptId = deptId == null ? null : deptId.trim();
    }

    public String getDeptCode() {
        return deptCode;
    }

    public void setDeptCode(String deptCode) {
        this.deptCode = deptCode == null ? null : deptCode.trim();
    }

    public String getDeptName() {
        return deptName;
    }

    public void setDeptName(String deptName) {
        this.deptName = deptName == null ? null : deptName.trim();
    }

    public String getDeptShortName() {
        return deptShortName;
    }

    public void setDeptShortName(String deptShortName) {
        this.deptShortName = deptShortName == null ? null : deptShortName.trim();
    }

    public String getDeptParentId() {
        return deptParentId;
    }

    public void setDeptParentId(String deptParentId) {
        this.deptParentId = deptParentId == null ? null : deptParentId.trim();
    }

    public String getDeptPhone() {
        return deptPhone;
    }

    public void setDeptPhone(String deptPhone) {
        this.deptPhone = deptPhone == null ? null : deptPhone.trim();
    }

    public String getDeptRemark() {
        return deptRemark;
    }

    public void setDeptRemark(String deptRemark) {
        this.deptRemark = deptRemark == null ? null : deptRemark.trim();
    }

    public Integer getDeptSort() {
        return deptSort;
    }

    public void setDeptSort(Integer deptSort) {
        this.deptSort = deptSort;
    }

    public Integer getDeptState() {
        return deptState;
    }

    public void setDeptState(Integer deptState) {
        this.deptState = deptState;
    }

    public String getDeptCreateUser() {
        return deptCreateUser;
    }

    public void setDeptCreateUser(String deptCreateUser) {
        this.deptCreateUser = deptCreateUser == null ? null : deptCreateUser.trim();
    }

    public Date getDeptCreateTime() {
        return deptCreateTime;
    }

    public void setDeptCreateTime(Date deptCreateTime) {
        this.deptCreateTime = deptCreateTime;
    }

    public String getDeptUpdateUser() {
        return deptUpdateUser;
    }

    public void setDeptUpdateUser(String deptUpdateUser) {
        this.deptUpdateUser = deptUpdateUser == null ? null : deptUpdateUser.trim();
    }

    public Date getDeptUpdateTime() {
        return deptUpdateTime;
    }

    public void setDeptUpdateTime(Date deptUpdateTime) {
        this.deptUpdateTime = deptUpdateTime;
    }

    public String getDeptPath() {
        return deptPath;
    }

    public void setDeptPath(String deptPath) {
        this.deptPath = deptPath == null ? null : deptPath.trim();
    }
}