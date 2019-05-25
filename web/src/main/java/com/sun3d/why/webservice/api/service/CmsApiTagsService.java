/*
@author lijing
@version 1.0 2015年8月4日 下午8:09:23
*/
package com.sun3d.why.webservice.api.service;

import java.util.List;

public interface CmsApiTagsService {
	public boolean checkTags(String tagsId,String dictCode) throws Exception;
	public boolean checkDictArea(String venueArea) throws Exception;
	public boolean checkDictMood(String dictId,String parentDictCode) throws Exception;
	public List getChildTagByType(String code);
	public List getChildDictByCode(String dictCode);
}

