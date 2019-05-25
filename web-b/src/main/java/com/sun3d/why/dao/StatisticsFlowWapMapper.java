package com.sun3d.why.dao;

import com.sun3d.why.model.StatisticsFlowWap;

import java.util.List;
import java.util.Map;

public interface StatisticsFlowWapMapper {
	
    int deleteByPrimaryKey(String id);

    int insert(StatisticsFlowWap record);

    int insertSelective(StatisticsFlowWap record);

    StatisticsFlowWap selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(StatisticsFlowWap record);

    int updateByPrimaryKeyWithBLOBs(StatisticsFlowWap record);

    int updateByPrimaryKey(StatisticsFlowWap record);
    
    List<StatisticsFlowWap> queryByMap(Map<String, String> map);

    List<Map<String,String>> queryByMapYear(Map<String, String> map);
}