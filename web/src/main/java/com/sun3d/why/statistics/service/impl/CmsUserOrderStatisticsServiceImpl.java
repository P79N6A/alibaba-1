package com.sun3d.why.statistics.service.impl;

import com.sun3d.why.dao.CmsUserOrderStatisticsMapper;
import com.sun3d.why.model.CmsUserOrderStatistics;
import com.sun3d.why.statistics.service.CmsUserOrderStatisticsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

@Service
@Transactional
public class CmsUserOrderStatisticsServiceImpl implements CmsUserOrderStatisticsService {
    @Autowired
    private CmsUserOrderStatisticsMapper userOrderStatisticsMapper;

    /**
     * 文化云平台会员登陆渠道统计
     * @param map
     * @return
     */
    @Override
    public List<CmsUserOrderStatistics> queryTerminalUserOrderStatistics(Map<String, Object> map) {
        return userOrderStatisticsMapper.queryTerminalUserOrderStatistics(map);
    }

    /**
     * 新增
     * @param userOrderStatistics
     * @return
     */
    @Override
    public int addUserOrderStatistics(CmsUserOrderStatistics userOrderStatistics) {
        return userOrderStatisticsMapper.addUserOrderStatistics(userOrderStatistics);
    }

    /**
     * 删除
     * @return
     */
    @Override
    public int deleteUserOrderStatistics() {
        return userOrderStatisticsMapper.deleteUserOrderStatistics();
    }

    /**
     * 查询
     * @param map
     * @return
     */
    @Override
    public List<CmsUserOrderStatistics> queryUserOrderStatistics(Map<String, Object> map){
        return userOrderStatisticsMapper.queryUserOrderStatistics(map);
    }
}
