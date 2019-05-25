package com.sun3d.why.service;

import java.util.List;
import java.util.Map;

import com.culturecloud.model.bean.moviessay.CcpMoviessayArticle;
import com.sun3d.why.model.ccp.CcpMoviessayArticleDto;
import com.sun3d.why.util.Pagination;

public interface CcpMoviessayArticleService {

	List<CcpMoviessayArticleDto> queryMoviessayArticle(CcpMoviessayArticleDto ccpMoviessayArticle, Pagination page);

	Map<String, Object> deletedMoviessayArticle(String articleId);

	CcpMoviessayArticleDto queryMoviessayArticleById(String articleId);

	CcpMoviessayArticleDto checkMessage(String articleId);

	Map<String, Object> updateVote(String articleId, Integer articleLike);

}
