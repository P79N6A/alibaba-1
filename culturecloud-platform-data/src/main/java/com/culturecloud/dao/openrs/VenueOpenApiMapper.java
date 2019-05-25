package com.culturecloud.dao.openrs;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.culturecloud.dao.dto.openrs.CmsVenue;
import com.culturecloud.dao.dto.openrs.VenueOpenDTO;

public interface VenueOpenApiMapper {
	
	CmsVenue selectByPrimaryKey(String venueId);

	List<VenueOpenDTO> getVenues(@Param("areaSource") String areaSource,@Param("updateTime") String updateTime,@Param("staticServerUrl") String staticServerUrl);
	
	int queryAppActivityCountByVenueId(String venueId);
	
	int queryAppRoomCountByVenueId(String venueId);
	
	int getVenueCommentCount(@Param("areaSource") String areaSource,@Param("commentTime") String commentTime);
	
	int getVenuePublishCount(@Param("areaSource") String areaSource,@Param("publishTime") String publishTime);

}
