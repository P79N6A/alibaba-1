package com.sun3d.why.service;

import java.util.List;

import com.culturecloud.model.bean.vote.CcpVoteItem;
import com.sun3d.why.dao.dto.CcpVoteItemDto;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.util.Pagination;

public interface CcpVoteItemService {
	
	List<CcpVoteItemDto> queryCcpVoteItems(String voteItemId, Pagination page);
	
	int saveCcpVoteItem(CcpVoteItem item, SysUser loginUser);
	
	CcpVoteItem queryVoteItemById(String voteItemId);
}
