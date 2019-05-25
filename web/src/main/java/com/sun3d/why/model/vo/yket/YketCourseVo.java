package com.sun3d.why.model.vo.yket;

import java.util.List;

import com.sun3d.why.model.bean.yket.YketCourse;
import com.sun3d.why.model.bean.yket.YketLabel;
import com.sun3d.why.model.bean.yket.YketTeacherInfo;

public class YketCourseVo extends YketCourse {

	private List<YketLabel> labels;
	private List<YketLabel> courseTypelabels;
	private List<YketLabel> courseFormlabels;

	private List<YketTeacherInfo> teachers;

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

	@Override
	public String toString() {
		return "YketCourseVo [labels=" + labels + ", teachers=" + teachers + "]";
	}

	public List<YketLabel> getCourseTypelabels() {
		return courseTypelabels;
	}

	public void setCourseTypelabels(List<YketLabel> courseTypelabels) {
		this.courseTypelabels = courseTypelabels;
	}

	public List<YketLabel> getCourseFormlabels() {
		return courseFormlabels;
	}

	public void setCourseFormlabels(List<YketLabel> courseFormlabels) {
		this.courseFormlabels = courseFormlabels;
	}

}
