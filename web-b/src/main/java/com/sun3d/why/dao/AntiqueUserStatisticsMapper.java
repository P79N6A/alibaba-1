package com.sun3d.why.dao;

import com.sun3d.why.model.AntiqueUserStatistics;

import java.util.Date;
import java.util.List;
import java.util.Map;

public interface AntiqueUserStatisticsMapper {

    /**
     * 根据周对藏品表进行统计
     * @param startDate   开始时间
     * @param endDate      结束时间
     * @return
     */
    List<AntiqueUserStatistics> queryAntiqueUserStatisticsByWeekDate(Date startDate, Date endDate);

    /**
     * 查询藏品用户信息数据
     * @param map
     * @return
     */
    int queryAntiqueUserCountByCondition(Map<String, Object> map);

    /**
     * 添加藏品用户信息数据
     * @param antiqueUserStatistics
     */
    int addAntiqueUserStatistics(AntiqueUserStatistics antiqueUserStatistics);

    /**
     * 根据月份对藏品进行统计
     * @param startDate
     * @param endDate
     * @return
     */
    List<AntiqueUserStatistics> queryAntiqueUserStatisticsByMonthDate(Date startDate, Date endDate);

    /**
     * 根据季度 年份对藏品进行统计
     * @param startDate
     * @param endDate
     * @return
     */
    List<AntiqueUserStatistics> queryAntiqueUserStatisticsByQuarterDate(Date startDate, Date endDate);

    /**
     * app取消收藏活动
     * @param antiqueUserStatistics
     * @return
     */
    int deleteAntiqueUser(AntiqueUserStatistics antiqueUserStatistics);
}