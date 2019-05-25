package com.culturecloud.service.local.common;

import com.culturecloud.model.bean.common.SysUserIntegral;

public interface SysUserIntegralService {


	/**
	 * 获取用户积分对象
	 * 
	 * @param userId
	 * @return
	 */
	SysUserIntegral getUserIntegralByUserId(String userId);

}
