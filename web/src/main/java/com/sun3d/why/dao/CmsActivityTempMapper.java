package com.sun3d.why.dao;

import com.sun3d.why.model.temp.CmsActivityTemp;

import java.util.List;
import java.util.Map;

public interface CmsActivityTempMapper {

    int countByCondition(Map<String,Object> params);

    List<CmsActivityTemp> queryByCondition(Map<String,Object> params);

}