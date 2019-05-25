package com.sun3d.why.service;

import java.util.List;

import com.sun3d.why.model.SysUser;
import com.sun3d.why.model.ccp.CcpExhibitionPage;
import com.sun3d.why.util.Pagination;

public interface CcpExhibitionPageService {

	List<CcpExhibitionPage> queryCcpExhibitionPage( String exhibitionId,
			Pagination page);
	
	Integer deleteExhibition(String pageId, SysUser loginUser);

	Integer saveExhibitionPage(CcpExhibitionPage exhibition,String exhibitionId, SysUser user,Integer pageType);

	Integer updateExhibitionPage(CcpExhibitionPage exhibition, SysUser loginUser);

	CcpExhibitionPage queryExhibitionPage(String pageId);
	
	int moveExhibition(String pageId,Integer moveType);
}
