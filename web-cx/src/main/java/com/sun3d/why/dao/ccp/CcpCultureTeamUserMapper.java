package com.sun3d.why.dao.ccp;

import com.sun3d.why.model.ccp.CcpCultureTeamUser;


public interface CcpCultureTeamUserMapper {
    int deleteByPrimaryKey(String userId);

    int insert(CcpCultureTeamUser record);

    int insertSelective(CcpCultureTeamUser record);

    CcpCultureTeamUser selectByPrimaryKey(String userId);

    int updateByPrimaryKeySelective(CcpCultureTeamUser record);

    int updateByPrimaryKey(CcpCultureTeamUser record);
}