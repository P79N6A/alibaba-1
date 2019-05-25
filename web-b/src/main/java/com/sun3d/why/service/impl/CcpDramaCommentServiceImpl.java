package com.sun3d.why.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.culturecloud.model.bean.drama.CcpDramaComment;
import com.sun3d.why.dao.CcpDramaCommentMapper;
import com.sun3d.why.dao.dto.CcpDramaCommentDto;
import com.sun3d.why.service.CcpDramaCommentService;
import com.sun3d.why.util.Pagination;


@Service
@Transactional
public class CcpDramaCommentServiceImpl implements CcpDramaCommentService {
	
	@Autowired
	private CcpDramaCommentMapper dramaCommentMapper;

	@Override
	public List<CcpDramaCommentDto> queryDramaCommentByCondition(CcpDramaComment comment, Pagination page) {

		Map<String, Object> map = new HashMap<>();

		String dramaId = comment.getDramaId();
		String dramaCommentRemark= comment.getDramaCommentRemark();

		if (StringUtils.isNotBlank(dramaId)) {

			map.put("dramaId", dramaId);
		}
		
		if(StringUtils.isNotBlank(dramaCommentRemark)){
			
			map.put("dramaCommentRemark", dramaCommentRemark.trim());
		}
		
		if(page!=null){
			map.put("firstResult", page.getFirstResult());
			map.put("rows", page.getRows());
			
			int total = dramaCommentMapper.queryDramaCommentCountByCondition(map);

			// 设置分页的总条数来获取总页数
			page.setTotal(total);
			page.setRows(page.getRows());
		}

		List<CcpDramaCommentDto> list = dramaCommentMapper.queryDramaCommentByCondition(map);

		return list;
	}

	@Override
	public int updateDramaComment(CcpDramaComment comment) {
		
		return dramaCommentMapper.updateByPrimaryKeySelective(comment);

	}

}
