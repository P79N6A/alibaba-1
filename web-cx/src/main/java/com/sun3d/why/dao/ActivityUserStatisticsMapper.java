package com.sun3d.why.dao;

import com.sun3d.why.model.ActivityUserStatistics;

import java.util.List;
import java.util.Map;

public interface ActivityUserStatisticsMapper {

    /**
     * 添加活动用户统计
     * @param record  活动用户对象
     */
    int addActivityUserStatistics(ActivityUserStatistics record);

    /**
     * 根据周对活动用户表进行统计
     * @param startDate 开始时间
     * @param endDate    结束时间
     * @return 活动统计信息
     */
    List<ActivityUserStatistics> queryActivityUserStatisticsByWeekDate(String startDate, String endDate);

    /**
     * 判断活动用户表是否存在着数据
     * @param map
     * @return
     */
    int queryActivityUserCountByCondition(Map<String, Object> map);

    /**
     * 根据月份进行统计
     * @param startDate 开始时间
     * @param endDate    结束时间
     * @return
     */
    List<ActivityUserStatistics> queryActivityUserStatisticsByMonthDate(String startDate, String endDate);
    /**
     * 根据年.季度进行统计
     * @param startDate 开始时间
     * @param endDate    结束时间
     * @return
     */
    List<ActivityUserStatistics> queryActivityUserStatisticsByQuarterDate(String startDate, String endDate);

    /**
     * app取消收藏活动
     * @param activityUserStatistics
     * @return
     */
    int deleteActivityUser(ActivityUserStatistics activityUserStatistics);
}