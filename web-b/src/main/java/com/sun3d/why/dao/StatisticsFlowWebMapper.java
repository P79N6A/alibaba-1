package com.sun3d.why.dao;

import com.sun3d.why.model.StatisticsFlowWeb;

import java.util.List;
import java.util.Map;

public interface StatisticsFlowWebMapper {

	int deleteByPrimaryKey(String id);

    int insert(StatisticsFlowWeb record);

    int insertSelective(StatisticsFlowWeb record);

    StatisticsFlowWeb selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(StatisticsFlowWeb record);

    int updateByPrimaryKeyWithBLOBs(StatisticsFlowWeb record);

    int updateByPrimaryKey(StatisticsFlowWeb record);
    
    List<StatisticsFlowWeb> queryByMap(Map<String, String> map);

    List<Map<String,String>> queryByMapYear(Map<String, String> map);
}