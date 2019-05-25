package com.sun3d.why.service;

import com.sun3d.why.model.CmsActivity;
import com.sun3d.why.model.CmsActivityEvent;
import com.sun3d.why.model.CmsActivitySeat;
import com.sun3d.why.model.SysUser;

import java.util.Date;
import java.util.List;
import java.util.Map;

public interface CmsActivitySeatService {


    int addActivitySeat(CmsActivitySeat record);

    int deleteByActivityId(String activityId);

    int deleteByEventId(String eventId);

    int editByActivitySeat(CmsActivitySeat record);

    List<CmsActivitySeat> queryCmsActivitySeatCondition(Map map);

    Map<String,CmsActivitySeat> getCmsActivitySeatInfo(String activityId, String[] seatIds);


    /**
     * 后台发布活动保存座位信息
     * @param activityId
     * @param seatIds
     * @param totalTicket
     * @param loginUser
     * @param endTime
     * @param cmsActivity
     * @param eventInfo
     * @return
     * @throws Exception
     */
    int addActivitySeatInfo(String activityId,String seatIds,Integer totalTicket,SysUser loginUser,Date endTime,CmsActivity cmsActivity,List<String> eventInfo) throws Exception;

    /**
     * 后台发布活动保存座位信息
     * @param event
     * @param
     * @return
     * @throws Exception
     */
    int addEventSeatInfo(CmsActivityEvent event,SysUser loginUser) throws Exception;

    /**
     * 前台用户发布可预定活动
     * @param activityId
     * @param totalTicket
     * @param endTime
     * @param cmsActivity
     * @param eventInfo
     * @return
     * @throws Exception
     */
    int addActivitySeatInfoByFrontUser(String activityId, Integer totalTicket, Date endTime, CmsActivity cmsActivity, List<String> eventInfo) throws Exception;

    int queryCountByActivityId(String activityId);

    /**
     * 根据活动id  和 seatCode  查询seatVal;
     * @param map
     * @return
     */
    CmsActivitySeat querySeatValByMap(Map map);

}