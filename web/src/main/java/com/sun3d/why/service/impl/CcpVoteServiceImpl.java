package com.sun3d.why.service.impl;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.culturecloud.model.bean.vote.CcpVote;
import com.culturecloud.model.bean.vote.CcpVoteUser;
import com.sun3d.why.dao.CcpVoteMapper;
import com.sun3d.why.dao.CcpVoteUserMapper;
import com.sun3d.why.dao.dto.CcpVoteDto;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.service.CcpVoteService;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.UUIDUtils;

@Service
public class CcpVoteServiceImpl implements CcpVoteService {

	@Autowired
	private CcpVoteMapper ccpVoteMapper;
	
	@Autowired
	private CcpVoteUserMapper userMapper;

	@Override
	public List<CcpVoteDto> queryVoteByCondition(CcpVote vote, Pagination page) {

		Map<String, Object> map = new HashMap<String, Object>();

		map.put("voteIsDel", 1);
		
		if(vote.getVoteCreateUser()!=null){
			map.put("voteCreateUser", vote.getVoteCreateUser());
		}

		// 分页
		if (page != null && page.getFirstResult() != null && page.getRows() != null) {
			map.put("firstResult", page.getFirstResult());
			map.put("rows", page.getRows());
			int total = ccpVoteMapper.queryVoteCountByCondition(map);
			page.setTotal(total);
		}

		List<CcpVoteDto> list = ccpVoteMapper.queryVoteByCondition(map);

		return list;
	}

	@Override
	public int saveCcpVote(CcpVote vote, SysUser user) {

		int result = 0;

		String voteId = vote.getVoteId();

		if (StringUtils.isBlank(voteId)) {

			vote.setVoteId(UUIDUtils.createUUId());
			vote.setVoteIsDel(1);
			vote.setVoteCreateTime(new Date());
			vote.setVoteUpdateTime(new Date());
			vote.setVoteCreateUser(user.getUserId());
			vote.setVoteUpdateUser(user.getUserId());
			result = ccpVoteMapper.insert(vote);

		} else {

			vote.setVoteUpdateTime(new Date());
			vote.setVoteUpdateUser(user.getUserId());

			result = ccpVoteMapper.updateByPrimaryKeySelective(vote);

		}

		return result;
	}

	@Override
	public CcpVote queryCcpVoteById(String voteId) {
		return ccpVoteMapper.selectByPrimaryKey(voteId);
	}

	@Override
	public List<CcpVoteUser> userList(String voteId, Pagination page,
			CcpVoteUser voteUser) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("voteId", voteId);
		if(StringUtils.isNotBlank(voteUser.getUserName())){
			map.put("userName",voteUser.getUserName());
		}
		  //分页
	     if (page != null && page.getFirstResult() != null && page.getRows() != null) {
		   map.put("firstResult", page.getFirstResult());
	       map.put("rows", page.getRows());
	       int total = userMapper.queryUserList(map);
	       page.setTotal(total);
	     }
     
	     List<CcpVoteUser> userList=userMapper.queryUserMessage(map);
	
	     return userList;
		
	}

}
