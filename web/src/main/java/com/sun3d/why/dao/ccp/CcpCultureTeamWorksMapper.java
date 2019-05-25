package com.sun3d.why.dao.ccp;

import java.util.List;
import java.util.Map;

import com.sun3d.why.model.ccp.CcpCultureTeam;
import com.sun3d.why.model.ccp.CcpCultureTeamWorks;

public interface CcpCultureTeamWorksMapper {
    int deleteByPrimaryKey(String cultureTeamWorksId);

    int insert(CcpCultureTeamWorks record);

    CcpCultureTeamWorks selectByPrimaryKey(String cultureTeamWorksId);

    int update(CcpCultureTeamWorks record);
    
    int deleteByCultureTeamId(String cultureTeamId);
    
    List<CcpCultureTeamWorks> queryCultureTeamWorksByCondition(Map<String, Object> map);

	List<CcpCultureTeamWorks> queryUserByCultureTeamIdList(String cultureTeamId);
}