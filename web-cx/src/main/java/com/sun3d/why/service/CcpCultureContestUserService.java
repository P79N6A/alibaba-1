package com.sun3d.why.service;

import java.util.Map;

import com.culturecloud.model.bean.culture.CcpCultureContestUser;

public interface CcpCultureContestUserService {

	public CcpCultureContestUser queryUserInfo(String userId);
	
	public Map<String,String> saveUserInfo(CcpCultureContestUser user);
	
	public CcpCultureContestUser queryUserInfoById(String cultureUserId);
	
	
}
