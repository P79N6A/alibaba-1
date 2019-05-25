package com.sun3d.why.service.impl;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.sun3d.why.dao.CmsReportMapper;
import com.sun3d.why.dao.SysDictMapper;
import com.sun3d.why.model.CmsReport;
import com.sun3d.why.model.SysDict;
import com.sun3d.why.service.CmsReportService;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.UUIDUtils;

@Service
@Transactional
public class CmsReportServiceImpl implements CmsReportService {
	@Autowired
	private CmsReportMapper cmsReportMapper;

	@Autowired
	private SysDictMapper sysDictMapper;

    /**
     * 根据举报对象进行查询
     * @param cmsReport 
     * @param page 
     * @return
     */
    @Override
    public List<CmsReport> queryReportInformationByContent(CmsReport cmsReport,String content, Pagination page) {

         Map<String, Object> map = new HashMap<String, Object>();
        //举报内容
        if (content != null && StringUtils.isNotBlank(content)) {
            map.put("content", "%" + content + "%");
        }
        //分页
        if (page != null && page.getFirstResult() != null && page.getRows() != null) {
            map.put("firstResult", page.getFirstResult());
            map.put("rows", page.getRows());
        }
        int total = cmsReportMapper.queryReportInformationByCount(map);
        //设置分页的总条数来获取总页数
        page.setTotal(total);
        List<CmsReport> list = cmsReportMapper.queryReportInformationByContent(map);
        
        //查询举报类别名
        for(CmsReport c : list){
        	String reportTypeNames = "";
        	if(c.getReportType()!=null){
        		String [] ids = c.getReportType().split(",");
            	for(String s : ids){
            		SysDict sysDict = sysDictMapper.querySysDictByDictId(s);
            		if(sysDict.getDictName().equals("其他")&&StringUtils.isNotBlank(c.getReportContent())){
            			reportTypeNames += "其他（" + c.getReportContent() + "）；";
            		}else{
            			reportTypeNames += sysDict.getDictName() + "；";
            		}
            	}
            	c.setReportTypeName(reportTypeNames.substring(0, reportTypeNames.length()-1));
        	}
        }
        return list;
    }

    /**
     * 用户举报接口
     * @param activityId        活动id
     * @param userId            用户id
     * @param reportType        举报类别
     * return 是否报名成功 (成功：success；失败：false)
     */
	@Override
	public String insertReport(String activityId, String userId, String reportType, String reportContent) {
		CmsReport cmsReport = new CmsReport();
		cmsReport.setReportId(UUIDUtils.createUUId());
		cmsReport.setReportTime(new Date());
 		if (StringUtils.isNotBlank(activityId)) {
			cmsReport.setReportActivityId(activityId);
	    }
	    if (StringUtils.isNotBlank(userId)) {
	    	cmsReport.setReportUserId(userId);
	    }
	    if (StringUtils.isNotBlank(reportType)) {
	    	cmsReport.setReportType(reportType);
	    }
	    if (StringUtils.isNotBlank(reportContent)) {
	    	cmsReport.setReportContent(reportContent);
	    }
 		int result = cmsReportMapper.insertReport(cmsReport);
 		if(result == 1){
            return  "success";
 		}else{
            return  "false";
 		}
	}
}