package com.sun3d.why.dao.ccp;

import java.util.List;
import java.util.Map;

import com.sun3d.why.model.ccp.CcpExhibitionPage;

public interface CcpExhibitionPageMapper {
	Integer deleteByPrimaryKey(String pageId);

    Integer insert(CcpExhibitionPage record);

    CcpExhibitionPage selectByPrimaryKey(String pageId);

    Integer update(CcpExhibitionPage record);
    
    List<CcpExhibitionPage> queryCcpExhibitionPageListByCondition(Map<String, Object> map);


    Integer queryInsidePages(Map<String, Object> map); 
	

	Integer queryCcpExhibitionPageCountByCondition(Map<String, Object> map);
    
    Integer queryCcpExhibitionPageSort(String exhibitionId);



}