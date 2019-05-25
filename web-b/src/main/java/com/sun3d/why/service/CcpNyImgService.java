package com.sun3d.why.service;

import java.util.List;

import com.sun3d.why.model.ccp.CcpNyImg;
import com.sun3d.why.util.Pagination;

public interface CcpNyImgService {
    
	List<CcpNyImg> queryNyImgByCondition(CcpNyImg ccpNyImg, Pagination page);
	
	String deleteNyImg(String nyImgId);

	int update(CcpNyImg ccpNyImg);

	CcpNyImg queryByNyImgId(String id);
}