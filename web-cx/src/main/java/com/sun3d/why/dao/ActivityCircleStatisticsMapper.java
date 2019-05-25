package com.sun3d.why.dao;

import com.sun3d.why.model.ActivityCircleStatistics;

import java.util.List;
import java.util.Map;

public interface ActivityCircleStatisticsMapper {

    int deleteInfo();

    int updateByExampleSelective(ActivityCircleStatistics record);

    int insertSelective(ActivityCircleStatistics record);

    public List<ActivityCircleStatistics> queryByMap(Map map);

    public List<Map> queryByAll(Map map);

}