package com.sun3d.why.dao;

import com.sun3d.why.model.CmsUserOrderStatistics;

import java.util.List;
import java.util.Map;

public interface CmsUserOrderStatisticsMapper {

    /**
     * 新增数据
     * @param record
     * @return
     */
    int addUserOrderStatistics(CmsUserOrderStatistics record);

    /**
     *文化云平台会员每周平均订票率统计
     * @param map
     * @return
     */
    List<CmsUserOrderStatistics> queryTerminalUserOrderStatistics(Map<String, Object> map);

    /**
     * 删除
     * @return
     */
    int deleteUserOrderStatistics();

    /**
     * 查询
     * @param map
     * @return
     */
    List<CmsUserOrderStatistics> queryUserOrderStatistics(Map<String, Object> map);
}