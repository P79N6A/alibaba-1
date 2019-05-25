package com.sun3d.why.dao;

import com.sun3d.why.model.CmsActivityPublisher;

public interface CmsActivityPublisherMapper {
    int insert(CmsActivityPublisher record);

    int update(CmsActivityPublisher record);
    
    CmsActivityPublisher queryActivityPublisherByActivityId(String activityId);
    
    CmsActivityPublisher queryActivityPublisherById(String activityId);
}