package com.sun3d.why.model.vo.yket;

import com.sun3d.why.model.bean.yket.YketCourse;
import com.sun3d.why.model.bean.yket.YketTeacherInfo;

public class YketCourseList4FrontVo extends YketCourse {

	private Integer courseTimeCount;
	private Integer likeCount;
	private YketTeacherInfo teacher;

	public Integer getCourseTimeCount() {
		return courseTimeCount;
	}

	public void setCourseTimeCount(Integer courseTimeCount) {
		this.courseTimeCount = courseTimeCount;
	}

	public YketTeacherInfo getTeacher() {
		return teacher;
	}

	public void setTeacher(YketTeacherInfo teacher) {
		this.teacher = teacher;
	}

	public Integer getLikeCount() {
		return likeCount;
	}

	public void setLikeCount(Integer likeCount) {
		this.likeCount = likeCount;
	}

}
