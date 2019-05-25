package com.sun3d.why.service;

import java.util.List;

import com.sun3d.why.model.ccp.CcpSceneImg;
import com.sun3d.why.model.ccp.CcpSceneUser;
import com.sun3d.why.model.ccp.CcpSceneVote;

public interface CcpSceneImgService {
    
	List<CcpSceneImg> querySceneImgList(CcpSceneImg vo);
	
	List<CcpSceneImg> querySelectSceneImgList(CcpSceneImg vo);
	
	List<CcpSceneUser> querySceneUserRanking();
	
	String addSceneVote(CcpSceneVote vo);
	
	String addSceneImg(CcpSceneImg vo);
	
	String addSceneUser(CcpSceneUser vo);
	
	CcpSceneUser querySceneUser(String userId);
}