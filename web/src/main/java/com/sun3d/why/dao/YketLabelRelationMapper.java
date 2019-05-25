package com.sun3d.why.dao;

import java.util.List;

import com.sun3d.why.model.bean.yket.YketLabel;
import com.sun3d.why.model.bean.yket.YketLabelRelationKey;

public interface YketLabelRelationMapper {
	int deleteByPrimaryKey(YketLabelRelationKey key);

	int insert(YketLabelRelationKey record);

	int insertSelective(YketLabelRelationKey record);

	int deleteByObject(YketLabelRelationKey key);

	List<YketLabel> selectObject(String objectId);
	
	List<YketLabel> selectCourseType(String objectId);

	List<YketLabel> selectCourseForm(String objectId);
}