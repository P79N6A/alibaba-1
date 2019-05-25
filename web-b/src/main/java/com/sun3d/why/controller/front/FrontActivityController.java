package com.sun3d.why.controller.front;

import com.sun3d.why.dao.CmsSensitiveWordsMapper;
import com.sun3d.why.jms.client.ActivityBookClient;
import com.sun3d.why.jms.model.JmsResult;
import com.sun3d.why.model.*;
import com.sun3d.why.model.extmodel.BasePath;
import com.sun3d.why.model.extmodel.BookActivitySeatInfo;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.service.*;
import com.sun3d.why.util.*;
import com.sun3d.why.webservice.api.model.CmsApiOrder;
import com.sun3d.why.webservice.api.service.CmsApiActivityOrderService;
import gui.ava.html.image.generator.HtmlImageGenerator;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.CollectionUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.io.File;
import java.net.URLDecoder;
import java.text.SimpleDateFormat;
import java.util.*;

@RequestMapping("/frontActivity")
@Controller
public class FrontActivityController {
    private Logger logger = LoggerFactory.getLogger(FrontActivityController.class);

    @Autowired
    private CmsActivityService activityService;

    @Autowired
    private SysDictService sysDictService;

    @Autowired
    private CmsAdvertService cmsAdvertService;


    @Autowired
    private CacheService cacheService;

    @Autowired
    private BasePath basePath;

    @Autowired
    private StaticServer staticServer;

    @Autowired
    private HttpSession session;

    //评论逻辑控制层
    @Autowired
    private CmsCommentService cmsCommentService;


    @Autowired
    private CmsActivityOrderService cmsActivityOrderService;

    @Autowired
    private CmsCommentService commentService;


    @Autowired
    private CmsUserMessageService userMessageService;
    @Autowired
    private CmsSensitiveWordsMapper cmsSensitiveWordsMapper;

    @Autowired
    private CmsApiActivityOrderService cmsApiActivityOrderService;

    @Autowired
    private CmsActivityEventService cmsActivityEventService;

    @Autowired
    private CmsVenueService cmsVenueService;

    @Autowired
    private CmsVideoService cmsVideoService;


    /**
     * 热点推荐活动
     *
     * @param activity
     * @param request
     * @param page
     * @return
     */
    @RequestMapping(value = "/frontRecommendActivity")
    public String frontRecommendActivity(String areaCode, CmsActivity activity, HttpServletRequest request, Pagination page) {
        try {
            if (StringUtils.isNotBlank(activity.getActivityName())) {
                request.setAttribute("activityName", activity.getActivityName());
            }
            List<CmsActivity> rsList = new ArrayList<CmsActivity>();
            if (StringUtils.isBlank(areaCode) && StringUtils.isBlank(activity.getActivityName())) {
                rsList = cacheService.queryActivityList(Constant.RecommendActivityList);
            } else {
                Map map = new HashMap();
                if (StringUtils.isNotBlank(areaCode))
                    map.put("activityArea", areaCode + ",%");
                if (StringUtils.isNotBlank(activity.getActivityName()))
                    map.put("activityName", "%" + activity.getActivityName().replace("_", "\\_").replace("%", "\\%") + "%");
                page.setRows(10);
                //根据浏览量排行  且未结束的活动
                rsList = this.activityService.queryRecommendActivityList(map, page);
            }

            request.setAttribute("recommendActivity", rsList);
            return "index/activity/publishActivity";
        } catch (Exception ex) {
            this.logger.error("frontRecommendActivity error {}", ex);
            ex.printStackTrace();
            return null;
        }
    }


    /**
     * 热点推荐活动的收藏数量
     *
     * @param activity
     * @param request
     * @param page
     * @return
     */
    @RequestMapping(value = "/frontRecommendActivityCollectNum")
    @ResponseBody
    public List frontRecommendActivityCollectNum(String areaCode, CmsActivity activity, HttpServletRequest request, Pagination page) {
        try {
            if (StringUtils.isNotBlank(activity.getActivityName())) {
                request.setAttribute("activityName", activity.getActivityName());
            }
            Map map = new HashMap();
            if (StringUtils.isNotBlank(areaCode))
                map.put("activityArea", areaCode + ",%");
            if (StringUtils.isNotBlank(activity.getActivityName()))
                map.put("activityName", "%" + activity.getActivityName().replace("_", "\\_").replace("%", "\\%") + "%");
            page.setRows(10);
            //根据浏览量排行  且未结束的活动
            List rsList = this.activityService.frontRecommendActivityCollectNum(map, page);
            return rsList;
        } catch (Exception ex) {
            this.logger.error("frontRecommendActivity error {}", ex);
            ex.printStackTrace();
            return null;
        }
    }


    /**
     * 最新发布的活动
     *
     * @param activity
     * @param request
     * @param page
     * @return
     */
    @RequestMapping(value = "/frontNewestActivity")
    public String frontNewestActivity(String areaCode, CmsActivity activity, HttpServletRequest request, Pagination page) {
        try {
            if (StringUtils.isNotBlank(activity.getActivityName())) {
                request.setAttribute("activityName", activity.getActivityName());
            }
            List<CmsActivity> rsList;
            if (StringUtils.isBlank(areaCode) && StringUtils.isBlank(activity.getActivityName())) {
                rsList = cacheService.queryActivityList(Constant.FrontNewestActivity);
                Map map = new HashMap();
                if (StringUtils.isNotBlank(activity.getActivityName()))
                    map.put("activityName", "%" + activity.getActivityName() + "%");
                Integer count = this.activityService.queryFrontCmsActivityCountByCondition(map);
                request.setAttribute("count", count);
            } else {
                page.setRows(4);
                CmsActivity cmsActivity = new CmsActivity();
                cmsActivity.setActivityName(activity.getActivityName());
                rsList = this.activityService.queryFrontActivityList(cmsActivity, areaCode, null, null, null, null, page, null, null);
                request.setAttribute("count", page.getTotal());
            }

            request.setAttribute("newestActivity", rsList);
            return "index/index/frontIndexLoad";
        } catch (Exception ex) {
            this.logger.error("frontNewestActivity error {}", ex);
            ex.printStackTrace();
            return null;
        }
    }




    /**
     * 你可能喜欢的
     *
     * @param areaCode 区县代码
     * @param activity
     * @param request
     * @param page
     * @return
     */
    @RequestMapping(value = "/frontLikeActivity")
    public String frontLikeActivity(String areaCode, CmsActivity activity, HttpServletRequest request, Pagination page) {
        try {
            if (StringUtils.isNotBlank(activity.getActivityName())) {
                request.setAttribute("activityName", activity.getActivityName());
            }
            //只显示未举行的活动 已经结束的活动不显示
            if (StringUtils.isBlank(areaCode)) {
                page.setRows(6);
            } else {
                page.setRows(10);
            }
            List<CmsActivity> rsList = activityService.queryYearHotActivity(areaCode, activity, page);
            //只显示未举行的活动 已经结束的活动不显示
            if (StringUtils.isBlank(areaCode)) {
                request.setAttribute("likeActivity", rsList);
            } else {
                request.setAttribute("recommendActivity", rsList);
            }
            return "index/activity/publishActivity";
        } catch (Exception ex) {
            this.logger.error("frontLikeActivity error {}", ex);
            ex.printStackTrace();
            return null;
        }
    }


    /**
     * 上海市首页的时候 可能喜欢从其他区县随机选取数据(排除热点和最新活动的数据)
     *
     * @param areaCode    区县代码
     * @param activityIds 首页 热点推荐和最新活动的活动id
     * @return
     */
    @RequestMapping(value = "/frontActivityListByCity")
    public String frontActivityListByCity(String areaCode, String activityName, CmsActivity cmsActivity, String[] activityIds, Pagination page, HttpServletRequest request) {
        try {
            if (StringUtils.isNotBlank(cmsActivity.getActivityName())) {
                request.setAttribute("activityName", cmsActivity.getActivityName());
            }
            String cacheCode = "";
            //推荐活动
            Map map = new HashMap();
            if (StringUtils.isNotBlank(areaCode)) {
                map.put("activityArea", areaCode + ",%");
                cacheCode = areaCode;
            } else {
                cacheCode = "45";
            }
            final String code = cacheCode;
            if (StringUtils.isNotBlank(activityName)) {
                map.put("activityName", "%" + activityName.replace("_", "\\_").replace("%", "\\%") + "%");
            } else {
                /*缓存add 2015.10.26 by niu*/
                List<CmsActivity> dataList = cacheService.getLikeActivityList(CacheConstant.LIKE_ACTIVITY + code);
                if (null != dataList && dataList.size() > 0) {
                    request.setAttribute("likeActivity", dataList);
                    return "index/activity/publishActivity";
                }
            }

            page.setRows(10);
            //根据浏览量排行  且未结束的活动
            List<CmsActivity> rsList = this.activityService.queryRecommendActivityList(map, page);
            //最新活动
            CmsActivity activity1 = new CmsActivity();
            activity1.setActivityName(activityName);
            page.setRows(15);
            List<CmsActivity> rsList2 = this.activityService.queryFrontActivityList(activity1, areaCode, null, null, null, null, page, null, null);
            int count = (rsList != null ? rsList.size() : 0) + (rsList2 != null ? rsList2.size() : 0);
            activityIds = new String[count];
            int index = 0;
            if (rsList != null && rsList.size() > 0) {
                for (CmsActivity activity : rsList) {
                    activityIds[index] = activity.getActivityId();
                    index++;
                }
            }
            if (rsList2 != null && rsList2.size() > 0) {
                for (CmsActivity activity : rsList2) {
                    activityIds[index] = activity.getActivityId();
                    index++;
                }
            }
            page.setRows(6);
            final List<CmsActivity> cmsActivities = activityService.queryActivityListByCity(areaCode, activityIds, activityName, cmsActivity, page);
            if (cmsActivities == null || cmsActivities.size() < 6) {
                int otherRows = page.getRows() - (cmsActivities == null ? 0 : cmsActivities.size());
                page.setRows(otherRows);
                List<CmsActivity> otherActivitys = this.activityService.queryFrontActivityList(activity1, areaCode, null, null, null, null, page, null, null);
                cmsActivities.addAll(otherActivitys);
            }

            request.setAttribute("likeActivity", cmsActivities);
            //request.setAttribute("likeActivity", cmsActivities);
            //不存在活动名称搜索是
            if (StringUtils.isBlank(activityName)) {
                Runnable runner = new Runnable() {
                    @Override
                    public void run() {
                        Calendar calendar = Calendar.getInstance();
                        calendar.setTime(new Date());
                        //设置过期时间为当前时间之后的24小时
                        calendar.add(Calendar.HOUR_OF_DAY, 24);
                        cacheService.setLikeActivityList(CacheConstant.LIKE_ACTIVITY + code, cmsActivities, calendar.getTime());
                    }
                };
                new Thread(runner).start();
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            this.logger.error("frontActivityListByCity error {}", ex);
        }
        return "index/activity/publishActivity";
    }

    /**
     * 活动列表页
     *
     * @param activity
     * @param request
     * @param page
     * @return
     */
    @RequestMapping(value = "/frontActivityList")
    public ModelAndView frontActivityList(CmsActivity activity, HttpServletRequest request, Pagination page, String areaCode) {
        ModelAndView model = new ModelAndView();
        model.setViewName("index/activity/frontActivityList");
        model.addObject("activity", activity);
        if (StringUtils.isNotBlank(activity.getActivityName())) {
            model.addObject("areaCode", areaCode);
            model.addObject("searchList", "Y");
        }

        return model;
    }


    /**
     * 前台活动列表listload
     *
     * @param activity
     * @param request
     * @param page
     * @return
     */
    @RequestMapping(value = "/frontActivityListLoad")
    public String frontActivityListLoad(CmsActivity activity, HttpServletRequest request, Pagination page) {
        try {
            page.setRows(16);
            if (StringUtils.isNotBlank(activity.getActivityStartTime())) {
                activity.setActivityStartTime(activity.getActivityStartTime() + " 00:00");
            }
            if (StringUtils.isNotBlank(activity.getActivityEndTime())) {
                activity.setActivityEndTime(activity.getActivityEndTime() + " 23:59");
            }
            List<CmsActivity> rsList = activityService.queryActivityListCollectNumLoad(activity, page);
            if (CollectionUtils.isEmpty(rsList)) {
                page.setRows(8);
                List<CmsActivity> rsListOther = activityService.queryMayLikeActivity(new CmsActivity(), page);
                request.setAttribute("activityListOther", rsListOther);
            }
            request.setAttribute("activityList", rsList);
            request.setAttribute("activity", activity);
            request.setAttribute("page", page);
            return "index/activity/frontActivityListLoad";
        } catch (Exception ex) {
            ex.printStackTrace();
            this.logger.error("frontActivityList error {}", ex);
            return null;
        }
    }


    /**
     * 活动详情
     * activityId 活动id
     *
     * @param request
     * @return
     */
    @RequestMapping(value = "/frontActivityDetail")
    public String frontActivityDetail(HttpServletRequest request) {
        try {
            String activityId = request.getParameter("activityId");
            Map map = activityService.queryFrontDetailInfo(activityId);
            request.setAttribute("cmsActivity", map.get("cmsActivity"));
            request.setAttribute("activityEventList", map.get("activityEventList"));
            request.setAttribute("createTime", map.get("createTime"));
            request.setAttribute("isOver", map.get("isOver"));

            // 前端2.0已审核评论数
            // CmsTerminalUser user = (CmsTerminalUser) session.getAttribute("terminalUser");
            CmsComment comment = new CmsComment();
            comment.setCommentRkId(activityId);
            comment.setCommentType(Constant.TYPE_ACTIVITY);
            int count = commentService.queryCommentCountByCondition(comment);
            request.setAttribute("commentCount", count);
            request.setAttribute("cmsActivityList", map.get("cmsActivityList"));
            //活动视频
            CmsVideo cmsVideo = new CmsVideo();
            cmsVideo.setReferId(activityId);
            cmsVideo.setVideoType(1);
            List<CmsVideo> cmsVideoList = cmsVideoService.cmsVideoList(cmsVideo, null);
            request.setAttribute("cmsVideoList", cmsVideoList);
        } catch (Exception e) {
            this.logger.error("frontActivityDetail error {}", e);
            e.printStackTrace();
        }
        return "index/activity/frontActivityDetail";
    }

    /**
     * 活动视频详情
     *
     * @param activityId 活动id
     * @param videoId    视频id
     * @param request
     * @return
     */
    @RequestMapping(value = "/frontActivityVideo")
    public String frontActivityVideo(HttpServletRequest request, String videoId, String activityId) {
        try {
            //活动详情
            CmsActivity cmsActivity = this.activityService.queryCmsActivityByActivityId(activityId);
            request.setAttribute("cmsActivity", cmsActivity);

            //视频列表
            CmsVideo cmsVideo = new CmsVideo();
            cmsVideo.setReferId(activityId);
            cmsVideo.setVideoType(1);
            List<CmsVideo> cmsVideoList = cmsVideoService.cmsVideoList(cmsVideo, null);
            request.setAttribute("cmsVideoList", cmsVideoList);

            //视频详情
            CmsVideo video = cmsVideoService.queryVideoByVideoId(videoId);
            request.setAttribute("CmsVideo", video);
        } catch (Exception e) {
            logger.error("frontActivityVideo error {}", e);
            e.printStackTrace();
        }
        return "index/activity/frontActivityVideo";
    }

    /**
     * 进入活动预定选坐页面
     *
     * @return
     */
    @RequestMapping(value = "/frontActivityBook")
    public ModelAndView frontActivityBook(String activityId) {
        ModelAndView model = new ModelAndView();
        try {
            CmsActivity cmsActivity = activityService.queryFrontActivityByActivityId(activityId);
            if (cmsActivity != null && cmsActivity.getActivityIsDel() == 1 && cmsActivity.getActivityState() == 6) {
                //在线选座情况
                //查询场次信息 时间段
                List<CmsActivityEvent> activityEventTimes = cmsActivityEventService.queryEventTimeByActivityId(activityId);
                //查询场次信息 最大 和最小的有效 日期 且有余票的
                Map map = cmsActivityEventService.queryMinMaxDateByActivityId(activityId);
                if (map != null && map.size() > 0) {
                    cmsActivity.setActivityStartTime(map.get("minEventDate").toString());
                    cmsActivity.setActivityEndTime(map.get("maxEventDate").toString());
                }
                String canNotEventStrs = cmsActivityEventService.queryCanNotBookEventTime(activityId);
                List<CmsActivityEvent> activityEventDates = cmsActivityEventService.queryEventDateByActivityId(activityId);
                model.addObject("activityEventTimes", activityEventTimes);
                model.addObject("activityEventDates", activityEventDates);
                model.addObject("activityId", activityId);
                model.addObject("cmsActivity", cmsActivity);
                model.addObject("canNotEventStrs", canNotEventStrs);
                model.setViewName("index/activity/frontActivityBook");
                return model;
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            this.logger.error("frontActivityBook error {}", ex);
            return null;
        }
        return null;
    }

    /**
     * 根据活动id 和活动场次信息得到 该活动场次的座位信息
     *
     * @param activityId
     * @param eventDateTime
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/showActivitySeatInfo")
    public Map showActivitySeatInfo(String activityId, String eventDateTime) throws Exception {
        return activityService.queryActivitySeatInfo(activityId, eventDateTime);
    }

    /**
     * 提交订单后，返回活动预定选坐页面
     *
     * @return
     */
    @RequestMapping(value = "/updateActivityBookInfo")
    public ModelAndView updateActivityBookInfo(String activityId, String selectSeatInfo, Integer bookCount, String eventDateTime, String orderPhoneNo) {
        ModelAndView model = new ModelAndView();
        try {
            CmsActivity cmsActivity = activityService.queryFrontActivityByActivityId(activityId);
            if (cmsActivity != null) {
                model.addObject("eventDateTime", eventDateTime);
                //在线选座情况
                //查询场次信息 时间段
                List<CmsActivityEvent> activityEventTimes = cmsActivityEventService.queryEventTimeByActivityId(activityId);
                //查询场次信息 最大 和最小的有效 日期
                Map map = cmsActivityEventService.queryMinMaxDateByActivityId(activityId);
                if (map != null && map.size() > 0) {
                    cmsActivity.setActivityStartTime(map.get("minEventDate").toString());
                    cmsActivity.setActivityEndTime(map.get("maxEventDate").toString());
                }
                List<CmsActivityEvent> activityEventDates = cmsActivityEventService.queryEventDateByActivityId(activityId);
                String canNotEventStrs = cmsActivityEventService.queryCanNotBookEventTime(activityId);
                model.addObject("activityEventTimes", activityEventTimes);
                model.addObject("activityEventDates", activityEventDates);
                model.addObject("activityId", activityId);
                model.addObject("cmsActivity", cmsActivity);
                model.addObject("selectSeatInfo", selectSeatInfo);
                model.addObject("canNotEventStrs", canNotEventStrs);
                model.addObject("bookCount", bookCount);
                model.addObject("orderPhoneNo", orderPhoneNo);
                model.setViewName("index/activity/frontActivityBook");
                return model;
            }
            model.setViewName("index/activity/frontActivityBook");
            return model;
        } catch (Exception ex) {
            ex.printStackTrace();
            this.logger.error("frontActivityBook error {}", ex);
            return null;
        }
    }


    /**
     * 验证活动预定
     *
     * @param seatId
     * @param cmsActivityOrder
     * @return
     */
    @RequestMapping(value = "/checkFrontActivityBook")
    @ResponseBody
    public Map checkFrontActivityBook(String[] seatId, Integer bookCount, CmsActivityOrder cmsActivityOrder) {
        Map map = new HashMap();
        try {
            CmsTerminalUser terminalUser = (CmsTerminalUser) session.getAttribute("terminalUser");
            if (terminalUser == null) {
                map.put("success", "N");
                map.put("msg", "login");
                return map;
            }
            BookActivitySeatInfo activitySeatInfo = new BookActivitySeatInfo();
            activitySeatInfo.setActivityId(cmsActivityOrder.getActivityId());
            activitySeatInfo.setSeatIds(seatId);
            activitySeatInfo.setBookCount(bookCount);
            activitySeatInfo.setUserId(terminalUser.getUserId());
            activitySeatInfo.setPrice(cmsActivityOrder.getOrderPrice());
            activitySeatInfo.setPhone(cmsActivityOrder.getOrderPhoneNo());
            activitySeatInfo.setsId(UUIDUtils.createUUId());
            activitySeatInfo.setEventId(cmsActivityOrder.getEventId());
            activitySeatInfo.setEventDateTime(cmsActivityOrder.getEventDateTime());
            String checkRs = cacheService.checkActivitySeatStatus(activitySeatInfo, activitySeatInfo.getSeatIds(), bookCount, terminalUser.getUserId());
            if (!Constant.RESULT_STR_SUCCESS.equals(checkRs)) {
                map.put("success", "N");
                map.put("msg", checkRs);
                return map;
            } else {
                map.put("success", "Y");
                return map;
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            this.logger.error("saveFrontActivityBook error {}", ex);
            map.put("success", "N");
            map.put("msg", ex.toString());
            return map;
        }
    }

    /**
     * 确定订单页面
     *
     * @param request
     * @param cmsActivityOrder
     * @param seatId
     * @param bookCount
     * @return
     */
    @RequestMapping(value = "/preSaveActivityOder")
    public String preSaveActivityOder(HttpServletRequest request, CmsActivityOrder cmsActivityOrder, String[] seatId, Integer bookCount, String seatValues) {
        try {
            CmsActivity cmsActivity = activityService.queryFrontActivityByActivityId(cmsActivityOrder.getActivityId());
            cmsActivityOrder.setOrderNumber(cacheService.genOrderNumber());
            if (seatId != null) {
                cmsActivityOrder.setOrderSummary(arrayToString(seatId));
                request.setAttribute("seatIds", arrayToString(seatId));
            }
            cmsActivityOrder.setOrderVotes(bookCount);
            request.setAttribute("activityOrder", cmsActivityOrder);
            request.setAttribute("activity", cmsActivity);
            request.setAttribute("seatValues", seatValues);
            request.setAttribute("bookCount", bookCount);
        } catch (Exception ex) {
            this.logger.error("preSaveActivityOder error {}", ex);
        }
        return "index/activity/activityBookOrder";
    }

    public String arrayToString(String[] strs) {
        StringBuffer sb = new StringBuffer();
        for (String str : strs) {
            sb.append(str + ",");
        }
        return sb.toString();
    }

    /**
     * 保存预定订单
     *
     * @param request
     * @param cmsActivityOrder
     * @param seatIds
     * @param bookCount
     * @return
     */
    @RequestMapping(value = "/saveActivityOder")
    @ResponseBody
    public Map saveActivityOder(HttpServletRequest request, CmsActivityOrder cmsActivityOrder, String seatValues, String seatIds, Integer bookCount) {
        Map map = new HashMap();
        try {
            CmsTerminalUser terminalUser = (CmsTerminalUser) session.getAttribute("terminalUser");
            if (terminalUser == null) {
                map.put("success", "N");
                map.put("msg", "请先登录");
                return map;
            }
            if (StringUtils.isBlank(seatIds) && bookCount == null) {
                map.put("success", "N");
                map.put("msg", "请选择座位");
                return map;
            }
            cmsActivityOrder.setSeatVals(seatValues);
            cmsActivityOrder.setOrderVotes(bookCount);
            String count = cmsActivityOrderService.addActivityOrder(cmsActivityOrder);
            return map;
        } catch (Exception ex) {
            ex.printStackTrace();
            map.put("success", "N");
            map.put("msg", ex.toString());
            return map;
        }
    }

    /**
     * 订单保存成功之后  跳转至成功提示页面
     *
     * @param request
     * @return
     */
    @RequestMapping(value = "/saveActivityOderOver")
    public String saveActivityOderOver(HttpServletRequest request, String activityId, String activityOrderId, String seatValues, String eventDateTime) {
        try {
            CmsActivity activity = activityService.queryCmsActivityByActivityId(activityId);
            CmsActivityOrder activityOrder = cmsActivityOrderService.queryCmsActivityOrderById(activityOrderId);
            request.setAttribute("activity", activity);
            request.setAttribute("activityOrder", activityOrder);
            request.setAttribute("eventDateTime", eventDateTime);
            seatValues = URLDecoder.decode(seatValues, "UTF-8");
            request.setAttribute("seatValues", seatValues.replace(",", "；"));
            request.setAttribute("activityName", activity.getActivityName());
            request.setAttribute("activityId", activityId);
            request.setAttribute("activityOrderId", activityOrderId);
        } catch (Exception e) {
            e.printStackTrace();
        }

        return "index/activity/activityBookSuccess";
    }

    /**
     * 生成电子票
     *
     * @param activityCity    市
     * @param activityArea    区
     * @param activityName    活动名称
     * @param eventDateTime   场次结束时间
     * @param activityAddress 活动地址
     * @param orderSummary    座位
     * @param seatValues      座位值
     * @param activityOrderId 活动订单id
     * @return
     */
    @RequestMapping(value = "/buildTicket")
    @ResponseBody
    public Map buildTicket(String activityCity, String activityArea, String activityName, String eventDateTime, String activityAddress, String orderSummary, String seatValues, String activityOrderId) {
        Map map = new HashMap();

        CmsActivityOrder activityOrder = cmsActivityOrderService.queryCmsActivityOrderById(activityOrderId);
        //封装二维码路径生成二维码图片
        StringBuffer sb = new StringBuffer();    //二维码保存地址
        StringBuffer sb2 = new StringBuffer();    //电子票保存地址
        StringBuffer sb3 = new StringBuffer();    //二维码显示地址
        StringBuffer sb4 = new StringBuffer();    //电子票显示地址
        sb.append(basePath.getBasePath());
        sb2.append(basePath.getBasePath());
        sb3.append(staticServer.getStaticServerUrl());
        sb4.append(staticServer.getStaticServerUrl());
        SimpleDateFormat sdf1 = new SimpleDateFormat("yyyyMM");
        sb.append(sdf1.format(new Date()));
        sb.append("/");
        sb2.append(sdf1.format(new Date()));
        sb2.append("/ticket/");
        sb3.append(sdf1.format(new Date()));
        sb3.append("/");
        sb4.append(sdf1.format(new Date()));
        sb4.append("/ticket/");
        // 判断是否存在0*0文件夹，如果没有就创建
        File file = new File(sb2.toString());
        if (!file.exists()) {
            file.mkdirs();
        }
        if (activityOrder.getOrderValidateCode() != null && org.apache.commons.lang3.StringUtils.isNotBlank(activityOrder.getOrderValidateCode())) {
            sb.append(activityOrder.getOrderValidateCode());
            sb.append(".jpg");
            sb2.append(activityOrder.getOrderValidateCode());
            sb2.append(".png");
            sb3.append(activityOrder.getOrderValidateCode());
            sb3.append(".jpg");
            sb4.append(activityOrder.getOrderValidateCode());
            sb4.append(".png");
        }
        Code.encode(activityOrder.getOrderValidateCode(), sb.toString());

        //生成电子票
        StringBuffer img = new StringBuffer();
        img.append(staticServer.getStaticServerUrl());
        img.append("front/ticket-top.png");
        HtmlImageGenerator imageGenerator = new HtmlImageGenerator();
        StringBuffer html = new StringBuffer();
        html.append("<head>" +
                "<meta http-equiv='Content-Type' content='text/html; charset=utf-8'/>" +
                "</head>");
        if (orderSummary != null && orderSummary != "") {
            html.append("<div style=\"display: block; width: 290px;height:440px;border: solid 1px #979797; background-color: #ffffff;font-family: Microsoft YaHei,PingFangSC-Regular,SimHei;\">");
            html.append("<div style=\"width: 100%; height: 57px; overflow: hidden;\"><img src=\"" + img + "\"/></div>");
            html.append("<div style=\"padding: 19px 29px 36px;\">");
            html.append("<h3 style=\"line-height: 20px; color: #262626; font-size: 14px; padding-bottom: 18px;\">" + activityName + "</h3>");
            html.append("<p style=\"line-height: 14px; color: #4A4A4A; font-size: 12px; padding: 2px 0;\">时间：" + eventDateTime + "</p>");
            html.append("<p style=\"line-height: 14px; color: #4A4A4A; font-size: 12px; padding: 2px 0;\">地址：" + activityAddress + "</p>");
            html.append("<p style=\"line-height: 14px; color: #4A4A4A; font-size: 12px; padding: 2px 0;\">座位：" + seatValues + "</p>");
            html.append("<div style=\"width: 95px; height: 95px; overflow: hidden; margin-top: 18px;margin-left:72px;\"><img src=\"" + sb3.toString() + "\"/></div>");
            html.append("</div>");
            html.append("</div>");
        } else {
            html.append("<div style=\"display: block; width: 290px;height:425px;border: solid 1px #979797; background-color: #ffffff;font-family: Microsoft YaHei,PingFangSC-Regular,SimHei;\">");
            html.append("<div style=\"width: 100%; height: 57px; overflow: hidden;\"><img src=\"" + img + "\"/></div>");
            html.append("<div style=\"padding: 19px 29px 36px;\">");
            html.append("<h3 style=\"line-height: 20px; color: #262626; font-size: 14px; padding-bottom: 18px;\">" + activityName + "</h3>");
            html.append("<p style=\"line-height: 14px; color: #4A4A4A; font-size: 12px; padding: 2px 0;\">时间：" + eventDateTime + "</p>");
            html.append("<p style=\"line-height: 14px; color: #4A4A4A; font-size: 12px; padding: 2px 0;\">地址：" + activityAddress + "</p>");
            html.append("<p style=\"line-height: 14px; color: #4A4A4A; font-size: 12px; padding: 2px 0;\">票数：" + activityOrder.getOrderVotes() + "张</p>");
            html.append("<div style=\"width: 95px; height: 95px; overflow: hidden; margin-top: 18px;margin-left:72px;\"><img src=\"" + sb3.toString() + "\"/></div>");
            html.append("</div>");
            html.append("</div>");
        }

        try {
            imageGenerator.loadHtml(html.toString());
            imageGenerator.getBufferedImage();    //防止图片生成失败，提前生成一次图片
            imageGenerator.saveAsImage(sb2.toString());
        } catch (Exception e) {
            logger.error("buildTicket error {}", e);
        }

        map.put("result", "Y");
        map.put("codeUrl", sb3.toString());
        map.put("ticketUrl", sb4.toString().replace("\\", "/"));
        return map;
    }

    /**
     * 取消用户订单
     *
     * @param request
     * @param activityOrderId
     * @return
     */
    @RequestMapping(value = "/cancelUserOrder")
    @ResponseBody
    public Map<String, String> cancelUserOrder(HttpServletRequest request, String activityOrderId, String orderSeat, Integer cancelCount) {
        Map map = new HashMap();
        try {
            CmsTerminalUser terminalUser = (CmsTerminalUser) session.getAttribute("terminalUser");
            map = cmsActivityOrderService.cancelUserOrder(activityOrderId, terminalUser, orderSeat, cancelCount);
            return map;
        } catch (Exception ex) {
            map.put("success", "N");
            map.put("msg", ex.toString());
            return map;
        }
    }


    /**
     * 根据查询出的座位列表绘制前台展示座位信息
     *
     * @param venueSeatList
     * @return
     */
    public Map<String, String> getSeatInfo(List<CmsVenueSeat> venueSeatList) {
        Map<String, String> allSeatInfo = new HashMap<String, String>();

        StringBuilder seatInfoBuilder = new StringBuilder();
        StringBuilder maintananceBuilder = new StringBuilder();
        StringBuilder vipBuilder = new StringBuilder();

        String commonSeat = "a";
        String noneSeat = "_";
        String maintenanceSeat = "m";
        String vipSeat = "v";

        int tmpVar = 1;

        for (int i = 0; i < venueSeatList.size(); i++) {
            CmsVenueSeat venueSeat = venueSeatList.get(i);
            if (tmpVar != venueSeat.getSeatRow()) {
                seatInfoBuilder.append(",");
                tmpVar++;
            }
            if (venueSeat.getSeatStatus() == Constant.VENUE_SEAT_STATUS_NORMAL) {
                seatInfoBuilder.append(commonSeat);
            }
            if (venueSeat.getSeatStatus() == Constant.VENUE_SEAT_STATUS_MAINTANANCE) {
                seatInfoBuilder.append(maintenanceSeat);
                maintananceBuilder.append(venueSeat.getSeatCode() + ",");
            }
            if (venueSeat.getSeatStatus() == Constant.VENUE_SEAT_STATUS_NONE) {
                seatInfoBuilder.append(noneSeat);
            }
            if (venueSeat.getSeatStatus() == Constant.VENUE_SEAT_STATUS_VIP) {
                seatInfoBuilder.append(vipSeat);
                vipBuilder.append(venueSeat.getSeatCode() + ",");
            }
        }

        String seatInfo = seatInfoBuilder.toString();
        String maintananceSeatInfo = maintananceBuilder.toString();
        String vipSeatInfo = vipBuilder.toString();
        if (!maintananceSeatInfo.equals("")) {
            maintananceSeatInfo = maintananceSeatInfo.substring(0, (maintananceSeatInfo.length() - 1));
        }
        if (!vipSeatInfo.equals("")) {
            vipSeatInfo = vipSeatInfo.substring(0, (vipSeatInfo.length() - 1));
        }
        allSeatInfo.put("seatInfo", seatInfo);
        allSeatInfo.put("maintananceInfo", maintananceSeatInfo);
        allSeatInfo.put("vipInfo", vipSeatInfo);
        return allSeatInfo;
    }


    /**
     * 根据活动id 查询该活动所有的标签值
     *
     * @param activityId
     * @return
     */
    @RequestMapping(value = "/queryActivityLabelById")
    @ResponseBody
    public List<Map> queryActivityLabelById(String activityId) {
        try {
            return activityService.queryActivityLabelById(activityId);
        } catch (Exception ex) {
            ex.printStackTrace();
            logger.error("queryActivityLabelById error {}", ex);
        }
        return null;
    }

    /**
     * 前端2.0 添加评论
     *
     * @param comment
     * @param
     * @return
     */
    @RequestMapping(value = "/addComment", method = {RequestMethod.POST})
    @ResponseBody
    public String addComment(CmsComment comment) {
        try {
            if (session.getAttribute("terminalUser") != null) {
                String sensitiveWords = CmsSensitive.sensitiveWords(comment, cmsSensitiveWordsMapper);
                if (StringUtils.isNotBlank(sensitiveWords) && sensitiveWords.equals("sensitiveWordsExist")) {
                    return Constant.SensitiveWords_EXIST;
                }
                CmsTerminalUser user = (CmsTerminalUser) session.getAttribute("terminalUser");
                comment.setCommentUserId(user.getUserId());
                comment.setCommentType(Constant.TYPE_ACTIVITY);
                return commentService.addComment(comment);
            }
        } catch (Exception e) {
            logger.error("addComment error {}", e);
            return Constant.RESULT_STR_FAILURE;
        }
        return Constant.RESULT_STR_FAILURE;
    }


    //前台场馆详情显示评论列表
    @RequestMapping(value = "/commentList")
    @ResponseBody
    public List<CmsComment> commentList(CmsComment cmsComment, Integer pageNum, Pagination page) {
        //评论列表
        page.setRows(10);
        page.setPage(pageNum);
        List<CmsComment> commentList = cmsCommentService.queryCommentByCondition(cmsComment, page, null);
        return commentList;
    }


    /**
     * 根据活动ID获取评论数量
     *
     * @return
     */
    @RequestMapping(value = "/getCommentCountById")
    @ResponseBody
    public int getCommentCountById(String activityId) {
        CmsComment cmsComment = new CmsComment();
        cmsComment.setCommentRkId(activityId);
        cmsComment.setCommentType(Constant.TYPE_ACTIVITY);
        int commentCount = cmsCommentService.queryCommentCountByCondition(cmsComment);
        return commentCount;
    }


    @RequestMapping(value = "/getAdvertImg")
    @ResponseBody
    public List<CmsAdvert> getAdvertImg(final String siteId, String displayPosition) {

        List<CmsAdvert> cacheList = cacheService.getAdvert(CacheConstant.ADVERT_IMG + siteId);

        if (!CollectionUtils.isEmpty(cacheList)) {
            return cacheList;
        }

        List<CmsAdvert> advertList = cmsAdvertService.queryAdvertBySite(siteId, displayPosition);
        if (!CollectionUtils.isEmpty(advertList)) {
            setAdvertToCache(siteId, advertList);
            return advertList;
        }

        //如果没有 则默认为上海市的轮播图 仍从缓存获取 放入缓存
        advertList = cacheService.getAdvert(CacheConstant.ADVERT_IMG + Constant.advertDefaultPos);
        if (!CollectionUtils.isEmpty(advertList)) {
            return advertList;
        }

        //都没取到 去查询上海市
        advertList = cmsAdvertService.queryAdvertBySite(Constant.advertDefaultPos, displayPosition);
        if (!CollectionUtils.isEmpty(advertList)) {
            setAdvertToCache(Constant.advertDefaultPos, advertList);
        }

        return advertList;
    }


    private void setAdvertToCache(final String siteId, final List<CmsAdvert> list) {
        Runnable runner = new Runnable() {
            @Override
            public void run() {
                Calendar calendar = Calendar.getInstance();
                calendar.setTime(new Date());
                //设置过期时间为当前时间之后的24小时
                calendar.add(Calendar.HOUR_OF_DAY, 24);
                cacheService.setAdvertList(CacheConstant.ADVERT_IMG + siteId, list, calendar.getTime());
            }
        };

        Thread t = new Thread(runner);
        t.start();
    }

    //第三方登录完善信息对话框
    @RequestMapping("/dialog")
    public ModelAndView dialog(HttpServletRequest request) {
        request.setAttribute("mobile", request.getParameter("code"));
        return new ModelAndView("index/activity/dialog");
    }


    /**
     * 查询订单是否已经生成
     *
     * @return
     */
    @RequestMapping(value = "/queryOrderNumber")
    @ResponseBody
    public int queryOrderNumber(String orderNumber) {
        int count = cmsActivityOrderService.queryCountByOrderNo(orderNumber);
        return count;
    }

    /**
     * 查询可以预定的时间段信息
     *
     * @param activityId
     * @param eventDate
     * @return
     */
    @RequestMapping(value = "/queryCanBookEventTime")
    @ResponseBody
    public List queryCanBookEventTime(String activityId, String eventDate) {
        try {
            return cmsActivityEventService.queryCanBookEventTime(activityId, eventDate);
        } catch (Exception ex) {
            ex.printStackTrace();
            return null;
        }
    }

    /**
     * 活动数字展馆列表首页
     *
     * @return
     */
    @RequestMapping(value = "/venueNoIndex")
    public String venueNoIndex() {
        return "index/activity/venueNoIndex";
    }


    /**
     * 活动数字展馆列表页
     *
     * @param page
     * @return
     */
    @RequestMapping(value = "/venueNoIndexLoad")
    public String venueNoIndexLoad(CmsActivity activity, Pagination page, HttpServletRequest request) {
        try {
            page.setRows(12);
            CmsVenue cmsVenue = cmsVenueService.queryVenueByVenueName(activity.getVenueName());
            List<CmsActivity> activityList = new ArrayList<CmsActivity>();
            if (cmsVenue != null) {
                activity.setVenueId(cmsVenue.getVenueId());
                activityList = activityService.queryCmsActivityListLoad(activity, page);
                request.setAttribute("venueId", cmsVenue.getVenueId());
            }
            if (activity.getVenueName() == null || "".equals(activity.getVenueName())) {
                activityList = activityService.queryCmsActivityListLoad(activity, page);
            }

            request.setAttribute("activityList", activityList);
            request.setAttribute("page", page);
            return "index/activity/venueNoIndexLoad";
        } catch (Exception ex) {
            ex.printStackTrace();
            this.logger.error("frontActivityList error {}", ex);
            return null;
        }
    }

    /**
     * 活动图书馆列表首页
     *
     * @return
     */
    @RequestMapping(value = "/venueBookIndex")
    public String venueBookIndex() {
        return "index/activity/venueBookIndex";
    }

    /**
     * 活动图书馆列表页
     *
     * @param page
     * @return
     */
    @RequestMapping(value = "/venueBookIndexLoad")
    public String venueBookIndexLoad(CmsActivity activity, Pagination page, HttpServletRequest request) {
        try {
            page.setRows(12);
            CmsVenue cmsVenue = cmsVenueService.queryVenueByVenueName(activity.getVenueName());
            List<CmsActivity> activityList = new ArrayList<CmsActivity>();
            if (cmsVenue != null) {
                activity.setVenueId(cmsVenue.getVenueId());
                activityList = activityService.queryBookCmsActivityListLoad(activity, page);
                request.setAttribute("venueId", cmsVenue.getVenueId());
            }
            if (activity.getVenueName() == null || "".equals(activity.getVenueName())) {
                activityList = activityService.queryBookCmsActivityListLoad(activity, page);
            }

            request.setAttribute("activityList", activityList);
            request.setAttribute("page", page);
            return "index/activity/venueBookIndexLoad";
        } catch (Exception ex) {
            ex.printStackTrace();
            this.logger.error("venueBookIndexLoad error {}", ex);
            return null;
        }
    }

    /**
     * 活动我想去接口
     *
     * @param activityId 活动id
     * @param userId     用户id
     *                   return 是否报名成功 (成功：success；失败：false)
     */
    @RequestMapping(value = "/addActivityUserWantgo")
    @ResponseBody
    public String addActivityUserWantgo(String activityId, String userId, Pagination page) throws Exception {
        String result = "false";
        try {
            CmsUserWantgo activityUserWantgo = new CmsUserWantgo();
            activityUserWantgo.setRelateId(activityId);
            activityUserWantgo.setUserId(userId);
            List<CmsUserWantgo> wantGoList = activityService.queryActivityUserWantgoByCondition(page, activityUserWantgo);
            if (wantGoList.size() == 0) {
                result = activityService.addActivityUserWantgo(activityId, userId);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    /**
     * 前台我想去列表listload
     *
     * @param activityId
     * @param userId
     * @param page
     * @return
     */
    @RequestMapping(value = "/frontWantGoListLoad")
    public String frontWantGoListLoad(String activityId, String userId, HttpServletRequest request, Pagination page) {
        try {
            page.setRows(24);    //前台每页显示24个
            CmsUserWantgo activityUserWantgo = new CmsUserWantgo();
            activityUserWantgo.setRelateId(activityId);
            List<CmsUserWantgo> wantGoList = activityService.queryActivityUserWantgoByCondition(page, activityUserWantgo);

            //该活动我想去总人数
            int count = activityService.queryActivityUserWantgoCount(activityUserWantgo);

            //判断用户是否已经点过我想去
            if (StringUtils.isNotBlank(userId)) {
                CmsUserWantgo activityUserWantgo2 = new CmsUserWantgo();
                activityUserWantgo2.setRelateId(activityId);
                activityUserWantgo2.setUserId(userId);
                List<CmsUserWantgo> list2 = activityService.queryActivityUserWantgoByCondition(page, activityUserWantgo2);
                if (list2.size() > 0) {
                    request.setAttribute("isWantGo", "N");
                } else {
                    request.setAttribute("isWantGo", "Y");
                }
            } else {
                request.setAttribute("isWantGo", "Y");
            }
            request.setAttribute("wantGoList", wantGoList);
            request.setAttribute("activityId", activityId);
            request.setAttribute("userId", userId);
            request.setAttribute("page", page);
            request.setAttribute("count", count);
            return "index/activity/frontWantGoListLoad";
        } catch (Exception ex) {
            ex.printStackTrace();
            this.logger.error("frontWantGoListLoad error {}", ex);
            return null;
        }
    }

    /**
     * 举报页面跳转
     *
     * @return
     */
    @RequestMapping("/activityReportDialog")
    public String activityReportDialog(HttpServletRequest request, String activityId) {
        request.setAttribute("activityId", activityId);
        /*request.setAttribute("userId", userId);*/
        return "index/activity/activityReportDialog";
    }


    /**
     * 得到子区县中的活动 余票数量
     */
    @RequestMapping(value = "/getSubSystemTicketCount")
    @ResponseBody
    public String getSubSystemTicketCount(String[] sysId) {
        if (sysId != null && sysId.length > 0) {
            return cmsApiActivityOrderService.getSubSystemActivityTicketCount(sysId);
        } else {
            return Constant.RESULT_STR_FAILURE;
        }
    }

    /**
     * 文化云3.1前端首页
     *
     * @return
     */
    @RequestMapping("/activityList")
    public String frontIndex(HttpServletRequest request) {
        request.setAttribute("activityName", request.getParameter("activityName"));
        return "index/activity/frontIndex";
    }

}
