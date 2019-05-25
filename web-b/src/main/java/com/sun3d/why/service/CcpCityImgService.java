package com.sun3d.why.service;

import java.util.List;

import com.sun3d.why.model.ccp.CcpCityImg;
import com.sun3d.why.model.ccp.CcpSceneImg;
import com.sun3d.why.util.Pagination;

public interface CcpCityImgService {
    
	List<CcpCityImg> queryCityImgByCondition(CcpCityImg ccpCityImg, Pagination page);
	
	String deleteCityImg(String cityImgId, String cityImgUrls);

	CcpCityImg queryCityImgById(String id);

	int update(CcpCityImg ccpCityImg);
}