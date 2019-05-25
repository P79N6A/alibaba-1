package com.sun3d.why.service.impl;

import com.sun3d.why.dao.CmsActivityEventMapper;
import com.sun3d.why.model.CmsActivityEvent;
import com.sun3d.why.service.CmsActivityEventService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

@Service
@Transactional
public class CmsActivityEventServiceImpl implements CmsActivityEventService{

    @Autowired
    private CmsActivityEventMapper cmsActivityEventMapper;
    /**
     * 查询场次信息
     * @param eventId
     * @return
     */
    public CmsActivityEvent queryByEventId(String eventId) {
        return cmsActivityEventMapper.queryByEventId(eventId);
    }

    /**
     * 删除场次信息
     * @param eventId
     * @return
     */
    public int deleteByEventId(String eventId) {
        return cmsActivityEventMapper.deleteByEventId(eventId);
    }

    /**
     * 增加场次信息
     * @param record
     * @return
     */
    public int addActivityEvent(CmsActivityEvent record) {
        return cmsActivityEventMapper.addActivityEvent(record);
    }


    /**
     * 编辑场次信息
     * @param record
     * @return
     */
    public int editByActivityEvent(CmsActivityEvent record) {
        return cmsActivityEventMapper.editByActivityEvent(record);
    }

    /**
     * 根据活动id 查询该活动的场次信息
     * @param activityId
     * @return
     */
    public List<CmsActivityEvent> queryCmsActivityEventByActivityId(String activityId) {
        return cmsActivityEventMapper.queryCmsActivityEventByActivityId(activityId);
    }

    /**
     * 根据活动id 查询该活动的时间段信息
     * @param activityId
     * @return
     */
    @Override
    public List<CmsActivityEvent> queryEventTimeByActivityId(String activityId) {
        return cmsActivityEventMapper.queryEventTimeByActivityId(activityId);
    }

    /**
     * 根据活动id 查询该活动的日期信息
     * @param activityId
     * @return
     */
    @Override
    public List<CmsActivityEvent> queryEventDateByActivityId(String activityId) {
        return cmsActivityEventMapper.queryEventDateByActivityId(activityId);
    }
    /**
     * 根据活动id 和场次 查询出场次信息
     */
    @Override
    public CmsActivityEvent queryEventByActivityAndTime(String activityId,String eventDateTime) {
        return cmsActivityEventMapper.queryEventByActivityAndTime(activityId,eventDateTime);
    }

    /**
     * 根据活动id 删除已有的场次信息
     * @param activityId
     * @return
     */
    @Override
    public int deleteEventInfoByActivityId(String activityId) {
        return cmsActivityEventMapper.deleteEventInfoByActivityId(activityId);
    }

    /**
     * 根据活动id 查询活动的场次日期段信息 最大的有效时间 和最小的有效时间
     */
    @Override
    public Map queryMinMaxDateByActivityId (String activityId) {
        return cmsActivityEventMapper.queryMinMaxDateByActivityId(activityId);
    }

    /**
     * 根据活动id 和 时间查询可以预定的时间段
     * @param activityId
     * @param eventDate
     * @return
     */
    public List<CmsActivityEvent> queryCanBookEventTime(String activityId,String eventDate) {
        return cmsActivityEventMapper.queryCanBookEventTime(activityId,eventDate);
    }

    /**
     * 根据活动id 查询不能预定的日期
     * @param activityId
     * @return
     */
    public String  queryCanNotBookEventTime(String activityId) {
        return cmsActivityEventMapper.queryCanNotBookEventTime(activityId);
    }

}