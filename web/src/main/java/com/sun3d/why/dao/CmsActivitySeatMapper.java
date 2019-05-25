package com.sun3d.why.dao;

import com.sun3d.why.model.CmsActivitySeat;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

public interface CmsActivitySeatMapper {


    int addActivitySeat(CmsActivitySeat record);

    int editByActivitySeat(CmsActivitySeat record);

    List<CmsActivitySeat> queryCmsActivitySeatCondition(Map map);

    List<CmsActivitySeat> selectSeatList(Map map);

    int selectSeatCount(Map map);


    int editActivitySeatByCode(@Param("record")CmsActivitySeat record,@Param("map")Map map);

    int queryCountByActivityId(String activityId);

    int deleteByActivityId(String activityId);

    int deleteByEventId(String eventId);
    /**
     * 根据活动id  和 seatCode  查询seatVal;
     * @param map
     * @return
     */
    CmsActivitySeat querySeatValByMap(Map map);

    int addActivitySeatList(List<CmsActivitySeat> seatlist);

    int editEventSeat(Map map);
}