package com.sun3d.why.dao;

import com.sun3d.why.model.SysRoleModule;

public interface SysRoleModuleMapper {

    /**
     * 新增角色权限关联表
     * @param roleModule
     * @return
     */
    int addRoleModule(SysRoleModule roleModule);

    /**
     * 删除角色权限关联表
     * @param roleId
     */
    int deleteRoleModuleByRoleId(String roleId);
}