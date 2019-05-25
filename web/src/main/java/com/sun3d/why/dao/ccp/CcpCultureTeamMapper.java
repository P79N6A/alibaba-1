package com.sun3d.why.dao.ccp;

import java.util.List;
import java.util.Map;

import com.sun3d.why.dao.dto.CcpCultureTeamDto;
import com.sun3d.why.model.ccp.CcpCultureTeam;

public interface CcpCultureTeamMapper {
    int deleteByPrimaryKey(String cultureTeamId);

    int insert(CcpCultureTeam record);

    CcpCultureTeamDto selectByPrimaryKey(String cultureTeamId);

    int update(CcpCultureTeam record);
    
    int queryCultureTeamCountByCondition(Map<String, Object> map);
	
	List<CcpCultureTeam> queryCultureTeamByCondition(Map<String, Object> map);
	
	List<CcpCultureTeamDto> queryWcCultureTeamByCondition(Map<String, Object> map);

}