package com.sun3d.why.service;

import java.util.List;
import java.util.Map;

import com.sun3d.why.common.Result;
import com.sun3d.why.model.bean.yket.SysUser;
import com.sun3d.why.model.bean.yket.YketCourse;
import com.sun3d.why.model.vo.yket.YketCourse4FrontVo;
import com.sun3d.why.model.vo.yket.YketCourseList4FrontVo;
import com.sun3d.why.model.vo.yket.YketCourseListVo;
import com.sun3d.why.model.vo.yket.YketCourseVo;
import com.sun3d.why.util.Pagination;

public interface YketCourseService {

	Result addCourse(YketCourseVo courseVo, SysUser user);

	List<YketCourseListVo> courList(String courseName, Pagination page);

	YketCourseVo getCourseInfo(String courseId);

	Result updateCourse(YketCourseVo courseVo, SysUser user);

	Result delCourse(String courseId, SysUser user);

	@Deprecated
	List<YketCourse> queryFrontYketCourseList(Map<String, Object> map);

	
	
	List<YketCourseList4FrontVo> getCourseList4Front(Map<String, String> map);
	
	 YketCourse4FrontVo getCourseDetailFront(Map<String, Object> map);

}
