package com.sun3d.why.statistics.service;

import com.sun3d.why.model.ActivityStatistics;
import com.sun3d.why.model.StatData;
import com.sun3d.why.model.StatReact;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.PaginationApp;

import java.text.ParseException;
import java.util.List;
import java.util.Map;

public interface ActivityStatisticsService {

    int editByActivityStatistics(ActivityStatistics record);

    abstract int addActivityStatistics(ActivityStatistics record);

    List<ActivityStatistics> queryByMap(Map map);

    List<ActivityStatistics> queryByArea(ActivityStatistics activityStatistics);

    List<ActivityStatistics> queryByBook(ActivityStatistics activityStatistics);

    List<ActivityStatistics> queryByTag(ActivityStatistics activityStatistics);

    List<ActivityStatistics> queryByMessage(ActivityStatistics activityStatistics, Pagination page, PaginationApp pageApp) throws ParseException;
    /**
     * 查询列表页面
     * @param activityId 评论对象
     * @param page 网页分页对象
     * @param  pageApp app分页对象
     * @return 评论集合
     */
    List<ActivityStatistics> queryCommentByActivity(ActivityStatistics activityId, Pagination page, PaginationApp pageApp);
    /**
     * 评论列表条数
     * @param comment 评论对象
     * @return 评论个数
     */
    int queryCommentCountByActivity(ActivityStatistics comment);



    String queryAllAreaInfo(String type);

    ActivityStatistics queryBySid(Integer sid,String area);

    int deleteBySid(Map map);

    Map queryCountInfo(Map map);

    List<StatData> selectStatDataByAdmin(Map map);

    List<StatReact> selectStatReactByAdmin(Map map);
}