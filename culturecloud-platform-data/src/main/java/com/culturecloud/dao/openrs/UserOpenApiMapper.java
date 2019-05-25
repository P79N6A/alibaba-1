package com.culturecloud.dao.openrs;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.culturecloud.dao.dto.openrs.UserCollectDTO;
import com.culturecloud.dao.dto.openrs.UserOpenDTO;

public interface UserOpenApiMapper {

	UserOpenDTO getUser(String userId);
	
	UserOpenDTO userAuth(@Param("username") String username,@Param("pwd") String pwd);
	
	List<UserCollectDTO> usercollect(String userId);
	
	int getRegisterCount(@Param("sysSource") String sysSource,@Param("registerTime") String registerTime);
}
