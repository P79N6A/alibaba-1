package com.sun3d.why.service.impl;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.culturecloud.model.bean.volunteer.CcpVolunteerRecruit;
import com.sun3d.why.dao.CcpVolunteerRecruitMapper;
import com.sun3d.why.service.CcpVolunteerRecruitService;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.UUIDUtils;
@Service
@Transactional
public class CcpVolunteerRecruitServiceImpl implements CcpVolunteerRecruitService{
	
	@Autowired 
	private CcpVolunteerRecruitMapper ccpVolunteerRecruitMapper;

	@Override
	public List<CcpVolunteerRecruit> queryVolunteerRecruitByCondition(
			CcpVolunteerRecruit volunteerRecruit, Pagination page) {
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		if(StringUtils.isNotBlank(volunteerRecruit.getRecruitName())){
		   map.put("recruitName", "%"+volunteerRecruit.getRecruitName()+"%");	
		}
		
		if(page != null){
			map.put("firstResult", page.getFirstResult());
			map.put("rows", page.getRows());
			int total = ccpVolunteerRecruitMapper.queryVolunteerRecruitByCondition(map);
			page.setTotal(total);
		}
		
		List<CcpVolunteerRecruit> list = ccpVolunteerRecruitMapper.queryVolunteerRecruitByList(map);
		return list;
	}

	@Override
	public int save(CcpVolunteerRecruit volunteerRecruit) {
		volunteerRecruit.setRecruitId(UUIDUtils.createUUId());
		volunteerRecruit.setRecruitCreateTime(new Date());
		volunteerRecruit.setRecruitUpdateTime(new Date());
		SimpleDateFormat fomDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String time = fomDateFormat.format(new Date());
		volunteerRecruit.setRecruitStartTime(time);
		volunteerRecruit.setRecruitEndTime(time);
		volunteerRecruit.setRecruitIsDelete(1);
		return ccpVolunteerRecruitMapper.insert(volunteerRecruit);
	}

	@Override
	public CcpVolunteerRecruit queryVolunteerRecruitById(String recruitId) {
		return ccpVolunteerRecruitMapper.selectByPrimaryKey(recruitId);
	}

	@Override
	public int deleteVolunteer(CcpVolunteerRecruit volunteerRecruit) {
		volunteerRecruit.setRecruitUpdateTime(new Date());
		volunteerRecruit.setRecruitIsDelete(2);
		return ccpVolunteerRecruitMapper.updateByPrimaryKeySelective(volunteerRecruit);
	}

	@Override
	public int editVolunteer(CcpVolunteerRecruit vt, String recruitId) {
		vt.setRecruitUpdateTime(new Date());
		vt.setRecruitId(recruitId);
		return ccpVolunteerRecruitMapper.updateByPrimaryKeySelective(vt);
	}

}
