package com.sun3d.why.service;

import java.util.List;

import com.sun3d.why.model.ccp.CcpCityImg;
import com.sun3d.why.model.ccp.CcpCityUser;
import com.sun3d.why.model.ccp.CcpCityVote;

public interface CcpCityImgService {
    
	List<CcpCityImg> queryCityImgList(CcpCityImg vo);
	
	List<CcpCityImg> querySelectCityImgList(CcpCityImg vo);
	
	List<CcpCityUser> queryCityUserRanking(Integer cityType);
	
	String addCityVote(CcpCityVote vo);
	
	String addCityImg(CcpCityImg vo);
	
	String addCityUser(CcpCityUser vo);
	
	CcpCityUser queryCityUser(String userId);
}