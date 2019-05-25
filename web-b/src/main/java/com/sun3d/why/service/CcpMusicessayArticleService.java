package com.sun3d.why.service;

import java.util.List;
import java.util.Map;

import com.culturecloud.model.bean.musicessay.CcpMusicessayArticle;
import com.sun3d.why.model.ccp.CcpMoviessayArticleDto;
import com.sun3d.why.model.ccp.CcpMusicessayArticleDto;
import com.sun3d.why.util.Pagination;

public interface CcpMusicessayArticleService {

	List<CcpMusicessayArticleDto> queryMusicessayArticle(CcpMoviessayArticleDto ccpMusicessayArticle, Pagination page);

	Map<String, Object> deletedMusicessayArticle(String articleId);

	CcpMusicessayArticle queryMusicessayArticleById(String articleId);

	CcpMusicessayArticle checkMessage(String articleId);

	Map<String, Object> updateVote(String articleId, Integer articleLike);

}
