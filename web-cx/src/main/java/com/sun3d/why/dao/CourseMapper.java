package com.sun3d.why.dao;

import java.util.List;
import java.util.Map;

import com.sun3d.why.model.peopleTrain.Course;

public interface CourseMapper {

	int queryCourserCountByCondition(Map<String, Object> map);

	List<Course> queryCourserByCondition(Map<String, Object> map);
	
	int saveCourse(Course course);
	
	List<Course> queryCourseListForFront(Map<String, Object> map);
	
	Course queryCourseByCourseId(String courseId);
	
	List<Course> queryCourseByIn(Map<String, Object> map);
	
	int editState(Course course);

}