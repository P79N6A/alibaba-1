package com.sun3d.why.model.vo.yket;

import java.util.List;

import com.sun3d.why.model.bean.yket.YketCourse;
import com.sun3d.why.model.bean.yket.YketLabel;
import com.sun3d.why.model.bean.yket.YketTeacherInfo;

public class YketCourseListVo extends YketCourse {

	private Integer courseTimeCount;
	private Integer commentCount;
	private List<YketLabel> labels;
	private List<YketLabel> courseTypelabels;

	private List<YketTeacherInfo> teachers;
	public Integer getCourseTimeCount() {
		return courseTimeCount;
	}
	public void setCourseTimeCount(Integer courseTimeCount) {
		this.courseTimeCount = courseTimeCount;
	}
	public Integer getCommentCount() {
		return commentCount;
	}
	public void setCommentCount(Integer commentCount) {
		this.commentCount = commentCount;
	}
	public List<YketLabel> getLabels() {
		return labels;
	}
	public void setLabels(List<YketLabel> labels) {
		this.labels = labels;
	}
	public List<YketTeacherInfo> getTeachers() {
		return teachers;
	}
	public void setTeachers(List<YketTeacherInfo> teachers) {
		this.teachers = teachers;
	}
	public List<YketLabel> getCourseTypelabels() {
		return courseTypelabels;
	}
	public void setCourseTypelabels(List<YketLabel> courseTypelabels) {
		this.courseTypelabels = courseTypelabels;
	}
	
}
