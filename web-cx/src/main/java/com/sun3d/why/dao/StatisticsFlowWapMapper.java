package com.sun3d.why.dao;

import com.sun3d.why.model.StatisticsFlowWap;

public interface StatisticsFlowWapMapper {
    int deleteByPrimaryKey(String id);

    int insert(StatisticsFlowWap record);

    StatisticsFlowWap selectByPrimaryKey(String id);

    int update(StatisticsFlowWap record);
    
    StatisticsFlowWap queryStatisticsFlowWapByDate(String date);

}