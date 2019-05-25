package com.sun3d.why.service;

import java.util.List;

import com.culturecloud.model.bean.vote.CcpVote;
import com.culturecloud.model.bean.vote.CcpVoteUser;
import com.sun3d.why.dao.dto.CcpVoteDto;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.util.Pagination;

public interface CcpVoteService {

	 List<CcpVoteDto> queryVoteByCondition(CcpVote vote, Pagination page);
	 
	 int saveCcpVote(CcpVote vote,SysUser user);
	 
	 CcpVote queryCcpVoteById(String voteId);

	List<CcpVoteUser> userList(String voteId, Pagination page,
			CcpVoteUser voteUser);
}
