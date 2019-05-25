package com.sun3d.why.webservice.controller;
import com.sun3d.why.util.JSONResponse;
import com.sun3d.why.util.PaginationApp;
import com.sun3d.why.webservice.service.UserActivityVoteAppService;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import javax.servlet.http.HttpServletResponse;
@Controller
@RequestMapping("/userActivityVote")
public class UserActvityVoteAppController {
    private Logger logger = Logger.getLogger(UserActvityVoteAppController.class);
    @Autowired
    private UserActivityVoteAppService userActivityVoteAppService;
    /**
     * app活动投票管理
     * @param activityId 活动id
     * @returns
     */
    @RequestMapping(value = "/userVote")
    public String userVote(HttpServletResponse response,String activityId) throws Exception {
        String json="";
        try {
            if (activityId != null && StringUtils.isNotBlank(activityId)) {
                json = userActivityVoteAppService.queryAppUserVoteById(activityId);
            } else {
                json = JSONResponse.commonResultFormat(10107, "活动id缺失", null);
            }
        }catch (Exception e) {
            e.printStackTrace();
            logger.info("query userVote error!"+e.getMessage());
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().print(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }
    /**
     * app活动投票管理
     * @param activityId 活动id
     * @returns
     */
    @RequestMapping(value = "/queryActivityVote")
    public String queryActivityVote(HttpServletResponse response,String activityId,String pageIndex,String pageNum ,PaginationApp pageApp) throws Exception {
        String json="";
        pageApp.setFirstResult(Integer.valueOf(pageIndex));
        pageApp.setRows(Integer.valueOf(pageNum));
        try {
            if (activityId != null && StringUtils.isNotBlank(activityId)) {
                json = userActivityVoteAppService.queryAppActivityVoteById(activityId, pageApp);
            } else {
                json = JSONResponse.commonResultFormat(10107, "活动id缺失", null);
            }
        }catch (Exception e) {
            e.printStackTrace();
            logger.info("query userVote error!"+e.getMessage());
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().print(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }
}
