package com.sun3d.why.service;

import com.sun3d.why.model.StatisticsSearchParamter;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

/**
 * Created by ct on 2017/4/24.
 */
public interface StatisticsService
{
    public List<Map<String,String>> getVenueListBySearchKey(Map param);
    public List<Map<String,String>> getActivityStatic(StatisticsSearchParamter sp);
    public List<Map<String,String>> getVenueStatic(StatisticsSearchParamter sp);
    public List<Map<String,String>> getUserStatic(StatisticsSearchParamter sp);
    public List<Map<String,String>> getBrowseStatic(StatisticsSearchParamter sp);

    public void generateVenueStatistics();
    public void generateActivityStatistics();
}
