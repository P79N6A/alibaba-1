package com.sun3d.why.dao;

import com.sun3d.why.model.VenueStatistics;

import java.util.List;
import java.util.Map;

public interface VenueStatisticsMapper {


    int deleteBySid(Map map);

    VenueStatistics queryBySid(Map map);


    int addActivityStatistics(VenueStatistics record);


    List<VenueStatistics> queryByArea();

    List<VenueStatistics> queryByAreaRoom(Map<String, Object> map);

    List<VenueStatistics> queryByTag(Map<String, Object> map);

    List<VenueStatistics> queryByTagRoom(Map<String, Object> map);

    List<VenueStatistics> queryByMessage(Map<String, Object> map);

    /**
     * 评论列表
     * @param map
     * @return 评论对象集合
     */
    List<VenueStatistics> queryCommentByVenue(Map<String, Object> map);

    /**
     * 评论列表条数
     * @param map
     * @return 评论个数
     */
    int queryCommentCountByVenue(Map<String, Object> map);
    Map queryCountInfo(Map map);

    Integer queryByMessageCount(Map<String, Object> map);

    int queryCommentCount(Map<String, Object> map);
}