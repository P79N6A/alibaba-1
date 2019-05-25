package com.culturecloud.service.local.common;

import com.culturecloud.model.request.common.SysUserIntegralReqVO;

public interface SysUserIntegralDetailService {

	/**
	 * 每周登录奖励
	 * @param lastWeedEndDate
	 * @param userId
	 * @return
	 */
	int weekOpenAddIntegral(SysUserIntegralReqVO vo);

}
