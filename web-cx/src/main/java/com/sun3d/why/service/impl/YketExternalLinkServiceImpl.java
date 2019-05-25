package com.sun3d.why.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sun3d.why.common.Result;
import com.sun3d.why.dao.YketExternalLinkMapper;
import com.sun3d.why.enumeration.RSKeyEnum;
import com.sun3d.why.model.bean.yket.YketExternalLink;
import com.sun3d.why.service.YketExternalLinkService;
import com.sun3d.why.util.Pagination;
@Service
public class YketExternalLinkServiceImpl implements YketExternalLinkService {
	
	@Autowired
	private YketExternalLinkMapper externalLinkMapper;

	@Override
	public List<YketExternalLink> queryYketExternalLink(
			YketExternalLink yketExternalLink, Pagination page) {
		Map<String, Object> map = new HashMap<String, Object>();
		// 分页
		if (page != null && page.getFirstResult() != null && page.getRows() != null) {
			map.put("firstResult", page.getFirstResult());
			map.put("rows", page.getRows());
			int total = this.externalLinkMapper.countYketExternalLink(map);
			page.setTotal(total);
		}
		return this.externalLinkMapper.countYketExternalLinkList(map);
	}

	@Override
	public Result updateExternalLinkById(YketExternalLink yketExternalLink) {
		if(yketExternalLink == null){
			Result.Error().setVal(RSKeyEnum.msg, "该外链不存在！");
		}
		this.externalLinkMapper.updateByPrimaryKeySelective(yketExternalLink);
		
		return Result.Ok();
	}

	@Override
	public YketExternalLink queryExternalLinkById(String id) {
		return this.externalLinkMapper.selectByPrimaryKey(id);
	}

	@Override
	public List<YketExternalLink> queryExternalLinkList() {
		return this.externalLinkMapper.queryExternalLinkList();
	}

}
