/*
@author lijing
@version 1.0 2015年8月4日 下午3:34:08
*/
package com.sun3d.why.webservice.api.service;

import com.sun3d.why.model.CmsActivityRoom;
import com.sun3d.why.webservice.api.model.CmsApiData;
import com.sun3d.why.webservice.api.model.CmsApiMessage;

public interface CmsApiActivityRoomService {
	public CmsApiMessage save(CmsApiData<CmsActivityRoom> apiData) throws Exception;

	public CmsApiMessage update(CmsApiData<CmsActivityRoom> apiData) throws Exception;
	
	public CmsApiMessage delete(CmsApiData<CmsActivityRoom> apiData) throws Exception;

	
}

