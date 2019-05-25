package com.sun3d.why.service;

import java.util.List;

import com.sun3d.why.model.ccp.CcpComedy;

public interface CcpComedyService {
    
	List<CcpComedy> queryComedyList(CcpComedy vo);
	
	CcpComedy selectByPrimaryKey(String userId);
	
	String saveOrUpdateCcpComedy(CcpComedy vo);
	
}