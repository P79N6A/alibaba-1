package com.sun3d.why.dao;

import java.util.List;
import java.util.Map;

import com.sun3d.why.model.peopleTrain.CourseCaptcha;

public interface CourseCaptchaMapper {
	
	List<CourseCaptcha> queryCodeByArea(String area);
	
	CourseCaptcha queryCaptchaByCode(Map<String,Object> map);
	
}
