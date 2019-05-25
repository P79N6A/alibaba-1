package com.sun3d.why.service;

import com.sun3d.why.model.CmsActivityPublisher;

import java.util.Map;

public interface CmsActivityPublisherService {

    /**
     * 新增/编辑信息
     * @param vo
     * @return
     */
	Map<String, Object> saveOrUpdateActivityPublisher(CmsActivityPublisher vo);

    /**
     * 根据活动id查询活动模板信息
     *  @param activityId 主键id
     * @return
     */
    CmsActivityPublisher queryActivityPublisherByActivityId(String activityId);

}

