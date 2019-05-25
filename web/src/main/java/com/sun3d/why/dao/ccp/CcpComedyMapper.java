package com.sun3d.why.dao.ccp;

import java.util.List;

import com.sun3d.why.model.ccp.CcpComedy;

public interface CcpComedyMapper {
    int deleteByPrimaryKey(String userId);

    int insert(CcpComedy record);

    CcpComedy selectByPrimaryKey(String userId);

    int update(CcpComedy record);

    List<CcpComedy> queryComedyList(CcpComedy record);
}