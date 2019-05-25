package com.sun3d.why.controller;

import com.sun3d.why.model.CmsReport;
import com.sun3d.why.model.CmsTerminalUser;
import com.sun3d.why.service.CmsReportService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.Pagination;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.List;

/**
 * 用户举报信息
 * Created by Administrator on 2015/12/09.
 */
@Controller
@RequestMapping(value = "/reportInformation")
public class CmsReportInformationController {
    private Logger logger = LoggerFactory.getLogger(CmsReportInformationController.class);
    @Autowired
    private CmsReportService cmsReportService;

    @Autowired
    private HttpSession session;
    /**
     * 进入用户举报列表
     * @param page 分页对象
     */
    @RequestMapping("/reportIndex")
    public String reportIndex(Pagination page, Model model,String content,String listType) {
    	CmsReport cmsReport = new CmsReport();
        List<CmsReport> reportList=cmsReportService.queryReportInformationByContent(cmsReport,content,page);
        model.addAttribute("reportList", reportList);
        model.addAttribute("page", page);
        model.addAttribute("content", content);
        model.addAttribute("listType", listType);
        return "admin/feedBack/report_index";
    }
    
    /**
     * 用户举报接口
     * @param activityId        活动id
     * @param reportType        举报类别
     * return 是否报名成功 (成功：success；失败：false)
     */
    @RequestMapping(value = "/addReport")
    @ResponseBody
    public String addReport(String activityId,String reportType,String reportContent){

        CmsTerminalUser user = (CmsTerminalUser) session.getAttribute(Constant.terminalUser);

        String userId =null;
        if(user==null){
            return  "timeOut";
        }else{
            userId  = user.getUserId();
        }

        try {
            String result=cmsReportService.insertReport(activityId,userId,reportType,reportContent);
            return  result;
        }catch (Exception e){
          e.printStackTrace();
        }

        return Constant.RESULT_STR_FAILURE;
    }
}
