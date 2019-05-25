package com.culturecloud.service.local.common;




public interface SysUserIntegralDetailService {

	
	/**
	 * 未核销
	 * 
	 * @param userId
	 * @param activityId
	 * @return
	 */
	int timeOutNotVerificationAddIntegral(String userId,String userName,String activityId,Integer deductionCredit,String orderId,String orderNumer);
	
	/**
	 * 每周登录奖励
	 * 
	 * @param userId
	 * @return
	 */
	int weekOpenAddIntegral(String userId,String date);
	
	

}
