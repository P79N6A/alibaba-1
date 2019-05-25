package com.culturecloud.service.local.impl.micronote;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Transactional;

import com.culturecloud.bean.BasePageResultListVO;
import com.culturecloud.dao.micronote.CcpMicronoteMapper;
import com.culturecloud.dao.micronote.CcpMicronoteVoteMapper;
import com.culturecloud.enumeration.common.IntegralTypeEnum;
import com.culturecloud.model.bean.micronote.CcpMicronote;
import com.culturecloud.model.bean.micronote.CcpMicronoteVote;
import com.culturecloud.model.request.micronote.CcpMicronoteReqVO;
import com.culturecloud.model.request.micronote.CcpMicronoteVoteReqVO;
import com.culturecloud.model.response.micronote.CcpMicronoteResVO;
import com.culturecloud.service.BaseService;
import com.culturecloud.service.local.common.SysUserIntegralService;
import com.culturecloud.service.local.micronote.CcpMicronoteService;

@Service
public class CcpMicronoteServiceImpl implements CcpMicronoteService{
	
	@Resource
	private CcpMicronoteMapper ccpMicronoteMapper;
	@Resource
	private CcpMicronoteVoteMapper ccpMicronoteVoteMapper;
	@Resource
	private SysUserIntegralService sysUserIntegralService;
	@Resource
	private BaseService baseService;
	
	@Override
	public BasePageResultListVO<CcpMicronoteResVO> getMicronoteList(CcpMicronoteReqVO request) {
		List<CcpMicronoteResVO> list = ccpMicronoteMapper.selectMicronoteList(request);
		int sum = ccpMicronoteMapper.selectMicronoteListCount(request);
		BasePageResultListVO<CcpMicronoteResVO> basePageResultListVO = new BasePageResultListVO<CcpMicronoteResVO>(list, sum);
		basePageResultListVO.setResultSize(request.getResultSize());
		basePageResultListVO.setResultIndex(request.getResultIndex());
		basePageResultListVO.setResultFirst(request.getResultFirst());
		return basePageResultListVO;
	}
	
	@Override
	public List<CcpMicronoteResVO> getMicronoteRankingList(CcpMicronoteReqVO request) {
		return ccpMicronoteMapper.selectMicronoteRankingList(request);
	}

	@Override
	public CcpMicronoteResVO getMicronoteByCondition(CcpMicronoteReqVO request) {
		CcpMicronoteResVO ccpMicronoteResVO = ccpMicronoteMapper.selectMicronoteByCondition(request);
		if(ccpMicronoteResVO!=null){
			int ranking = ccpMicronoteMapper.selectRankingByVoteCount(ccpMicronoteResVO.getVoteCount());
			ccpMicronoteResVO.setRanking(ranking);
		}
		return ccpMicronoteResVO;
	}

	@Override
	public void deleteMicronote(CcpMicronoteReqVO request) {
		ccpMicronoteMapper.deleteByPrimaryKey(request.getNoteId());
	}

	@Override
	@Transactional(isolation=Isolation.SERIALIZABLE)
	public void voteMicronote(CcpMicronoteVoteReqVO request) {
		int count = ccpMicronoteVoteMapper.countUserTodayVote(request);
		if(count==0){
			ccpMicronoteVoteMapper.insert(request);
			sysUserIntegralService.insertUserIntegral(request.getUserId(), 1, 0, "用户投票微笔记大赛", IntegralTypeEnum.TGB_VOTE.getIndex());
		}
	}

	@Override
	@Transactional(isolation=Isolation.SERIALIZABLE)
	public int saveMicronote(CcpMicronoteReqVO request) {
		CcpMicronoteReqVO vo = new CcpMicronoteReqVO();
		vo.setUserId(request.getCreateUser());
		CcpMicronoteResVO res = getMicronoteByCondition(vo);
		if(res==null){
			ccpMicronoteMapper.insert(request);
			sysUserIntegralService.insertUserIntegral(request.getCreateUser(), 500, 0, "用户参与微笔记大赛", IntegralTypeEnum.TGB_JOIN.getIndex());
			return 1;
		}else{
			return 0;
		}
	}
	
}
