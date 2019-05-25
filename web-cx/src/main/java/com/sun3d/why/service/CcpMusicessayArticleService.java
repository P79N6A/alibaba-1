package com.sun3d.why.service;

import java.util.List;

import com.culturecloud.model.bean.musicessay.CcpMusicessayArticle;
import com.sun3d.why.dao.ccp.CcpMusicessayArticleDto;
import com.sun3d.why.util.PaginationApp;

public interface CcpMusicessayArticleService {

	/**
	 * 列表
	 * 
	 * @param musicessayArticle
	 * @param createUser
	 * @param rows
	 * @param firstResult
	 * @return
	 */
	List<CcpMusicessayArticleDto> queryMusicessayArticle(CcpMusicessayArticle musicessayArticle,String loginUser,PaginationApp pageApp);
	
	int queryMusicessayArticleCount(CcpMusicessayArticle musicessayArticle);
	
	/**
	 * 保存
	 * @param musicessayArticle
	 * @return
	 */
	int saveMusicessayArticle(CcpMusicessayArticle musicessayArticle);
	
	int likeMusicessayArticle(String userId,String articleId);
	
	CcpMusicessayArticleDto queryMusicessayArticleDetail(String loginUser,String articleId);
	
	// 真善美排行榜
	List<CcpMusicessayArticleDto> queryMusicessayArticleRanking(String userId);
	
	// 我的最高排行
	CcpMusicessayArticleDto myMusicessayArticleBest(String userId);
}
