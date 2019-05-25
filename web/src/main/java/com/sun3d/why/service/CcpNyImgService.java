package com.sun3d.why.service;

import java.util.List;

import com.sun3d.why.model.ccp.CcpNyImg;
import com.sun3d.why.model.ccp.CcpNyUser;
import com.sun3d.why.model.ccp.CcpNyVote;

public interface CcpNyImgService {
    
	List<CcpNyImg> queryNyImgList(CcpNyImg vo);
	
	List<CcpNyImg> querySelectNyImgList(CcpNyImg vo);
	
	List<CcpNyUser> queryNyUserRanking();
	
	String addNyVote(CcpNyVote vo);
	
	String addNyImg(CcpNyImg vo);
	
	String addNyUser(CcpNyUser vo);
	
	CcpNyUser queryNyUser(String userId);
}