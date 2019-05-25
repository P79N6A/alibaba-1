package com.sun3d.why.service;

import com.sun3d.why.model.CmsActivityEvent;

import java.util.List;
import java.util.Map;

public interface CmsActivityEventService {
    /**
     * 查询场次信息
     * @param eventId
     * @return
     */
    CmsActivityEvent queryByEventId(String eventId);

    /**
     * 删除场次信息
     * @param eventId
     * @return
     */
    int deleteByEventId(String eventId);

    /**
     * 增加场次信息
     * @param record
     * @return
     */
    int addActivityEvent(CmsActivityEvent record);


    /**
     * 编辑场次信息
     * @param record
     * @return
     */
    int editByActivityEvent(CmsActivityEvent record);

    /**
     * 根据活动id 查询该活动的场次信息
     * @param activityId
     * @return
     */
    List<CmsActivityEvent> queryCmsActivityEventByActivityId(String activityId);

    /**
     * 根据活动id 查询该活动的时间段信息
     * @param activityId
     * @return
     */
    public List<CmsActivityEvent> queryEventTimeByActivityId(String activityId);

    /**
     * 根据活动id 查询该活动的日期信息
     * @param activityId
     * @return
     */
    public List<CmsActivityEvent> queryEventDateByActivityId(String activityId);

    /**
     * 根据活动id 和场次 查询出场次信息
     */
    public CmsActivityEvent queryEventByActivityAndTime(String activityId,String eventDateTime);

    /**
     * 根据活动id 删除已有的场次信息
     * @param activityId
     * @return
     */
    public int deleteEventInfoByActivityId(String activityId);


    /**
     * 根据活动id 查询活动的场次日期段信息 最大的有效时间 和最小的有效时间
     */
    public Map queryMinMaxDateByActivityId (String activityId);

    /**
     * 根据活动id 和 时间查询可以预定的时间段
     * @param activityId
     * @param eventDate
     * @return
     */
    public List<CmsActivityEvent> queryCanBookEventTime(String activityId,String eventDate);

    /**
     * 根据活动id 查询不能预定的日期
     * @param activityId
     * @return
     */
    public String  queryCanNotBookEventTime(String activityId);
}