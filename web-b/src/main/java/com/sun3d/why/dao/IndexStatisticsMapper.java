package com.sun3d.why.dao;

import com.sun3d.why.model.IndexStatistics;

import java.util.List;
import java.util.Map;

public interface IndexStatisticsMapper {
//    int countByExample(IndexStatisticsExample example);
//
//    int deleteByExample(IndexStatisticsExample example);

    List<IndexStatistics> queryByMap(Map map);

    int addIndexStatistics(IndexStatistics record);

    int deleteInfo();

//    List<IndexStatistics> selectByExample(IndexStatisticsExample example);

//    int updateByExampleSelective(@Param("record") IndexStatistics record);

//    int updateByExample(@Param("record") IndexStatistics record);
//
//    List<IndexStatistics> queryByArea(Map map);
}