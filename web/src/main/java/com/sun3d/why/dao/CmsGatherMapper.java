package com.sun3d.why.dao;

import java.util.List;
import java.util.Map;

import com.sun3d.why.model.CmsGather;

public interface CmsGatherMapper {
    int deleteByPrimaryKey(String gatherId);

    int insert(CmsGather record);

    CmsGather selectByPrimaryKey(String gatherId);

    int update(CmsGather record);
    
	List<CmsGather> queryGatherByCondition(Map<String, Object> map);

}