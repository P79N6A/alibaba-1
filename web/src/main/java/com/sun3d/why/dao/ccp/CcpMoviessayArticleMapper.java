package com.sun3d.why.dao.ccp;

import java.util.List;
import java.util.Map;
import org.apache.ibatis.annotations.Param;
import com.culturecloud.model.bean.moviessay.CcpMoviessayArticle;
import com.culturecloud.model.bean.musicessay.CcpMusicessayArticle;

public interface CcpMoviessayArticleMapper {
	
	int queryMoviessayArticleListCount(Map<String,Object>map);
    
    List<CcpMoviessayArticleDto> queryMoviessayArticleList(Map<String,Object>map);
    
    CcpMoviessayArticleDto queryMoviessayArticleDetail(@Param("loginUser") String loginUser,@Param("articleId") String articleId);

    List<CcpMoviessayArticleDto> queryMoviessayArticleRanking(Map<String,Object>map);

    CcpMoviessayArticleDto myMoviessayArticleBest(String userId);
    
    CcpMoviessayArticle selectByPrimaryKey(String articleId);
    
    int updateByPrimaryKeySelective(CcpMoviessayArticle record);
    
    int insert(CcpMoviessayArticle record);
    
    List<CcpMoviessayArticleDto> queryMoviessayTimes(String userId);
}