package com.sun3d.why.service;

import java.util.Map;

import com.sun3d.why.model.CmsUserMovieAnswer;

public interface CmsUserMovieAnswerService {
	
	/**
	 * 保存或更新电影节问答
	 * @param record
	 * @return
	 */
	String saveOrUpdateMovieAnswer(CmsUserMovieAnswer record);

	/**
	 * 获取用户统计信息
	 * @param userScore
	 * @param userId
	 * @return
	 */
	CmsUserMovieAnswer statisticsMovieAnswer(Integer userScore, String userId);
	
	/**
	 * 获取用户信息
	 * @param userId
	 * @return
	 */
	CmsUserMovieAnswer queryMovieUserInfo(String userId);
	
	/**
	 * 电影节问答保存虚拟用户数据
	 * @return
	 */
	String saveMovieAnswerData();

}
