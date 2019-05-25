package com.sun3d.why.statistics.service.impl;

import com.sun3d.why.dao.CmsUserLoginStatisticsMapper;
import com.sun3d.why.model.CmsUserLoginStatistics;
import com.sun3d.why.statistics.service.CmsUserLoginStatisticsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

@Service
@Transactional
public class CmsUserLoginStatisticsServiceImpl implements CmsUserLoginStatisticsService {
    @Autowired
    private CmsUserLoginStatisticsMapper userLoginStatisticsMapper;

    /**
     * 文化云平台会员登陆渠道统计
     * @param map
     * @return
     */
    @Override
    public List<CmsUserLoginStatistics> queryTerminalUserLoginTypeStatistics(Map<String, Object> map) {
        return userLoginStatisticsMapper.queryTerminalUserLoginTypeStatistics(map);
    }

    /**
     * 删除
     * @return
     */
    @Override
    public int deleteUserLoginStatistics() {
        return userLoginStatisticsMapper.deleteUserLoginStatistics();
    }

    /**
     * 新增
     * @param userLoginStatistics
     * @return
     */
    @Override
    public int addUserLoginStatistics(CmsUserLoginStatistics userLoginStatistics) {
        return userLoginStatisticsMapper.addUserLoginStatistics(userLoginStatistics);
    }

    /**
     * 查询
     * @param map
     * @return
     */
    @Override
    public List<CmsUserLoginStatistics> queryUserLoginStatistics(Map<String, Object> map){
        return userLoginStatisticsMapper.queryUserLoginStatistics(map);
    }
}
