package com.sun3d.why.dao.ccp;

import java.util.List;
import java.util.Map;
import com.culturecloud.model.bean.moviessay.CcpMoviessayArticle;
import com.sun3d.why.model.ccp.CcpMoviessayArticleDto;

public interface CcpMoviessayArticleMapper {
  
	//查询记录数
	int queryMovieArticleCount(Map<String, Object> map);
	
	
	
	//查询所有的记录
	List<CcpMoviessayArticleDto> queryMoviessayArticleByList(Map<String, Object> map);
	
	
	
	//查询实体
	CcpMoviessayArticleDto selectByPrimaryKey(String articleId);
	
	
	
	//更新信息（是否合格）
	int updateByPrimaryKeySelective(CcpMoviessayArticle record);
	
	
	
	//删除操作（假删除）
    int deleteByPrimaryKey(String articleId);

    
    
    //详情
    CcpMoviessayArticleDto checkMessage(String articleId);
    
    
    
    
    
    
    
    int insert(CcpMoviessayArticle record);

  
    int insertSelective(CcpMoviessayArticle record);

   
    

   
    

   
    int updateByPrimaryKeyWithBLOBs(CcpMoviessayArticle record);

    
    int updateByPrimaryKey(CcpMoviessayArticle record);

	
	
	
	

	
}