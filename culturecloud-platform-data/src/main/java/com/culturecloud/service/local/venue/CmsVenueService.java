package com.culturecloud.service.local.venue;

import java.util.List;

import com.culturecloud.model.response.venue.CmsVenueVO;

public interface CmsVenueService {

	List<CmsVenueVO> searchVenue(int limit,String keyword);
}
