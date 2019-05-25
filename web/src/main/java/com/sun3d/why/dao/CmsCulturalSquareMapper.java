package com.sun3d.why.dao;

import java.util.List;
import java.util.Map;
import com.sun3d.why.dao.dto.CmsCulturalSquareDto;



public interface CmsCulturalSquareMapper {
    int deleteByPrimaryKey(String squareId);

    int insert(CmsCulturalSquareDto record);

    CmsCulturalSquareDto selectByPrimaryKey(String squareId);

    int update(CmsCulturalSquareDto record);

    List<CmsCulturalSquareDto> queryCulturalSquareByCondition(Map<String,Object> map);
    
    int deleteByOutId(String outId);
}