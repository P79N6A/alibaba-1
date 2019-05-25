package com.sun3d.why.dao;

import com.sun3d.why.model.CmsActivityVenueRelevance;

import java.util.List;


public interface CmsActivityVenueRelevanceMapper {

    /**
     * 根据活动id删除活动场馆的关联关系
     *
     * @param activityId 活动主键id
     * @return 0 失败 1 成功
     */
    int deleteActivityVenueRelevance(String activityId);

    /**
     * 添加活动场馆的关联关系
     *
     * @param record 活动场馆关联关系对象
     * @return 0 失败 1 成功
     */
    int addActivityVenueRelevance(CmsActivityVenueRelevance record);

    List<CmsActivityVenueRelevance> queryActivityVenueRelevanceByActivityId(String activityId);


}