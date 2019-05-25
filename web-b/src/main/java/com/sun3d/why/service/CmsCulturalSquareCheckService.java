package com.sun3d.why.service;

import java.util.List;

import com.culturecloud.model.bean.square.CmsCulturalSquare;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.util.Pagination;

public interface CmsCulturalSquareCheckService {

	List<CmsCulturalSquare> querySquareList(Pagination page,
			CmsCulturalSquare cmsCulturalSquare);

	int setMessageTop(CmsCulturalSquare cmsCulturalSquare, SysUser sysUser);

	CmsCulturalSquare queryCulturalSquareById(String squareId);

	int update(CmsCulturalSquare cmsCulturalSquare);

}
