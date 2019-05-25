package com.sun3d.why.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.sun3d.why.dao.CourseCaptchaMapper;
import com.sun3d.why.model.peopleTrain.CourseCaptcha;
import com.sun3d.why.service.CourseCaptchaService;

@Service
@Transactional
public class CourseCaptchaServiceImpl implements CourseCaptchaService {
	
	@Autowired
	private CourseCaptchaMapper courseCaptchaMapper;
	
	@Override
	public List<CourseCaptcha> queryCodeByArea(String area) {
		return courseCaptchaMapper.queryCodeByArea(area);
	}
	
	public CourseCaptcha queryCaptchaByCode(Map<String,Object> map){
		return courseCaptchaMapper.queryCaptchaByCode(map);
	}

}
