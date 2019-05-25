package com.sun3d.why.model;

import com.sun3d.why.util.Pagination;

import java.io.Serializable;
import java.util.Date;

public class SysRole extends Pagination implements Serializable {
    private String roleId;

    private String roleName;

    private String roleRemark;

    private Integer roleSort;

    private Integer roleState;

    private String roleCreateUser;

    private Date roleCreateTime;

    private String roleUpdateUser;

    private Date roleUpdateTime;

    public String getRoleId() {
        return roleId;
    }

    public void setRoleId(String roleId) {
        this.roleId = roleId == null ? null : roleId.trim();
    }

    public String getRoleName() {
        return roleName;
    }

    public void setRoleName(String roleName) {
        this.roleName = roleName == null ? null : roleName.trim();
    }

    public String getRoleRemark() {
        return roleRemark;
    }

    public void setRoleRemark(String roleRemark) {
        this.roleRemark = roleRemark == null ? null : roleRemark.trim();
    }

    public Integer getRoleSort() {
        return roleSort;
    }

    public void setRoleSort(Integer roleSort) {
        this.roleSort = roleSort;
    }

    public Integer getRoleState() {
        return roleState;
    }

    public void setRoleState(Integer roleState) {
        this.roleState = roleState;
    }

    public String getRoleCreateUser() {
        return roleCreateUser;
    }

    public void setRoleCreateUser(String roleCreateUser) {
        this.roleCreateUser = roleCreateUser == null ? null : roleCreateUser.trim();
    }

    public Date getRoleCreateTime() {
        return roleCreateTime;
    }

    public void setRoleCreateTime(Date roleCreateTime) {
        this.roleCreateTime = roleCreateTime;
    }

    public String getRoleUpdateUser() {
        return roleUpdateUser;
    }

    public void setRoleUpdateUser(String roleUpdateUser) {
        this.roleUpdateUser = roleUpdateUser == null ? null : roleUpdateUser.trim();
    }

    public Date getRoleUpdateTime() {
        return roleUpdateTime;
    }

    public void setRoleUpdateTime(Date roleUpdateTime) {
        this.roleUpdateTime = roleUpdateTime;
    }
}