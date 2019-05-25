package com.sun3d.why.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sun3d.why.dao.BpReportMapper;
import com.sun3d.why.dao.SysDictMapper;
import com.sun3d.why.model.CmsReport;
import com.sun3d.why.model.SysDict;
import com.sun3d.why.service.BpReportService;
import com.sun3d.why.util.Pagination;

@Service
public class BpReportServiceImpl implements BpReportService {

	@Autowired
	private BpReportMapper bpReportMapper;
	
	@Autowired
	private SysDictMapper sysDictMapper;
	
	@Override
	public List<CmsReport> queryReportList(CmsReport cmsReport, String content, Pagination page) {
		Map<String, Object> map = new HashMap<String, Object>();
		// 举报内容
		if (content != null && StringUtils.isNotBlank(content)) {
			map.put("content", "%" + content + "%");
		}
		// 分页
		if (page != null && page.getFirstResult() != null && page.getRows() != null) {
			map.put("firstResult", page.getFirstResult());
			map.put("rows", page.getRows());
		}
		int total = bpReportMapper.queryReportInformationByCount(map);
		// 设置分页的总条数来获取总页数
		page.setTotal(total);
		List<CmsReport> list = bpReportMapper.queryReportInformationByContent(map);

		// 查询举报类别名
		for (CmsReport c : list) {
			String reportTypeNames = "";
			if (c.getReportType() != null) {
				String[] ids = c.getReportType().split(",");
				for (String s : ids) {
					SysDict sysDict = sysDictMapper.querySysDictByDictId(s);
					if (sysDict.getDictName().equals("其他") && StringUtils.isNotBlank(c.getReportContent())) {
						reportTypeNames += "其他（" + c.getReportContent() + "）；";
					} else {
						reportTypeNames += sysDict.getDictName() + "；";
					}
				}
				c.setReportTypeName(reportTypeNames.substring(0, reportTypeNames.length() - 1));
			}
		}
		return list;
	}

}
