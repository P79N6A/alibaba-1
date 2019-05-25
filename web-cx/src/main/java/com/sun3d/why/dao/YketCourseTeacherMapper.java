package com.sun3d.why.dao;

import com.sun3d.why.model.bean.yket.YketCourseTeacher;

public interface YketCourseTeacherMapper {
	int insert(YketCourseTeacher record);

	int insertSelective(YketCourseTeacher record);

	int deleteByCourse(String courseId);

}