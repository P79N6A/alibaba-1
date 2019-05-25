package com.sun3d.why.dao;

import com.sun3d.why.model.SysUser;
import com.sun3d.why.model.extmodel.AreaData;

import java.util.List;
import java.util.Map;

public interface SysUserMapper {

    /**
     * 根据主键删除用户
     * @param userId
     * @return
     */
    int deleteSysUserByUserId(String userId);


    int addSysUser(SysUser record);


    SysUser querySysUserByUserId(String userId);


    int editBySysUser(SysUser record);

    List<SysUser> querySysUserByCondition(SysUser sysUser);

    List<SysUser> querySysUserByMap(Map<String, Object> map);

    int queryUserCountByCondition(Map<String, Object> map);

    public List<SysUser> querySysUserIndex(Map<String, Object> map);

    public Integer querySysUserIndexCount(Map<String, Object> map);

    public List<SysUser> queryNotAssignedUsers(Map<String, Object> map);

    /**
     * 验证系统根据用户账号与密码查询后台用户信息
     * @param map
     */
    SysUser queryAppSysUserById(Map<String, Object> map);
    
    /**
	 * 查询管理员所有的区域信息
	 */
    List<SysUser> queryUserAllArea(Map<String, Object> map);

    /**
     * @根据用户名查找用户信息
     * @para userAccount
     * @return SysUser
     * @authour  hucheng
     * @content add
     * @date  2016/1/20
     * */
     SysUser querySysUserByUserAccount(String userAccount);

}