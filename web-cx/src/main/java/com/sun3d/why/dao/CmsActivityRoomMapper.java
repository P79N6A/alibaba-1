package com.sun3d.why.dao;

import com.sun3d.why.model.CmsActivityRoom;

import java.util.List;
import java.util.Map;

public interface CmsActivityRoomMapper {

    CmsActivityRoom queryCmsActivityRoomById(String roomId);

    int addCmsActivityRoom(CmsActivityRoom record);

    int editCmsActivityRoom(CmsActivityRoom record);
    
    int deleteRecycleActivityRoom(String id);

    List<CmsActivityRoom> queryCmsActivityRoomByCondition(Map<String,Object> map);

    int queryCmsActivityRoomCountByCondition(Map<String,Object> map);

    /**
     * 带条件查询符合的统计数据[平台内容统计--活动室统计]
     * @param cmsActivityRoom
     * @return
     */
    List<CmsActivityRoom> queryRoomStatistic(CmsActivityRoom cmsActivityRoom);

    /**
     * app根据展馆id获取相关活动室信息
     * @param map
     * @return
     */
    List<CmsActivityRoom> queryAppActivityRoomById(Map<String, Object> map);

    /**
     * why3.5 app根据展馆id获取相关活动室个数
     * @param map
     * @return
     */
    int queryAppActivityRoomCountById(Map<String, Object> map);

    /**
     * appg根据活动室id获取活动室详情
     * @param roomId 活动室id
     * @return
     */
     CmsActivityRoom queryAppActivityRoomByRoomId(String roomId);

    /**
     * 查询场馆是可用活动室个数
     * @param roomVenueId
     * @return
     */
     List<CmsActivityRoom> queryActivityRoomCount(String roomVenueId);

    /**
     * 前端页面显示关联的活动室
     * @param map
     * @return
     */
    public List<CmsActivityRoom> queryRelatedRoom(Map<String,Object> map);

    /**
     * 前端页面显示关联的活动室总数
     * @param map
     * @return
     */
    public int queryRelatedRoomCount(Map<String,Object> map);
    
    /**
     * 查询所有符合条件 可预定的活动室
     * 
     * @param map
     * @return
     */
    public List<CmsActivityRoom> queryAllAppActivityRoomList(Map<String,Object> map);
    
    public int queryAllAppActivityRoomListCount(Map<String,Object> map);
    
    public String queryAllAppActivityRoomTagNames(String roomId);
}