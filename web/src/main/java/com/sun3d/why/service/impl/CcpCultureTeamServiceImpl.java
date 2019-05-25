package com.sun3d.why.service.impl;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.sun3d.why.dao.ccp.CcpCultureTeamMapper;
import com.sun3d.why.dao.ccp.CcpCultureTeamVoteMapper;
import com.sun3d.why.dao.ccp.CcpCultureTeamWorksMapper;
import com.sun3d.why.dao.ccp.CcpCultureTeamUserMapper;
import com.sun3d.why.dao.dto.CcpCultureTeamDto;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.model.ccp.CcpCultureTeam;
import com.sun3d.why.model.ccp.CcpCultureTeamVote;
import com.sun3d.why.model.ccp.CcpCultureTeamWorks;
import com.sun3d.why.model.ccp.CcpCultureTeamUser;
import com.sun3d.why.service.CcpCultureTeamService;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.PaginationApp;
import com.sun3d.why.util.UUIDUtils;

@Service
@Transactional
public class CcpCultureTeamServiceImpl implements CcpCultureTeamService {

	private Logger logger = Logger.getLogger(CcpCultureTeamServiceImpl.class);
    @Autowired
    private CcpCultureTeamMapper ccpCultureTeamMapper;
    @Autowired
    private CcpCultureTeamWorksMapper ccpCultureTeamWorksMapper;
    @Autowired
    private CcpCultureTeamVoteMapper ccpVoteMapper;
    @Autowired
    private CcpCultureTeamUserMapper ccpUserMapper;
    @Autowired
    private HttpSession session;

	@Override
	public List<CcpCultureTeam> queryCultureTeamByCondition(CcpCultureTeam ccpCultureTeam, Pagination page) {
		Map<String, Object> map = new HashMap<String, Object>();
		if (ccpCultureTeam != null) {
            if (StringUtils.isNotBlank(ccpCultureTeam.getCultureTeamName())){
                map.put("cultureTeamName", "%" + ccpCultureTeam.getCultureTeamName() + "%");
            }
            if (StringUtils.isNotBlank(ccpCultureTeam.getCultureTeamId())){
                map.put("cultureTeamId", ccpCultureTeam.getCultureTeamId());
            }
            if (ccpCultureTeam.getCultureTeamType() != null){
            	map.put("cultureTeamType", ccpCultureTeam.getCultureTeamType());
            }
        }
		//分页
        if (page != null && page.getFirstResult() != null && page.getRows() != null) {
            map.put("firstResult", page.getFirstResult());
            map.put("rows", page.getRows());
            int total = ccpCultureTeamMapper.queryCultureTeamCountByCondition(map);
            page.setTotal(total);
        }
        return ccpCultureTeamMapper.queryCultureTeamByCondition(map);
	}

	@Override
	public String saveOrUpdateCultureTeam(CcpCultureTeam vo) {
		try {
			int result = 1;
			SysUser sysUser = (SysUser) session.getAttribute("user");
			if(sysUser != null){
				CcpCultureTeam ccpCultureTeam = ccpCultureTeamMapper.selectByPrimaryKey(vo.getCultureTeamId());
				if(ccpCultureTeam!=null){
					vo.setCultureTeamFamily(vo.getCultureTeamFamily()!=null?vo.getCultureTeamFamily():"");
					vo.setCultureTeamRule(vo.getCultureTeamRule()!=null?vo.getCultureTeamRule():"");
					vo.setCultureTeamAddressUrl(vo.getCultureTeamAddressUrl()!=null?vo.getCultureTeamAddressUrl():"");
					vo.setCultureTeamPrize(vo.getCultureTeamPrize()!=null?vo.getCultureTeamPrize():"");
					vo.setCultureTeamMedia(vo.getCultureTeamMedia()!=null?vo.getCultureTeamMedia():"");
					result = ccpCultureTeamMapper.update(vo);
				}else{
					vo.setCultureTeamId(UUIDUtils.createUUId());
					vo.setCreateTime(new Date());
					vo.setCreateUser(sysUser.getUserId());
					result = ccpCultureTeamMapper.insert(vo);
				}
				if(result == 1){
					ccpCultureTeamWorksMapper.deleteByCultureTeamId(vo.getCultureTeamId());
					
					if(vo.getWorksNames()!=null){
						int sort = 0;
						for(int i=0;i<vo.getWorksNames().length;i++){
							if(StringUtils.isNotBlank(vo.getWorksNames()[i])){
								sort++;
								CcpCultureTeamWorks ccpCultureTeamWorks = new CcpCultureTeamWorks();
								ccpCultureTeamWorks.setCultureTeamWorksId(UUIDUtils.createUUId());
								ccpCultureTeamWorks.setCultureTeamId(vo.getCultureTeamId());
								ccpCultureTeamWorks.setWorksName(vo.getWorksNames()[i]);
								if(vo.getWorksManuscripts().length>0){
									ccpCultureTeamWorks.setWorksManuscript(vo.getWorksManuscripts()[i]);
								}
								if(vo.getWorksStages().length>0){
									ccpCultureTeamWorks.setWorksStage(vo.getWorksStages()[i]);
								}
								ccpCultureTeamWorks.setWorksSort(sort);
								ccpCultureTeamWorks.setCreateTime(new Date());
								ccpCultureTeamWorksMapper.insert(ccpCultureTeamWorks);
							}
						}
					}
				    return  "200";
				}else{
				    return  "500";
				}
			}else{
				return  "500";
			}
		} catch (Exception e) {
			e.printStackTrace();
			return  "500";
		}
	}

	@Override
	public CcpCultureTeamDto queryCultureTeamByPrimaryKey(String cultureTeamId) {
		CcpCultureTeamDto ccpCultureTeam = ccpCultureTeamMapper.selectByPrimaryKey(cultureTeamId);
		return ccpCultureTeam;
	}

	@Override
	public List<CcpCultureTeamWorks> queryCultureTeamWorksByCondition(String cultureTeamId) {
		Map<String, Object> map = new HashMap<String, Object>();
		if (StringUtils.isNotBlank(cultureTeamId)){
            map.put("cultureTeamId", cultureTeamId);
        }
		List<CcpCultureTeamWorks> worksList = ccpCultureTeamWorksMapper.queryCultureTeamWorksByCondition(map);
		return worksList;
	}

	@Override
	public String deleteCultureTeam(String cultureTeamId) {
		int result = 1;
		result = ccpCultureTeamMapper.deleteByPrimaryKey(cultureTeamId);
		if(result == 1){
			ccpCultureTeamWorksMapper.deleteByCultureTeamId(cultureTeamId);
			return  "200";
		}else{
		    return  "500";
		}
	}

	@Override
	public List<CcpCultureTeamDto> queryWcCultureTeamByCondition(CcpCultureTeamDto ccpCultureTeam, PaginationApp page) {
		Map<String, Object> map = new HashMap<String, Object>();
		if (ccpCultureTeam != null) {
            if (StringUtils.isNotBlank(ccpCultureTeam.getCultureTeamId())){
                map.put("cultureTeamId", ccpCultureTeam.getCultureTeamId());
            }
            if (ccpCultureTeam.getCultureTeamType() != null){
            	map.put("cultureTeamType", ccpCultureTeam.getCultureTeamType());
            }
            if (ccpCultureTeam.getReviewType() != null){
            	map.put("reviewType", ccpCultureTeam.getReviewType());
            }
            if(ccpCultureTeam.getUserId() != null){
            	map.put("userId", ccpCultureTeam.getUserId());
            }
        }
		//分页
        if (page != null && page.getFirstResult() != null && page.getRows() != null) {
            map.put("firstResult", page.getFirstResult());
            map.put("rows", page.getRows());
        }
        return ccpCultureTeamMapper.queryWcCultureTeamByCondition(map);
	}

	//浦东投票
	@Override
	public String saveVote(CcpCultureTeamVote vote) {
		
		CcpCultureTeamUser user=ccpUserMapper.selectByPrimaryKey(vote.getUserId());
        int todayVoteCount = ccpVoteMapper.queryTodayVoteCount(vote);
		
		if(todayVoteCount>0){
			return "repeat";
		}
		vote.setVoteId(UUIDUtils.createUUId());
		vote.setCreateTime(new Date());
		int count = ccpVoteMapper.insert(vote);
		if (count > 0) {
			if(user==null){//判断是否是第一次登录
				return "100";
			}else {
				return "200";
			}
		}else{
			return "500";
		}
		
		
	}

	@Override
	public int insertUserMessage(CcpCultureTeamUser user) {
		user.setCreateTime(new Date());
		return ccpUserMapper.insertSelective(user);
	}


	@Override
	public List<CcpCultureTeamWorks> queryUserByCultureTeamIdList(
			String cultureTeamId) {
		return ccpCultureTeamWorksMapper.queryUserByCultureTeamIdList(cultureTeamId);
	}
}
