package com.sun3d.why.dao;

import java.util.List;

import com.sun3d.why.model.CmsVenueSysUserRelevance;

public interface CmsVenueSysUserRelevanceMapper {
	
	List<CmsVenueSysUserRelevance> queryVenueSysUserRelevanceByVenueId(String venueId);

	int addVenueSysUserRelevance(CmsVenueSysUserRelevance record);
}
