package com.sun3d.why.service;

import java.util.List;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.sun3d.why.model.CmsReport;
import com.sun3d.why.util.Pagination;

/**
 * Created by ldq on 2015/12/09.
 */
public interface CmsReportService {

    /**
     * 举报对象进行查询
     * @param cmsReport
     * @param page
     * @return
     */
    List<CmsReport> queryReportInformationByContent(CmsReport cmsReport,String content, Pagination page);
    
    /**
     * 用户举报接口
     * @param activityId        活动id
     * @param userId            用户id
     * @param reportType        举报类别
     * return 是否报名成功 (成功：success；失败：false)
     */
    String insertReport(String activityId,String userId,String reportType,String reportContent);

}
