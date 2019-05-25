package com.sun3d.why.service;

import java.util.List;

import com.sun3d.why.model.SysUser;
import com.sun3d.why.model.ccp.CcpExhibition;
import com.sun3d.why.util.Pagination;



public interface CcpExhibitionService {

	List<CcpExhibition> queryCcpExhibition(CcpExhibition exhibition,
			Pagination page);
	
	CcpExhibition queryFrontExhibition(String exhibitionId);

	CcpExhibition queryCcpExhibitionById(String exhibitionId);

	int saveExhibition(CcpExhibition exhibition,SysUser user);

	int deleteExhibition(String exhibitionId, SysUser loginUser);

	List<CcpExhibition> queryCcpManagerExhibition(String exhibitionId,
			Pagination page);

	int update(CcpExhibition exhibition,SysUser user);


	



}
