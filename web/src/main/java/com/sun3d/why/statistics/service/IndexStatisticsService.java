package com.sun3d.why.statistics.service;

import com.sun3d.why.model.IndexStatistics;
import com.sun3d.why.model.SysUser;

import java.util.List;
import java.util.Map;

public interface IndexStatisticsService {
//    int countByExample(IndexStatisticsExample example);
//
//    int deleteByExample(IndexStatisticsExample example);

    List<IndexStatistics> queryByMap(Map map);

    int addIndexStatistics(IndexStatistics record);

    int deleteInfo();

//    List<IndexStatistics> selectByExample(IndexStatisticsExample example);

//    int updateByExampleSelective(@Param("record") IndexStatistics record);

    List<IndexStatistics> queryInfoByInfo(Map map, SysUser sysUser,String area) ;

//    int updateByExample(@Param("record") IndexStatistics record);
//
//    List<IndexStatistics> queryByArea(Map map);
    
    List<IndexStatistics> queryIndexStatistics(IndexStatistics vo,SysUser sysUser);
}