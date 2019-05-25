package com.sun3d.why.service;

import com.sun3d.why.model.UserIntegral;

public interface UserIntegralService {

	/** 根据主键删除用户积分*/
	int deleteUserIntegralById(String integralId);
	/** 添加用户积分*/
	int addUserIntegral(UserIntegral record);
	/** 根据主键获取用户积分*/
	UserIntegral selectUserIntegralById(String integralId);
	/** 更新用户积分*/
	int updateUserIntegral(UserIntegral record);
	/** 根据用户id获取用户积分相关数据*/
	UserIntegral selectUserIntegralByUserId(String userId);
}
