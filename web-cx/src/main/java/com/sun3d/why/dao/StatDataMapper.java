package com.sun3d.why.dao;

import com.sun3d.why.model.StatData;

import java.util.List;

import java.util.Map;

public interface StatDataMapper {

    int insertSelective(StatData record);

    List<StatData> selectByAdmin(Map map);

    List<StatData> selectVenueByAdmin(Map map);

}

