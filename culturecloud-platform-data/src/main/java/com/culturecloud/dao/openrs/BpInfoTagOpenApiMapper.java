package com.culturecloud.dao.openrs;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.culturecloud.dao.dto.openrs.BpInfoTagOpenDTO;


public interface BpInfoTagOpenApiMapper {

	List<BpInfoTagOpenDTO> getBpInfoTags(@Param("areaSource") String areaSource,@Param("updateTime") String updateTime,@Param("staticServerUrl")String staticServerUrl);
	
}
