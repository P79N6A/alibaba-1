package com.sun3d.why.service;

import com.sun3d.why.model.SysRole;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.util.Pagination;

import java.util.List;

public interface SysRoleService {

    /**
     * 根据用户id查询角色对象
     * @param userId
     * @return
     */
    List<SysRole> queryRoleByUserId(String userId);

    /**
     * 角色列表首页
     * @param role
     * @return
     */
    List<SysRole> queryRoleByCondition(SysRole role, Pagination page);

    /**
     * 后台新增角色
     * @param role
     * @param user
     * @return
     */
    String addRole(SysRole role,SysUser user);

    /**
     * 验证角色名称不可重复
     * @param roleName
     * @return false 修改失败,true 修改成功
     */
    boolean queryRoleNameIsExists(String roleName);

    /**
     * 修改活动信息状态为已删除
     *
     * @param roleId 主键
     * @return false 修改失败,true 修改成功
     */
    boolean updateRoleStateStatus(String roleId);

    /**
     * 根据角色id查询角色对象
     * @param roleId 角色id
     * @return 角色对象
     */
    SysRole queryRoleById(String roleId);

    /**
     * 后台更新角色
     * @param role
     * @param user
     * @return
     */
    String editRole(SysRole role,SysUser user);

    /**
     * 得到所有角色
     * @return
     */
    List<SysRole> queryRoleByConditionOrderRoleSort();
}
