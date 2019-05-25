package com.culturecloud.service.local.common;

import com.culturecloud.model.bean.common.SysUserIntegral;

public interface SysUserIntegralService {

	
	/**
	 * 插入用户积分
	 * 
	 * @param userId 用户id
	 * @param integralChange 增加减少积分数
	 * @param changeType 积分变化类型 0:增加、1:扣除
	 * @param integralFrom 积分日志
	 * @param integralType 积分类型
	 * @return
	 */
	int insertUserIntegral(String userId,Integer integralChange,Integer changeType,String integralFrom,Integer integralType);

	/**
	 * 获取用户积分对象
	 * 
	 * @param userId
	 * @return
	 */
	SysUserIntegral getUserIntegralByUserId(String userId);
	
	int checkDayIntegral(String userId);

}
