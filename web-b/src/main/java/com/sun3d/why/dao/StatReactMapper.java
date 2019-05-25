package com.sun3d.why.dao;

import com.sun3d.why.model.StatReact;

import java.util.List;
import java.util.Map;

public interface StatReactMapper {

    int insertSelective(StatReact record);

    List<StatReact> selectByAdmin(Map map);
}