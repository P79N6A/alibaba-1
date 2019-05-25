package com.sun3d.why.service;

import com.sun3d.why.model.CmsUserCnAnswer;

public interface CmsUserCnAnswerService {
	
	/**
	 * 保存或更新长宁歌剧问答
	 * @param record
	 * @return
	 */
	String saveOrUpdateCnAnswer(CmsUserCnAnswer record);

	/**
	 * 获取用户统计信息
	 * @param userScore
	 * @param userId
	 * @return
	 */
	CmsUserCnAnswer statisticsCnAnswer(Integer userScore, String userId);
	
	/**
	 * 获取用户信息
	 * @param userId
	 * @return
	 */
	CmsUserCnAnswer queryCnUserInfo(String userId);
	
	/**
	 * 保存虚拟用户数据
	 * @return
	 */
	String saveCnAnswerData(Integer num);
	
}
