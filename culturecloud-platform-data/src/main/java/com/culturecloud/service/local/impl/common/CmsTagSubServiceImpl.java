package com.culturecloud.service.local.impl.common;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.culturecloud.dao.common.CmsTagSubMapper;
import com.culturecloud.dao.dto.common.CmsTagSubDto;
import com.culturecloud.model.response.common.CmsTagSubVO;
import com.culturecloud.service.local.common.CmsTagSubService;

@Service
public class CmsTagSubServiceImpl implements CmsTagSubService {
	
	@Resource
	private CmsTagSubMapper cmsTagSubMapper;

	@Override
	public List<CmsTagSubVO> queryRelateTagSubList(String relateId) {
		
		List<CmsTagSubVO> result=new ArrayList<CmsTagSubVO>();
		
		 List<CmsTagSubDto> list=	cmsTagSubMapper.queryRelateTagSubList(relateId);
		
		 for (CmsTagSubDto cmsTagSubDto : list) {
			 CmsTagSubVO vo=new CmsTagSubVO(cmsTagSubDto);
			 
			 result.add(vo);
		}
		
		return result;
	}

}
