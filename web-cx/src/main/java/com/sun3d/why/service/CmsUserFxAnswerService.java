package com.sun3d.why.service;

import com.sun3d.why.model.CmsUserFxAnswer;

public interface CmsUserFxAnswerService {
	
	/**
	 * 保存或更新奉贤问答
	 * @param record
	 * @return
	 */
	String saveOrUpdateFxAnswer(CmsUserFxAnswer record);

	/**
	 * 获取用户信息
	 * @param userId
	 * @return
	 */
	CmsUserFxAnswer queryFxUserInfo(String userId);
	
}
