package com.sun3d.why.dao;

import java.util.List;
import java.util.Map;

import com.sun3d.why.model.peopleTrain.CourseOrder;

public interface CourseOrderMapper {
	
	int queryCourseOrderCount(Map<String,Object> map);
	
	void addCourseOrder(CourseOrder courseOrder);
	
	List<CourseOrder> queryCourseOrderByUserId(Map<String,Object> map);
	
	int queryCourseOrderCountByUserId(Map<String,Object> map);
	
	int queryCourseOrderCountByCondition(Map<String, Object> map);

	List<CourseOrder> queryCourseOrderByCondition(Map<String, Object> map);

	int updateOrder(CourseOrder courseOrder);

	CourseOrder queryCourseOrderByorderId(Map<String, Object> map);
	
	List<CourseOrder> queryCourseViewByConditionForCollege(Map<String, Object> map);
	
	int queryCourseViewCountByConditionForCollege(Map<String, Object> map);
   //获取当前用户的学分
    int getIntegral(Map<String,Object> map);

}
