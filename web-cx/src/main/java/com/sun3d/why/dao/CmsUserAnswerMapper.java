package com.sun3d.why.dao;

import java.util.List;
import java.util.Map;

import com.sun3d.why.model.CmsUserAnswer;

public interface CmsUserAnswerMapper {
    int deleteByPrimaryKey(String userId);

    int insert(CmsUserAnswer record);

    CmsUserAnswer selectByPrimaryKey(String userId);
    
    CmsUserAnswer selectByCondition(CmsUserAnswer record);

    int update(CmsUserAnswer record);
    
    CmsUserAnswer statisticsAnswer(CmsUserAnswer record);

	int queryUserList(Map<String, Object> map);

	List<CmsUserAnswer> queryUserMessage(Map<String, Object> map);

}