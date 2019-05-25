package com.sun3d.why.dao;

import com.sun3d.why.model.StatisticsFlowWeb;

public interface StatisticsFlowWebMapper {
    int deleteByPrimaryKey(String id);

    int insert(StatisticsFlowWeb record);

    StatisticsFlowWeb selectByPrimaryKey(String id);

    int update(StatisticsFlowWeb record);

    StatisticsFlowWeb queryStatisticsFlowWebByDate(String date);
}