package com.sun3d.why.webservice.controller;
import com.sun3d.why.model.CmsUserTag;
import com.sun3d.why.service.SysDictService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.JSONResponse;
import com.sun3d.why.webservice.service.TagAppService;
import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import javax.servlet.http.HttpServletResponse;
/**
 * 手机app接口 标签管理
 * Created by Administrator on 2015/7/1
 */
@RequestMapping("/appTag")
@Controller
public class TagAppController {
    private Logger logger = Logger.getLogger(TagAppController.class);
    @Autowired
    private TagAppService tagAppService;
    @Autowired
    private SysDictService sysDictService;
    /**
     * app用户选择喜欢标签
     * @param cmsUsertag
     */
    @RequestMapping(value = "/addUserTags")
    public String addUserTags(HttpServletResponse response,CmsUserTag cmsUsertag) throws Exception {
        String json="";
        try {
            if (cmsUsertag != null && StringUtils.isNotBlank(cmsUsertag.getUserSelectTag()) ) {
                  json=tagAppService.addUserTags(cmsUsertag);
            } else {
                json = JSONResponse.commonResultFormat(10107, "活动标签id缺失", null);
            }
        } catch (Exception e) {
            e.printStackTrace();
            logger.info("系统出错!"+e.getMessage());
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }


    /**
     * app推送6个活动与展馆标签
     */
    @RequestMapping(value = "/appActivityTags")
    public String appActivityTag(HttpServletResponse response) throws Exception {
        String json = "";
        json=tagAppService.queryActivityVenueTagsByType(1,2);
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }

    /**
     * app获取活动标签名称
     * @return json
     */
    @RequestMapping(value = "/appActivityTagByType")
    public String appActivityTagByType(HttpServletResponse response) throws Exception {
        String json = "";
        try {
            json=tagAppService.queryCmsActivityTagByCondition(Constant.ACTIVITY_MOOD,Constant.ACTIVITY_TYPE,Constant.ACTIVITY_CROWD);
        } catch (Exception e) {
            e.printStackTrace();
            logger.error("query activityTag error"+e.toString());
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }
    /**
     * app获取展馆标签名称
     * @return json
     */
   @RequestMapping(value = "/appVenueTagByType")
    public String appVenueTagByType(HttpServletResponse response) throws Exception {
        String json="";
        try {
            json=tagAppService.queryCmsActivityTagByCondition(Constant.VENUE_TYPE,null,Constant.VENUE_CROWD);
        }catch (Exception e) {
            e.printStackTrace();
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }
    /**
     * app获取反馈标签名称
     * @return json
     */
    @RequestMapping(value = "/appFeedBackTagByType")
    public String appCultureTagByType(HttpServletResponse response) throws Exception {
        String  json="";
        try {
            json=sysDictService.queryAppSysDictByCode(Constant.FEED_BACK_TYPE);
        }catch (Exception e) {
            e.printStackTrace();
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }
}

