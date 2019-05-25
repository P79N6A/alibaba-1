package com.sun3d.why.service;

import java.util.List;

import com.sun3d.why.model.ccp.CcpWalkImg;
import com.sun3d.why.model.ccp.CcpWalkUser;
import com.sun3d.why.model.ccp.CcpWalkVote;

public interface CcpWalkImgService {
    
	List<CcpWalkImg> queryWalkImgList(CcpWalkImg vo);
	
	List<CcpWalkImg> querySelectWalkImgList(CcpWalkImg vo);
	
	List<CcpWalkUser> queryWalkUserRanking();
	
	String addWalkVote(CcpWalkVote vo);
	
	String addWalkImg(CcpWalkImg vo);
	
	String addWalkUser(CcpWalkUser vo);
	
	CcpWalkUser queryWalkUser(String userId);
}