package com.sun3d.why.model;

import com.sun3d.why.model.extmodel.DictExt;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

public class SysDict implements Serializable {
    private String dictId;

    private String dictName;

    private String dictCode;

    private String dictParentId;

    private String dictRemark;

    private Integer dictSort;

    private Integer dictState;

    private String dictCreateUser;

    private Date dictCreateTime;

    private String dictUpdateUser;

    private Date dictUpdateTime;
    private  String userAccount;

    public String getUserAccount() {
        return userAccount;
    }

    public void setUserAccount(String userAccount) {
        this.userAccount = userAccount;
    }

    public String getDictId() {
        return dictId;
    }

    public void setDictId(String dictId) {
        this.dictId = dictId == null ? null : dictId.trim();
    }

    public String getDictName() {
        return dictName;
    }

    public void setDictName(String dictName) {
        this.dictName = dictName == null ? null : dictName.trim();
    }

    public String getDictCode() {
        return dictCode;
    }

    public void setDictCode(String dictCode) {
        this.dictCode = dictCode == null ? null : dictCode.trim();
    }

    public String getDictParentId() {
        return dictParentId;
    }

    public void setDictParentId(String dictParentId) {
        this.dictParentId = dictParentId == null ? null : dictParentId.trim();
    }

    public String getDictRemark() {
        return dictRemark;
    }

    public void setDictRemark(String dictRemark) {
        this.dictRemark = dictRemark == null ? null : dictRemark.trim();
    }

    public Integer getDictSort() {
        return dictSort;
    }

    public void setDictSort(Integer dictSort) {
        this.dictSort = dictSort;
    }

    public Integer getDictState() {
        return dictState;
    }

    public void setDictState(Integer dictState) {
        this.dictState = dictState;
    }

    public String getDictCreateUser() {
        return dictCreateUser;
    }

    public void setDictCreateUser(String dictCreateUser) {
        this.dictCreateUser = dictCreateUser == null ? null : dictCreateUser.trim();
    }

    public Date getDictCreateTime() {
        return dictCreateTime;
    }

    public void setDictCreateTime(Date dictCreateTime) {
        this.dictCreateTime = dictCreateTime;
    }

    public String getDictUpdateUser() {
        return dictUpdateUser;
    }

    public void setDictUpdateUser(String dictUpdateUser) {
        this.dictUpdateUser = dictUpdateUser == null ? null : dictUpdateUser.trim();
    }

    public Date getDictUpdateTime() {
        return dictUpdateTime;
    }

    public void setDictUpdateTime(Date dictUpdateTime) {
        this.dictUpdateTime = dictUpdateTime;
    }
}