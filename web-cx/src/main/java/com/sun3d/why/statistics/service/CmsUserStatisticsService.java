package com.sun3d.why.statistics.service;

import com.sun3d.why.model.CmsUserStatistics;

import java.util.List;
import java.util.Map;

public interface CmsUserStatisticsService {

    /**
     * 根据类型删除
     * @param sType
     * @return
     */
    int deleteUserStatistics(Integer sType);

    /**
     * 新增数据
     * @param userStatistics
     * @return
     */
    int addUserStatistics(CmsUserStatistics userStatistics);

    /**
     * 截至昨日数据统计
     * @param map
     * @return
     */
    int queryTerminalUserStatistics(Map<String, Object> map);

    /**
     * 文化云平台会员年龄统计
     * @param map
     * @return
     */
    List<CmsUserStatistics> queryTerminalUserAgeStatistics(Map<String, Object> map);

    /**
     * 文化云平台会员性别统计
     * @param map
     */
    List<CmsUserStatistics> queryTerminalUserSexStatistics(Map<String, Object> map);

    /**
     * 查询
     * @param map
     * @return
     */
    List<CmsUserStatistics> queryUserStatistics(Map<String, Object> map);
}
