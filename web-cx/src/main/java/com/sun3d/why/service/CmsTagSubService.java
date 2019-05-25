package com.sun3d.why.service;

import java.util.List;

import com.sun3d.why.model.CmsTagSub;

public interface CmsTagSubService {

	
	public List<CmsTagSub> queryByTagId(String tagId);
	
	public List<CmsTagSub> queryCommonTag(Integer type);
	
	public CmsTagSub queryById(String tagSubId);
}
