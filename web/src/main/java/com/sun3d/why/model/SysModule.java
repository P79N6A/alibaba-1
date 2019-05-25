package com.sun3d.why.model;

import com.sun3d.why.util.Pagination;

import java.io.Serializable;
import java.util.Date;


/**
 * 模块管理实体类
 *
 * @author wangfan 2015/04/22
 */
public class SysModule extends Pagination implements Serializable{

    /**
     * 模块id
     */
    private String moduleId;

    /**
     * 模块名称
     */
    private String moduleName;

    /**
     * 模块链接地址
     */
    private String moduleUrl;

    /**
     * 模块上级id
     */
    private String moduleParentId;

    /**
     * 模块描述
     */
    private String moduleRemark;

    /**
     * 模块状态，逻辑删除用到，1：正常 2：删除
     */
    private Integer moduleState;

    /**
     * 排序
     */
    private Integer moduleSort;

    /**
     * 操作员
     */
    private String moduleCreateUser;

    /**
     * 录入时间
     */
    private Date moduleCreateTime;

    /**
     * 更新人
     */
    private String moduleUpdateUser;

    /**
     * 更新时间
     */
    private Date moduleUpdateTime;

    public String getModuleId() {
        return moduleId;
    }

    public void setModuleId(String moduleId) {
        this.moduleId = moduleId == null ? null : moduleId.trim();
    }

    public String getModuleName() {
        return moduleName;
    }

    public void setModuleName(String moduleName) {
        this.moduleName = moduleName == null ? null : moduleName.trim();
    }

    public String getModuleUrl() {
        return moduleUrl;
    }

    public void setModuleUrl(String moduleUrl) {
        this.moduleUrl = moduleUrl == null ? null : moduleUrl.trim();
    }

    public String getModuleParentId() {
        return moduleParentId;
    }

    public void setModuleParentId(String moduleParentId) {
        this.moduleParentId = moduleParentId == null ? null : moduleParentId.trim();
    }

    public String getModuleRemark() {
        return moduleRemark;
    }

    public void setModuleRemark(String moduleRemark) {
        this.moduleRemark = moduleRemark == null ? null : moduleRemark.trim();
    }

    public Integer getModuleState() {
        return moduleState;
    }

    public void setModuleState(Integer moduleState) {
        this.moduleState = moduleState;
    }

    public Integer getModuleSort() {
        return moduleSort;
    }

    public void setModuleSort(Integer moduleSort) {
        this.moduleSort = moduleSort;
    }

    public String getModuleCreateUser() {
        return moduleCreateUser;
    }

    public void setModuleCreateUser(String moduleCreateUser) {
        this.moduleCreateUser = moduleCreateUser == null ? null : moduleCreateUser.trim();
    }

    public Date getModuleCreateTime() {
        return moduleCreateTime;
    }

    public void setModuleCreateTime(Date moduleCreateTime) {
        this.moduleCreateTime = moduleCreateTime;
    }

    public String getModuleUpdateUser() {
        return moduleUpdateUser;
    }

    public void setModuleUpdateUser(String moduleUpdateUser) {
        this.moduleUpdateUser = moduleUpdateUser == null ? null : moduleUpdateUser.trim();
    }

    public Date getModuleUpdateTime() {
        return moduleUpdateTime;
    }

    public void setModuleUpdateTime(Date moduleUpdateTime) {
        this.moduleUpdateTime = moduleUpdateTime;
    }
}