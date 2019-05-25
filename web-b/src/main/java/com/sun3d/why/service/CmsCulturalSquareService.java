package com.sun3d.why.service;

import java.util.List;

import com.sun3d.why.model.CmsCulturalSquare;
import com.sun3d.why.util.Pagination;


public interface CmsCulturalSquareService {

	int addSquareInform( CmsCulturalSquare cmsCulturalSquare);

	List<CmsCulturalSquare> querySquareInformList(Pagination page, CmsCulturalSquare cmsCulturalSquare);

	CmsCulturalSquare selectByPrimaryKey(String squareId);

	String updateByPrimaryKeySelective(CmsCulturalSquare cmsCulturalSquare);

	int deleteSquareInform(String squareId);

}
