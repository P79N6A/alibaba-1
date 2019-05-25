package com.sun3d.why.dao;

import java.util.List;
import java.util.Map;

import com.sun3d.why.model.CmsReport;

public interface BpReportMapper {

	/**
	 * 查询出举报信息总数
	 * @param map	查询条件
	 * @return
	 */
	int queryReportInformationByCount(Map<String, Object> map);

	/**
	 * 根据分页条件查询出当前页数据
	 * @param map	查询条件
	 * @return
	 */
	List<CmsReport> queryReportInformationByContent(Map<String, Object> map);

}
