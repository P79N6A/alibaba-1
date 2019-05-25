package com.sun3d.why.model;

import java.io.Serializable;
import java.util.Date;

public class CmsSubject implements Serializable {
    private String subjectId;

    private String subjectName;

    private String subjectSubtitle;

    private String subjectParentId;

    private Integer subjectType;

    private Integer subjectSort;

    private Integer subjectMemo;

    private String subjectIconUrl;

    private Integer subjectIsDel;

    private Integer subjectState;

    private Date subjectCreateTime;

    private Date subjectUpdateTime;

    private String subjectCreateUser;

    private String subjectUpdateUser;

    private String subjectDept;

    public String getSubjectId() {
        return subjectId;
    }

    public void setSubjectId(String subjectId) {
        this.subjectId = subjectId == null ? null : subjectId.trim();
    }

    public String getSubjectName() {
        return subjectName;
    }

    public void setSubjectName(String subjectName) {
        this.subjectName = subjectName == null ? null : subjectName.trim();
    }

    public String getSubjectSubtitle() {
        return subjectSubtitle;
    }

    public void setSubjectSubtitle(String subjectSubtitle) {
        this.subjectSubtitle = subjectSubtitle == null ? null : subjectSubtitle.trim();
    }

    public String getSubjectParentId() {
        return subjectParentId;
    }

    public void setSubjectParentId(String subjectParentId) {
        this.subjectParentId = subjectParentId == null ? null : subjectParentId.trim();
    }

    public Integer getSubjectType() {
        return subjectType;
    }

    public void setSubjectType(Integer subjectType) {
        this.subjectType = subjectType;
    }

    public Integer getSubjectSort() {
        return subjectSort;
    }

    public void setSubjectSort(Integer subjectSort) {
        this.subjectSort = subjectSort;
    }

    public Integer getSubjectMemo() {
        return subjectMemo;
    }

    public void setSubjectMemo(Integer subjectMemo) {
        this.subjectMemo = subjectMemo;
    }

    public String getSubjectIconUrl() {
        return subjectIconUrl;
    }

    public void setSubjectIconUrl(String subjectIconUrl) {
        this.subjectIconUrl = subjectIconUrl == null ? null : subjectIconUrl.trim();
    }

    public Integer getSubjectIsDel() {
        return subjectIsDel;
    }

    public void setSubjectIsDel(Integer subjectIsDel) {
        this.subjectIsDel = subjectIsDel;
    }

    public Integer getSubjectState() {
        return subjectState;
    }

    public void setSubjectState(Integer subjectState) {
        this.subjectState = subjectState;
    }

    public Date getSubjectCreateTime() {
        return subjectCreateTime;
    }

    public void setSubjectCreateTime(Date subjectCreateTime) {
        this.subjectCreateTime = subjectCreateTime;
    }

    public Date getSubjectUpdateTime() {
        return subjectUpdateTime;
    }

    public void setSubjectUpdateTime(Date subjectUpdateTime) {
        this.subjectUpdateTime = subjectUpdateTime;
    }

    public String getSubjectCreateUser() {
        return subjectCreateUser;
    }

    public void setSubjectCreateUser(String subjectCreateUser) {
        this.subjectCreateUser = subjectCreateUser == null ? null : subjectCreateUser.trim();
    }

    public String getSubjectUpdateUser() {
        return subjectUpdateUser;
    }

    public void setSubjectUpdateUser(String subjectUpdateUser) {
        this.subjectUpdateUser = subjectUpdateUser == null ? null : subjectUpdateUser.trim();
    }

    public String getSubjectDept() {
        return subjectDept;
    }

    public void setSubjectDept(String subjectDept) {
        this.subjectDept = subjectDept == null ? null : subjectDept.trim();
    }
}