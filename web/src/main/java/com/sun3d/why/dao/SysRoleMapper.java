package com.sun3d.why.dao;

import com.sun3d.why.model.SysRole;

import java.util.List;
import java.util.Map;

public interface SysRoleMapper {

    /**
     * 根据用户id查询角色对象
     * @param userId
     * @return
     */
    List<SysRole> queryRoleByUserId(String userId);

    /**
     * 角色列表
     * @param map
     * @return
     */
    List<SysRole> queryRoleByCondition(Map<String, Object> map);

    /**
     * 角色列表条数
     * @param map
     * @return
     */
    int queryRoleCountByCondition(Map<String, Object> map);

    /**
     * 新增角色保存
     * @param record
     * @return
     */
    int addRole(SysRole record);

    /**
     * 验证角色名称不可重复
     * @param roleName
     * @return 0 不存在 1存在
     */
    int queryRoleNameIsExists(String roleName);

    /**
     * 修改角色信息
     * @param role  角色对象
     * @return 0 失败, 1成功
     */
    int editRole(SysRole role);

    /**
     * 根据角色id查询角色对象
     * @param roleId 角色id
     * @return 角色对象
     */
    SysRole queryRoleById(String roleId);

    /**
     * 得到所有角色
     * @return
     */
    List<SysRole> queryRoleByConditionOrderRoleSort();
}