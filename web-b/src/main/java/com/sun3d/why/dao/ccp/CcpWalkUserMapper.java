package com.sun3d.why.dao.ccp;

import com.sun3d.why.model.ccp.CcpWalkUser;

public interface CcpWalkUserMapper {
    int deleteByPrimaryKey(String userId);

    int insert(CcpWalkUser record);

    CcpWalkUser selectByPrimaryKey(String userId);

    int update(CcpWalkUser record);
    
}