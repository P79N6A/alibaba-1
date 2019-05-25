package com.sun3d.why.statistics.service.impl;

import com.sun3d.why.dao.CmsUserStatisticsMapper;
import com.sun3d.why.model.CmsUserStatistics;
import com.sun3d.why.statistics.service.CmsUserStatisticsService;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

@Service
@Transactional
public class CmsUserStatisticsServiceImpl implements CmsUserStatisticsService {
    @Autowired
    private CmsUserStatisticsMapper userStatisticsMapper;

    private Logger logger = Logger.getLogger(CmsUserStatisticsServiceImpl.class);

    /**
     * 根据类型删除
     * @param sType
     * @return
     */
    @Override
    public int deleteUserStatistics(Integer sType) {
        return userStatisticsMapper.deleteUserStatistics(sType);
    }

    /**
     * 新增数据
     * @param userStatistics
     * @return
     */
    @Override
    public int addUserStatistics(CmsUserStatistics userStatistics) {
        return  userStatisticsMapper.addUserStatistics(userStatistics);
    }

    /**
     * 截至昨日数据统计
     * @param map
     * @return
     */
    @Override
    public int queryTerminalUserStatistics(Map<String, Object> map){
        return userStatisticsMapper.queryTerminalUserStatistics(map);
    }

    /**
     * 文化云平台会员年龄统计
     * @param map
     * @return
     */
    @Override
    public List<CmsUserStatistics> queryTerminalUserAgeStatistics(Map<String, Object> map) {
        return userStatisticsMapper.queryTerminalUserAgeStatistics(map);
    }

    /**
     * 文化云平台会员性别统计
     * @param map
     */
    @Override
    public List<CmsUserStatistics> queryTerminalUserSexStatistics(Map<String, Object> map) {
        return userStatisticsMapper.queryTerminalUserSexStatistics(map);
    }

    /**
     * 查询
     * @param map
     * @return
     */
    @Override
    public List<CmsUserStatistics> queryUserStatistics(Map<String, Object> map){
        return userStatisticsMapper.queryUserStatistics(map);
    }
}
