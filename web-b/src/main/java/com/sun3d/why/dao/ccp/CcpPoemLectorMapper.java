package com.sun3d.why.dao.ccp;

import java.util.List;
import java.util.Map;

import com.sun3d.why.model.ccp.CcpNyImg;
import com.sun3d.why.model.ccp.CcpPoemLector;

public interface CcpPoemLectorMapper {
    int deleteByPrimaryKey(String lectorId);

    int insert(CcpPoemLector record);

    CcpPoemLector selectByPrimaryKey(String lectorId);

    int update(CcpPoemLector record);

    int queryPoemLectorCountByCondition(Map<String, Object> map);
    
    List<CcpPoemLector> queryPoemLectorByCondition(Map<String, Object> map);
}