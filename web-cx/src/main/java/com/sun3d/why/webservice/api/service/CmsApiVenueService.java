package com.sun3d.why.webservice.api.service;

import com.sun3d.why.model.CmsVenue;
import com.sun3d.why.webservice.api.model.CmsApiData;
import com.sun3d.why.webservice.api.model.CmsApiMessage;

public interface CmsApiVenueService {
	public CmsApiMessage save(CmsApiData<CmsVenue> apiData) throws Exception;

	public CmsApiMessage update(CmsApiData<CmsVenue> apiData) throws Exception;
	
	public CmsApiMessage delete(CmsApiData<CmsVenue> apiData) throws Exception;

	public CmsApiMessage returnVenue(CmsApiData<CmsVenue> apiData) throws Exception;
	
}
