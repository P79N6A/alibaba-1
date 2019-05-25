package com.sun3d.why.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.sun3d.why.model.SysUserRole;

public interface SysUserRoleMapper {
	/**
	 * 根据userId删除
	 * 
	 * @param userId
	 * @return
	 */
	int deleteUserRoleByUserId(String userId);

	/**
	 * 新增
	 * 
	 * @param userRole
	 * @return
	 */
	int addUserRole(SysUserRole userRole);

	List<SysUserRole> selectUserRoleByUserIdAndRoleName(@Param(value = "roleName") String roleName,
			@Param(value = "userId") String userId);
}