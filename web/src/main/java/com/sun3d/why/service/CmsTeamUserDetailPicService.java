package com.sun3d.why.service;

import java.util.List;

import com.sun3d.why.model.CmsTeamUserDetailPic;

public interface CmsTeamUserDetailPicService {

	
	List<CmsTeamUserDetailPic> queryCmsTeamUserDetailByTuserId(String tuserId);
}
