package com.culturecloud.model.response.wrpx;

import com.culturecloud.model.bean.wrpx.WrpxCourse;

public class WrpxCourseVo extends WrpxCourse {
	private String courseFields;
	private String courseTypeName;
	public String getCourseFields() {
		return courseFields;
	}
	public void setCourseFields(String courseFields) {
		this.courseFields = courseFields;
	}
	public String getCourseTypeName() {
		return courseTypeName;
	}
	public void setCourseTypeName(String courseTypeName) {
		this.courseTypeName = courseTypeName;
	}
	 
	
	
}
