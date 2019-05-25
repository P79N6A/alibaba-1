package com.sun3d.why.service;

import com.culturecloud.model.bean.musicessay.CcpMusicessayUser;

public interface CcpMusicessayUserService {
	
	public CcpMusicessayUser queryUserInfo(String userId);
	
	public int saveUserInfo(CcpMusicessayUser user);
}
