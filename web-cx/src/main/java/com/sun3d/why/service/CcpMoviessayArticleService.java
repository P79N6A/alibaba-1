package com.sun3d.why.service;

import java.util.List;

import com.culturecloud.model.bean.moviessay.CcpMoviessayArticle;
import com.sun3d.why.dao.ccp.CcpMoviessayArticleDto;
import com.sun3d.why.util.PaginationApp;

public interface CcpMoviessayArticleService {
	
	
	List<CcpMoviessayArticleDto> queryMoviessayArticle(CcpMoviessayArticle MoviessayArticle,String loginUser,PaginationApp pageApp);
	
	int queryMoviessayArticleCount(CcpMoviessayArticle MoviessayArticle);
	
	int saveMoviessayArticle(CcpMoviessayArticle MoviessayArticle);
	
	int likeMoviessayArticle(String userId,String articleId);
	
	CcpMoviessayArticleDto queryMoviessayArticleDetail(String loginUser,String articleId);
	
	// 真善美排行榜
	List<CcpMoviessayArticleDto> queryMoviessayArticleRanking(String userId);
	
	// 我的最高排行
	CcpMoviessayArticleDto myMoviessayArticleBest(String userId);
	
	//一发布征文次数
	String queryMoviessayTimes(String userId);
}
