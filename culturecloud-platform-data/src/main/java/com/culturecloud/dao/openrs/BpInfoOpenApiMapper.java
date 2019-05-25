package com.culturecloud.dao.openrs;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.culturecloud.dao.dto.openrs.BpInfoOpenDTO;


public interface BpInfoOpenApiMapper {

	List<BpInfoOpenDTO> getBpInfos(@Param("areaSource") String areaSource,@Param("updateTime") String updateTime,@Param("staticServerUrl")String staticServerUrl);
	
}
