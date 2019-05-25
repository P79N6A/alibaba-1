package com.sun3d.why.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sun3d.why.dao.CmsTagSubMapper;
import com.sun3d.why.model.CmsTagSub;
import com.sun3d.why.service.CmsTagSubService;

@Service
public class CmsTagSubServiceImpl implements CmsTagSubService{
	
	@Autowired
	private CmsTagSubMapper cmsTagSubMapper;

	@Override
	public List<CmsTagSub> queryByTagId(String tagId) {

		return 	cmsTagSubMapper.queryByTagId(tagId);
	}

	@Override
	public List<CmsTagSub> queryCommonTag(Integer type) {
		return cmsTagSubMapper.queryCommonTag(type);
	}

	@Override
	public CmsTagSub queryById(String tagSubId) {
		return cmsTagSubMapper.selectByPrimaryKey(tagSubId);
	}

}
