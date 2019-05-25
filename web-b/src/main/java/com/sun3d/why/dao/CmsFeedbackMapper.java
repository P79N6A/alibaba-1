package com.sun3d.why.dao;

import com.sun3d.why.model.CmsFeedback;

import java.util.List;
import java.util.Map;

public interface CmsFeedbackMapper {

    int insertFeedInformation(CmsFeedback cmsFeedback);
  
    int queryFeedInformationByCount(Map<String, Object> map);

    List<CmsFeedback> queryFeedInformationByContent(Map<String, Object> map);

    /**
     * app获取用户反馈列表
     * @param map
     * @return
     */
    List<CmsFeedback> queryAppFeedInformationListById(Map<String, Object> map);
}