package com.sun3d.why.service;

import java.util.List;

import com.sun3d.why.model.ccp.CcpSceneImg;
import com.sun3d.why.util.Pagination;

public interface CcpSceneImgService {
    
	List<CcpSceneImg> querySceneImgByCondition(CcpSceneImg ccpSceneImg, Pagination page);
	
	String deleteSceneImg(String sceneImgId);

	CcpSceneImg querySceneImgById(String sceneImgId);

	int update(CcpSceneImg ccpSceneImg);
}