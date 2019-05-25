package com.sun3d.why.service;

import java.util.List;

import com.culturecloud.model.bean.drama.CcpDramaComment;
import com.sun3d.why.dao.dto.CcpDramaCommentDto;
import com.sun3d.why.util.Pagination;

public interface CcpDramaCommentService {
	
	public List<CcpDramaCommentDto> queryDramaCommentByCondition(CcpDramaComment comment, Pagination page);

	public int updateDramaComment(CcpDramaComment comment);
}
