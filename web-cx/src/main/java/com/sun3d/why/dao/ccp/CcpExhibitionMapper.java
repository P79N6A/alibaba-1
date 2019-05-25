package com.sun3d.why.dao.ccp;

import java.util.List;
import java.util.Map;

import com.sun3d.why.model.ccp.CcpExhibition;

public interface CcpExhibitionMapper {
    int deleteByPrimaryKey(String exhibitionId);

    int insert(CcpExhibition record);

    CcpExhibition selectByPrimaryKey(String exhibitionId);

    int update(CcpExhibition record);

	int queryExhibitionListByCondition(Map<String, Object> map);

	List<CcpExhibition> queryCcpExhibitionListByCondition(
			Map<String, Object> map);

	int queryCcpManagerExhibitionCount(Map<String, Object> map);

	List<CcpExhibition> queryManagerExhibition(Map<String, Object> map);


}