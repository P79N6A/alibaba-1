package com.culturecloud.dao.openrs;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.culturecloud.dao.dto.openrs.ActivityOpenDTO;

public interface ActivityOpenApiMapper {

	List<ActivityOpenDTO> getAcivitys(@Param("areaSource") String areaSource,@Param("updateTime") String updateTime,@Param("staticServerUrl")String staticServerUrl);
	
	int getActivityCommentCount(@Param("areaSource") String areaSource,@Param("commentTime") String commentTime);
	
	int getActivityPublishCount(@Param("areaSource") String areaSource,@Param("publishTime") String publishTime);
}
