package com.sun3d.why.service;

import java.util.List;

import com.sun3d.why.model.ccp.CcpWalkImg;
import com.sun3d.why.util.Pagination;

public interface CcpWalkImgService {
    
	List<CcpWalkImg> queryWalkImgByCondition(CcpWalkImg ccpWalkImg, Pagination page);
	
	String deleteWalkImg(String walkImgId, String walkImgUrls);
	
	CcpWalkImg queryWalkImgById(String id);

	int update(CcpWalkImg ccpWalkImg);
	
	String brushWalkVote(String walkImgId, Integer count);
}