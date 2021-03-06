package com.sun3d.why.dao.ccp;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.culturecloud.model.bean.musicessay.CcpMusicessayArticle;

public interface CcpMusicessayArticleMapper {
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table ccp_musicessay_article
     *
     * @mbggenerated Tue Apr 25 20:03:06 CST 2017
     */
    int deleteByPrimaryKey(String articleId);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table ccp_musicessay_article
     *
     * @mbggenerated Tue Apr 25 20:03:06 CST 2017
     */
    int insert(CcpMusicessayArticle record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table ccp_musicessay_article
     *
     * @mbggenerated Tue Apr 25 20:03:06 CST 2017
     */
    int insertSelective(CcpMusicessayArticle record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table ccp_musicessay_article
     *
     * @mbggenerated Tue Apr 25 20:03:06 CST 2017
     */
    CcpMusicessayArticle selectByPrimaryKey(String articleId);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table ccp_musicessay_article
     *
     * @mbggenerated Tue Apr 25 20:03:06 CST 2017
     */
    int updateByPrimaryKeySelective(CcpMusicessayArticle record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table ccp_musicessay_article
     *
     * @mbggenerated Tue Apr 25 20:03:06 CST 2017
     */
    int updateByPrimaryKeyWithBLOBs(CcpMusicessayArticle record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table ccp_musicessay_article
     *
     * @mbggenerated Tue Apr 25 20:03:06 CST 2017
     */
    int updateByPrimaryKey(CcpMusicessayArticle record);
    
    int queryMusicessayArticleListCount(Map<String,Object>map);
    
    List<CcpMusicessayArticleDto>queryMusicessayArticleList(Map<String,Object>map);
    
    CcpMusicessayArticleDto queryMusicessayArticleDetail(@Param("loginUser") String loginUser,@Param("articleId") String articleId);

    List<CcpMusicessayArticleDto> queryMusicessayArticleRanking(Map<String,Object>map);

    CcpMusicessayArticleDto myMusicessayArticleBest(String userId);
}