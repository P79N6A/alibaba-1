package com.sun3d.why.dao;

import java.util.List;
import java.util.Map;

import com.culturecloud.model.bean.square.CmsCulturalSquare;

public interface CmsCulturalSquareCheckMapper {
    int deleteByPrimaryKey(String squareId);

    int insert(CmsCulturalSquare record);

    int insertSelective(CmsCulturalSquare record);

    CmsCulturalSquare selectByPrimaryKey(String squareId);

    int updateByPrimaryKeySelective(CmsCulturalSquare record);

    int updateByPrimaryKey(CmsCulturalSquare record);

	int querySquareCheckCount(Map<String, Object> map);

	List<CmsCulturalSquare> querySquareCheckList(Map<String, Object> map);

	int update(CmsCulturalSquare m);

}