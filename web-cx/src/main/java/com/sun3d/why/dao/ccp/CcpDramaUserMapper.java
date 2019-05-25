package com.sun3d.why.dao.ccp;

import com.sun3d.why.model.ccp.CcpDramaUser;

public interface CcpDramaUserMapper {
    int deleteByPrimaryKey(String userId);

    int insert(CcpDramaUser record);

    CcpDramaUser selectByPrimaryKey(String userId);

    int update(CcpDramaUser record);

}