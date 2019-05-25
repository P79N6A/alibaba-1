package com.sun3d.why.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.culturecloud.model.bean.culture.CcpCultureContestAnswer;
import com.sun3d.why.dao.CcpCultureContestAnswerMapper;
import com.sun3d.why.dao.dto.CcpCultureContestAnswerDto;
import com.sun3d.why.service.CcpCultureContestAnswerService;

@Service
@Transactional
public class CcpCultureContestAnswerServiceImpl implements CcpCultureContestAnswerService {

	@Autowired
	private CcpCultureContestAnswerMapper cultureContestAnswerMapper;

	@Override
	public List<CcpCultureContestAnswer> queryCcpCultureContestAnswerByUser(String userId, Integer stageNumber) {

		return cultureContestAnswerMapper.queryUserContestAnswerList(userId, stageNumber);
	}

	@Override
	public int updateCcpCultureContestAnswer(CcpCultureContestAnswer answer) {
		
		return cultureContestAnswerMapper.updateByPrimaryKeySelective(answer);
	}

	@Override
	public CcpCultureContestAnswer queryCcpCultureContestAnswerById(String cultureAnswerId) {
		return cultureContestAnswerMapper.selectByPrimaryKey(cultureAnswerId);
	}

	@Override
	public List<CcpCultureContestAnswerDto> queryAnswerRanking(String cultureUserId, Integer stageNumber,String answerId,Integer groupType,Integer limit) {
		
		 Map<String, Object> map=new HashMap<>();
		 
		 if(StringUtils.isNotBlank(cultureUserId)){
			 map.put("cultureUserId", cultureUserId);
		 }
		 if(stageNumber!=null){
			 map.put("stageNumber", stageNumber);
		 }
		 if(StringUtils.isNotBlank(answerId)){
			 map.put("answerId", answerId);
		 }
		 
		 if(groupType!=null){
			 map.put("userGroupType", groupType);
		 }
		 
		 if(limit!=null){
			 map.put("limit", limit);
		 }
		 
		return  cultureContestAnswerMapper.queryAnswerRanking(map);
	}

	@Override
	public List<CcpCultureContestAnswerDto> queryAnswerSumRanking(String cultureUserId, Integer stageNumber,
			String answerId, Integer groupType,Integer limit) {
		
		 Map<String, Object> map=new HashMap<>();
		 
		 if(StringUtils.isNotBlank(cultureUserId)){
			 map.put("cultureUserId", cultureUserId);
		 }
		
		 if(StringUtils.isNotBlank(answerId)){
			 map.put("answerId", answerId);
		 }
		 
		 if(groupType!=null){
			 map.put("userGroupType", groupType);
		 }
		 
		 if(limit!=null){
			 map.put("limit", limit);
		 }
		 
		return  cultureContestAnswerMapper.queryAnswerSumRanking(map);
	}

}
