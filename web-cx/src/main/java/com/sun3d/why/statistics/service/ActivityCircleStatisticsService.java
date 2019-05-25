package com.sun3d.why.statistics.service;

import com.sun3d.why.model.ActivityCircleStatistics;
import com.sun3d.why.model.SysUser;

import java.util.List;
import java.util.Map;

public interface ActivityCircleStatisticsService {


    int insertSelective(ActivityCircleStatistics record);

    int deleteInfo();

    List<ActivityCircleStatistics> queryByMap(Map map,SysUser loginUser);

    Map queryAreaLabelInfo(Map map, SysUser loginUser);


}