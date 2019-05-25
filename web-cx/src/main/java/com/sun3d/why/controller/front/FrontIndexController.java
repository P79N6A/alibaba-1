package com.sun3d.why.controller.front;

import com.alibaba.fastjson.JSONObject;
import com.sun3d.why.model.*;
import com.sun3d.why.model.ccp.CcpAdvertRecommend;
import com.sun3d.why.service.*;
import com.sun3d.why.util.Pagination;
import org.apache.commons.collections.CollectionUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.text.SimpleDateFormat;
import java.util.*;

@RequestMapping("/frontIndex")
@Controller
public class FrontIndexController {
    private Logger logger = LoggerFactory.getLogger(FrontIndexController.class);

    @Autowired
    private CmsActivityService activityService;

    @Autowired
    private CmsVenueService cmsVenueService;

    @Autowired
    private CmsAdvertService cmsAdvertService;

    @Autowired
    private CmsQuestionAnwserService cmsQuestionAnwserService;

    @Autowired
    private HttpSession session;

    @Autowired
    private CcpAdvertRecommendService ccpAdvertRecommendService;

    @RequestMapping(value = "/toApp")
    public String toApp() {
        return "index/app";
    }


    @RequestMapping(value = "/legal", method = {RequestMethod.GET})
    public String serviceLegal() {
        return "index/legal";
    }

    /**
     * 意见反馈
     *
     * @return
     */
    @RequestMapping(value = "/feedBack", method = {RequestMethod.GET})
    public String serviceFeedBack() {
        return "index/feedBack/frontFeedBack";
    }


    /**
     * 文化云3.1 合作伙伴
     *
     * @return
     */
    @RequestMapping("/partner")
    public String partner() {
        return "index/partner";
    }

    /**
     * 文化云3.1 友情链接
     *
     * @return
     */
    @RequestMapping("/friendship")
    public String friendship() {
        return "index/friendship";
    }

    /**
     * 文化云3.1前端首页即将开始的活动
     *
     * @return
     */
    @RequestMapping("/frontWillStartActivity")
    public String frontWillStartActivity(CmsActivity activity, HttpServletRequest request) {
        Pagination page = new Pagination();
        page.setRows(20);
        List<CmsActivity> willStartActivityList = activityService.queryWillStartActivity(activity, page);
        request.setAttribute("willStartActivityList", willStartActivityList);
        return "index/index/frontIndexLoad";
    }

    /**
     * 文化云3.1前端首页本周的活动(从当天开始往后推7天的活动)
     *
     * @return
     */
    @RequestMapping("/frontThisWeekActivity")
    public String frontThisWeekActivity(CmsActivity activity, HttpServletRequest request) {
        // 当天
        List<Map<String, Object>> thisWeekActivityList = new ArrayList<Map<String, Object>>();
        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
        Calendar cal = Calendar.getInstance();
        Map<String, Object> map = new HashMap<String, Object>();
        Pagination page = new Pagination();
        page.setRows(5);
        activity.setActivityStartTime(format.format(cal.getTime()));
        List<CmsActivity> activityList = activityService.queryThisWeekActivity(activity, page);
        //map.put(getWeekDay(cal.get(Calendar.DAY_OF_WEEK)-1), activityList);
        map.put("key", getWeekDay(cal.get(Calendar.DAY_OF_WEEK) - 1));
        map.put("value", activityList);
        thisWeekActivityList.add(map);
        // 后六天
        for (int i = 1; i <= 6; i++) {
            cal.add(Calendar.DATE, 1);
            Map<String, Object> activityMap = new HashMap<String, Object>();
            activity.setActivityStartTime(format.format(cal.getTime()));
            List<CmsActivity> cmsActivityList = activityService.queryThisWeekActivity(activity, page);
            //activityMap.put(getWeekDay(cal.get(Calendar.DAY_OF_WEEK) - 1), cmsActivityList);
            activityMap.put("key", getWeekDay(cal.get(Calendar.DAY_OF_WEEK) - 1));
            activityMap.put("value", cmsActivityList);
            thisWeekActivityList.add(activityMap);
        }
        request.setAttribute("thisWeekActivityList", thisWeekActivityList);
        return "index/index/frontIndexLoad";
    }

    // 根据数字判断星期几
    private String getWeekDay(int day) {
        if (day == 1) {
            return "星期一";
        } else if (day == 2) {
            return "星期二";
        } else if (day == 3) {
            return "星期三";
        } else if (day == 4) {
            return "星期四";
        } else if (day == 5) {
            return "星期五";
        } else if (day == 6) {
            return "星期六";
        } else if (day == 0) {
            return "星期日";
        }
        return "星期一";
    }

    /**
     * 文化云3.1前端首页猜你喜欢的活动
     *
     * @return
     */
    @RequestMapping("/frontMayLikeActivity")
    public String frontMayLikeActivity(CmsActivity activity, HttpServletRequest request) {
        Pagination page = new Pagination();
        page.setRows(4);
        List<CmsActivity> mayLikeActivityList = activityService.queryMayLikeActivity(activity, page);
        request.setAttribute("mayLikeActivityList", mayLikeActivityList);
        return "index/index/frontIndexLoad";
    }




    /**
     * 文化云3.1前端首页周末去哪儿的活动
     *
     * @return
     */
    @RequestMapping("/frontWeekEndActivity")
    public String frontWeekEndActivity(CmsActivity activity, HttpServletRequest request) {
        List<CmsActivity> weekEndActivityList = activityService.queryNavigationActivity();
        request.setAttribute("weekEndActivityList", weekEndActivityList);
        return "index/index/frontIndexLoad";
    }

    /**
     * 文化云3.1前端首页推荐场馆
     *
     * @return
     */
    @RequestMapping("/frontRecommendVenue")
    public String frontRecommendVenue(CmsVenue venue, HttpServletRequest request) {
        Pagination page = new Pagination();
        page.setRows(4);
        List<CmsVenue> venueList = cmsVenueService.queryRecommendVenue(venue, page);
        request.setAttribute("venueList", venueList);
        return "index/index/frontIndexLoad";
    }

    /**
     * 文化云3.1前端首页互动天地
     *
     * @return
     */
    @RequestMapping("/frontInteract")
    public ModelAndView frontInteract(Pagination page) {
        page.setRows(1);
        ModelAndView model = new ModelAndView();
        List<CmsQuestionAnwser> answerList = cmsQuestionAnwserService.queryQuestionAnswer(page);
        if (CollectionUtils.isNotEmpty(answerList)) {
            model.addObject("answer", answerList.get(0));
        }
        Map<String, Object> map = new HashMap<String, Object>();
        int total = cmsQuestionAnwserService.queryQuestionAnswerCount(map);
        model.addObject("page", page);
        model.addObject("total", total);
        model.setViewName("index/index/frontIndexLoad");
        return model;
    }

    /**
     * 文化云3.1前端首页热点推荐
     *
     * @return
     */
    @RequestMapping("/frontHotelRecommendAdvert")
    public String frontHotelRecommendAdvert(HttpServletRequest request) {
        Pagination page = new Pagination();
        page.setRows(5);
        List<CmsAdvert> advertList = cmsAdvertService.queryHotelRecommendAdvert(page);
        request.setAttribute("advertList", advertList);
        return "index/index/frontIndexLoad";
    }


    /**
     * 文化云3.4 前端首页
     *
     * @return
     */
    @RequestMapping("/index.do")
    public String index(HttpServletRequest request) {
        return "index/index/index";
    }

    /**
     * 文化云3.4前端   首页推荐
     *
     * @return
     */
    @RequestMapping("/advertIndex")
    public String hotelRecommendAdvert(HttpServletRequest request) {
        CcpAdvertRecommend advert=new CcpAdvertRecommend();
        advert.setAdvertType(request.getParameter("type"));
        advert.setAdvertPostion(1);
        advert.setAdvertState(1);
        List<CcpAdvertRecommend> advList = ccpAdvertRecommendService.queryCcpAdvertRecommend(advert);
        if(request.getParameter("type").equals("D")){
            List<CmsVenue> advertList= new ArrayList<CmsVenue>();
            for(CcpAdvertRecommend adv:advList){
                CmsVenue act=cmsVenueService.queryVenueById(adv.getAdvertUrl());
                advertList.add(act);
            }
            request.setAttribute("advertVenueList", advertList);
        }else{
            List<CmsActivity> advertList= new ArrayList<CmsActivity>();
            for(CcpAdvertRecommend adv:advList){
                CmsActivity act=activityService.queryFrontActivityByActivityId(adv.getAdvertUrl());
                advertList.add(act);
            }
            request.setAttribute("advertList", advertList);
        }
        return "index/index/frontIndexLoad";
    }

    /**
     * 文化云3.4前端   首页活动列表查询
     *
     * @return
     */
    @RequestMapping("/activityQueryList")
    @ResponseBody
    public String activityQueryList(HttpServletRequest request, CmsActivity activity, Pagination page) {
        JSONObject jsonObject = new JSONObject();
        try {
            page.setRows(12);
            //1-可预订 0-不可预订 空表示所有
            String bookType = request.getParameter("bookType");
            //筛选类别1(5天之内) 2(5-10天) 3(10-15天) 4(15天以后)
            String chooseType = request.getParameter("chooseType");
            //排序类别：2-即将开始 3-即将结束 4-最新发布 5-人气最高 6-评价最好
            String sortType = request.getParameter("sortType");
            //是否周末  1-周末 0-工作日 空表示不选
            String isWeekend = request.getParameter("isWeekend");
            CmsTerminalUser terminalUser = (CmsTerminalUser) session.getAttribute("terminalUser");
            List<CmsActivity> activityList = activityService.queryIndexActivityByCondition(activity, page, isWeekend, chooseType, sortType, bookType, terminalUser);
            //request.setAttribute("activityList", activityList);
            jsonObject.put("list", activityList);
            jsonObject.put("page", page);
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return jsonObject.toString();
    }

    /**
     * 文化云3.4 联系我们页面
     *
     * @return
     */
    @RequestMapping("/contact.do")
    public String contact(HttpServletRequest request) {
        return "index/index/contact";
    }
    /**
     * 文化云3.4 手机下载页面
     *
     * @return
     */
    @RequestMapping("/phone.do")
    public String phone(HttpServletRequest request) {
        return "index/index/phone";
    }

}
