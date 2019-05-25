package com.sun3d.why.service;

import java.util.List;

import com.sun3d.why.common.Result;
import com.sun3d.why.model.bean.yket.SysUser;
import com.sun3d.why.model.bean.yket.YketCourseHour;
import com.sun3d.why.util.Pagination;

public interface CourseHourService {

	List<YketCourseHour> queryCourseIdByCourseHour(String courseId,
			Pagination page);

	int addCourseHour(YketCourseHour yketCourseHour, SysUser sysUser);

	YketCourseHour queryYketCourseHourByHourId(String hourId);

	Result editCourseHour(YketCourseHour yketCourseHour, SysUser sysUser);

	Result deleteCourseHour(String hourId, SysUser sysUser);

	Result moveDown(String hourId, Integer sort);

	Result moveUp(String hourId, Integer sort);

	int queryHourName(String hourName, String courseId);

}
