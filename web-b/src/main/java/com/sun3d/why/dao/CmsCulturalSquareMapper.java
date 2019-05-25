package com.sun3d.why.dao;

import java.util.List;
import java.util.Map;

import com.sun3d.why.model.CmsCulturalSquare;

public interface CmsCulturalSquareMapper {
    int deleteByPrimaryKey(String squareId);

    int insert(CmsCulturalSquare record);

    CmsCulturalSquare selectByPrimaryKey(String squareId);

    int update(CmsCulturalSquare record);

    int deleteByOutId(String outId);

	List<CmsCulturalSquare> queryCulturalSquareByCondition(Map<String, Object> map);
	
	List<CmsCulturalSquare> querySquareInformList(Map<String, Object> map);

	int querySquareInformCount(Map<String, Object> map);

	int querySquareCheckCount(Map<String, Object> map);

	List<CmsCulturalSquare> querySquareCheckList(Map<String, Object> map);

}