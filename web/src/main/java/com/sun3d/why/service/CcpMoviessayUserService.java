package com.sun3d.why.service;

import com.culturecloud.model.bean.moviessay.CcpMoviessayUser;

public interface CcpMoviessayUserService {
	
	public CcpMoviessayUser queryUserInfo(String userId);
	
	public int saveUserInfo(CcpMoviessayUser user);
	
	String selectByUserId(String userId);
}
