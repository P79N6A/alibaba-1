package com.sun3d.why.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.culturecloud.model.bean.volunteer.CcpVolunteerApplyPic;
import com.sun3d.why.dao.CcpVolunteerApplyMapper;
import com.sun3d.why.dao.CcpVolunteerApplyPicMapper;
import com.sun3d.why.dao.dto.CcpVolunteerApplyDto;
import com.sun3d.why.service.CcpVolunteerApplyService;
import com.sun3d.why.util.Pagination;

@Service
@Transactional
public class CcpVolunteerApplyServiceImpl implements CcpVolunteerApplyService{
	
	@Autowired
	private CcpVolunteerApplyMapper ccpVolunteerApplyMapper;
	@Autowired
	private CcpVolunteerApplyPicMapper ccpVolunteerApplyPicMapper;
	@Override
	public List<CcpVolunteerApplyDto> queryCcpVolunteerApply(String userId, Pagination page) {

		  Map<String, Object> map = new HashMap<String, Object>();	
		  map.put("userId", userId);
	        if (page != null) {
	        	
	        	int total=ccpVolunteerApplyMapper.selectByUserId(map).size();
	        	
	        	page.setTotal(total);
	        	
	            map.put("firstResult",page.getFirstResult());
	            map.put("rows",page.getRows());
	        }
	        List<CcpVolunteerApplyDto> volunDtoList = ccpVolunteerApplyMapper.selectByUserId(map);
	        List<CcpVolunteerApplyPic> volunPicList = new ArrayList<CcpVolunteerApplyPic>();
	        //查出照片
	        for(CcpVolunteerApplyDto ccpVolunteerApply:volunDtoList){
	        	String applyId = ccpVolunteerApply.getVolunteerApplyId();
	        	volunPicList = ccpVolunteerApplyPicMapper.selectByApplyId(applyId);
	        	String[] imgs = new String[2];
	        	for(int i=0;i<volunPicList.size();i++){
	        		imgs[i] = volunPicList.get(i).getApplyPicUrl();
	        	}
	        	ccpVolunteerApply.setImgs(imgs);
	        }
	        return volunDtoList;
	}

}
