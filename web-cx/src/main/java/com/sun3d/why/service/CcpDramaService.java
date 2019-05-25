package com.sun3d.why.service;

import java.util.List;

import com.sun3d.why.model.ccp.CcpDrama;
import com.sun3d.why.model.ccp.CcpDramaComment;
import com.sun3d.why.model.ccp.CcpDramaUser;
import com.sun3d.why.model.ccp.CcpDramaVote;


public interface CcpDramaService {
    
	List<CcpDrama> queryCcpDramalist(CcpDrama vo);
	
	List<CcpDramaComment> queryCcpDramaCommentlist(CcpDramaComment vo);
	
	String addDramaVote(CcpDramaVote vo);
	
	String addDramaUser(CcpDramaUser vo);
	
	String addDramaComment(CcpDramaComment vo);
	
	CcpDramaUser queryCcpDramaUser(String userId);
	
}