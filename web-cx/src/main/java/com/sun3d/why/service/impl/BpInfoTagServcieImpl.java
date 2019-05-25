package com.sun3d.why.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sun3d.why.dao.BpInfoTagMapper;
import com.sun3d.why.model.BpInfoTag;
import com.sun3d.why.service.BpInfoTagServcie;

@Service
public class BpInfoTagServcieImpl implements BpInfoTagServcie{

	@Autowired
	private BpInfoTagMapper bpInfoTagMapper;
	
	@Override
	public List<BpInfoTag> queryParentTag() {
		return bpInfoTagMapper.queryParentTagsByCode();
	}

	/**
	 * 根据子标签查找兄弟标签
	 * @param infoTagCode
	 * @return
	 */
	@Override
	public List<BpInfoTag> queryChildTagByChildTag(String infoTagCode) {
		return bpInfoTagMapper.queryChildTagsByChildCode(infoTagCode);
	}

	@Override
	public BpInfoTag queryParentTagByCode(String infoTagCode) {
		return bpInfoTagMapper.queryParentTagByCode(infoTagCode);
	}

	@Override
	public List<BpInfoTag> queryChildTags(String parentTagCode) {
		return bpInfoTagMapper.queryChildTagByCode(parentTagCode);
	}

}
