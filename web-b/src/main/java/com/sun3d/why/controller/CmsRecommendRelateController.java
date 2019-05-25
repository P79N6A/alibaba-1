package com.sun3d.why.controller;

import com.sun3d.why.model.*;
import com.sun3d.why.service.*;
import com.sun3d.why.util.Pagination;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpSession;
import java.util.*;

@Controller
@RequestMapping(value = "/recommendRelate")
public class CmsRecommendRelateController {

    private Logger logger = Logger.getLogger(CmsRecommendRelateController.class);

    @Autowired
    private RecommendRelatedService recommendRelatedService;

    @Autowired
    private CmsActivityService activityService;

    @Autowired
    private HttpSession session;

    @Autowired
    private CmsListRecommendTagService cmsListRecommendTagService;

    @Autowired
    private CmsTagService cmsTagService;

    @Autowired
    private SysDictService sysDictService;


    /**
     * 推荐列表
     *
     * @return
     */
    @RequestMapping(value = "/recommendIndex")
    public ModelAndView recommendIndex(CmsActivity activity, Pagination page) {
        ModelAndView model = new ModelAndView();
        Map<String, Object> params = new HashMap<>();
        List<CmsRecommendRelated> recommendList = recommendRelatedService.queryRecommendActivity(activity, page);
        model.setViewName("admin/recommend/recommendActivityIndex");
        model.addObject("recommendList", recommendList);
        model.addObject("activity", activity);
        model.addObject("page", page);
        return model;
    }

    /**
     * 后台推荐活动
     *
     * @param activity
     * @return
     */
    @RequestMapping(value = "recommendActivity")
    @ResponseBody
    public String recommendActivity(CmsActivity activity) {
        try {
            CmsRecommendRelated cmsRecommendRelated = new CmsRecommendRelated();
            cmsRecommendRelated.setRecommendColumnType(4);
            cmsRecommendRelated.setTopTime(new Date());
            cmsRecommendRelated.setTopType(0);
            cmsRecommendRelated.setRelatedId(activity.getActivityId());
            cmsRecommendRelated.setTopId(activity.getActivityId());
            SysUser sysUser = (SysUser) session.getAttribute("user");
            String rsStrs = recommendRelatedService.insert(cmsRecommendRelated, sysUser);
            return rsStrs;
        } catch (Exception ex) {
            ex.printStackTrace();
            this.logger.error("recommendActivity error {}", ex);
            return ex.toString();
        }
    }

    /**
     * 后台置顶活动
     *
     * @param activity
     * @return
     */
    @RequestMapping(value = "topActivity")
    @ResponseBody
    public String topActivity(CmsActivity activity) {
        try {
            CmsRecommendRelated cmsRecommendRelated = new CmsRecommendRelated();
            cmsRecommendRelated.setRecommendColumnType(5);
            cmsRecommendRelated.setTopTime(new Date());
            cmsRecommendRelated.setTopId(activity.getActivityType());
            cmsRecommendRelated.setTopType(1);
            cmsRecommendRelated.setRelatedId(activity.getActivityId());
            SysUser sysUser = (SysUser) session.getAttribute("user");
            String rsStrs = recommendRelatedService.insert(cmsRecommendRelated, sysUser);
            return rsStrs;
        } catch (Exception ex) {
            ex.printStackTrace();
            this.logger.error("recommendActivity error {}", ex);
            return ex.toString();
        }
    }

    /**
     * 后台取消推荐活动
     *
     * @param activity
     * @return
     */
    @RequestMapping(value = "cancelRecommendActivity")
    @ResponseBody
    public String cancelRecommendActivity(CmsActivity activity) {
        try {
            String rsStrs = recommendRelatedService.deleteById(activity.getRecommendId());
            return rsStrs;
        } catch (Exception ex) {
            ex.printStackTrace();
            this.logger.error("cancelRecommendActivity error {}", ex);
            return ex.toString();
        }
    }

    /**
     * 活动列表页
     *
     * @param activity
     * @param page
     * @return
     */
    @RequestMapping("/activityIndex")
    public ModelAndView activityIndex(CmsActivity activity, Pagination page) {
        ModelAndView model = new ModelAndView();
        try {

            if (StringUtils.isBlank(activity.getActivityType())) {
                List<CmsTag> list = new ArrayList<CmsTag>();
                List<SysDict> dicts = sysDictService.querySysDictByCode("ACTIVITY_TYPE");
                if (dicts != null && dicts.size() > 0) {
                    list = cmsTagService.queryCmsTagByCondition(dicts.get(0).getDictId(), 20);
                }
                activity.setActivityType(list.get(0).getTagId());
            }


            SysUser sysUser = (SysUser) session.getAttribute("user");
            List<CmsActivity> activityList = activityService.queryCmsActivityByCondition(activity, page, sysUser);

            model.addObject("activityList", activityList);
            model.addObject("page", page);
            model.addObject("activity", activity);
            model.addObject("activityType",activity.getActivityType());
            model.setViewName("admin/recommend/topActivityIndex");
        } catch (Exception e) {
            logger.error("activityIndex error {}", e);
        }
        return model;
    }
    /**
     * 后台推荐周末去哪儿
     *
     * @param activity
     * @return
     */
    @RequestMapping(value = "weekendActivity")
    @ResponseBody
    public String weekendActivity(CmsActivity activity) {
        try {
            CmsRecommendRelated cmsRecommendRelated = new CmsRecommendRelated();
            cmsRecommendRelated.setRecommendColumnType(3);
            cmsRecommendRelated.setTopTime(new Date());
            cmsRecommendRelated.setTopType(0);
            cmsRecommendRelated.setRelatedId(activity.getActivityId());
            cmsRecommendRelated.setTopId(activity.getActivityId());
            SysUser sysUser = (SysUser) session.getAttribute("user");
            String rsStrs = recommendRelatedService.insert(cmsRecommendRelated, sysUser);
            return rsStrs;
        } catch (Exception ex) {
            ex.printStackTrace();
            this.logger.error("recommendActivity error {}", ex);
            return ex.toString();
        }
    }

}
