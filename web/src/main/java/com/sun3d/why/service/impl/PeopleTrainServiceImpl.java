package com.sun3d.why.service.impl;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.sun3d.why.dao.PeopleTrainMapper;
import com.sun3d.why.model.CmsTerminalUser;
import com.sun3d.why.model.SysShareDept;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.model.peopleTrain.CourseCaptcha;
import com.sun3d.why.model.peopleTrain.TrainTerminalUser;
import com.sun3d.why.service.CmsTerminalUserService;
import com.sun3d.why.service.CourseCaptchaService;
import com.sun3d.why.service.PeopleTrainService;
import com.sun3d.why.service.SysShareDeptService;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.UUIDUtils;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional
public class PeopleTrainServiceImpl implements PeopleTrainService {
	@Autowired
	private SysShareDeptService sysShareDeptService;
	@Autowired
	private PeopleTrainMapper peopleTrainMapper;
	@Autowired
	private CourseCaptchaService courseCaptchaService;
	@Autowired
	private CmsTerminalUserService terminalUserService;
	
	@Override
	public List<TrainTerminalUser> queryPeopleTrainByCondition(String searchKey, TrainTerminalUser trainTerminalUser, Pagination page,SysUser sysUser) {
		Map<String, Object> map = new HashMap<String, Object>();
		// 权限验证
		if (sysUser != null && StringUtils.isNotBlank(sysUser.getUserCounty()) && ((sysUser.getUserCounty()).indexOf("44")==-1 && (sysUser.getUserCounty()).indexOf("45")==-1)) {
			map.put("sysUserId", sysUser.getUserId());
		}
		if(StringUtils.isNotBlank(searchKey)){
            map.put("searchKey", searchKey);
        }
		if(trainTerminalUser!=null && StringUtils.isNotBlank(trainTerminalUser.getUserMobileNo())){
            map.put("userMobileNo", "%"+trainTerminalUser.getUserMobileNo()+"%");
        }
        //分页
        if (page != null && page.getFirstResult() != null && page.getRows() != null) {
            map.put("firstResult", page.getFirstResult());
            map.put("rows", page.getRows());
            int total = peopleTrainMapper.queryTrainTerminalUserCountByCondition(map);
            page.setTotal(total);
        }

		return peopleTrainMapper.queryTrainTerminalUserByCondition(map);
	}
	
	@Override
	public String addTrainTerminalUser(TrainTerminalUser user,CmsTerminalUser terminalUser) {
		String result = null;
		if(user==null){
			result= "表单提交失败";
			return result;
		}
		List<CourseCaptcha> captchas =  courseCaptchaService.queryCodeByArea(null);
		CourseCaptcha courseCaptcha = null;
		if(user.getVerificationCode()!=null){
			Map<String,Object> map = new HashMap<String,Object>();
			map.put("code", user.getVerificationCode());
			courseCaptcha = courseCaptchaService.queryCaptchaByCode(map);
			if(captchas!=null && captchas.size()>0 && courseCaptcha!=null){
				StringBuffer sb = new StringBuffer();
				for(CourseCaptcha captcha:captchas){
					sb.append(captcha.getCode()).append(",");
				}
				if((sb.toString()).indexOf(user.getVerificationCode())==-1){
					result= "报名识别码不正确";
					return result;
				}
			}else{
				result= "报名识别码不正确";
				return result;
			}
		}
		TrainTerminalUser trainTerminalUser = this.queryTrainUserByUserId(user.getUserId());
		if(trainTerminalUser!=null){
			if(user.getVerificationCode()!=null){
				user.setVerificationCode(courseCaptcha.getId());
			}
			user.setUpdateTime(new Date());
			this.updateTrainTerminalUser(user);
		}else{
			user.setId(UUIDUtils.createUUId());
			if(user.getVerificationCode()!=null){
				user.setVerificationCode(courseCaptcha.getId());
			}
			user.setCreateTime(new Date());
			user.setUpdateTime(new Date());
			peopleTrainMapper.addTrainTerminalUser(user);
		}
		terminalUserService.updateTerminalUserById(terminalUser);
		return result;
	}

	@Override
	public TrainTerminalUser queryTrainUserByUserId(String userId) {
		return peopleTrainMapper.queryTrainUserByUserId(userId);
	}

	@Override
	public String updateTrainTerminalUser(TrainTerminalUser trainTerminalUser) {
		peopleTrainMapper.updateTrainTerminalUser(trainTerminalUser);
		return "sucess";
	}
	
	@Override
	public List<TrainTerminalUser> queryPeopleTrainByExprot() {
		Map<String, Object> map = new HashMap<String, Object>();
		return peopleTrainMapper.queryTrainTerminalUserByCondition(map);
	}
	@Override
	public TrainTerminalUser queryPeopleTrainById(String searchKey) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("searchKey", searchKey);
		return peopleTrainMapper.queryPeopleTrainById(map);
	}

}