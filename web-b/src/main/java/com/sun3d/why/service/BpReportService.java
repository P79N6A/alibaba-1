package com.sun3d.why.service;

import java.util.List;

import com.sun3d.why.model.CmsReport;
import com.sun3d.why.util.Pagination;

public interface BpReportService {

	/**
	 * 举报信息列表 
	 * @param cmsReport  举报信息对象
	 * @param content 内容
	 * @param page	分页信息
	 * @return
	 */
	List<CmsReport> queryReportList(CmsReport cmsReport, String content, Pagination page);

}
