package com.sun3d.why.dao;

import com.sun3d.why.model.StatisticsSearchParamter;

import java.util.List;
import java.util.Map;

/**
 * Created by ct on 2017/4/24.
 */
public interface StatisticsMapper
{
    public List<Map<String,String>> getVenueListBySearchKey(Map param);
    public List<Map<String,String>> getActivityStatic(StatisticsSearchParamter sp);
    public List<Map<String,String>> getVenueStatic(StatisticsSearchParamter sp);
    public List<Map<String,String>> getUserStatic(StatisticsSearchParamter sp);
    public List<Map<String,String>> getBrowseStatic(StatisticsSearchParamter sp);

    public void generateVenueStatistics();
    public void generateActivityStatistics();

}
