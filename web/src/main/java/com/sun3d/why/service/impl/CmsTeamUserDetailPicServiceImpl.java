package com.sun3d.why.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.sun3d.why.dao.CmsTeamUserDetailPicMapper;
import com.sun3d.why.model.CmsTeamUserDetailPic;
import com.sun3d.why.service.CmsTeamUserDetailPicService;

@Service
@Transactional
public class CmsTeamUserDetailPicServiceImpl implements CmsTeamUserDetailPicService{
	
	@Autowired
	private CmsTeamUserDetailPicMapper cmsTeamUserDetailPicServiceMapper;

	@Override
	public List<CmsTeamUserDetailPic> queryCmsTeamUserDetailByTuserId(String tuserId) {
	
		return cmsTeamUserDetailPicServiceMapper.queryCmsTeamUserDetailByTuserId(tuserId);
	}

}
