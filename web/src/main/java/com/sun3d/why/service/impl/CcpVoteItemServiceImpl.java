package com.sun3d.why.service.impl;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.culturecloud.model.bean.vote.CcpVoteItem;
import com.sun3d.why.dao.CcpVoteItemMapper;
import com.sun3d.why.dao.dto.CcpVoteItemDto;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.service.CcpVoteItemService;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.UUIDUtils;

@Service
public class CcpVoteItemServiceImpl implements CcpVoteItemService{
	
	@Autowired
	private  CcpVoteItemMapper voteItemMapper;

	@Override
	public List<CcpVoteItemDto> queryCcpVoteItems(String voteId, Pagination page) {
		
		Map<String, Object> map = new HashMap<String, Object>();

		map.put("itemIsDel", 1);
		map.put("voteId", voteId);

		// 分页
		if (page != null && page.getFirstResult() != null && page.getRows() != null) {
			map.put("firstResult", page.getFirstResult());
			map.put("rows", page.getRows());
			int total = voteItemMapper.queryVoteItemCountByCondition(map);
			page.setTotal(total);
		}

		List<CcpVoteItemDto> list = voteItemMapper.queryVoteItemByCondition(map);

		return list;
	}

	@Override
	public int saveCcpVoteItem(CcpVoteItem item, SysUser user) {
		int result = 0;

		String voteItemId = item.getVoteItemId();

		if (StringUtils.isBlank(voteItemId)) {

			item.setVoteItemId(UUIDUtils.createUUId());
			item.setItemIsDel(1);
			item.setItemCreateTime(new Date());
			item.setItemUpdateTime(new Date());
			item.setItemCreateUser(user.getUserId());
			item.setItemUpdateUser(user.getUserId());

			result = voteItemMapper.insert(item);

		} else {

			item.setItemUpdateTime(new Date());
			item.setItemUpdateUser(user.getUserId());

			result = voteItemMapper.updateByPrimaryKeySelective(item);

		}

		return result;
	}

	@Override
	public CcpVoteItem queryVoteItemById(String voteItemId) {
		return voteItemMapper.selectByPrimaryKey(voteItemId);
	}

}
