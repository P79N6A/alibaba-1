package com.sun3d.why.statistics.service;

import com.sun3d.why.model.CmsUserOrderStatistics;

import java.util.List;
import java.util.Map;

public interface CmsUserOrderStatisticsService {

    /**
     * 文化云平台会员登陆渠道统计
     * @param map
     * @return
     */
    List<CmsUserOrderStatistics> queryTerminalUserOrderStatistics(Map<String, Object> map);

    /**
     * 新增
     * @param userOrderStatistics
     * @return
     */
    int addUserOrderStatistics(CmsUserOrderStatistics userOrderStatistics);

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
