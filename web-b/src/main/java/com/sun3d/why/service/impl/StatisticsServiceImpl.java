package com.sun3d.why.service.impl;

import com.sun3d.why.dao.StatisticsMapper;
import com.sun3d.why.model.StatisticsSearchParamter;
import com.sun3d.why.service.StatisticsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

/**
 * Created by ct on 2017/4/24.
 */
@Service("NewStatisticsService")
public class StatisticsServiceImpl implements StatisticsService
{
    @Autowired
    private StatisticsMapper mapper;

    @Override
    public List<Map<String, String>> getVenueListBySearchKey(Map param)
    {
        return mapper.getVenueListBySearchKey(param);
    }

    @Override
    public List<Map<String, String>> getActivityStatic(StatisticsSearchParamter sp)
    {
        return mapper.getActivityStatic(sp);
    }

    @Override
    public List<Map<String, String>> getVenueStatic(StatisticsSearchParamter sp)
    {
        return mapper.getVenueStatic(sp);
    }

    @Override
    public List<Map<String, String>> getUserStatic(StatisticsSearchParamter sp)
    {
        return mapper.getUserStatic(sp);
    }

    @Override
    public List<Map<String, String>> getBrowseStatic(StatisticsSearchParamter sp)
    {
        return mapper.getBrowseStatic(sp);
    }

    @Override
    public void generateVenueStatistics()
    {
        mapper.generateVenueStatistics();
    }

    @Override
    public void generateActivityStatistics()
    {
        mapper.generateActivityStatistics();
    }
}
