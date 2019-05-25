package com.sun3d.why.dao;

import com.sun3d.why.model.ActivityStatistics;

import java.util.List;
import java.util.Map;

public interface ActivityStatisticsMapper {


    int deleteBySid(Map map);

    ActivityStatistics queryBySid(Map map);

    int editByActivityStatistics(ActivityStatistics record);

    int addActivityStatistics(ActivityStatistics record);

    List<ActivityStatistics> queryByMap(Map map);

    List<ActivityStatistics> queryByArea();

    List<ActivityStatistics> queryByBook(Map map);

    List<ActivityStatistics> queryByTag(Map<String, Object> map);

    List<ActivityStatistics> queryByMessage(Map<String, Object> map);
    /**
     * 评论条数
     * @param map
     * @return 评论个数
     */
    int queryMessageCountByActivity(Map<String, Object> map);
    /**
     * 评论列表
     * @param map
     * @return 评论对象集合
     */
    List<ActivityStatistics> queryCommentByActivity(Map<String, Object> map);

    /**
     * 评论列表条数
     * @param map
     * @return 评论个数
     */
    int queryCommentCountByActivity(Map<String, Object> map);

    int queryCommentCount(Map<String, Object> map);

    Map queryCountInfo(Map map);
}