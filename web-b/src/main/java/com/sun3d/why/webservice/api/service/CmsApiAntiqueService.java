/*
@author lijing
@version 1.0 2015年8月4日 下午3:34:48
*/
package com.sun3d.why.webservice.api.service;

import com.sun3d.why.model.CmsAntique;
import com.sun3d.why.webservice.api.model.CmsApiData;
import com.sun3d.why.webservice.api.model.CmsApiMessage;

public interface CmsApiAntiqueService {
	public CmsApiMessage save(CmsApiData<CmsAntique> apiData) throws Exception;

	public CmsApiMessage update(CmsApiData<CmsAntique> apiData) throws Exception;
	
	public CmsApiMessage delete(CmsApiData<CmsAntique> apiData) throws Exception;
}

