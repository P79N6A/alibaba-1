package com.sun3d.why.service;

import java.util.List;

import com.sun3d.why.model.ccp.CcpMerchantUser;
import com.sun3d.why.util.Pagination;


public interface CcpMerchantUserService {
	
	List<CcpMerchantUser> queryMerchantUserByCondition(CcpMerchantUser ccpMerchantUser, Pagination page);
	
	String saveSysUser(String merchantUserId);

}