/*
@author lijing
@version 1.0 2015年8月4日 下午3:33:41
*/
package com.sun3d.why.webservice.api.service;

import com.sun3d.why.model.CmsActivity;
import com.sun3d.why.webservice.api.model.CmsApiData;
import com.sun3d.why.webservice.api.model.CmsApiMessage;

public interface CmsApiActivityService {
	public CmsApiMessage save(CmsApiData<CmsActivity> apiData) throws Exception;

	public CmsApiMessage update(CmsApiData<CmsActivity> apiData) throws Exception;
	
	public CmsApiMessage delete(CmsApiData<CmsActivity> apiData) throws Exception;

	public CmsApiMessage returnActivity(CmsApiData<CmsActivity> apiData) throws Exception;
}

