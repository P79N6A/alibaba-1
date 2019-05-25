package com.sun3d.why.service;

import java.util.List;

import com.sun3d.why.dao.dto.CcpCultureTeamDto;
import com.sun3d.why.model.ccp.CcpCultureTeam;
import com.sun3d.why.model.ccp.CcpCultureTeamVote;
import com.sun3d.why.model.ccp.CcpCultureTeamWorks;
import com.sun3d.why.model.ccp.CcpCultureTeamUser;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.PaginationApp;

public interface CcpCultureTeamService {

	/**
	 * 浦东文化社团评选列表
	 * @param ccpAssociation
	 * @param page
	 * @return
	 */
	List<CcpCultureTeam> queryCultureTeamByCondition(CcpCultureTeam ccpCultureTeam, Pagination page);
	
	/**
	 * 根据ID查团体信息
	 * @param cultureTeamId
	 * @return
	 */
	CcpCultureTeamDto queryCultureTeamByPrimaryKey(String cultureTeamId);
	
	/**
	 * 保存或更新团体
	 * @param ccpCultureTeam
	 * @return
	 */
	String saveOrUpdateCultureTeam(CcpCultureTeam ccpCultureTeam);
	
	/**
	 * 删除团体
	 * @param cultureTeamId
	 * @return
	 */
	String deleteCultureTeam(String cultureTeamId);
	
	/**
	 * 浦东文化社团作品评选列表
	 * @param ccpAssociation
	 * @param page
	 * @return
	 */
	List<CcpCultureTeamWorks> queryCultureTeamWorksByCondition(String cultureTeamId);
	
	/**
	 * 浦东文化社团评选H5列表
	 * @param ccpAssociation
	 * @param page
	 * @return
	 */
	List<CcpCultureTeamDto> queryWcCultureTeamByCondition(CcpCultureTeamDto ccpCultureTeam, PaginationApp page);

	String saveVote(CcpCultureTeamVote vote);

	int insertUserMessage(CcpCultureTeamUser user);

	List<CcpCultureTeamWorks> queryUserByCultureTeamIdList(String cultureTeamId);
}
