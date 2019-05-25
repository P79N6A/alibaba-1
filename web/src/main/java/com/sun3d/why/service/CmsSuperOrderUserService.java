package com.sun3d.why.service;

import com.sun3d.why.model.CmsSuperOrderUser;

public interface CmsSuperOrderUserService {
    
	CmsSuperOrderUser querySuperOrderUserByUserMobileNo(String userMobileNo);
	
	String sendCode(CmsSuperOrderUser cmsSuperOrderUser, String userMobileNo);
}