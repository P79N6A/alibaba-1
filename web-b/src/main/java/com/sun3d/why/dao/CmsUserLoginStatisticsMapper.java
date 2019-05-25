package com.sun3d.why.dao;

import com.sun3d.why.model.CmsUserLoginStatistics;

import java.util.List;
import java.util.Map;

public interface CmsUserLoginStatisticsMapper {

    /**
     * 新增数据
     * @param record
     * @return
     */
    int addUserLoginStatistics(CmsUserLoginStatistics record);

    /**
     * 文化云平台会员登陆渠道统计
     * @param map
     * @return
     */
    List<CmsUserLoginStatistics> queryTerminalUserLoginTypeStatistics(Map<String, Object> map);

    /**
     * 删除
     * @return
     */
    int deleteUserLoginStatistics();

    /**
     * 查询
     * @param map
     * @return
     */
    List<CmsUserLoginStatistics> queryUserLoginStatistics(Map<String, Object> map);
}