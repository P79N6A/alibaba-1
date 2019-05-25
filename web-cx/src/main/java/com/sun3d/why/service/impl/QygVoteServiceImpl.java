package com.sun3d.why.service.impl;

import java.util.Date;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.sun3d.why.dao.QygProjectEntryMapper;
import com.sun3d.why.dao.QygUserMapper;
import com.sun3d.why.dao.QygVoteMapper;
import com.sun3d.why.model.qyg.QygUser;
import com.sun3d.why.model.qyg.QygVote;
import com.sun3d.why.service.QygVoteService;
import com.sun3d.why.util.UUIDUtils;
@Service
@Transactional
public class QygVoteServiceImpl implements QygVoteService {
	
	@Autowired
	private QygVoteMapper qygVoteMapper;
	@Autowired
	private QygUserMapper userMapper;
	@Autowired
	private QygProjectEntryMapper projectEntryMapper;

	@Override
	public String saveQygVote(QygVote vo) {
		
		QygUser user= userMapper.selectByPrimaryKey(vo.getUserId());
		
		if(user==null){	//第一次投票
			return "100";
		}
		int todayVoteCount = qygVoteMapper.queryTodayVoteCount(vo);
		
		if(todayVoteCount>0){
			return "repeat";
		}
		vo.setVoteId(UUIDUtils.createUUId());
		vo.setCreateTime(new Date());
		int count = projectEntryMapper.insertVote(vo);
		if (count > 0) {
				return "200";
		}else{
			return "500";
		}
	}
}
