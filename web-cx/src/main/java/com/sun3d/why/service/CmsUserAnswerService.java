package com.sun3d.why.service;

import com.sun3d.why.model.CmsUserAnswer;

public interface CmsUserAnswerService {
	
	/**
	 * 保存或更新问答
	 * @param record
	 * @return
	 */
	String saveOrUpdateAnswer(CmsUserAnswer record);

	/**
	 * 获取用户统计信息
	 * @param userScore
	 * @param userId
	 * @return
	 */
	CmsUserAnswer statisticsAnswer(CmsUserAnswer record);
	
	/**
	 * 获取用户信息
	 * @param userId
	 * @return
	 */
	CmsUserAnswer queryUserInfo(CmsUserAnswer record);
	
	/**
	 * 保存虚拟用户数据
	 * @return
	 */
	String saveAnswerData(Integer num,String type);
	
}
