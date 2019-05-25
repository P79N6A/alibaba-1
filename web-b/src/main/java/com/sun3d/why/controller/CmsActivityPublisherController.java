package com.sun3d.why.controller;

import com.sun3d.why.model.CmsActivityPublisher;
import com.sun3d.why.service.CmsActivityPublisherService;
import com.sun3d.why.service.CmsActivityService;
import com.sun3d.why.util.JSONResponse;
import com.sun3d.why.webservice.service.ActivityAppService;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;

@RequestMapping("/activityPublisher")
@Controller
public class CmsActivityPublisherController {
    private Logger logger = LoggerFactory.getLogger(CmsActivityPublisherController.class);

    @Autowired
    private HttpSession session;

    @Autowired
    private CmsActivityService cmsActivityService;
    
    @Autowired
    private ActivityAppService activityAppService;
    
    @Autowired
    private CmsActivityPublisherService cmsActivityPublisherService;

    /**
     * 跳转到活动发布器模板
     * @param activityId
     * @return
     */
    @RequestMapping("/preActivityPublisher")
    public ModelAndView activityIndex(String activityId) {
        ModelAndView model = new ModelAndView();
        try {
            CmsActivityPublisher cmsActivityPublisher = cmsActivityPublisherService.queryActivityPublisherByActivityId(activityId);
            model.addObject("cmsActivityPublisher", cmsActivityPublisher);
            model.addObject("activityId", activityId);
            model.setViewName("admin/activity/activityPublisher");
        } catch (Exception e) {
            logger.error("preActivityPublisher error {}", e);
        }
        return model;
    }
    
    /**
     * 活动详情
     * @param userId     用户id
     * @return json  10107 活动id缺失
     */
    @RequestMapping(value = "/activityDetail")
    public String activityWcDetail(HttpServletResponse response, String activityId) throws Exception {
        String json = "";
        try {
            if (StringUtils.isNotBlank(activityId) && activityId != null) {
                json = activityAppService.queryAppCmsActivityById(activityId, null);
            } else {
                json = JSONResponse.commonResultFormat(10107, "活动id缺失", null);
            }
        } catch (Exception e) {
            e.printStackTrace();
            logger.info("query activityDetail error!" + e.getMessage());
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }
    
    /**
     * 添加、编辑活动发布器模板
     * @param vo
     * @return
     */
    @RequestMapping(value = "/saveOrUpdateActivityPublisher")
    @ResponseBody
    public Object deleteActivity(CmsActivityPublisher vo) {
    	Map<String, Object> map = new HashMap<String, Object>();
    	try {
    		map = cmsActivityPublisherService.saveOrUpdateActivityPublisher(vo);
    	} catch (Exception e) {
            logger.error("saveOrUpdateActivityPublisher error {}", e);
        }
        return map;
    }
}
