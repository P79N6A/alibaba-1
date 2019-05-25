package com.sun3d.why.dao;

import java.util.List;
import java.util.Map;

import com.culturecloud.model.bean.culture.CcpCultureContestQuestion;

public interface CcpCultureContestQuestionMapper {
    
    int deleteByPrimaryKey(Integer cultureQuestionId);

   
    int insert(CcpCultureContestQuestion question);

    
    int insertSelective(CcpCultureContestQuestion record);

  
    int queryQuestionCountByCondition(Map<String,Object> map);
    
    int updateByPrimaryKey(CcpCultureContestQuestion record);
    
    List<CcpCultureContestQuestion> queryQuestionByCondition(Map<String,Object> map);

    
    List<CcpCultureContestQuestion> queryQuestionById(Integer cultureQuestionId);
    
    
    int updateByPrimaryKeySelective(CcpCultureContestQuestion record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table ccp_culture_contest_question
     *
     * @mbggenerated Wed May 17 16:23:35 CST 2017
     */
    
}