package com.sun3d.why.service;

import java.util.List;
import java.util.Map;

import com.sun3d.why.model.SysUser;
import com.sun3d.why.model.peopleTrain.Course;
import com.sun3d.why.model.peopleTrain.CourseOrderTemp;
import com.sun3d.why.util.Pagination;

public interface CourseService {
	
	List<Course> queryCourseByCondition(String courseType, String courseField,String searchKey, Course course,Pagination page, SysUser sysUser);
	
	int saveCourse(Course course, SysUser sysUser);
	
	List<Course> queryCourseListForFront(Map<String, Object> map);
	
	Course queryCourseByCourseId(String courseId);
	
	List<Course> queryCourseByIn(CourseOrderTemp temp);
	
	int editState(Course course, String state,String checkState);
	
	int editSaveCourse(Course course);

}
