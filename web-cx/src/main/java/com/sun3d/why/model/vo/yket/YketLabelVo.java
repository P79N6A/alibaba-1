package com.sun3d.why.model.vo.yket;

import com.sun3d.why.model.bean.yket.YketLabel;

public class YketLabelVo extends YketLabel{

	private Integer courseCount;

	public Integer getCourseCount() {
		return courseCount;
	}

	public void setCourseCount(Integer courseCount) {
		this.courseCount = courseCount;
	}

	@Override
	public String toString() {
 		return "YketLabelVo [courseCount=" + courseCount + "]";
	}

 
	
}
