package com.culturecloud.model.response.wrpx;

import java.io.Serializable;

import com.culturecloud.model.bean.wrpx.WrpxTrainningMethod;

public class WrpxTrainningMethodVo extends WrpxTrainningMethod implements Serializable {
/**
 * 
 */
private static final long serialVersionUID = 1110078124140959851L;
 
private Integer courseTypeCount;

public Integer getCourseTypeCount() {
	return courseTypeCount;
}

public void setCourseTypeCount(Integer courseTypeCount) {
	this.courseTypeCount = courseTypeCount;
}

}
