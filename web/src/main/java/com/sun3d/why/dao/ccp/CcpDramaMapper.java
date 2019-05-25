package com.sun3d.why.dao.ccp;

import java.util.List;

import com.sun3d.why.model.ccp.CcpDrama;

public interface CcpDramaMapper {
    int deleteByPrimaryKey(String dramaId);

    int insert(CcpDrama record);

    CcpDrama selectByPrimaryKey(String dramaId);

    int update(CcpDrama record);
    
    List<CcpDrama> queryCcpDramalist(CcpDrama vo);

}