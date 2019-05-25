package com.sun3d.why.dao.ccp;

import java.util.List;

import com.sun3d.why.model.ccp.CcpPoemLector;

public interface CcpPoemLectorMapper {
    int deleteByPrimaryKey(String lectorId);

    int insert(CcpPoemLector record);

    CcpPoemLector selectByPrimaryKey(String lectorId);

    int update(CcpPoemLector record);
    
    List<CcpPoemLector> queryAllPoemLector();

}