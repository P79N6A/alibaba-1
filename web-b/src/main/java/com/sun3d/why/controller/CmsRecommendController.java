package com.sun3d.why.controller;

import com.sun3d.why.model.*;
import com.sun3d.why.model.extmodel.AreaData;
import com.sun3d.why.service.*;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.Pagination;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpSession;
import java.util.List;

/**
 * Created by cj on 2015/7/30.
 */
@Controller
@RequestMapping(value = "/recommend")
public class CmsRecommendController {

    private Logger logger = Logger.getLogger(CmsRecommendController.class);

    @Autowired
    private CmsRecommendService cmsRecommendService;

    @Autowired
    private CmsActivityService activityService;

    @Autowired
    private HttpSession session;

    @Autowired
    private CmsListRecommendTagService cmsListRecommendTagService;

    @Autowired
    private CmsVenueService cmsVenueService;

    /**
     * 自动注入广告业务操作层service实例
     */
    @Autowired
    private CmsAdvertService cmsAdvertService;

    /**
     * 推荐列表
     * @return
     */
    @RequestMapping(value = "/recommendIndex")
    public ModelAndView recommendIndex(CmsRecommend cmsRecommend,Pagination page){
        ModelAndView model = new ModelAndView();

        List<CmsRecommend> recommendList = cmsRecommendService.queryCmsRecommendIndex(cmsRecommend,page);

        model.setViewName("admin/recommend/recommendIndex");
        model.addObject("recommendList",recommendList);
        model.addObject("page",page);
        return model;
    }

    /**
     * 取消推荐
     * @param recommendId
     * @return
     */
    @RequestMapping(value = "cancelRecommend")
    @ResponseBody
    public String cancelRecommend(String recommendId){
        String result = Constant.RESULT_STR_FAILURE;

        CmsRecommend cmsRecommend = cmsRecommendService.queryCmsRecommendById(recommendId);
        if (cmsRecommend.getRecommendType() == Constant.RECOMMENT_ACTIVITY){
            SysUser sysUser = (SysUser) session.getAttribute("user");
            result = activityService.recommendActivity(cmsRecommend.getRelatedId(),sysUser,"web");
        }
        return  result;
    }


    /**
     * 得到所有区域的编码信息
     */
    @RequestMapping(value = "/getLocArea")
    @ResponseBody
    public List<AreaData> getLocArea() {
        List<AreaData> areaDataList = null;
        try {
            areaDataList = cmsRecommendService.queryVenueAllArea();
        } catch(Exception e){
            logger.error("获取区县信息出错!",e);
        }
        return areaDataList;
    }


    /**
     * 活动列表页推荐
     *
     * @return
     */
    @RequestMapping("/preCmsListRecommendTag")
    public ModelAndView cmsListRecommendTagIndex() {
        ModelAndView model = new ModelAndView();
         List<CmsListRecommendTag> cmsListRecommendTagList =  cmsListRecommendTagService.queryCmsListRecommendTagList();
        StringBuffer tagIds = new StringBuffer("");
        if(null != cmsListRecommendTagList && !cmsListRecommendTagList.isEmpty()){
            for(int i=0;i<cmsListRecommendTagList.size();i++){
                tagIds.append(cmsListRecommendTagList.get(i).getTagId()+",");
            }
            model.addObject("tagIds",tagIds);
        }

          model.setViewName("admin/recommend/activityListRecommendTag");
        return model;
    }


    /**
     * 活动列表页推荐
     *
     * @return
     */
    @RequestMapping(value = "/cmsListRecommendTag")
    public ModelAndView addCmsListRecommendTag(String activityType) {
        //ModelAndView model = new ModelAndView();
        SysUser sysUser = (SysUser) session.getAttribute("user");
        cmsListRecommendTagService.addCmsListRecommendTag(activityType,sysUser);
        //model.setViewName("admin/recommend/activityListRecommendTag");
        return new ModelAndView("redirect:/recommend/preCmsListRecommendTag.do");

    }


    /**
     * web取消端置顶活动
     * @param activityId
     * @return
     */
    @RequestMapping(value = "/cancelHomeNavigationRecommendActivity", method = RequestMethod.POST)
    @ResponseBody
    public String cancelHomeNavigationRecommendActivity(String activityId) {
        try {
            return activityService.editRecommendCmsActivity(activityId);
        } catch (Exception ex) {
            ex.printStackTrace();
            this.logger.error("recommendActivity error {}", ex);
            return ex.toString();
        }
    }

    /**
     * app端首页栏目推荐活动列表页
     *
     * @param activity
     * @param page
     * @return
     */
    @RequestMapping(value = "/appActivityHomeRecommendIndex")
    public ModelAndView appActivityHomeRecommendIndex(CmsActivity activity, Pagination page) {
        ModelAndView model = new ModelAndView();
        try {
            List<CmsActivity> activityList = activityService.queryAppRecommendCmsActivityByCondition(activity, page);

            model.addObject("activityList", activityList);
            model.addObject("page", page);
            model.addObject("activity", activity);

            //这里添加platform参数是为了区分跳转web端页面还是app端页面，两个平台 查询条件都是一致的
            model.setViewName("admin/recommend/appNavigationRecommendIndex");
        } catch (Exception e) {
            logger.error("activityIndex error {}", e);
        }
        return model;
    }

    /**
     * app端置顶活动
     * @param activity
     * @return
     */
    @RequestMapping(value = "/appHomeNavigationRecommendActivity", method = RequestMethod.POST)
    @ResponseBody
    public String appHomeNavigationRecommendActivity(CmsActivity activity) {
        try {
            Pagination page = new Pagination();
            page.setRows(3);
            SysUser user = (SysUser)session.getAttribute("user");
            return activityService.editAppNavigationRecommendActivity(activity, page, user);
        } catch (Exception ex) {
            ex.printStackTrace();
            this.logger.error("recommendActivity error {}", ex);
            return ex.toString();
        }
    }

    /**
     * app取消端置顶活动
     * @param recommendId
     * @return
     */
    @RequestMapping(value = "/cancelAppHomeNavigationRecommendActivity", method = RequestMethod.POST)
    @ResponseBody
    public String cancelAppHomeNavigationRecommendActivity(String recommendId) {
        try {
            return activityService.editAppHomeNavigationRecommendActivity(recommendId);
        } catch (Exception ex) {
            ex.printStackTrace();
            this.logger.error("recommendActivity error {}", ex);
            return ex.toString();
        }
    }

    /**
     * web端场馆推荐
     * @param venue
     * @param areaData
     * @param page
     * @return
     */
    @RequestMapping(value ="/homeVenueRecommendIndex")
    public ModelAndView venueIndex(CmsVenue venue, String areaData, String venueType, String searchKey, Pagination page) {
        ModelAndView model = new ModelAndView();
        List<CmsVenue> list = null;
        try{
            if(session.getAttribute("user") != null){
                SysUser user = (SysUser)session.getAttribute("user");
                String userDeptPath = null;
                if(user != null){
                    userDeptPath = user.getUserDeptPath();
                }
                if(StringUtils.isNotBlank(areaData)){
                    venue.setVenueArea(areaData);
                }
                if(StringUtils.isNotBlank(venueType)){
                    venue.setVenueType(venueType);
                }
                if(StringUtils.isNotBlank(searchKey)){
//                    venue.setSearchKey(searchKey);
                    //解决名称搜索无效
                    venue.setVenueName(searchKey);
                }
                venue.setVenueState(Constant.PUBLISH);
                list = cmsVenueService.queryRecommendVenueByConditionList(venue,page, null, userDeptPath);
            }
            model.addObject("list", list);
            model.addObject("venue", venue);
            model.addObject("page", page);
            model.addObject("areaData", areaData);
            model.addObject("venueType", venueType);
            model.addObject("searchKey", searchKey);
            model.setViewName("admin/recommend/homeVenueRecommendIndex");
        }catch (Exception e){
            logger.error("venueIndex error" , e);
        }
        return model;
    }


    /**
     *
     *
     * @param record web端 活动热点推荐
     * @param page   Pagination 分页功能对象
     * @return ModelAndView 页面跳转及数据传递
     */
    @RequestMapping(value = "/homeHotRecommendIndex")
    public ModelAndView advertIndex(CmsAdvert record, Pagination page) {
        //创建一个ModelAndView对象，代表了MVC Web程序中Model与View的对象
        //view代表跳转的页面，model代表传到前台的数据
        ModelAndView model = new ModelAndView();
        List<CmsAdvert> list = null;
        try {
            SysUser user = (SysUser) session.getAttribute("user");
            if(user==null){
                return null;
            }
            if(StringUtils.isNotBlank(user.getUserCounty())){
                String key = user.getUserCounty().split(",")[0];
                if(!"45".equals(key))
                    record.setAdvertSite(key);
            }

            list = cmsAdvertService.queryRecommendCmsAdvertByList(record,page);
        } catch (Exception e) {
            logger.error("加载广告列表页面时出错!",e);
        }
        model.setViewName("admin/recommend/homeHotRecommendIndex");
        model.addObject("list", list);
        model.addObject("page", page);
        model.addObject("record",record);
        return model;
    }


    /**
     * 置顶活动
     *
     * @param activity
     * @return
     */
    @RequestMapping(value = "/recommendActivity", method = RequestMethod.POST)
    @ResponseBody
    public String recommendActivity(CmsActivity activity,String platform) {
        try {
            //String activityId,String activityRecommend
            SysUser sysUser = (SysUser) session.getAttribute("user");
            String rsStrs = activityService.recommendActivity(activity.getActivityId(), sysUser,platform);
            if (Constant.RESULT_STR_SUCCESS.equals(rsStrs)) {
                //成功后将最新数据放至内存中  需要在数据库执行完后操作 不然由于spring 进行了数据库事物控制 不会马上查询到推荐的活动信息
                activityService.setIndexListInfoToRedis();
            }
            return rsStrs;
        } catch (Exception ex) {
            ex.printStackTrace();
            this.logger.error("recommendActivity error {}", ex);
            return ex.toString();
        }
    }


    //添加热点推荐
    @RequestMapping(value="/addHomeRecommend")
    public ModelAndView addAdvertShow(String sortNum){
        ModelAndView model = new ModelAndView();
        model.addObject("sortNum",sortNum);
        model.setViewName("admin/recommend/addHomeHotRecommend");
        return model;
    }

}
