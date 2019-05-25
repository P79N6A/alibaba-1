package com.sun3d.why.service;

import java.util.List;

import com.sun3d.why.model.ccp.CcpPoem;
import com.sun3d.why.model.ccp.CcpPoemLector;
import com.sun3d.why.model.ccp.CcpPoemUser;

public interface CcpPoemService {
    
	List<CcpPoem> queryPoemByCondition(CcpPoem ccpPoem);
	
	String addPoemUser(CcpPoemUser ccpPoemUser);
	
	List<CcpPoemLector> queryAllPoemLector();
	
}