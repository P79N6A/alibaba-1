package com.sun3d.why.dao;

import com.sun3d.why.model.CmsUserStatistics;

import java.util.List;
import java.util.Map;

public interface CmsUserStatisticsMapper {
    /**
     * 新增数据
     * @param record
     * @return
     */
    int addUserStatistics(CmsUserStatistics record);

    /**
     * 根据类型删除
     * @param sType
     * @return
     */
    int deleteUserStatistics(Integer sType);

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