package com.sun3d.why.webservice.service.impl;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.sun3d.why.dao.*;
import com.sun3d.why.jms.client.ActivityBookClient;
import com.sun3d.why.model.*;
import com.sun3d.why.model.extmodel.AppIndexData;
import com.sun3d.why.model.extmodel.BookActivitySeatInfo;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.model.extmodel.shareUrl;
import com.sun3d.why.service.CacheConstant;
import com.sun3d.why.service.CacheService;
import com.sun3d.why.service.CmsActivityOrderService;
import com.sun3d.why.service.CollectService;
import com.sun3d.why.statistics.service.StatisticService;
import com.sun3d.why.util.*;
import com.sun3d.why.webservice.api.model.CmsApiOrder;
import com.sun3d.why.webservice.api.service.CmsApiActivityOrderService;
import com.sun3d.why.webservice.api.util.CmsApiOtherServer;
import com.sun3d.why.webservice.api.util.HttpClientConnection;
import com.sun3d.why.webservice.api.util.HttpResponseText;
import com.sun3d.why.webservice.service.ActivityAppService;
import com.sun3d.why.webservice.service.UserWillStartAppService;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@Transactional
@Service
public class ActivityAppServiceImpl implements ActivityAppService {
    private Logger logger = Logger.getLogger(ActivityAppServiceImpl.class);
    @Autowired
    private CmsActivityMapper activityMapper;
    @Autowired
    private StaticServer staticServer;
    @Autowired
    private CollectService collectService;
    @Autowired
    private CacheService cacheService;
    @Autowired
    private shareUrl shareUrlService;
    @Autowired
    private CmsActivityEventMapper cmsActivityEventMapper;
    @Autowired
    private CmsUserWantgoMapper cmsUserWantgoMapper;
    @Autowired
    private CmsActivityRecommendTagMapper cmsActivityRecommendTagMapper;
    @Autowired
    private CmsListRecommendTagMapper cmsListRecommendTagMapper;
    @Autowired
    private CmsVideoMapper cmsVideoMapper;
    @Autowired
    private CmsUserTagMapper cmsUserTagMapper;
    @Autowired
    private CmsTagMapper cmsTagMapper;
    @Autowired
    private CmsTerminalUserMapper userMapper;
    @Autowired
    private CmsApiOtherServer cmsApiOtherServer;
    @Autowired
    private UserWillStartAppService userWillStartAppService;
    @Autowired
    private CmsApiActivityOrderService cmsApiActivityOrderService;
    @Autowired
    private StatisticService statisticService;
    @Autowired
    private UserIntegralMapper userIntegralMapper;
    @Autowired
    private UserIntegralDetailMapper userIntegralDetailMapper;
    @Autowired
    private CmsActivityOrderService cmsActivityOrderService;
    @Autowired
    private CmsActivitySeatMapper cmsActivitySeatMapper;

    // 正则表达式匹配为大于0数字
    private String match = "(([0-9]+)([.]([0-9]+))?|([.]([0-9]+))?)$";
    /**
     * app首页栏目推荐活动列表
     *
     * @param pageApp          分页对象
     * @param lon
     * @param lat
     * @param freeActivity     免费看演出
     * @param childrenActivity 孩子学艺术
     * @param whereActivity    周末去哪儿
     */
    @Override
    public String queryAppActivityList(PaginationApp pageApp, String lon, String lat, String freeActivity, String childrenActivity, String whereActivity) {
        List<Map<String, Object>> mapFreeActivityList = new ArrayList<Map<String, Object>>();
        List<Map<String, Object>> mapChildrenList = new ArrayList<Map<String, Object>>();
        List<Map<String, Object>> mapWhereList = new ArrayList<Map<String, Object>>();
        Map<String, Object> map = new HashMap<String, Object>();
        if (pageApp != null && pageApp.getFirstResult() != null && pageApp.getRows() != null) {
            map.put("firstResult", pageApp.getFirstResult());
            map.put("rows", pageApp.getRows());
        }
        map.put("activityIsDel", Constant.NORMAL);
        map.put("activityState", Constant.PUBLISH);
        //免费看演出活动列表
        if (freeActivity != null && StringUtils.isNotBlank(freeActivity)) {
            map.put("tagName", freeActivity);
            map.put("recommendType", Constant.RECOMMEND_COLUMN_TYPE1);
            List<CmsActivity> rsList = activityMapper.queryFrontAppAllActivityList(map);
            mapFreeActivityList = getAppActivityResult(rsList, staticServer, null, null, null, null, null);
        }
        //孩子学艺术活动列表
        if (childrenActivity != null && StringUtils.isNotBlank(childrenActivity)) {
            map.put("tagName", childrenActivity);
            map.put("recommendType", Constant.RECOMMEND_COLUMN_TYPE2);
            List<CmsActivity> rsList = activityMapper.queryFrontAppAllActivityList(map);
            mapChildrenList = getAppActivityResult(rsList, staticServer, null, null, null, null, null);
        }
        //周末去哪儿
        if (whereActivity != null && StringUtils.isNotBlank(whereActivity)) {
            map.put("tagName", whereActivity);
            map.put("recommendType", Constant.RECOMMEND_COLUMN_TYPE2);
            List<CmsActivity> rsList = activityMapper.queryFrontAppAllActivityList(map);
            mapWhereList = getAppActivityResult(rsList, staticServer, null, null, null, null, null);
        }
        return JSONResponse.toFourParamterResult(0, mapFreeActivityList, mapChildrenList, mapWhereList, null);
    }

    /**
     * app根据条件筛选活动
     *
     * @param appType        活动类型筛选  1.距离  2.即将开始
     * @param pageApp        分页对象
     * @param Lon            用户经度
     * @param Lat            用户纬度
     * @param activityTypeId 活动类型标签id
     * @param activityTime   活动时间
     * @return
     */
    @Override
    public String queryActivityListPage(String appType, PaginationApp pageApp, String Lon, String Lat, String activityTime, String activityTypeId, String userId) throws ParseException {
        List<Map<String, Object>> listMap = new ArrayList<Map<String, Object>>();
        Map<String, Object> map = new HashMap<String, Object>();
        try {
            map.put("activityIsDel", 1);
            map.put("activityState", 6);
            //区分即将开始 距离
            map.put("appType", appType);
            map.put("lat", Lat);
            map.put("lon", Lon);
            if (StringUtils.isNotBlank(activityTypeId)) {
                String[] tagIds = activityTypeId.split(",");
                map.put("typeTagIds", tagIds);
            }
            if (pageApp != null && pageApp.getFirstResult() != null && pageApp.getRows() != null) {
                map.put("firstResult", pageApp.getFirstResult());
                map.put("rows", pageApp.getRows());
            }
            if (activityTime != null && StringUtils.isNotBlank(activityTime)) {
                map.put("activityTime", activityTime);
            }
            List<CmsActivity> activityList = activityMapper.queryActivityListPage(map);
            listMap = getAppActivityResult(activityList, staticServer, activityTypeId, cmsTagMapper, appType, userId, userMapper);
        } catch (Exception e) {
            e.printStackTrace();
            logger.error("query activityList error" + e.getMessage());
        }
        return JSONResponse.toAppResultFormat(0, listMap);
    }

    /**
     * app获取最热门活动列表
     *
     * @param pageApp        分页对象
     * @param activityTypeId 活动类型标签id
     * @param appType        1.距离  2.即将开始 3.热门
     * @param userId         用户id
     * @return
     */
    @Override
    public String queryAppHotByActivity(PaginationApp pageApp, String Lon, String Lat, String activityTypeId, String appType, String userId) throws ParseException {
        List<Map<String, Object>> listMap = new ArrayList<Map<String, Object>>();
        Map map = new HashMap();
        try {
            map.put("activityIsDel", 1);
            map.put("activityState", 6);
            if (pageApp != null && pageApp.getFirstResult() != null && pageApp.getRows() != null) {
                map.put("firstResult", pageApp.getFirstResult());
                map.put("rows", pageApp.getRows());
                //  int total = activityMapper.queryAppHotByActivityListCount(map);
                //pageApp.setTotal(total);
            }
            map.put("lat", Lat);
            map.put("lon", Lon);
            if (StringUtils.isNotBlank(activityTypeId)) {
                String[] tagIds = activityTypeId.split(",");
                map.put("typeTagIds", tagIds);
            }
            List<CmsActivity> activityList = activityMapper.queryAppHotByActivity(map);
            listMap = getAppActivityResult(activityList, staticServer, activityTypeId, cmsTagMapper, appType, userId, userMapper);
        } catch (Exception e) {
            e.printStackTrace();
            logger.error(e.getMessage());
        }
        return JSONResponse.toAppResultFormat(0, listMap);
    }

    /**
     * 根据活动id查询活动详情
     *
     * @param activityId 活动id
     * @return
     */
    @Override
    public String queryAppActivityById(String activityId, String userId) {
        SimpleDateFormat sdf2 = new SimpleDateFormat("yyyy-MM-dd HH:mm");
        List<Map<String, Object>> mapTypeList = new ArrayList<Map<String, Object>>();
        List<Map<String, Object>> listMap = new ArrayList<Map<String, Object>>();
        List<Map<String, Object>> listVideo = new ArrayList<Map<String, Object>>();
        Map<String, Object> map = new HashMap<String, Object>();
        if (userId != null && StringUtils.isNotBlank(userId)) {
            map.put("userId", userId);
            map.put("type", Constant.TYPE_ACTIVITY);
        }
        if (activityId != null && StringUtils.isNotBlank(activityId)) {
            map.put("relatedId", activityId);
        }
        map.put("videoType", Constant.ACTIVITY_VIDEO_TYPE);
        /*  SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
       String date = sdf.format(new Date());
        map.put("activityStartTime", date);*/
        CmsActivity cmsActivity = activityMapper.queryAppActivityById(map);
        if (cmsActivity != null) {
            Map<String, Object> mapActivity = new HashMap<String, Object>();
            String activityIconUrl = "";
            if (StringUtils.isNotBlank(cmsActivity.getActivityIconUrl())) {
                activityIconUrl = staticServer.getStaticServerUrl() + cmsActivity.getActivityIconUrl();
            }
            mapActivity.put("activityIconUrl", activityIconUrl);
            mapActivity.put("activityIsCollect", cmsActivity.getCollectNum() > 0 ? 1 : 0);
            mapActivity.put("activityFunName", cmsActivity.getFunName() != null ? cmsActivity.getFunName() : "");
            //查询该活动收藏数量
            int collectNum = collectService.getHotNum(cmsActivity.getActivityId(), Constant.TYPE_ACTIVITY);
            mapActivity.put("collectNum", collectNum != 0 ? collectNum : 0);
            mapActivity.put("activityName", cmsActivity.getActivityName() != null ? cmsActivity.getActivityName() : "");
            mapActivity.put("activitySite", cmsActivity.getActivitySite() != null ? cmsActivity.getActivitySite() : "");
            mapActivity.put("activityAddress", (cmsActivity.getActivityAddress() != null ? cmsActivity.getActivityAddress() : ""));
            mapActivity.put("activityStartTime", cmsActivity.getActivityStartTime() != null ? cmsActivity.getActivityStartTime() : "");
            mapActivity.put("activityEndTime", StringUtils.isNotBlank(cmsActivity.getActivityEndTime()) ?
                    cmsActivity.getActivityEndTime() : mapActivity.get("activityStartTime"));
            mapActivity.put("activityTel", cmsActivity.getActivityTel() != null ? cmsActivity.getActivityTel() : "");

            //子系统对接修改
            mapActivity.put("activityDateNums", cmsActivity.getDateNums());
            //end
            mapActivity.put("activityTimeDes", cmsActivity.getActivityTimeDes() != null ? cmsActivity.getActivityTimeDes() : "");

            mapActivity.put("activityPrice", StringUtils.isNotBlank(cmsActivity.getActivityPrice()) &&
                    cmsActivity.getActivityIsFree() == 2 ? (cmsActivity.getActivityPrice().matches(match) ? cmsActivity.getActivityPrice() : "0") : "0");
            String priceDescribe = "";
            if (Double.parseDouble(mapActivity.get("activityPrice").toString()) > 0d && cmsActivity.getActivityIsFree() == 2) {
                priceDescribe = mapActivity.get("activityPrice") + "元 " + (cmsActivity.getPriceDescribe() != null ? cmsActivity.getPriceDescribe() : "");
            } else {
                priceDescribe = "免费";
            }
            mapActivity.put("priceDescribe", priceDescribe);
            // 嘉定数据
            if ("1".equals(cmsActivity.getSysNo()) && StringUtils.isNotBlank(cmsActivity.getSysId())) {
                //为嘉定活动时
                Map map1 = this.getSubSystemTicketCount(cmsActivity);
                if (map1 != null && "Y".equals(map1.get("success").toString())) {
                    Integer ticketCount = Integer.valueOf(map1.get("ticketCount") == null ? "0" : map1.get("ticketCount").toString());
                    mapActivity.put("activityAbleCount", ticketCount);
                } else {
                    mapActivity.put("activityAbleCount", 0);
                }
            } else {
                mapActivity.put("activityAbleCount", cmsActivity.getAvailableCount() != null ? cmsActivity.getAvailableCount() : 0);
            }

            mapActivity.put("activityTime", cmsActivity.getActivityTime());
            //获取活动经纬度
            double activityLon = 0d;
            if (cmsActivity.getActivityLon() != null) {
                activityLon = cmsActivity.getActivityLon();
            }
            double activityLat = 0d;
            if (cmsActivity.getActivityLat() != null) {
                activityLat = cmsActivity.getActivityLat();
            }
            mapActivity.put("activityLon", activityLon);
            mapActivity.put("activityLat", activityLat);
            mapActivity.put("activityIsReservation", cmsActivity.getActivityIsReservation() != null ? cmsActivity.getActivityIsReservation() : "");
            mapActivity.put("activitySalesOnline", cmsActivity.getActivitySalesOnline() != null ? cmsActivity.getActivitySalesOnline() : "");
            mapActivity.put("activityId", cmsActivity.getActivityId() != null ? cmsActivity.getActivityId() : "");
            // 无收费（活动简介前加直接前往、无需预约、无需付费，有任何问题欢迎拨打电话咨询（电话号码？）），有收费（需要事先预定，请点击“活动预定”按钮进行票务预订。有任何问题欢迎拨打电话咨询（电话号码？））
            if (cmsActivity.getActivityIsFree() == 1) {
                if (cmsActivity.getActivityIsReservation() == 1) {
                    mapActivity.put("activityMemo", "<font color='#ff0000'>【 温馨提示：直接前往、无需预约、无需付费，有任何问题" +
                            "欢迎拨打电话咨询" + mapActivity.get("activityTel") + " 】</font>" + (cmsActivity.getActivityMemo() != null ? cmsActivity.getActivityMemo() : ""));
                } else if (cmsActivity.getActivityIsReservation() == 2) {
                    mapActivity.put("activityMemo", "<font color='#ff0000'>【 温馨提示：需要事先预定，请点击“活动预定”按钮进行票务预订。有任何问题欢迎拨打电话" +
                            "咨询" + mapActivity.get("activityTel") + " 】</font>" + (cmsActivity.getActivityMemo() != null ? cmsActivity.getActivityMemo() : ""));
                } else {
                    mapActivity.put("activityMemo", cmsActivity.getActivityMemo() != null ? cmsActivity.getActivityMemo() : "");
                }
            } else if (cmsActivity.getActivityIsFree() == 2) {
                if (cmsActivity.getActivityIsReservation() == 1) {
                    mapActivity.put("activityMemo", "<font color='#ff0000'>【 温馨提示：直接前往、无需预约、需要付费,有任何问题欢迎拨打" +
                            "电话咨询" + "" + mapActivity.get("activityTel") + " 】</font>" + (cmsActivity.getActivityMemo() != null ? cmsActivity.getActivityMemo() : ""));
                } else if (cmsActivity.getActivityIsReservation() == 2) {
                    mapActivity.put("activityMemo", "<font color='#ff0000'>【 温馨提示：需要事先预定，需要付费,请点击“活动预定”按钮进行票务预订。有任何问题欢迎拨打" +
                            "电话咨询" + "" + mapActivity.get("activityTel") + " 】</font>" + (cmsActivity.getActivityMemo() != null ? cmsActivity.getActivityMemo() : ""));
                } else {
                    mapActivity.put("activityMemo", cmsActivity.getActivityMemo() != null ? cmsActivity.getActivityMemo() : "");
                }
            } else {
                mapActivity.put("activityMemo", cmsActivity.getActivityMemo() != null ? cmsActivity.getActivityMemo() : "");
            }
            //获取活动视频信息
            List<CmsVideo> videoList = cmsVideoMapper.queryVideoById(map);
            if (CollectionUtils.isNotEmpty(videoList)) {
                for (CmsVideo videos : videoList) {
                    Map<String, Object> mapVideo = new HashMap<String, Object>();
                    mapVideo.put("videoTitle", videos.getVideoTitle() != null ? videos.getVideoTitle() : "");
                    mapVideo.put("videoLink", videos.getVideoLink() != null ? videos.getVideoLink() : "");
                    String videoImgUrl = "";
                    if (StringUtils.isNotBlank(videos.getVideoImgUrl())) {
                        videoImgUrl = staticServer.getStaticServerUrl() + videos.getVideoImgUrl();
                    }
                    mapVideo.put("videoImgUrl", videoImgUrl);
                    mapVideo.put("videoCreateTime", DateUtils.formatDate(videos.getVideoCreateTime()));
                    listVideo.add(mapVideo);
                }
            }
            List<CmsActivityEvent> activityEventList = cmsActivityEventMapper.queryAppActivityEventById(map);
            if (CollectionUtils.isNotEmpty(activityEventList)) {
                StringBuffer eventIds = new StringBuffer(); // 封装活动场次id
                StringBuffer statusSb = new StringBuffer(); //封装时间段是否有效
                StringBuffer eventimes = new StringBuffer(); //封装活动具体时间
                StringBuffer timeQuantums = new StringBuffer(); //封装活动时间段
                StringBuffer eventCounts = new StringBuffer();//封装每个活动时间段场次票数
                for (CmsActivityEvent events : activityEventList) {
                    if ("1".equals(cmsActivity.getSysNo()) && StringUtils.isNotBlank(cmsActivity.getSysId())) {
                        //为嘉定活动时
                        events.setCounts(Integer.parseInt(mapActivity.get("activityAbleCount").toString()));
                    }

                    Date date = new Date();
                    String times = events.getEventDateTime().substring(0, events.getEventDateTime().lastIndexOf("-"));
                    String nowDate2 = sdf2.format(date);
                    int statusDate = CompareTime.timeCompare2(times, nowDate2);
                    String eventId = events.getEventId() != null ? events.getEventId() : "";
                    String timeQuantum = events.getEventTime() != null ? events.getEventTime() : "";
                    String eventDateTimes = events.getEventDateTime() != null ? events.getEventDateTime() : "";
                    int eventCount = events.getCounts() > 0 ? events.getCounts() : 0;
                    //返回 0 表示时间日期相同
                    //返回 1 表示日期1>日期2
                    //返回 -1 表示日期1<日期2
                    if (statusDate == -1 || events.getCounts() == 0) {
                        statusSb.append("0" + ",");
                    } else {
                        statusSb.append("1" + ",");
                    }
                    eventIds.append(eventId + ",");
                    timeQuantums.append(timeQuantum + ",");
                    eventimes.append(eventDateTimes + ",");
                    eventCounts.append(eventCount + ",");
                }
                //预定活动时使用id
                mapActivity.put("activityEventIds", eventIds.toString());
                mapActivity.put("activityEventimes", eventimes.toString());
                mapActivity.put("status", statusSb.toString());
                mapActivity.put("timeQuantum", RemoveRepeatedChar.removerepeatedchar(timeQuantums.toString()));
                mapActivity.put("eventCounts", eventCounts.toString());
            }
       /*     StringBuffer eventIds=new StringBuffer(); // 封装活动场次id
            StringBuffer statusSb=new StringBuffer(); //封装时间段是否有效
            StringBuffer eventimes=new StringBuffer(); //封装活动具体时间
            StringBuffer timeQuantums=new StringBuffer(); //封装活动时间段
            //判断活动时间是否已过期
            if(cmsActivity.getEventDateTimes()!=null && StringUtils.isNotBlank(cmsActivity.getEventDateTimes())){
                String[] dateTimes=cmsActivity.getEventDateTimes().split(",");
                for(int i=0;i<dateTimes.length;i++) {
                    Date date = new Date();
                    String times = dateTimes[i].toString().substring(0, dateTimes[i].toString().lastIndexOf("-"));
                    String nowDate2=sdf2.format(date);
                    int statusDate= CompareTime.timeCompare2(times,nowDate2);
                    String eventId=cmsActivity.getEventIds()!=null?StringUtils.split(cmsActivity.getEventIds(),",")[i]:"";
                    String timeQuantum=cmsActivity.getEventimes()!=null?StringUtils.split(cmsActivity.getEventimes(),",")[i]:"";
                    eventIds.append(eventId+",");
                    timeQuantums.append(timeQuantum+",");
                    eventimes.append(dateTimes[i].toString()+",");
                    //返回 0 表示时间日期相同
                    //返回 1 表示日期1>日期2
                    //返回 -1 表示日期1<日期2
                    if (statusDate==-1 || Integer.valueOf(StringUtils.split(cmsActivity.getCounts(),",")[i])==0){
                        statusSb.append("0"+",");
                    }else {
                        statusSb.append("1"+",");
                    }
                }
            }
            //预定活动时使用id
            mapActivity.put("activityEventIds",eventIds.toString());
            mapActivity.put("activityEventimes",eventimes.toString());
            mapActivity.put("status",statusSb.toString());
            mapActivity.put("timeQuantum",timeQuantums.toString());*/
            //添加分享的shareUrl
            StringBuffer sb = new StringBuffer();
            sb.append(shareUrlService.getShareUrl());
            sb.append(Constant.commentActivityUrl);
            sb.append("activityId=" + cmsActivity.getActivityId());
            mapActivity.put("shareUrl", sb.toString());
            //该用户是否已报名该活动 0.该用户未参加 1.参加
            mapActivity.put("activityIsWant", cmsActivity.getActivityIsWant() > 0 ? cmsActivity.getActivityIsWant() : 0);
            mapActivity.put("activityNotice", cmsActivity.getActivityNotice() != null ? cmsActivity.getActivityNotice() : "");
            if (cmsActivity.getTagName() != null && StringUtils.isNotBlank(cmsActivity.getTagName())) {
                String[] tagNames = cmsActivity.getTagName().split(",");
                for (String tagName : tagNames) {
                    Map<String, Object> mapMood = new HashMap<String, Object>();
                    mapMood.put("tagName", tagName);
                    mapTypeList.add(mapMood);
                }
            }
        /*    if(cmsActivity.getTagIds()!=null && StringUtils.isNotBlank(cmsActivity.getTagIds())){
               String[] tags=cmsActivity.getTagIds().split(",");
              //  Map<String,Object> map1=new HashMap<String,Object>();
              //  map1.put("tags",tags);
               List<CmsTag> tagList=cmsTagMapper.queryAppTagNameById(tags);
               for(CmsTag tag:tagList){
                   Map<String, Object> mapMood = new HashMap<String, Object>();
                    mapMood.put("tagName",tag.getTagName());
                    mapTypeList.add(mapMood);
               }
            }*/
            listMap.add(mapActivity);
        }
        return JSONResponse.toFourParamterResult(0, listMap, mapTypeList, listVideo, null);
    }

    /**
     * why3.5 根据id获取活动详情
     *
     * @param activityId 活动id
     * @param userId     用户id
     * @return
     */
    @Override
    public String queryAppCmsActivityById(String activityId, String userId) {
        SimpleDateFormat sdf2 = new SimpleDateFormat("yyyy-MM-dd HH:mm");
        List<Map<String, Object>> mapTypeList = new ArrayList<Map<String, Object>>();
        List<Map<String, Object>> listMap = new ArrayList<Map<String, Object>>();
        List<Map<String, Object>> listVideo = new ArrayList<Map<String, Object>>();
        Map<String, Object> map = new HashMap<String, Object>();
        if (StringUtils.isNotBlank(userId)) {
            map.put("userId", userId);
            map.put("type", Constant.TYPE_ACTIVITY);
        }
        if (StringUtils.isNotBlank(activityId)) {
            map.put("relatedId", activityId);
        }
        map.put("videoType", Constant.ACTIVITY_VIDEO_TYPE);
        CmsActivity cmsActivity = activityMapper.queryAppCmsActivityById(map);
        if (cmsActivity != null) {
            Map<String, Object> mapActivity = new HashMap<String, Object>();
            String activityIconUrl = "";
            if (StringUtils.isNotBlank(cmsActivity.getActivityIconUrl())) {
                activityIconUrl = staticServer.getStaticServerUrl() + cmsActivity.getActivityIconUrl();
            }
            mapActivity.put("activityIconUrl", activityIconUrl);
            mapActivity.put("activityIsCollect", cmsActivity.getCollectNum() > 0 ? 1 : 0);
            mapActivity.put("activityFunName", cmsActivity.getFunName() != null ? cmsActivity.getFunName() : "");
            //查询该活动收藏数量
            int collectNum = collectService.getHotNum(cmsActivity.getActivityId(), Constant.TYPE_ACTIVITY);
            mapActivity.put("collectNum", collectNum != 0 ? collectNum : 0);
            mapActivity.put("activityName", cmsActivity.getActivityName() != null ? cmsActivity.getActivityName() : "");
            mapActivity.put("activitySite", cmsActivity.getActivitySite() != null ? cmsActivity.getActivitySite() : "");
            if (StringUtils.isNotBlank(cmsActivity.getVenueName())) {
                mapActivity.put("activityAddress", (StringUtils.isNotBlank(cmsActivity.getActivityAddress()) ? cmsActivity.getActivityAddress() + "." : "") + cmsActivity.getVenueName());
            } else {
                mapActivity.put("activityAddress", StringUtils.isNotBlank(cmsActivity.getActivityAddress()) ?
                        cmsActivity.getActivityAddress() + (StringUtils.isNotBlank(cmsActivity.getActivitySite()) ? "." +
                                cmsActivity.getActivitySite() : "") : (StringUtils.isNotBlank(cmsActivity.getActivitySite()) ? cmsActivity.getActivitySite() : ""));
            }
            mapActivity.put("activityStartTime", cmsActivity.getActivityStartTime() != null ? cmsActivity.getActivityStartTime() : "");
            mapActivity.put("activityEndTime", StringUtils.isNotBlank(cmsActivity.getActivityEndTime()) ?
                    cmsActivity.getActivityEndTime() : mapActivity.get("activityStartTime"));
            mapActivity.put("activityTel", cmsActivity.getActivityTel() != null ? cmsActivity.getActivityTel() : "");

            //子系统对接修改
            mapActivity.put("activityDateNums", cmsActivity.getDateNums());
            //end
            mapActivity.put("activityTimeDes", cmsActivity.getActivityTimeDes() != null ? cmsActivity.getActivityTimeDes() : "");
            mapActivity.put("activityIsFree", cmsActivity.getActivityIsFree() != null ? cmsActivity.getActivityIsFree() : 1);
            mapActivity.put("activityPrice", cmsActivity.getActivityPrice() != null ? cmsActivity.getActivityPrice() : "");
            mapActivity.put("priceDescribe", cmsActivity.getPriceDescribe() != null ? cmsActivity.getPriceDescribe() : "");
            // 嘉定数据
            if ("1".equals(cmsActivity.getSysNo()) && StringUtils.isNotBlank(cmsActivity.getSysId())) {
                //为嘉定活动时
                Map map1 = this.getSubSystemTicketCount(cmsActivity);
                if (map1 != null && "Y".equals(map1.get("success").toString())) {
                    Integer ticketCount = Integer.valueOf(map1.get("ticketCount") == null ? "0" : map1.get("ticketCount").toString());
                    mapActivity.put("activityAbleCount", ticketCount);
                } else {
                    mapActivity.put("activityAbleCount", 0);
                }
            } else {
                mapActivity.put("activityAbleCount", cmsActivity.getAvailableCount() != null ? cmsActivity.getAvailableCount() : 0);
            }

            mapActivity.put("activityTime", cmsActivity.getActivityTime() != null ? cmsActivity.getActivityTime() : "");
            //获取活动经纬度
            double activityLon = 0d;
            if (cmsActivity.getActivityLon() != null) {
                activityLon = cmsActivity.getActivityLon();
            }
            double activityLat = 0d;
            if (cmsActivity.getActivityLat() != null) {
                activityLat = cmsActivity.getActivityLat();
            }
            mapActivity.put("activityLon", activityLon);
            mapActivity.put("activityLat", activityLat);
            mapActivity.put("activityIsReservation", cmsActivity.getActivityIsReservation() != null ? cmsActivity.getActivityIsReservation() : "");
            mapActivity.put("activitySalesOnline", cmsActivity.getActivitySalesOnline() != null ? cmsActivity.getActivitySalesOnline() : "");
            mapActivity.put("activityId", cmsActivity.getActivityId() != null ? cmsActivity.getActivityId() : "");
            mapActivity.put("activityMemo", cmsActivity.getActivityMemo() != null ? cmsActivity.getActivityMemo() : "");
            mapActivity.put("activityHost", cmsActivity.getActivityHost() != null ? cmsActivity.getActivityHost() : "");
            mapActivity.put("activityOrganizer", cmsActivity.getActivityOrganizer() != null ? cmsActivity.getActivityOrganizer() : "");
            mapActivity.put("activityCoorganizer", cmsActivity.getActivityCoorganizer() != null ? cmsActivity.getActivityCoorganizer() : "");
            mapActivity.put("activityPerformed", cmsActivity.getActivityPerformed() != null ? cmsActivity.getActivityPerformed() : "");
            mapActivity.put("activitySpeaker", cmsActivity.getActivitySpeaker() != null ? cmsActivity.getActivitySpeaker() : "");
            // 无收费（活动简介前加直接前往、无需预约、无需付费，有任何问题欢迎拨打电话咨询（电话号码？）），有收费（需要事先预定，请点击“活动预定”按钮进行票务预订。有任何问题欢迎拨打电话咨询（电话号码？））
            if (cmsActivity.getActivityIsFree() == 1) {
                if (cmsActivity.getActivityIsReservation() == 1) {
                    mapActivity.put("activityTips", "<font color='#FA8808' style='font-family:\"STYuanti-SC-Light\";font-size:\"26px\"'> 温馨提示：</font><font color='#262626' style='font-family:\"STYuanti-SC-Light\";font-size:\"26px\"'>直接前往、无需预约、无需付费，有任何问题" +
                            "欢迎拨打电话咨询(" + mapActivity.get("activityTel") + ")</font>");
                } else if (cmsActivity.getActivityIsReservation() == 2) {
                    mapActivity.put("activityTips", "<font color='#FA8808' style='font-family:\"STYuanti-SC-Light\";font-size:\"26px\"'> 温馨提示：</font>" +
                            "<font color='#262626' style='font-family:\"STYuanti-SC-Light\";font-size:\"26px\"'>需要事先预定，" +
                            "请点击“</font><font color='#FA8808' style='font-family:\"STYuanti-SC-Light\";font-size:\"26px\"'>" +
                            "立即预约</font><font color='#262626' style='font-family:\"STYuanti-SC-Light\";font-size:\"26px\"'>”按钮进行票务预订。有任何问题欢迎拨打电话" +
                            "咨询(" + mapActivity.get("activityTel") + ")</font>");
                }
            } else if (cmsActivity.getActivityIsFree() == 2) {
                if (cmsActivity.getActivityIsReservation() == 1) {
                    mapActivity.put("activityTips", "<font color='#FA8808' style='font-family:\"STYuanti-SC-Light\";font-size:\"26px\"'>温馨提示：</font><font color='#262626' style='font-family:\"STYuanti-SC-Light\";font-size:\"26px\"'>直接前往、无需预约、需要付费，有任何问题欢迎拨打" +
                            "电话咨询(" + mapActivity.get("activityTel") + ")</font>");
                } else if (cmsActivity.getActivityIsReservation() == 2) {
                    mapActivity.put("activityTips", "<font color='#FA8808' style='font-family:\"STYuanti-SC-Light\";font-size:\"26px\"'>温馨提示：</font><font color='#262626' style='font-family:\"STYuanti-SC-Light\";font-size:\"26px\"'>需要事先预定，需要付费，" +
                            "请点击“</font><font color='#FA8808' style='font-family:\"STYuanti-SC-Light\";font-size:\"26px\"'>立即预约</font><font color='#262626' style='font-family:\"STYuanti-SC-Light\";font-size:\"26px\"'>”按钮进行票务预订。" +
                            "有任何问题欢迎拨打电话咨询(" + mapActivity.get("activityTel") + ")</font>");
                }
            }
            //获取活动视频信息
            List<CmsVideo> videoList = cmsVideoMapper.queryVideoById(map);
            if (CollectionUtils.isNotEmpty(videoList)) {
                for (CmsVideo videos : videoList) {
                    Map<String, Object> mapVideo = new HashMap<String, Object>();
                    mapVideo.put("videoTitle", videos.getVideoTitle() != null ? videos.getVideoTitle() : "");
                    mapVideo.put("videoLink", videos.getVideoLink() != null ? videos.getVideoLink() : "");
                    String videoImgUrl = "";
                    if (StringUtils.isNotBlank(videos.getVideoImgUrl())) {
                        videoImgUrl = staticServer.getStaticServerUrl() + videos.getVideoImgUrl();
                    }
                    mapVideo.put("videoImgUrl", videoImgUrl);
                    mapVideo.put("videoCreateTime", DateUtils.formatDate(videos.getVideoCreateTime()));
                    listVideo.add(mapVideo);
                }
            }
            List<CmsActivityEvent> activityEventList = cmsActivityEventMapper.queryAppActivityEventById(map);
            if (CollectionUtils.isNotEmpty(activityEventList)) {
                StringBuffer eventIds = new StringBuffer(); // 封装活动场次id
                StringBuffer statusSb = new StringBuffer(); //封装时间段是否有效
                StringBuffer eventimes = new StringBuffer(); //封装活动具体时间
                StringBuffer timeQuantums = new StringBuffer(); //封装活动时间段
                StringBuffer eventCounts = new StringBuffer();//封装每个活动时间段场次票数
                StringBuffer eventPrices = new StringBuffer();//封装每个活动时间段场次票价
                StringBuffer spikeDifferences = new StringBuffer();//封装每个活动秒杀倒计时（时间戳）（如果非秒杀活动为0）
                for (CmsActivityEvent events : activityEventList) {
                    if ("1".equals(cmsActivity.getSysNo()) && StringUtils.isNotBlank(cmsActivity.getSysId())) {
                        //为嘉定活动时
                        events.setCounts(Integer.parseInt(mapActivity.get("activityAbleCount").toString()));
                    }

                    Date date = new Date();
                    String times = events.getEventDateTime().substring(0, events.getEventDateTime().lastIndexOf("-"));
                    String nowDate2 = sdf2.format(date);
                    int statusDate = CompareTime.timeCompare2(times, nowDate2);
                    String eventId = events.getEventId() != null ? events.getEventId() : "";
                    String timeQuantum = events.getEventTime() != null ? events.getEventTime() : "";
                    String eventDateTimes = events.getEventDateTime() != null ? events.getEventDateTime() : "";
                    String eventPrice = events.getOrderPrice() != null ? events.getOrderPrice() : "0";
                    int eventCount = events.getCounts() > 0 ? events.getCounts() : 0;
                    long spikeDifference = 0;
                    if (events.getSpikeTime() != null) {
                        spikeDifference = (events.getSpikeTime().getTime() - new Date().getTime()) / 1000;
                    }
                    //返回 0 表示时间日期相同
                    //返回 1 表示日期1>日期2
                    //返回 -1 表示日期1<日期2
                    if (statusDate == -1 || events.getCounts() == 0) {
                        statusSb.append("0" + ",");
                    } else {
                        statusSb.append("1" + ",");
                    }
                    eventIds.append(eventId + ",");
                    timeQuantums.append(timeQuantum + ",");
                    eventimes.append(eventDateTimes + ",");
                    eventCounts.append(eventCount + ",");
                    eventPrices.append(eventPrice + ",");
                    spikeDifferences.append((spikeDifference >= 0 ? spikeDifference : 0) + ",");
                }
                //预定活动时使用id
                mapActivity.put("activityEventIds", eventIds.toString());
                //场次开始日期加时间段
                mapActivity.put("activityEventimes", eventimes.toString());
                mapActivity.put("status", statusSb.toString());
                mapActivity.put("timeQuantum", RemoveRepeatedChar.removerepeatedchar(timeQuantums.toString()));
                mapActivity.put("eventCounts", eventCounts.toString());
                mapActivity.put("eventPrices", eventPrices.toString());
                mapActivity.put("spikeDifferences", spikeDifferences.toString());

                String lastEventTime = mapActivity.get("activityEndTime") + " " + activityEventList.get(activityEventList.size() - 1).getEventTime().split("-")[0];
                try {
                    mapActivity.put("activityIsPast", (sdf2.parse(lastEventTime).getTime() - new Date().getTime()) > 0 ? 0 : 1);
                } catch (ParseException e) {
                    e.printStackTrace();
                    return JSONResponse.toFourParamterResult(500, "activityIsPast判断出错", null, null, null);
                }
            } else {
                String lastEventTime = mapActivity.get("activityEndTime") + " 00:00";
                try {
                    mapActivity.put("activityIsPast", (sdf2.parse(lastEventTime).getTime() - new Date().getTime()) > 0 ? 0 : 1);
                } catch (ParseException e) {
                    e.printStackTrace();
                    return JSONResponse.toFourParamterResult(500, "activityIsPast判断出错", null, null, null);
                }
            }

            //添加分享的shareUrl
            StringBuffer sb = new StringBuffer();
            sb.append(shareUrlService.getShareUrl());
            sb.append(Constant.commentActivityUrl);
            sb.append("activityId=" + cmsActivity.getActivityId());
            mapActivity.put("shareUrl", sb.toString());
            //该用户是否已报名该活动 0.该用户未参加 1.参加
            mapActivity.put("activityIsWant", cmsActivity.getActivityIsWant() > 0 ? cmsActivity.getActivityIsWant() : 0);
            mapActivity.put("activityNotice", cmsActivity.getActivityNotice() != null ? cmsActivity.getActivityNotice() : "");
            if (cmsActivity.getTagName() != null && StringUtils.isNotBlank(cmsActivity.getTagName())) {
                String[] tagNames = cmsActivity.getTagName().split(",");
                for (String tagName : tagNames) {
                    Map<String, Object> mapMood = new HashMap<String, Object>();
                    mapMood.put("tagName", tagName);
                    mapTypeList.add(mapMood);
                }
            }
            mapActivity.put("ticketSettings", StringUtils.isNotBlank(cmsActivity.getTicketSettings()) ? cmsActivity.getTicketSettings() : "Y");
            mapActivity.put("ticketNumber", cmsActivity.getTicketNumber() != null ? cmsActivity.getTicketNumber() : "");
            mapActivity.put("ticketCount", cmsActivity.getTicketCount() != null ? cmsActivity.getTicketCount() : "");
            mapActivity.put("identityCard", cmsActivity.getIdentityCard() != null ? cmsActivity.getIdentityCard() : "");
            mapActivity.put("priceType", cmsActivity.getPriceType() != null ? cmsActivity.getPriceType() : "");
            mapActivity.put("lowestCredit", cmsActivity.getLowestCredit() != null ? cmsActivity.getLowestCredit() : "");
            mapActivity.put("costCredit", cmsActivity.getCostCredit() != null ? cmsActivity.getCostCredit() : "");
            mapActivity.put("deductionCredit", cmsActivity.getDeductionCredit() != null ? cmsActivity.getDeductionCredit() : "");
            mapActivity.put("spikeType", cmsActivity.getSpikeType() != null ? cmsActivity.getSpikeType() : "");
            mapActivity.put("singleEvent", cmsActivity.getSingleEvent() != null ? cmsActivity.getSingleEvent() : "");

            //积分判断
            if (StringUtils.isNotBlank(userId)) {
                UserIntegral userIntegral = userIntegralMapper.selectUserIntegralByUserId(userId);
                if (userIntegral != null) {
                    if (cmsActivity.getLowestCredit() != null) {
                        if (cmsActivity.getLowestCredit() > userIntegral.getIntegralNow()) {
                            mapActivity.put("integralStatus", "1");
                        } else {
                            if (cmsActivity.getCostCredit() != null) {
                                if (cmsActivity.getCostCredit() > userIntegral.getIntegralNow()) {
                                    mapActivity.put("integralStatus", "2");
                                } else {    //消耗积分未填
                                    mapActivity.put("integralStatus", "0");
                                }
                            } else {
                                mapActivity.put("integralStatus", "0");
                            }
                        }
                    } else {    //最低积分未填
                        if (cmsActivity.getCostCredit() != null) {
                            if (cmsActivity.getCostCredit() > userIntegral.getIntegralNow()) {
                                mapActivity.put("integralStatus", "2");
                            } else {
                                mapActivity.put("integralStatus", "0");
                            }
                        } else {
                            mapActivity.put("integralStatus", "0");
                        }
                    }
                } else {
                    if (mapActivity.get("lowestCredit") != "") {
                        mapActivity.put("integralStatus", "1");
                    } else {
                        if (mapActivity.get("costCredit") != "") {
                            mapActivity.put("integralStatus", "2");
                        } else {
                            mapActivity.put("integralStatus", "0");
                        }
                    }
                }
            }
            listMap.add(mapActivity);
        }
        return JSONResponse.toFourParamterResult(0, listMap, mapTypeList, listVideo, null);
    }

    /**
     * 得到嘉定子系统的可预定票数
     *
     * @param cmsActivity
     * @param
     * @return
     * @throws Exception
     */
    private Map getSubSystemTicketCount(CmsActivity cmsActivity) {
        // 子系统取消预定接口
        // 向子系统发送请求
        CmsApiOrder apiOrder = new CmsApiOrder();
        apiOrder.setStatus(true);
        Map map = new HashMap();
        try {
            // 查询活动，判断活动的的外部系统的预定链接地址
            String sysNo = cmsActivity.getSysNo();
            String sysId = cmsActivity.getSysId();
            if (StringUtils.isNotBlank(sysNo) && StringUtils.isNotBlank(sysId)) {
                JSONObject json = new JSONObject();
                json.put("sysNo", sysNo);
                json.put("activityId", sysId);
                String url = cmsApiOtherServer.getActivityTicketCountUrl(sysNo);
                HttpResponseText httpResponseText = HttpClientConnection.post(url, json);
                if (httpResponseText.getHttpCode() == 200) {
                    String result = httpResponseText.getData();
                    JSONObject data = JSON.parseObject(result);//解析数据为json
                    if (Boolean.parseBoolean(data.get("status") == null ? "false" : data.get("status").toString())) {
                        Integer ticketCount = Integer.valueOf(data.get("ticketCount") == null ? "0" : data.get("ticketCount").toString());
                        map.put("success", "Y");
                        map.put("ticketCount", ticketCount);
                        return map;
                    } else {
                        map.put("success", "N");
                        map.put("ticketCount", "0");
                        return map;
                    }
                } else {
                    apiOrder.setStatus(false);
                    apiOrder.setMsg("系统请求子系统发生错误:" + httpResponseText.getData());
                }
            } else {
                apiOrder.setStatus(true);
                apiOrder.setMsg("sysId,sysNo不存在，无须调用子系统座位功能!");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    private Map getSubSystemSeatInfo(CmsActivity cmsActivity, String eventDateTime) {
        // 子系统取消预定接口
        // 向子系统发送请求
        CmsApiOrder apiOrder = new CmsApiOrder();
        apiOrder.setStatus(true);
        Map map = new HashMap();
        try {
            // 查询活动，判断活动的的外部系统的预定链接地址
            String sysNo = cmsActivity.getSysNo();
            String sysId = cmsActivity.getSysId();
            if (StringUtils.isNotBlank(sysNo) && StringUtils.isNotBlank(sysId)) {
                JSONObject json = new JSONObject();
                json.put("sysNo", sysNo);
                json.put("activityId", sysId);
                String url = cmsApiOtherServer.getActivitySeatInfoUrl(sysNo);
                HttpResponseText httpResponseText = HttpClientConnection.post(url, json);
                if (httpResponseText.getHttpCode() == 200) {
                    String result = httpResponseText.getData();
                    JSONObject data = JSON.parseObject(result);//解析数据为json
                    logger.info("嘉定座位数据：" + data);
                    if (Boolean.parseBoolean(data.get("status") == null ? "false" : data.get("status").toString())) {
                        String seatInfo = data.get("seatInfo") == null ? "" : data.get("seatInfo").toString();
                        String vipInfo = data.get("vipInfo") == null ? "" : data.get("vipInfo").toString();
                        Integer ticketCount = Integer.valueOf(data.get("ticketCount") == null ? "0" : data.get("ticketCount").toString());
                        map.put("seatInfo", seatInfo);
                        map.put("vipInfo", vipInfo);
                        map.put("success", "Y");
                        map.put("maxColumn", data.get("maxColumn") == null ? "0" : data.get("maxColumn"));
                        map.put("ticketCount", ticketCount);
                        //得到场次id
                        CmsActivityEvent cmsActivityEvent = cmsActivityEventMapper.queryEventByActivityAndTime(cmsActivity.getActivityId(), eventDateTime);
                        if (cmsActivityEvent != null) {
                            map.put("eventId", cmsActivityEvent.getEventId());
                        }
                        return map;
                    } else {
                        return map;
                    }
                } else {
                    apiOrder.setStatus(false);
                    apiOrder.setMsg("系统请求子系统发生错误:" + httpResponseText.getData());
                }
            } else {
                apiOrder.setStatus(true);
                apiOrder.setMsg("sysId,sysNo不存在，无须调用子系统座位功能!");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * why3.5 app用户收藏活动
     *
     * @param userId  用户Id
     * @param pageApp 分页对象
     * @return
     */
    @Override
    public String queryUserAppCollectAct(String userId, PaginationApp pageApp) {
        List<Map<String, Object>> listMapActivity = new ArrayList<Map<String, Object>>();
        Map<String, Object> map = new HashMap<String, Object>();
        if (userId != null && StringUtils.isNotBlank(userId)) {
            map.put("userId", userId);
        }
        map.put("type", Constant.COLLECT_ACTIVITY);
        if (pageApp != null && pageApp.getFirstResult() != null && pageApp.getRows() != null) {
            map.put("firstResult", pageApp.getFirstResult());
            map.put("rows", pageApp.getRows());
        }
        // 查询用户收藏活动列表
        List<CmsActivity> activityList = activityMapper.queryCollectActivity(map);
        if (activityList.size() > 0) {
            for (CmsActivity activity : activityList) {
                Map<String, Object> mapActivity = new HashMap<String, Object>();
                mapActivity.put("activityId", activity.getActivityId() != null ? activity.getActivityId() : "");
                mapActivity.put("activityName", activity.getActivityName() != null ? activity.getActivityName() : "");
                mapActivity.put("activityAddress", activity.getActivityAddress() != null ? activity.getActivityAddress() : "");
                mapActivity.put("activityIconUrl", StringUtils.isNotBlank(activity.getActivityIconUrl()) ? staticServer.getStaticServerUrl() + activity.getActivityIconUrl() : "");
                mapActivity.put("venueName", StringUtils.isNotBlank(activity.getVenueName()) ?
                        activity.getVenueName() : (StringUtils.isNoneBlank(activity.getActivitySite()) ? activity.getActivitySite() : ""));
                mapActivity.put("activityStartTime", activity.getActivityStartTime() != null ? activity.getActivityStartTime() : "");
                mapActivity.put("activityEndTime", activity.getActivityEndTime() != null ? activity.getActivityEndTime() : "");
                listMapActivity.add(mapActivity);
            }
        }
        return JSONResponse.toAppResultFormat(0, listMapActivity);
    }

    /**
     * app获取活动座位信息
     *
     * @param activityId        活动id
     * @param userId            用户id
     * @param activityEventimes 活动具体时间
     * @return
     */
    @Override
    public String queryAppActivitySeatsById(String activityId, String userId, String activityEventimes) {
        List<Map<String, Object>> listMap = new ArrayList<Map<String, Object>>();
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("relatedId", activityId);
        CmsActivity cmsActivity = activityMapper.queryAppActivityById(map);
        if (cmsActivity != null) {
            Map<String, Object> activityMap = new HashMap<String, Object>();
            // 嘉定数据
            if ("1".equals(cmsActivity.getSysNo())) {
                // 在线选座
                if ("Y".equals(cmsActivity.getActivitySalesOnline())) {
                    // 发送http 请求至嘉定系统中获取座位信息
                    Map map1 = this.getSubSystemSeatInfo(cmsActivity, activityEventimes);
                    Map<String, String> map2 = new HashMap<String, String>();
                    // 加已占用的座位
                    if (map1.get("vipInfo") != null) {
                        String[] array = map1.get("vipInfo").toString().split(",");
                        for (String a : array) {
                            map2.put(a, a);
                        }
                    }
                    // 解析
                    List<Map<String, Object>> maps = new ArrayList<Map<String, Object>>();
                    if (map1.get("seatInfo") != null) {
                        String[] rows = map1.get("seatInfo").toString().split(",");
                        for (int i = 0; i < rows.length; i++) {
                            String row = rows[i];
                            Pattern p = Pattern.compile("_", Pattern.CASE_INSENSITIVE);
                            Matcher m = p.matcher(row);
                            int count = 0;
                            int count1 = 0;
                            while (m.find()) {
                                count++;
                            }
                            int x = i + 1;
                            for (int j = 0; j < count; j++) {
                                Map<String, Object> oneMap = new HashMap<String, Object>();
                                int y = j + 1;
                                int index = row.indexOf(x + "_" + y);
                                if (row.contains(x + "_" + y)) { // 存在该座位
                                    if (map2.get(x + "_" + y) != null) { // 表示已占用座位
                                        oneMap.put("seatRow", x);
                                        oneMap.put("seatColumn", y);
                                        oneMap.put("seatVal", row.substring(row.indexOf("-", index) + 1, row.indexOf("]", index)));
                                        oneMap.put("seatStatus", Constant.VENUE_SEAT_STATUS_MAINTANANCE);
                                        maps.add(oneMap);
                                        count1++;
                                    } else { // 为空表示正常座位
                                        oneMap.put("seatRow", x);
                                        oneMap.put("seatColumn", y);
                                        oneMap.put("seatVal", row.substring(row.indexOf("-", index) + 1, row.indexOf("]", index)));
                                        oneMap.put("seatStatus", Constant.VENUE_SEAT_STATUS_NORMAL);
                                        maps.add(oneMap);
                                        count1++;
                                    }
                                } else { //  不存在该座位
                                    oneMap.put("seatRow", x);
                                    oneMap.put("seatColumn", y);
                                    oneMap.put("seatVal", "");
                                    oneMap.put("seatStatus", Constant.VENUE_SEAT_STATUS_NONE);
                                    maps.add(oneMap);
                                    count1++;
                                }

                                if (count == count1) { // 判断跳出列循环
                                    break;
                                }
                            }
                        }
                    }

                    activityMap.put("ticketCount", map1.get("ticketCount"));
                    activityMap.put("seatList", maps);
                } else {
                    Map map1 = this.getSubSystemTicketCount(cmsActivity);
                    activityMap.put("seatList", "");
                    activityMap.put("ticketCount", map1.get("ticketCount"));
                }
                listMap.add(activityMap);
                return JSONResponse.toAppResultFormat(0, listMap);
            }
            //在线选座情况
            if ("Y".equals(cmsActivity.getActivitySalesOnline())) {
                Map<String, String> seatInfo = new HashMap<String, String>();
                seatInfo.put("activityId", activityId);
                seatInfo.put("activityEventimes", activityEventimes);
                List<CmsActivitySeat> list = cmsActivitySeatMapper.selectSeatList(seatInfo);
                if (CollectionUtils.isEmpty(list)) {
                    CmsActivityEvent event = cmsActivityEventMapper.queryEventByActivityAndTime(activityId, activityEventimes);
                    list = cacheService.getSeatInfoByIdAndTime(activityId, activityEventimes);
                    List<CmsActivitySeat> seats = new LinkedList<>();
                    for (CmsActivitySeat seat : list) {
                        seat.setActivitySeatId(UUIDUtils.createUUId());
                        seat.setEventId(event.getEventId());
                        seat.setSeatCreateTime(new Date());
                        seat.setSeatCreateUser("1");
                        seat.setSeatUpdateTime(new Date());
                        seat.setSeatUpdateUser("1");
                        seats.add(seat);
                    }
                    int result = cmsActivitySeatMapper.addActivitySeatList(seats);
                }
                //可以预定的票数
                Integer ticketCount = cmsActivitySeatMapper.selectSeatCount(seatInfo);
                if (ticketCount == null) {
                    ticketCount = cacheService.getSeatCountByActivityIdAndTime(activityId, activityEventimes);
                }
                if (list != null && list.size() > 0) {
                    List<Map<String, Object>> seatMapList = getAppSeatInfobyList(list);
                    activityMap.put("seatList", seatMapList);
                    activityMap.put("ticketCount", ticketCount);
                }
            } else {
                //自由入座情况
                String ticketCount = cacheService.getValueByKey(CacheConstant.ACTIVITY_TICKET_COUNT + activityId);
                if (ticketCount == null) {
                    CmsActivityEvent event = cmsActivityEventMapper.queryEventByActivityAndTime(activityId, activityEventimes);
                    ticketCount = String.valueOf(event.getAvailableCount());
                }
                activityMap.put("seatList", "");
                activityMap.put("ticketCount", ticketCount);
            }
            listMap.add(activityMap);
        }
        return JSONResponse.toAppResultFormat(0, listMap);
    }

    /**
     * app预定活动
     *
     * @param activityId        活动id
     * @param userId            用户id
     * @param activityEventIds  活动场次id
     * @param bookCount         预定数目
     * @param orderMobileNum    预定电话号码
     * @param orderName         姓名
     * @param orderIdentityCard 身份证
     * @param orderPrice        票价
     * @param activityEventimes 活动具体时间
     * @param costTotalCredit   参与此活动消耗的总积分数
     * @param seatIds           座位号
     * @return
     */
    @Override
    @Transactional(isolation= Isolation.SERIALIZABLE)
    public String appActivityOrderByCondition(String activityId, String userId, String activityEventIds, String bookCount, String orderMobileNum,
                                              String orderPrice, String activityEventimes, String[] seatIds, String seatValues, String orderName, String orderIdentityCard, String costTotalCredit) {
        JSONObject jsonObject = new JSONObject();
        int orderType = 2;
        int bookCounts = 0;
        BookActivitySeatInfo activitySeatInfo = new BookActivitySeatInfo();
        CmsActivityOrder cmsActivityOrder = new CmsActivityOrder();

        activitySeatInfo.setActivityId(activityId);
        activitySeatInfo.setSeatIds(seatIds);
        if (bookCount != null && StringUtils.isNotBlank(bookCount)) {
            activitySeatInfo.setBookCount(Integer.valueOf(bookCount));
            bookCounts = Integer.valueOf(bookCount);
        }
        activitySeatInfo.setUserId(userId);
        if (StringUtils.isNotBlank(orderPrice)) {
            //构造以字符串内容为值的BigDecimal类型的变量bd
            BigDecimal bd = new BigDecimal(orderPrice);
            //设置小数位数，第一个变量是小数位数，第二个变量是取舍方法(四舍五入)
            bd = bd.setScale(2, BigDecimal.ROUND_HALF_UP);
            activitySeatInfo.setPrice(bd);
            cmsActivityOrder.setOrderPrice(bd);
        }

        activitySeatInfo.setPhone(orderMobileNum);
        activitySeatInfo.setsId(UUIDUtils.createUUId());
        activitySeatInfo.setOrderNumber(cacheService.genOrderNumber());
        if (StringUtils.isNotBlank(orderName)) {
            activitySeatInfo.setOrderName(EmojiFilter.filterEmoji(orderName));
        }
        if (StringUtils.isNotBlank(orderIdentityCard)) {
            activitySeatInfo.setOrderIdentityCard(orderIdentityCard);
        }
        activitySeatInfo.setType(orderType);
        activitySeatInfo.setEventId(activityEventIds);
        activitySeatInfo.setBook(true);
        activitySeatInfo.setEventDateTime(activityEventimes.toString());
        if (StringUtils.isBlank(costTotalCredit)) {
            activitySeatInfo.setCostTotalCredit("0");
            costTotalCredit = "0";
        } else {
            cmsActivityOrder.setCostTotalCredit(costTotalCredit);
        }
        CmsTerminalUser terminalUser = userMapper.queryTerminalUserById(userId);
        activitySeatInfo.setSeatIds(seatIds);

        cmsActivityOrder.setActivityOrderId(UUIDUtils.createUUId());
        cmsActivityOrder.setOrderNumber(cacheService.genOrderNumber());
        cmsActivityOrder.setActivityId(activityId);
        cmsActivityOrder.setEventId(activityEventIds);
        cmsActivityOrder.setUserId(userId);
        cmsActivityOrder.setSeatVals(seatValues);
        cmsActivityOrder.setOrderSummary(seatValues);
        cmsActivityOrder.setOrderVotes(bookCounts);
        cmsActivityOrder.setOrderPhoneNo(orderMobileNum);
        if (StringUtils.isBlank(costTotalCredit)) {
            cmsActivityOrder.setCostTotalCredit("0");
        } else {
            cmsActivityOrder.setCostTotalCredit(costTotalCredit);
        }
        if (StringUtils.isNotBlank(orderName)) {
            cmsActivityOrder.setOrderName(EmojiFilter.filterEmoji(orderName));
        }
        if (StringUtils.isNotBlank(orderIdentityCard)) {
            cmsActivityOrder.setOrderIdentityCard(orderIdentityCard);
        }
        cmsActivityOrder.setOrderVotes(Integer.valueOf(bookCount));
        cmsActivityOrder.setEventDateTime(activityEventimes.toString());


        // 嘉定数据
//        CmsApiOrder apiOrder = this.cmsApiActivityOrderService.addOrder(activitySeatInfo, terminalUser, seatValues);
//        if (apiOrder.isStatus()) {
//            activitySeatInfo.setSysId(apiOrder.getContentId());
//            activitySeatInfo.setSysNo(apiOrder.getSysNo());
//            cmsActivityOrder.setSysId(apiOrder.getContentId());
//            cmsActivityOrder.setSysNo(apiOrder.getSysNo());
//            //子系统直接生成订单
//            if (activitySeatInfo.getSysNo() != null && !"0".equals(activitySeatInfo.getSysNo())) {
//                jsonObject.put("status", 0);
//                jsonObject.put("data", apiOrder.getOrderNum());
//                return jsonObject.toString();
//            } else {
                String checkRs = cmsActivityOrderService.checkActivitySeatStatus(cmsActivityOrder, seatIds);
                if (Constant.RESULT_STR_SUCCESS.equals(checkRs)) {
                    ActivityBookClient activityBookClient = new ActivityBookClient();
                    String counts = cmsActivityOrderService.addActivityOrder(cmsActivityOrder);
//                    JmsResult jmsResult = activityBookClient.bookActivitySeat(activitySeatInfo, cacheService);
                    if (!Constant.RESULT_STR_FAILURE.equals(counts)) {

                        //积分扣除
                        if (StringUtils.isNotBlank(userId) && Integer.parseInt(costTotalCredit) > 0) {
                            UserIntegral userIntegral = userIntegralMapper.selectUserIntegralByUserId(userId);
                            userIntegral.setIntegralNow(userIntegral.getIntegralNow() - Integer.parseInt(costTotalCredit));
                            int count = userIntegralMapper.updateByPrimaryKeySelective(userIntegral);
                            if (count > 0 && Integer.parseInt(costTotalCredit) > 0) {
                                UserIntegralDetail userIntegralDetail = new UserIntegralDetail();
                                userIntegralDetail.setIntegralDetailId(UUIDUtils.createUUId());
                                userIntegralDetail.setCreateTime(new Date());
                                userIntegralDetail.setIntegralId(userIntegral.getIntegralId());
                                userIntegralDetail.setIntegralChange(Integer.parseInt(costTotalCredit));
                                userIntegralDetail.setChangeType(1);
                                userIntegralDetail.setIntegralFrom("系统扣除活动预订所需积分，订单号：" + counts);
                                userIntegralDetail.setIntegralType(7);
                                userIntegralDetailMapper.insertSelective(userIntegralDetail);
                            }
                        }
                        jsonObject.put("status", 0);
                        jsonObject.put("data", "预订成功");
                    } else {
                        jsonObject.put("status", 2);
                        jsonObject.put("data", "余票不足");
                    }
                } else {
                    jsonObject.put("status", 1);
                    if (StringUtils.isNotBlank(checkRs) && checkRs.equals("more")) {
                        jsonObject.put("data", "该用户购买的票数超过了5张");
                    } else if (StringUtils.isNotBlank(checkRs) && checkRs.equals("moreLimit")) {
                        jsonObject.put("data", "该用户购买的票数超过了单场活动订单数量");
                    } else if (StringUtils.isNotBlank(checkRs) && checkRs.equals("moreLimitCount")) {
                        jsonObject.put("data", "该用户购买的票数超过了单笔最大购票数");
                    } else if (StringUtils.isNotBlank(checkRs) && checkRs.equals("overtime")) {
                        jsonObject.put("data", "活动已开始，不可预定");
                    } else if (StringUtils.isNotBlank(checkRs) && checkRs.equals("errorCount")) {
                        jsonObject.put("data", "请输入正确的票数");
                    } else if (StringUtils.isNotBlank(checkRs) && checkRs.equals("overCount")) {
                        jsonObject.put("data", "剩余票数不足");
                    } else if (StringUtils.isNotBlank(checkRs) && checkRs.equals("该场次不存在")) {
                        jsonObject.put("data", "该场次不存在");
                    } else {
                        jsonObject.put("data", checkRs);
                    }
                }
//            }
//        } else {
//            jsonObject.put("status", 1);
//            jsonObject.put("data", apiOrder.getMsg() + ",错误代码:" + apiOrder.getCode());
//            return jsonObject.toString();
//        }
        return jsonObject.toString();
    }

    /**
     * app根据不同条件筛选活动列表
     *
     * @param activity 活动对象
     * @param timeType 1.今天 2.明天 3本周末
     * @param pageApp  分页对象
     * @param lon
     * @param lat
     */
    @Override
    public String queryAppActivityListByCondition(CmsActivity activity, String timeType, PaginationApp pageApp, String lon, String lat) throws ParseException {
        SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd");
        List<Map<String, Object>> listMap = new ArrayList<Map<String, Object>>();
        String nowDate = null;
        Map map = new HashMap();
        map.put("lat", lat);
        map.put("lon", lon);
        try {
            //1 代表今天 2代表明天 3代表本周末
            if (StringUtils.isNotBlank(timeType) && !timeType.equals("")) {
                Date date = new Date();
                nowDate = sf.format(date);
                if (timeType.equals("1")) {
                    map.put("activityTime", nowDate);
                } else if (timeType.equals("2")) {
                    Calendar cal = Calendar.getInstance();
                    cal.setTime(sf.parse(nowDate));
                    cal.add(Calendar.DAY_OF_YEAR, +1);
                    String nextDate = sf.format(cal.getTime());
                    map.put("activityTime", nextDate);
                } else if (timeType.equals("3")) {
                    Calendar currentDate = Calendar.getInstance();
                    currentDate.setFirstDayOfWeek(Calendar.MONDAY);
                    currentDate.set(Calendar.HOUR_OF_DAY, 23);
                    currentDate.set(Calendar.MINUTE, 59);
                    currentDate.set(Calendar.SECOND, 59);
                    currentDate.set(Calendar.DAY_OF_WEEK, Calendar.SUNDAY);
                    map.put("activityTime", sf.format(currentDate.getTime()));
                } else if (timeType.equals("4")) {
                    Calendar cal = Calendar.getInstance();
                    cal.set(Calendar.DAY_OF_WEEK, Calendar.MONDAY); //获取本周一的日期
                    map.put("activityStartTime", sf.format(cal.getTime()));
                    //  System.out.println(sf.format(cal.getTime()));
                    cal.set(Calendar.DAY_OF_WEEK, Calendar.SUNDAY);
                    cal.add(Calendar.WEEK_OF_YEAR, 1);   //获取本周末时间
                    // System.out.println(sf.format(cal.getTime()));
                    map.put("activityEndTime", sf.format(cal.getTime()));
                }
            }
            //活动开始时间
            if (activity != null && !StringUtils.isBlank(activity.getActivityStartTime())) {
                map.put("activityStartTime", activity.getActivityStartTime());
            }
            //活动结束时间
            if (activity != null && StringUtils.isNotBlank(activity.getActivityEndTime())) {
                map.put("activityEndTime", activity.getActivityEndTime());
            }
            //位置
            if (activity != null && StringUtils.isNotBlank(activity.getActivityLocation())) {
                map.put("activityLocation", activity.getActivityLocation());
            }
            //区县代码
            if (activity != null && StringUtils.isNotBlank(activity.getActivityArea())) {
                map.put("activityArea", activity.getActivityArea() + ",%");
            }
            //类型
            if (activity != null && StringUtils.isNotBlank(activity.getActivityType())) {
                map.put("activityType", "%" + activity.getActivityType() + ",%");
            }
            //主题
            if (activity != null && StringUtils.isNotBlank(activity.getActivityTheme())) {
                map.put("activityTheme", "%" + activity.getActivityTheme() + ",%");
            }
            //活动名称模糊查询
            if (activity != null && StringUtils.isNotBlank(activity.getActivityName())) {
                map.put("activityName", "%/" + activity.getActivityName() + "%");
            }
            map.put("activityIsDel", 1);
            map.put("activityState", 6);
            if (pageApp != null && pageApp.getFirstResult() != null && pageApp.getRows() != null) {
                map.put("firstResult", pageApp.getFirstResult());
                map.put("rows", pageApp.getRows());
                int total = activityMapper.queryAppActivityListCount(map);
                pageApp.setTotal(total);
            }
            List<CmsActivity> activityList = activityMapper.queryAppActivityListByCondition(map);
            listMap = getAppActivityResult(activityList, staticServer, null, null, null, null, null);
        } catch (Exception e) {
            e.printStackTrace();
            logger.error("query activityList error" + e.getMessage());
        }
        return JSONResponse.toAppActivityResultFormat(0, listMap, pageApp.getTotal());
    }

    /**
     * app根据查询出的座位列表绘制app展示座位信息
     *
     * @param venueSeatList 座位列表list
     * @return mapList 座位信息
     */
    public List<Map<String, Object>> getAppSeatInfobyList(List<CmsActivitySeat> venueSeatList) {
        List<Map<String, Object>> mapList = new ArrayList<Map<String, Object>>();
        //   Map<String, String> allSeatInfo = new HashMap<String, String>();
        // StringBuilder seatInfoBuilder = new StringBuilder();
        for (int i = 0; i < venueSeatList.size(); i++) {
            Map<String, Object> seatMap = new HashMap<String, Object>();
            CmsActivitySeat map = venueSeatList.get(i);
            //1代表座位正常
            if (Integer.valueOf(map.getSeatStatus()) == Constant.VENUE_SEAT_STATUS_NORMAL) {
                if (map.getSeatVal() != null && StringUtils.isNotBlank(map.getSeatVal())) {
                    String[] activitySeat = map.getSeatVal().split("_");
                    seatMap.put("seatVal", activitySeat[1].toString());
                }
                seatMap.put("seatRow", map.getSeatRow());
                seatMap.put("seatColumn", map.getSeatColumn());
                seatMap.put("seatStatus", Constant.VENUE_SEAT_STATUS_NORMAL);
            }
            //2代表座位被占用
            if (Integer.valueOf(map.getSeatStatus()) == Constant.VENUE_SEAT_STATUS_MAINTANANCE) {
                if (map.getSeatVal() != null && StringUtils.isNotBlank(map.getSeatVal())) {
                    String[] activitySeat = map.getSeatVal().split("_");
                    seatMap.put("seatVal", activitySeat[1].toString());
                }
                seatMap.put("seatRow", map.getSeatRow());
                seatMap.put("seatColumn", map.getSeatColumn());
                seatMap.put("seatStatus", Constant.VENUE_SEAT_STATUS_MAINTANANCE);
            }
            //3代表作座位被删除
            if (Integer.valueOf(map.getSeatStatus()) == Constant.VENUE_SEAT_STATUS_NONE) {
                if (map.getSeatVal() != null && StringUtils.isNotBlank(map.getSeatVal())) {
                    String[] activitySeat = map.getSeatVal().split("_");
                    seatMap.put("seatVal", activitySeat[1].toString());
                }
                seatMap.put("seatRow", map.getSeatRow());
                seatMap.put("seatColumn", map.getSeatColumn());
                seatMap.put("seatStatus", Constant.VENUE_SEAT_STATUS_NONE);
            }
            mapList.add(seatMap);
        }
        logger.info("app在线选座表" + mapList.toString());
        return mapList;
    }

    /**
     * why3.4 app所有活动列表返回数据业务处理
     */
    private List<Map<String, Object>> getAppCmsActivityResult(List<CmsActivity> activityList, StaticServer staticServer, String activityThemeTagId, CmsTagMapper cmsTagMapper, String appType, String userId, CmsTerminalUserMapper userMapper) {
        List<Map<String, Object>> listMap = new ArrayList<Map<String, Object>>();
        try {
            if (CollectionUtils.isNotEmpty(activityList)) {
                //更改用户是否已登录
                if (StringUtils.isNotBlank(appType) && Integer.valueOf(appType) == 1) {
                    if (StringUtils.isNotBlank(userId)) {
                        CmsTerminalUser terminalUser = userMapper.queryTerminalUserById(userId);
                        terminalUser.setUserIsLogin(Constant.LOGIN_SUCCESS);
                        int count = userMapper.editTerminalUserById(terminalUser);
                    }
                }
                for (CmsActivity activity : activityList) {
                    Map<String, Object> mapActivity = new HashMap<String, Object>();
                    mapActivity.put("activityId", activity.getActivityId() != null ? activity.getActivityId() : "");
                    mapActivity.put("activityAddress", activity.getActivityAddress() != null ? activity.getActivityAddress() : "");
                    mapActivity.put("activityName", activity.getActivityName() != null ? activity.getActivityName() : "");

                    //进行活动时间判断
                    /*int statusDate1 = CompareTime.timeCompare2(activity.getActivityStartTime() + " 00:00", DateUtils.parseDateToLongString(TimeUtil.getTimesmorning()));
                    int statusDate2 = CompareTime.timeCompare2(activity.getActivityStartTime() + " 00:00", DateUtils.parseDateToLongString(TimeUtil.getTimesnight()));
                    int statusDate3 = CompareTime.timeCompare2(activity.getActivityStartTime() + " 00:00", DateUtils.parseDateToLongString(TimeUtil.getTomorrownight()));
                    String activityEndTime = "";
                    //返回 0 表示时间日期相同
                    //返回 1 表示日期1>日期2
                    //返回 -1 表示日期1<日期2
                    if (statusDate1 == -1) {
                        mapActivity.put("activityStartTime", activity.getActivityStartTime().substring(5).toString());
                        activityEndTime = activity.getActivityEndTime().substring(5);
                    } else if (statusDate1 == 0 && statusDate2 == -1) {
                        mapActivity.put("activityStartTime", activity.getActivityStartTime().substring(5).toString()+" "+"(今天)" + " " + activity.getEventimes().split(",")[0].toString());
                    } else if (statusDate2 == 0 && statusDate3 == -1) {
                        mapActivity.put("activityStartTime", activity.getActivityStartTime().substring(5).toString()+" "+"(明天)" + " " + activity.getEventimes().split(",")[0].toString());
                    } else if (statusDate1 == 1 && statusDate3 == 0) {
                        mapActivity.put("activityStartTime", activity.getActivityStartTime().substring(5).toString());
                    } else if (statusDate1 == 1 && statusDate3 == 1) {
                        mapActivity.put("activityStartTime", activity.getActivityStartTime().substring(5).toString());
                        activityEndTime = activity.getActivityEndTime().substring(5);
                    }
                    mapActivity.put("activityEndTime", activityEndTime);*/

                    if (StringUtils.isBlank(activity.getEventimes())) {
                        activity.setEventimes("");
                    }
                    int activityPast = 0;
                    // 活动开始时间
                    String activityStartTime = activity.getActivityStartTime() + " 00:00";
                    String activityMinTime = activity.getActivityStartTime() + " " +
                            activity.getEventimes().split(",")[activity.getEventimes().split(",").length - 1].split("-")[0];
                    // 今天时间
                    String nowTime = DateUtils.parseDateToLongString(TimeUtil.getTimesmorning());
                    String nowCurrentTime = DateUtils.parseDateToLongString(new Date());
                    // 明天时间
                    String tomorrowTime = DateUtils.parseDateToLongString(DateUtils.getDefaultStartUseTime());

                    String[] startTime = activity.getActivityStartTime().split("-");

                    if (StringUtils.isBlank(activity.getActivityEndTime()) || activity.getActivityStartTime().equals(activity.getActivityEndTime())) { // 同一天活动
                        if (CompareTime.timeCompare2(activityStartTime, nowTime) == 0) { // 今天的活动
                            mapActivity.put("activityStartTime", startTime[1] + "月" + startTime[2] + "日(今天) " + activity.getEventimes().split(",")[0]);
                            if (CompareTime.timeCompare2(activityMinTime, nowCurrentTime) < 0) {
                                activityPast = 1;
                            }
                        } else if (CompareTime.timeCompare2(activityStartTime, tomorrowTime) == 0) { // 明天的活动
                            mapActivity.put("activityStartTime", startTime[1] + "月" + startTime[2] + "日(明天) " + activity.getEventimes().split(",")[0]);
                        } else if (CompareTime.timeCompare2(activityStartTime, tomorrowTime) > 0) { // 未来时间活动
                            mapActivity.put("activityStartTime", startTime[1] + "月" + startTime[2] + "日 " + activity.getEventimes().split(",")[0]);
                        } else if (CompareTime.timeCompare2(activityStartTime, nowTime) < 0) { // 过期活动
                            mapActivity.put("activityStartTime", startTime[1] + "月" + startTime[2] + "日 " + activity.getEventimes().split(",")[0]);
                            activityPast = 1;
                        }
                    } else { // 跨天活动
                        String activityEndTime = activity.getActivityEndTime() + " 00:00";
                        String activityMaxTime = activity.getActivityEndTime() + " " +
                                activity.getEventimes().split(",")[activity.getEventimes().split(",").length - 1].split("-")[0];
                        String[] endTime = activity.getActivityEndTime().split("-");
                        if (CompareTime.timeCompare2(activityStartTime, nowTime) == 0) { // 今天活动
                            mapActivity.put("activityStartTime", startTime[1] + "月" + startTime[2] + "日开始(今天)");
                        } else if (CompareTime.timeCompare2(activityStartTime, tomorrowTime) == 0) { // 明天活动
                            mapActivity.put("activityStartTime", startTime[1] + "月" + startTime[2] + "日开始(明天)");
                        } else if (CompareTime.timeCompare2(activityStartTime, tomorrowTime) > 0) { // 未来其它时间活动
                            mapActivity.put("activityStartTime", startTime[1] + "月" + startTime[2] + "日开始");
                        } else if (CompareTime.timeCompare2(activityEndTime, nowTime) < 0) { // 过期活动
                            mapActivity.put("activityStartTime", startTime[1] + "月" + startTime[2] + "日至" + endTime[1] + "月" + endTime[2] + "日");
                            activityPast = 1;
                        } else if (CompareTime.timeCompare2(activityStartTime, nowTime) < 0 && CompareTime.timeCompare2(activityEndTime, nowTime) == 0) {
                            mapActivity.put("activityStartTime", "今天结束");
                            if (CompareTime.timeCompare2(activityMaxTime, nowCurrentTime) < 0) {
                                activityPast = 1;
                            }
                        } else if (CompareTime.timeCompare2(activityStartTime, nowTime) < 0 && CompareTime.timeCompare2(activityEndTime, nowTime) > 0) {
                            long endLong = DateUtils.parseLongStringToDate(activityEndTime).getTime();
                            long nowLong = DateUtils.parseLongStringToDate(nowTime).getTime();
                            long betweenDays = (endLong - nowLong) / (1000 * 3600 * 24);
                            mapActivity.put("activityStartTime", betweenDays + "天后结束");
                        }
                    }

                    mapActivity.put("activityPast", activityPast);
                    mapActivity.put("activitySubject", activity.getActivitySubject() != null ? activity.getActivitySubject() : "");
                    mapActivity.put("activitySite", activity.getActivitySite() != null ? activity.getActivitySite() : "");
                    mapActivity.put("activityPrice", StringUtils.isNotBlank(activity.getActivityPrice()) &&
                            activity.getActivityIsFree() == 2 ? (activity.getActivityPrice().matches(match) ? activity.getActivityPrice() : "0") : "0");
                    mapActivity.put("tagId", activity.getTagId() != null ? activity.getTagId() : "");
                    mapActivity.put("tagName", activity.getTagName() != null ? activity.getTagName() : "");
                    mapActivity.put("activityUpdateTime", activity.getActivityUpdateTime() != null ? DateUtils.convertToSS(activity.getActivityUpdateTime()) : "");

                    if (Double.parseDouble(mapActivity.get("activityPrice").toString()) > 0d) {
                        mapActivity.put("activityPriceRgb", "#008000");
                    } else {
                        mapActivity.put("activityPriceRgb", "#ff0000");
                    }

                    String activityIconUrl = "";
                    if (StringUtils.isNotBlank(activity.getActivityIconUrl())) {
                        activityIconUrl = staticServer.getStaticServerUrl() + activity.getActivityIconUrl();
                    }
                    mapActivity.put("activityIconUrl", activityIconUrl);
                    //获取活动经纬度
                    double activityLon = 0d;
                    if (activity.getActivityLon() != null) {
                        activityLon = activity.getActivityLon();
                    }
                    double activityLat = 0d;
                    if (activity.getActivityLat() != null) {
                        activityLat = activity.getActivityLat();
                    }
                    double distance = 0d;
                    if (activity.getDistance() != null) {
                        distance = activity.getDistance();
                    }

                    mapActivity.put("activityLon", activityLon);
                    mapActivity.put("activityLat", activityLat);
                    if (StringUtils.isNotBlank(activity.getSysId()) && "1".equals(activity.getSysNo())) {
                        distance = 20 + (int) (Math.random() * 10000) % 10;
                        mapActivity.put("distance", distance);
                    } else {
                        mapActivity.put("distance", distance / 1000);
                    }

              /*  double distance = 0d;
                if (StringUtils.isNotBlank(Lat) && StringUtils.isNotBlank(Lon)) {
                    appDistance startDistancs = new appDistance();
                    startDistancs.setLongitude(Double.parseDouble(Lon));
                    startDistancs.setDimensionality(Double.parseDouble(Lat));
                    appDistance endDistancs = new appDistance();
                    endDistancs.setLongitude(activityLon);
                    endDistancs.setDimensionality(activityLat);
                    distance = getDistance(startDistancs, endDistancs);
                }*/
                    //N 显示最新 O什么也不显示
                  /*  if (activity.getHours() > 0) {
                        mapActivity.put("activityRecommend", "N");
                    } else {
                        mapActivity.put("activityRecommend", "O");
                    }*/
                    //活动主题标签名称
                    if (StringUtils.isNotBlank(activity.getTagId()) && StringUtils.isNotBlank(activityThemeTagId)) {
                        String[] activityThemeIds = activity.getTagId().split(",");
                        String[] tagThemeIds = activityThemeTagId.split(",");
                        outPut:
                        for (int i = 0; i < activityThemeIds.length; i++) {
                            for (int j = 0; j < tagThemeIds.length; j++) {
                                if (StringUtils.isNotEmpty(activityThemeIds[i]) && StringUtils.isNotEmpty(tagThemeIds[j]) && activityThemeIds[i].equals(tagThemeIds[j])) {
                                    String[] colorLength = StringUtils.split(activity.getTagColor(), ",");
                                    if (colorLength.length >= activityThemeIds.length) {
                                        mapActivity.put("tagColor", activity.getTagColor() != null ? StringUtils.split(activity.getTagColor(), ",")[i] : "");
                                        mapActivity.put("tagInitial", activity.getTagInitial() != null ? StringUtils.split(activity.getTagInitial(), ",")[i] : "");
                                        break outPut;

                                    }
                                }
                            }
                        }
                    }
                    mapActivity.put("activityAbleCount", activity.getAvailableCount() != null ? activity.getAvailableCount() : "0");
                    //是否可预订 1：否 2：是
                    mapActivity.put("activityIsReservation", activity.getActivityIsReservation() != null ? activity.getActivityIsReservation() : "");
                    mapActivity.put("activityArea", activity.getActivityArea() != null ? activity.getActivityArea() : "");
                    mapActivity.put("tagName", activity.getTagName() != null ? activity.getTagName() : "");
                    mapActivity.put("sysNo", activity.getSysNo() != null ? activity.getSysNo() : "");
                    mapActivity.put("sysId", activity.getSysId() != null ? activity.getSysId() : "");

                    listMap.add(mapActivity);
                }
            }
            return listMap;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return listMap;
    }

    /**
     * 公共获取根据条件筛选活动列表
     */
    public List<Map<String, Object>> getAppActivityResult(List<CmsActivity> activityList, StaticServer staticServer, String activityThemeTagId, CmsTagMapper cmsTagMapper, String appType, String userId, CmsTerminalUserMapper userMapper) {
        List<Map<String, Object>> listMap = new ArrayList<Map<String, Object>>();
        try {
            if (CollectionUtils.isNotEmpty(activityList)) {
                //更改用户是否已登录
                if (StringUtils.isNotBlank(appType) && Integer.valueOf(appType) == 1) {
                    if (StringUtils.isNotBlank(userId)) {
                        CmsTerminalUser terminalUser = userMapper.queryTerminalUserById(userId);
                        terminalUser.setUserIsLogin(Constant.LOGIN_SUCCESS);
                        int count = userMapper.editTerminalUserById(terminalUser);
                    }
                }
                for (CmsActivity activity : activityList) {
                    Map<String, Object> mapActivity = new HashMap<String, Object>();
                    mapActivity.put("activityId", activity.getActivityId() != null ? activity.getActivityId() : "");
                    mapActivity.put("activityAddress", activity.getActivityAddress() != null ? activity.getActivityAddress() : "");
                    mapActivity.put("activityName", activity.getActivityName() != null ? activity.getActivityName() : "");

                    //进行活动时间判断
                    /*int statusDate1 = CompareTime.timeCompare2(activity.getActivityStartTime() + " 00:00", DateUtils.parseDateToLongString(TimeUtil.getTimesmorning()));
                    int statusDate2 = CompareTime.timeCompare2(activity.getActivityStartTime() + " 00:00", DateUtils.parseDateToLongString(TimeUtil.getTimesnight()));
                    int statusDate3 = CompareTime.timeCompare2(activity.getActivityStartTime() + " 00:00", DateUtils.parseDateToLongString(TimeUtil.getTomorrownight()));
                    String activityEndTime = "";
                    //返回 0 表示时间日期相同
                    //返回 1 表示日期1>日期2
                    //返回 -1 表示日期1<日期2
                    if (statusDate1 == -1) {
                        mapActivity.put("activityStartTime", activity.getActivityStartTime().substring(5).toString());
                        activityEndTime = activity.getActivityEndTime().substring(5);
                    } else if (statusDate1 == 0 && statusDate2 == -1) {
                        mapActivity.put("activityStartTime", activity.getActivityStartTime().substring(5).toString()+" "+"(今天)" + " " + activity.getEventimes().split(",")[0].toString());
                    } else if (statusDate2 == 0 && statusDate3 == -1) {
                        mapActivity.put("activityStartTime", activity.getActivityStartTime().substring(5).toString()+" "+"(明天)" + " " + activity.getEventimes().split(",")[0].toString());
                    } else if (statusDate1 == 1 && statusDate3 == 0) {
                        mapActivity.put("activityStartTime", activity.getActivityStartTime().substring(5).toString());
                    } else if (statusDate1 == 1 && statusDate3 == 1) {
                        mapActivity.put("activityStartTime", activity.getActivityStartTime().substring(5).toString());
                        activityEndTime = activity.getActivityEndTime().substring(5);
                    }
                    mapActivity.put("activityEndTime", activityEndTime);*/

                    if (StringUtils.isBlank(activity.getEventimes())) {
                        activity.setEventimes("");
                    }
                    int activityPast = 0;
                    // 活动开始时间
                    String activityStartTime = activity.getActivityStartTime() + " 00:00";
                    String activityMinTime = activity.getActivityStartTime() + " " +
                            activity.getEventimes().split(",")[activity.getEventimes().split(",").length - 1].split("-")[0];
                    // 今天时间
                    String nowTime = DateUtils.parseDateToLongString(TimeUtil.getTimesmorning());
                    String nowCurrentTime = DateUtils.parseDateToLongString(new Date());
                    // 明天时间
                    String tomorrowTime = DateUtils.parseDateToLongString(DateUtils.getDefaultStartUseTime());

                    String[] startTime = activity.getActivityStartTime().split("-");

                    if (StringUtils.isBlank(activity.getActivityEndTime()) || activity.getActivityStartTime().equals(activity.getActivityEndTime())) { // 同一天活动
                        if (CompareTime.timeCompare2(activityStartTime, nowTime) == 0) { // 今天的活动
                            mapActivity.put("activityStartTime", startTime[1] + "月" + startTime[2] + "日(今天) " + activity.getEventimes().split(",")[0]);
                            if (CompareTime.timeCompare2(activityMinTime, nowCurrentTime) < 0) {
                                activityPast = 1;
                            }
                        } else if (CompareTime.timeCompare2(activityStartTime, tomorrowTime) == 0) { // 明天的活动
                            mapActivity.put("activityStartTime", startTime[1] + "月" + startTime[2] + "日(明天) " + activity.getEventimes().split(",")[0]);
                        } else if (CompareTime.timeCompare2(activityStartTime, tomorrowTime) > 0) { // 未来时间活动
                            mapActivity.put("activityStartTime", startTime[1] + "月" + startTime[2] + "日 " + activity.getEventimes().split(",")[0]);
                        } else if (CompareTime.timeCompare2(activityStartTime, nowTime) < 0) { // 过期活动
                            mapActivity.put("activityStartTime", startTime[1] + "月" + startTime[2] + "日 " + activity.getEventimes().split(",")[0]);
                            activityPast = 1;
                        }
                    } else { // 跨天活动
                        String activityEndTime = activity.getActivityEndTime() + " 00:00";
                        String activityMaxTime = activity.getActivityEndTime() + " " +
                                activity.getEventimes().split(",")[activity.getEventimes().split(",").length - 1].split("-")[0];
                        String[] endTime = activity.getActivityEndTime().split("-");
                        if (CompareTime.timeCompare2(activityStartTime, nowTime) == 0) { // 今天活动
                            mapActivity.put("activityStartTime", startTime[1] + "月" + startTime[2] + "日开始(今天)");
                        } else if (CompareTime.timeCompare2(activityStartTime, tomorrowTime) == 0) { // 明天活动
                            mapActivity.put("activityStartTime", startTime[1] + "月" + startTime[2] + "日开始(明天)");
                        } else if (CompareTime.timeCompare2(activityStartTime, tomorrowTime) > 0) { // 未来其它时间活动
                            mapActivity.put("activityStartTime", startTime[1] + "月" + startTime[2] + "日开始");
                        } else if (CompareTime.timeCompare2(activityEndTime, nowTime) < 0) { // 过期活动
                            mapActivity.put("activityStartTime", startTime[1] + "月" + startTime[2] + "日至" + endTime[1] + "月" + endTime[2] + "日");
                            activityPast = 1;
                        } else if (CompareTime.timeCompare2(activityStartTime, nowTime) < 0 && CompareTime.timeCompare2(activityEndTime, nowTime) == 0) {
                            mapActivity.put("activityStartTime", "今天结束");
                            if (CompareTime.timeCompare2(activityMaxTime, nowCurrentTime) < 0) {
                                activityPast = 1;
                            }
                        } else if (CompareTime.timeCompare2(activityStartTime, nowTime) < 0 && CompareTime.timeCompare2(activityEndTime, nowTime) > 0) {
                            long endLong = DateUtils.parseLongStringToDate(activityEndTime).getTime();
                            long nowLong = DateUtils.parseLongStringToDate(nowTime).getTime();
                            long betweenDays = (endLong - nowLong) / (1000 * 3600 * 24);
                            mapActivity.put("activityStartTime", betweenDays + "天后结束");
                        }
                    }

                    mapActivity.put("activityPast", activityPast);
                    mapActivity.put("activitySubject", activity.getActivitySubject() != null ? activity.getActivitySubject() : "");
                    mapActivity.put("activitySite", activity.getActivitySite() != null ? activity.getActivitySite() : "");
                    mapActivity.put("activityPrice", StringUtils.isNotBlank(activity.getActivityPrice()) &&
                            activity.getActivityIsFree() == 2 ? (activity.getActivityPrice().matches(match) ? activity.getActivityPrice() : "0") : "0");

                    if (Double.parseDouble(mapActivity.get("activityPrice").toString()) > 0d) {
                        mapActivity.put("activityPriceRgb", "#008000");
                    } else {
                        mapActivity.put("activityPriceRgb", "#ff0000");
                    }

                    String activityIconUrl = "";
                    if (StringUtils.isNotBlank(activity.getActivityIconUrl())) {
                        activityIconUrl = staticServer.getStaticServerUrl() + activity.getActivityIconUrl();
                    }
                    mapActivity.put("activityIconUrl", activityIconUrl);
                    //获取活动经纬度
                    double activityLon = 0d;
                    if (activity.getActivityLon() != null) {
                        activityLon = activity.getActivityLon();
                    }
                    double activityLat = 0d;
                    if (activity.getActivityLat() != null) {
                        activityLat = activity.getActivityLat();
                    }
                    double distance = 0d;
                    if (activity.getDistance() != null) {
                        distance = activity.getDistance();
                    }
                    mapActivity.put("activityLon", activityLon);
                    mapActivity.put("activityLat", activityLat);

                    if (StringUtils.isNotBlank(activity.getSysId()) && "1".equals(activity.getSysNo())) {
                        distance = 20 + (int) (Math.random() * 10000) % 10;
                        mapActivity.put("distance", distance);
                    } else {
                        mapActivity.put("distance", distance / 1000);
                    }
              /*  double distance = 0d;
                if (StringUtils.isNotBlank(Lat) && StringUtils.isNotBlank(Lon)) {
                    appDistance startDistancs = new appDistance();
                    startDistancs.setLongitude(Double.parseDouble(Lon));
                    startDistancs.setDimensionality(Double.parseDouble(Lat));
                    appDistance endDistancs = new appDistance();
                    endDistancs.setLongitude(activityLon);
                    endDistancs.setDimensionality(activityLat);
                    distance = getDistance(startDistancs, endDistancs);
                }*/
                    //N 显示最新 O什么也不显示
                  /*  if (activity.getHours() > 0) {
                        mapActivity.put("activityRecommend", "N");
                    } else {
                        mapActivity.put("activityRecommend", "O");
                    }*/
                    //活动主题标签名称
                    /*if (StringUtils.isNotBlank(activity.getTagId()) && StringUtils.isNotBlank(activityThemeTagId)) {
                        String[] activityThemeIds = activity.getTagId().split(",");
                        String[] tagThemeIds = activityThemeTagId.split(",");
                        outPut:
                        for (int i = 0; i < activityThemeIds.length; i++) {
                            for (int j = 0; j < tagThemeIds.length; j++) {
                                if (StringUtils.isNotEmpty(activityThemeIds[i]) && StringUtils.isNotEmpty(tagThemeIds[j]) && activityThemeIds[i].equals(tagThemeIds[j])) {
                                    String[] colorLength = StringUtils.split(activity.getTagColor(), ",");
                                    if (colorLength.length >= activityThemeIds.length) {
                                        mapActivity.put("tagColor", activity.getTagColor() != null ? StringUtils.split(activity.getTagColor(), ",")[i] : "");
                                        mapActivity.put("tagInitial", activity.getTagInitial() != null ? StringUtils.split(activity.getTagInitial(), ",")[i] : "");
                                        break outPut;

                                    }
                                }
                            }
                        }
                    }*/
                    mapActivity.put("tagColor", activity.getTagColor() != null ? activity.getTagColor() : "");
                    mapActivity.put("tagInitial", activity.getTagInitial() != null ? activity.getTagInitial() : "");
                    mapActivity.put("activityAbleCount", activity.getAvailableCount() != null ? activity.getAvailableCount() : "0");
                    //是否可预订 1：否 2：是
                    mapActivity.put("activityIsReservation", activity.getActivityIsReservation() != null ? activity.getActivityIsReservation() : "");
                    mapActivity.put("activityUpdateTime", activity.getActivityUpdateTime() != null ? DateUtils.convertToSS(activity.getActivityUpdateTime()) : "");
                    mapActivity.put("sysNo", activity.getSysNo() != null ? activity.getSysNo() : "");
                    mapActivity.put("sysId", activity.getSysId() != null ? activity.getSysId() : "");

                    listMap.add(mapActivity);
                }
            }
            return listMap;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return listMap;
    }

    /**
     * app根据场馆id获取相关活动列表
     *
     * @param venueId 展馆id
     * @param pageApp 分页对象
     */
    public String queryAppActivityListById(String venueId, PaginationApp pageApp) {
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("venueId", venueId);
        //数据状态
        map.put("activityIsDel", Constant.NORMAL);
        map.put("activityState", Constant.PUBLISH);
        if (pageApp != null && pageApp.getFirstResult() != null && pageApp.getRows() != null) {
            map.put("firstResult", pageApp.getFirstResult());
            map.put("rows", pageApp.getRows());
        }
      /*  SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
        String date = sdf.format(new Date());
        map.put("activityStartTime", date);*/
        List<Map<String, Object>> listMap = new ArrayList<Map<String, Object>>();
        try {
            List<CmsActivity> activityList = activityMapper.queryActivityListById(map);
            if (activityList != null && activityList.size() > 0) {
                String staticUrl = staticServer.getStaticServerUrl();
                for (CmsActivity activity : activityList) {
                    Map<String, Object> activityMap = new HashMap<String, Object>();
                    activityMap.put("activityId", activity.getActivityId() != null ? activity.getActivityId() : "");
                    activityMap.put("activityName", activity.getActivityName() != null ? activity.getActivityName() : "");//活动名称
                    activityMap.put("activityStartTime", activity.getActivityStartTime() != null ? activity.getActivityStartTime() : "");//活动开始时间
                    activityMap.put("activityEndTime", activity.getActivityEndTime() != null ? activity.getActivityEndTime() : "");//活动结束时间
                    activityMap.put("activityIconUrl", staticUrl + activity.getActivityIconUrl());//图片路径
                    activityMap.put("activityAbleCount", activity.getAvailableCount());//剩余票数
                    // 价格判断 by qww 2016/3/24
                    activityMap.put("activityPrice", StringUtils.isNotBlank(activity.getActivityPrice()) &&
                            activity.getActivityIsFree() == 2 ? (activity.getActivityPrice().matches(match) ? activity.getActivityPrice() : "0") : "0");
                    activityMap.put("sysNo", activity.getSysNo() != null ? activity.getSysNo() : "");
                    activityMap.put("sysId", activity.getSysId() != null ? activity.getSysId() : "");
                    //是否可预订 1：否 2：是
                    activityMap.put("activityIsReservation", activity.getActivityIsReservation() != null ? activity.getActivityIsReservation() : "");
                    listMap.add(activityMap);
                }
            }
        } catch (Exception e) {
            logger.error("app根据展馆id获取活动列表出错!", e);
        }
        return JSONResponse.toAppResultFormat(0, listMap);
    }

    /**
     * app获取首页活动(类型)标签列表接口
     *
     * @param userId 用户id
     * @return
     */
    @Override
    public String queryAppActivityTagList(String userId) {
        //  List<Map<String, Object>> mapThemeList = new ArrayList<Map<String, Object>>();
        List<Map<String, Object>> mapTypelist = new ArrayList<Map<String, Object>>();
        List<CmsActivity> activityThemeList = activityMapper.queryActivityThemeByCode(Constant.ACTIVITY_TYPE);
        List<CmsUserTag> activityUserTagList = cmsUserTagMapper.queryActivityUserTagListById(userId);
        if (CollectionUtils.isNotEmpty(activityThemeList)) {
            for (CmsActivity activity : activityThemeList) {
                Map<String, Object> mapTypeTag = new HashMap<String, Object>();
                mapTypeTag.put("tagName", activity.getTagName() != null ? activity.getTagName() : "");
                mapTypeTag.put("tagId", activity.getTagId() != null ? activity.getTagId() : "");
                String tagImageUrl = "";
                if (StringUtils.isNotBlank(activity.getTagImageUrl())) {
                    tagImageUrl = staticServer.getStaticServerUrl() + activity.getTagImageUrl();
                }
                mapTypeTag.put("tagImageUrl", tagImageUrl);
                //     mapThemeTag.put("activityTheme",1);
                if (CollectionUtils.isNotEmpty(activityUserTagList)) {
                    for (CmsUserTag tags : activityUserTagList) {
                        if (activity.getTagId().equals(tags.getUserSelectTag())) {
                            //代表该用户选择该类型标签
                            mapTypeTag.put("status", 1);
                            break;
                        } else {
                            //代表该用户未选择该类型标签
                            mapTypeTag.put("status", 2);
                        }
                    }
                    mapTypelist.add(mapTypeTag);
                } else {
                    //代表该用户未选择该类型标签
                    mapTypeTag.put("status", 2);
                    mapTypelist.add(mapTypeTag);
                }
            }
        }
        /*
        List<CmsActivity>  activityTypeList=activityMapper.queryActivityThemeByCode(Constant.ACTIVITY_TYPE);
        if(CollectionUtils.isNotEmpty(activityTypeList)){
            for(CmsActivity activity:activityTypeList){
                Map<String,Object> mapTypeTag=new HashMap<String, Object>();
                mapTypeTag.put("tagName",activity.getTagName()!=null?activity.getTagName():"");
                mapTypeTag.put("tagId",activity.getTagId()!=null?activity.getTagId():"");
                String tagImageUrl = "";
                if (StringUtils.isNotBlank(activity.getTagImageUrl())) {
                    tagImageUrl = staticServer.getStaticServerUrl() + activity.getTagImageUrl();
                }
                mapTypeTag.put("tagImageUrl", tagImageUrl);
                mapTypeTag.put("activityType",2);
                if(CollectionUtils.isNotEmpty(activityUserTagList)){
                    for (CmsUserTag tags :activityUserTagList) {
                        if (activity.getTagId().equals(tags.getUserSelectTag())) {
                            //代表该用户选择该类型标签
                            mapTypeTag.put("status", 1);
                            break;
                        } else {
                            //代表该用户未选择该类型标签
                            mapTypeTag.put("status", 2);
                        }
                    }
                    mapTypelist.add(mapTypeTag);
                }else {
                    //代表该用户未选择该类型标签
                    mapTypeTag.put("status",2);
                    mapTypelist.add(mapTypeTag);
                }
            }
        }
        */
        return JSONResponse.toAppResultFormat(0, mapTypelist);
    }

    /**
     * app用户报名活动接口
     *
     * @param activityId 活动id
     * @param userId     用户id
     *                   return 是否报名成功 (成功：success；失败：false)
     */
    @Override
    public String addActivityUserWantgo(String activityId, String userId) {
        int flag = 0;
        int status = 0;
        CmsUserWantgo userWantgo = new CmsUserWantgo();
        if (activityId != null && StringUtils.isNotBlank(activityId)) {
            userWantgo.setRelateId(activityId);
        }
        if (userId != null && StringUtils.isNotBlank(userId)) {
            userWantgo.setUserId(userId);
        }
        status = cmsUserWantgoMapper.queryAppUserWantCountById(userWantgo);
        if (status > 0) {
            return JSONResponse.commonResultFormat(14111, "该用户已报名该活动,不可重复报名", null);
        }
        userWantgo.setSid(UUIDUtils.createUUId());
        userWantgo.setCreateTime(new Date());
        userWantgo.setRelateType(Constant.WANT_GO_ACTIVITY);
        flag = cmsUserWantgoMapper.addUserWantgo(userWantgo);
        if (flag > 0) {
            return JSONResponse.commonResultFormat(0, "用户报名活动成功", null);
        } else {
            return JSONResponse.commonResultFormat(1, "用户报名活动失败", null);
        }
    }

    /**
     * app获取活动报名列表接口
     *
     * @param activityId 活动id
     * @return
     */
    @Override
    public String queryAppActivityUserWantgoList(PaginationApp pageApp, String activityId) {
        List<Map<String, Object>> listMap = new ArrayList<Map<String, Object>>();
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("relateType", Constant.WANT_GO_ACTIVITY);
        if (StringUtils.isNotBlank(activityId)) {
            map.put("relateId", activityId);
        }
        if (pageApp != null && pageApp.getFirstResult() != null && pageApp.getRows() != null) {
            map.put("firstResult", pageApp.getFirstResult());
            map.put("rows", pageApp.getRows());
        }
        try {
            int total = cmsUserWantgoMapper.queryUserWantgoCount(map);
            //设置分页的总条数来获取总页数
            pageApp.setTotal(total);
            List<CmsUserWantgo> wgList = cmsUserWantgoMapper.queryAppUserWantgoList(map);
            listMap = getAppActivityUserWantgoResult(wgList);
        } catch (Exception e) {
            e.printStackTrace();
            logger.error("query activityUserWantgoList error!" + e.getMessage());
        }
        return JSONResponse.toAppActivityResultFormat(0, listMap, pageApp.getTotal());
    }

    /**
     * why3.5 app获取活动报名列表接口(点赞人列表)
     *
     * @param activityId 活动id
     * @return
     */
    @Override
    public String queryAppCmsActivityUserWantgoList(PaginationApp pageApp, String activityId) {
        List<Map<String, Object>> listMap = new ArrayList<Map<String, Object>>();
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("relateType", Constant.WANT_GO_ACTIVITY);
        map.put("relateId", activityId);
        int count = cmsUserWantgoMapper.queryUserWantgoCount(map);
        if (pageApp != null && pageApp.getFirstResult() != null && pageApp.getRows() != null) {
            map.put("firstResult", pageApp.getFirstResult());
            map.put("rows", pageApp.getRows());
        }
        try {
            List<CmsUserWantgo> wgList = cmsUserWantgoMapper.queryAppUserWantgoList(map);
            listMap = getAppActivityUserWantgoResult(wgList);
        } catch (Exception e) {
            e.printStackTrace();
            logger.error("query activityUserWantgoList error!" + e.getMessage());
        }
        return JSONResponse.toAppActivityResultFormat(1, listMap, count);
    }



    /**
     * app用户浏览标签随机推送活动
     *
     * @param userId     用户id
     * @param activityId 活动id
     * @return
     */
    @Override
    public String addRandActivity(String userId, String activityId) {
        int flag = 0;
        try {
            CmsActivityRecommendTag cmsActivityRecommendTag = new CmsActivityRecommendTag();
            cmsActivityRecommendTag.setTagRecommendActivityId(UUIDUtils.createUUId());
            cmsActivityRecommendTag.setUserId(userId);
            cmsActivityRecommendTag.setRelationId(activityId);
            cmsActivityRecommendTag.setState(1);
            flag = cmsActivityRecommendTagMapper.addRandActivity(cmsActivityRecommendTag);
        } catch (Exception e) {
            e.printStackTrace();
            logger.error("add randActivity error!" + e.getMessage());
        }
        if (flag > 0) {
            return JSONResponse.toAppResultFormat(0, "浏览推送活动成功");
        } else {
            return JSONResponse.toAppResultFormat(1, "浏览推送活动失败");
        }
    }

    /**
     * 获得我想去用户map格式
     */
    public List<Map<String, Object>> getAppActivityUserWantgoResult(List<CmsUserWantgo> list) {
        List<Map<String, Object>> listMap = new ArrayList<Map<String, Object>>();
        if (CollectionUtils.isNotEmpty(list)) {
            for (CmsUserWantgo activityUserWantgo : list) {
                Map<String, Object> mapWg = new HashMap<String, Object>();
                mapWg.put("userId", activityUserWantgo.getUserId() != null ? activityUserWantgo.getUserId() : "");
                mapWg.put("userName", activityUserWantgo.getUserName() != null ? activityUserWantgo.getUserName() : "");
                String userHeadImgUrl = "";
                if (StringUtils.isNotBlank(activityUserWantgo.getUserHeadImgUrl()) && activityUserWantgo.getUserHeadImgUrl().contains("http://")) {
                    userHeadImgUrl = activityUserWantgo.getUserHeadImgUrl();
                } else if (StringUtils.isNotBlank(activityUserWantgo.getUserHeadImgUrl())) {
                    userHeadImgUrl = staticServer.getStaticServerUrl() + activityUserWantgo.getUserHeadImgUrl();
                }
                mapWg.put("userHeadImgUrl", userHeadImgUrl);
                mapWg.put("userSex", activityUserWantgo.getUserSex() != null ? activityUserWantgo.getUserSex() : "");
                SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
                mapWg.put("userBirth", activityUserWantgo.getUserBirth() != null ? df.format(activityUserWantgo.getUserBirth()) : "");
                listMap.add(mapWg);
            }
        }
        return listMap;
    }

    /**
     * app即将开始时的活动数目
     *
     * @param userId 用户id
     * @param tagId  标签id
     * @return
     */
    @Override
    public String queryAppWillStartActivityCount(String userId, String tagId) {
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("activityState", Constant.PUBLISH);
        map.put("activityIsDel", Constant.NORMAL);

        if (StringUtils.isNotBlank(tagId)) {
            map.put("tagId", tagId);
        } else {
            map.put("tag", "Y");
        }

        if (StringUtils.isNotBlank(userId)) {
            map.put("userId", userId);
            CmsUserWillStart willStart = userWillStartAppService.queryUserWillStartByUserId(map);
            if (willStart != null && willStart.getClickTime() != null) {
                map.put("clickTime", willStart.getClickTime());
            }
        }

        int count = userWillStartAppService.queryAppWillStartActivityCount(map);
        return JSONResponse.toAppResultFormat(0, count);
    }

    /**
     * app端点击即将开始时新增数据
     *
     * @param userId 用户id
     * @return
     */
    @Override
    public String addAppWillStart(String userId, String versionNo, String tagId) {
        try {
            CmsUserWillStart userWillStart = new CmsUserWillStart();
            userWillStart.setUserId(userId);
            userWillStart.setClickTime(new Date());
            userWillStart.setVersionNo(versionNo);

            Map<String, Object> map = new HashMap<String, Object>();
            if (StringUtils.isNotBlank(userWillStart.getUserId())) {
                map.put("userId", userWillStart.getUserId());
            }
            if (StringUtils.isNotBlank(tagId)) {
                userWillStart.setTagId(tagId);
                map.put("tagId", tagId);
            } else {
                userWillStart.setTagId("Y");
                map.put("tag", "Y");
            }

            int count = userWillStartAppService.queryUserWillStartCountByUserId(map);
            if (count > 0) {
                userWillStartAppService.editAppWillStartByUserId(userWillStart);
            } else {
                userWillStart.setId(UUIDUtils.createUUId());
                userWillStartAppService.addAppWillStart(userWillStart);
            }
            return JSONResponse.toAppResultFormat(1, "点击即将开始操作成功");
        } catch (Exception e) {
            e.printStackTrace();
            logger.error("add randActivity error!" + e.getMessage());
        }
        return JSONResponse.toAppResultFormat(0, "点击即将开始操作失败");
    }

    /**
     * app取消用户报名活动
     *
     * @param activityId 活动id
     * @param userId     用户id
     * @return
     */
    @Override
    public String deleteActivityUserWantgo(String activityId, String userId) {
        CmsUserWantgo userWantgo = new CmsUserWantgo();
        if (StringUtils.isNotBlank(activityId)) {
            userWantgo.setRelateId(activityId);
        }
        if (StringUtils.isNotBlank(userId)) {
            userWantgo.setUserId(userId);
        }
        int flag = cmsUserWantgoMapper.deleteUserWantgo(userWantgo);
        if (flag > 0) {
            return JSONResponse.commonResultFormat(0, "用户取消报名活动成功", null);
        } else {
            return JSONResponse.commonResultFormat(1, "用户取消报名活动失败", null);
        }
    }

    /**
     * app查询推荐的活动
     *
     * @param pageApp 分页对象
     * @return
     */
    @Override
    public String queryRecommendActivity(PaginationApp pageApp) {
        Map<String, Object> map = new HashMap<String, Object>();
        if (pageApp != null && pageApp.getFirstResult() != null && pageApp.getRows() != null) {
            map.put("firstResult", pageApp.getFirstResult());
            map.put("rows", pageApp.getRows());
        }
        List<CmsActivity> activityList = activityMapper.queryRecommendActivity(map);

        List<Map<String, Object>> listMap = getAppActivityResult(activityList, staticServer, null, null, null, null, null);
        if (CollectionUtils.isEmpty(listMap)) {
            listMap = new ArrayList<Map<String, Object>>();
        }
        return JSONResponse.toAppResultFormat(0, listMap);
    }

    /**
     * why3.4 app查询推荐的活动
     *
     * @param pageApp 分页对象
     * @return
     */
    @Override
    public String queryRecommendCmsActivity(PaginationApp pageApp) {
        List<CmsActivity> activityList = cacheService.getLikeActivityList(CacheConstant.APP_RECOMMEND_ACTIVITY);
        if (CollectionUtils.isEmpty(activityList)) {
            final List<CmsActivity> list = activityMapper.queryAppRecommendCmsActivity();
            if (CollectionUtils.isNotEmpty(list)) {
                activityList = list;
                Runnable runner = new Runnable() {
                    @Override
                    public void run() {
                        Calendar calendar = Calendar.getInstance();
                        calendar.setTime(new Date());
                        //设置过期时间为当前时间之后的24小时
                        calendar.add(Calendar.HOUR_OF_DAY, 24);
                        cacheService.setLikeActivityList(CacheConstant.APP_RECOMMEND_ACTIVITY, list, calendar.getTime());
                    }
                };
                new Thread(runner).start();
            }
        }

        // 分页
        if (CollectionUtils.isNotEmpty(activityList)) {
            if (pageApp.getFirstResult() > activityList.size()) {
                activityList = new ArrayList<CmsActivity>();
            } else {
                if ((pageApp.getFirstResult() + pageApp.getRows()) > activityList.size()) {
                    activityList = activityList.subList(pageApp.getFirstResult(), activityList.size());
                } else {
                    activityList = activityList.subList(pageApp.getFirstResult(), pageApp.getFirstResult() + pageApp.getRows());
                }
            }
        }

        List<Map<String, Object>> listMap = this.getAppCmsActivityResult(activityList, staticServer, null, null, null, null, null);
        if (CollectionUtils.isEmpty(listMap)) {
            listMap = new ArrayList<Map<String, Object>>();
        }
        return JSONResponse.toAppResultFormat(0, listMap);
    }


    /**
     * app查询置顶标签的活动
     *
     * @param pageApp 分页对象
     * @return
     */
    @Override
    public String queryTopActivity(PaginationApp pageApp, String tagId) {
        Map<String, Object> map = new HashMap<String, Object>();
        if (StringUtils.isBlank(tagId)) {
            return JSONResponse.commonResultFormat(10107, "标签id缺失", null);
        }
        map.put("tagId", tagId);
        if (pageApp != null && pageApp.getFirstResult() != null && pageApp.getRows() != null) {
            map.put("firstResult", pageApp.getFirstResult());
            map.put("rows", pageApp.getRows());
        }
        List<CmsActivity> activityList = activityMapper.queryTopActivity(map);

        List<Map<String, Object>> listMap = new ArrayList<Map<String, Object>>();
        listMap = getAppActivityResult(activityList, staticServer, null, null, null, null, null);
        return JSONResponse.toAppResultFormat(0, listMap);
    }

    /**
     * why3.4 app查询置顶标签的活动
     *
     * @param pageApp 分页对象
     * @return
     */
    @Override
    public String queryTopCmsActivity(PaginationApp pageApp, final String tagId) {
        if (StringUtils.isBlank(tagId)) {
            return JSONResponse.commonResultFormat(10107, "标签id缺失", null);
        }

        List<CmsActivity> activityList = cacheService.getLikeActivityList(CacheConstant.APP_TOP_ACTIVITY + tagId);
        if (CollectionUtils.isEmpty(activityList)) {
            Map<String, Object> map = new HashMap<String, Object>();
            map.put("tagId", tagId);
            final List<CmsActivity> list = activityMapper.queryAppTopCmsActivity(map);
            if (CollectionUtils.isNotEmpty(list)) {
                activityList = list;
                Runnable runner = new Runnable() {
                    @Override
                    public void run() {
                        Calendar calendar = Calendar.getInstance();
                        calendar.setTime(new Date());
                        //设置过期时间为当前时间之后的24小时
                        calendar.add(Calendar.HOUR_OF_DAY, 24);
                        cacheService.setLikeActivityList(CacheConstant.APP_TOP_ACTIVITY + tagId, list, calendar.getTime());
                    }
                };
                new Thread(runner).start();
            }
        }

        // 分页
        if (CollectionUtils.isNotEmpty(activityList)) {
            if (pageApp.getFirstResult() > activityList.size()) {
                activityList = new ArrayList<CmsActivity>();
            } else {
                if ((pageApp.getFirstResult() + pageApp.getRows()) > activityList.size()) {
                    activityList = activityList.subList(pageApp.getFirstResult(), activityList.size());
                } else {
                    activityList = activityList.subList(pageApp.getFirstResult(), pageApp.getFirstResult() + pageApp.getRows());
                }
            }
        }

        List<Map<String, Object>> listMap = this.getAppCmsActivityResult(activityList, staticServer, null, null, null, null, null);
        if (CollectionUtils.isEmpty(listMap)) {
            listMap = new ArrayList<Map<String, Object>>();
        }
        return JSONResponse.toAppResultFormat(0, listMap);
    }


    @Override
    public String queryAppIndexData(List<String> dataList, String lon, String lat) {
        Map<String, Object> paramMap = new HashMap<String, Object>();
        if (StringUtils.isNotBlank(lon) && StringUtils.isNotBlank(lat)) {
            paramMap.put("lon", lon);
            paramMap.put("lat", lat);
            paramMap.put("list", dataList);
        }
        List<AppIndexData> list = activityMapper.queryAppIndexData(paramMap);
        List<Map<String, Object>> listMap = new ArrayList<Map<String, Object>>();
        if (CollectionUtils.isNotEmpty(list)) {
            for (AppIndexData data : list) {
                Map<String, Object> map = new HashMap<String, Object>();
                map.put("activityId", data.getActivityId() != null ? data.getActivityId() : "");
                map.put("commentCount", data.getCommentCount() != null ? String.valueOf(data.getCommentCount()) : "0");
                map.put("scanCount", data.getScanCount() != null ? String.valueOf(data.getScanCount()) : "0");
                map.put("collectCount", data.getCollectCount() != null ? String.valueOf(data.getCollectCount()) : "0");
                map.put("ticketCount", data.getTicketCount() != null ? String.valueOf(data.getTicketCount()) : "0");
                if (StringUtils.isNotBlank(data.getSysId()) && "1".equals(data.getSysNo())) {
                    map.put("distance", 20 + (int) (Math.random() * 10000) % 10);
                } else {
                    map.put("distance", data.getDistance() != null ? String.valueOf(data.getDistance() / 1000) : "0");
                }
                listMap.add(map);
            }
        }
        return JSONResponse.toAppResultFormat(1, listMap);
    }

    /**
     * why3.4 app近期活动列表
     *
     * @param activityType
     * @param activityLocation
     * @param sortType
     * @param chooseType
     * @return
     */
    @Override
    public String queryNearActivityByCondition(PaginationApp pageApp, String activityType, String activityArea, String activityLocation,
                                               String sortType, String lon, String lat, String chooseType, String isWeekend, String bookType) {
        Map<String, Object> map = new HashMap<String, Object>();
        if (pageApp != null && pageApp.getFirstResult() != null && pageApp.getRows() != null) {
            map.put("firstResult", pageApp.getFirstResult());
            map.put("rows", pageApp.getRows());
        }
        if (StringUtils.isNotBlank(activityType)) {
            map.put("activityType", activityType.split(","));
        }
        if (StringUtils.isNotBlank(activityArea)) {
            map.put("activityArea", "%" + activityArea + ",%");
        }
        if (StringUtils.isNotBlank(activityLocation)) {
            map.put("activityLocation", activityLocation);
        }
        if (StringUtils.isNotBlank(lon) && StringUtils.isNotBlank(lat)) {
            map.put("lon", lon);
            map.put("lat", lat);
        } else {
            return JSONResponse.commonResultFormat(10107, "经纬度缺失", null);
        }
        if (StringUtils.isNotBlank(sortType)) {
            map.put("sortType", Integer.parseInt(sortType));
        }

        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm");
        if (StringUtils.isNotBlank(chooseType)) {
            map.put("chooseType", chooseType);
            if (Integer.parseInt(chooseType) == 1) {
                Calendar cal = Calendar.getInstance();
                map.put("startTime", format.format(cal.getTime()));
                cal.add(Calendar.DATE, 5);
                map.put("endTime", format.format(cal.getTime()));
                if (StringUtils.isNotBlank(isWeekend)) {
                    map.put("isWeekend", isWeekend);
                    Calendar ca = Calendar.getInstance();
                    map.put("list", this.getWeekendList(ca, isWeekend, 5));
                }
            } else if (Integer.parseInt(chooseType) == 2) {
                Calendar cal = Calendar.getInstance();
                cal.add(Calendar.DATE, 5);
                map.put("startTime", format.format(cal.getTime()));
                cal.add(Calendar.DATE, 5);
                map.put("endTime", format.format(cal.getTime()));
                if (StringUtils.isNotBlank(isWeekend)) {
                    map.put("isWeekend", isWeekend);
                    Calendar ca = Calendar.getInstance();
                    ca.add(Calendar.DATE, 5);
                    map.put("list", this.getWeekendList(ca, isWeekend, 5));
                }
            } else if (Integer.parseInt(chooseType) == 3) {
                Calendar cal = Calendar.getInstance();
                cal.add(Calendar.DATE, 10);
                map.put("startTime", format.format(cal.getTime()));
                cal.add(Calendar.DATE, 5);
                map.put("endTime", format.format(cal.getTime()));
                if (StringUtils.isNotBlank(isWeekend)) {
                    map.put("isWeekend", isWeekend);
                    Calendar ca = Calendar.getInstance();
                    ca.add(Calendar.DATE, 10);
                    map.put("list", this.getWeekendList(ca, isWeekend, 5));
                }
            } else if (Integer.parseInt(chooseType) == 4) {
                Calendar cal = Calendar.getInstance();
                cal.add(Calendar.DATE, 15);
                map.put("startTime", format.format(cal.getTime()));
                cal.add(Calendar.DATE, 16);
                map.put("endTime", format.format(cal.getTime()));
                if (StringUtils.isNotBlank(isWeekend)) {
                    map.put("isWeekend", isWeekend);
                    Calendar ca = Calendar.getInstance();
                    ca.add(Calendar.DATE, 15);
                    map.put("list", this.getWeekendList(ca, isWeekend, 16));
                }
            }
        } else {
            if (StringUtils.isNotBlank(isWeekend)) {
                map.put("isWeekend", isWeekend);
                Calendar cal = Calendar.getInstance();
                map.put("startTime", format.format(cal.getTime()));
                cal.add(Calendar.DATE, 31);
                map.put("endTime", format.format(cal.getTime()));
                Calendar ca = Calendar.getInstance();
                map.put("list", this.getWeekendList(ca, isWeekend, 31));
            }
        }

        if (StringUtils.isNotBlank(bookType)) {
            map.put("bookType", bookType);
        }

        List<CmsActivity> activityList = activityMapper.queryNearActivityByCondition(map);
        List<Map<String, Object>> listMap = this.getAppCmsActivityResult(activityList, staticServer, null, null, null, null, null);
        if (CollectionUtils.isEmpty(listMap)) {
            listMap = new ArrayList<Map<String, Object>>();
        }
        return JSONResponse.toAppResultFormat(1, listMap);
    }

    // 得到时间段内的日期
    private List<String> getWeekendList(Calendar ca, String isWeekend, int index) {
        List<String> list = new ArrayList<String>();
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        if (Integer.parseInt(isWeekend) == 1) {
            if ((ca.get(Calendar.DAY_OF_WEEK) - 1) == 0 || (ca.get(Calendar.DAY_OF_WEEK) - 1) == 6) {
                list.add(dateFormat.format(ca.getTime()));
            }
            for (int i = 0; i < index; i++) {
                ca.add(Calendar.DATE, 1);
                if ((ca.get(Calendar.DAY_OF_WEEK) - 1) == 0 || (ca.get(Calendar.DAY_OF_WEEK) - 1) == 6) {
                    list.add(dateFormat.format(ca.getTime()));
                }
            }
        } else if (Integer.parseInt(isWeekend) == 0) {
            if ((ca.get(Calendar.DAY_OF_WEEK) - 1) != 0 && (ca.get(Calendar.DAY_OF_WEEK) - 1) != 6) {
                list.add(dateFormat.format(ca.getTime()));
            }
            for (int i = 0; i < index; i++) {
                ca.add(Calendar.DATE, 1);
                if ((ca.get(Calendar.DAY_OF_WEEK) - 1) != 0 && (ca.get(Calendar.DAY_OF_WEEK) - 1) != 6) {
                    list.add(dateFormat.format(ca.getTime()));
                }
            }
        }
        return list;
    }

    /**
     * why3.5 app所有活动列表返回数据业务处理
     */
    private List<Map<String, Object>> getAppCmsActivityListResult(List<CmsActivity> activityList, StaticServer staticServer) {
        List<Map<String, Object>> listMap = new ArrayList<Map<String, Object>>();
        try {
            if (CollectionUtils.isNotEmpty(activityList)) {
                for (CmsActivity activity : activityList) {
                    Map<String, Object> mapActivity = new HashMap<String, Object>();
                    mapActivity.put("activityId", activity.getActivityId() != null ? activity.getActivityId() : "");
                    mapActivity.put("activityAddress", activity.getActivityAddress() != null ? activity.getActivityAddress() : "");
                    mapActivity.put("activityName", activity.getActivityName() != null ? activity.getActivityName() : "");
                    mapActivity.put("activitySubject", activity.getActivitySubject() != null ? activity.getActivitySubject() : "");
                    mapActivity.put("activitySite", activity.getActivitySite() != null ? activity.getActivitySite() : "");
                    mapActivity.put("activityPrice", activity.getActivityPrice() != null ? activity.getActivityPrice() : "");
                    mapActivity.put("activityIsFree", activity.getActivityIsFree() != null ? activity.getActivityIsFree() : 1);
                    mapActivity.put("activityStartTime", activity.getActivityStartTime() != null ? activity.getActivityStartTime() : "");
                    mapActivity.put("activityEndTime", activity.getActivityEndTime() != null ? activity.getActivityEndTime() : "");
                    mapActivity.put("tagId", activity.getTagId() != null ? activity.getTagId() : "");
                    mapActivity.put("tagName", activity.getTagName() != null ? activity.getTagName() : "");
                    mapActivity.put("activityUpdateTime", activity.getActivityUpdateTime() != null ? DateUtils.convertToSS(activity.getActivityUpdateTime()) : "");

                    if (activity.getActivityIsReservation() == 2) {
                        if (activity.getSpikeType() == 1) {
                            mapActivity.put("activitySubject", (StringUtils.isNotBlank(activity.getActivitySubject()) ? activity.getActivitySubject() + "." : "") + "抢票秒杀");
                        } else {
                            mapActivity.put("activitySubject", (StringUtils.isNotBlank(activity.getActivitySubject()) ? activity.getActivitySubject() + "." : "") + "在线预定");
                        }
                    } else {
                        mapActivity.put("activitySubject", (StringUtils.isNotBlank(activity.getActivitySubject()) ? activity.getActivitySubject() + "." : "") + "直接前往");
                    }

                    if (StringUtils.isNotBlank(activity.getVenueName())) {
                        mapActivity.put("activityLocationName", (StringUtils.isNotBlank(activity.getDictName()) ? activity.getDictName() + "." : "") +
                                activity.getVenueName());
                    } else {
                    	mapActivity.put("activityLocationName", (StringUtils.isNotBlank(activity.getDictName()) ? activity.getDictName() + "." : "") +
                                activity.getActivityAddress());
                    
                    }

                    String activityIconUrl = "";
                    if (StringUtils.isNotBlank(activity.getActivityIconUrl())) {
                        activityIconUrl = staticServer.getStaticServerUrl() + activity.getActivityIconUrl();
                    }
                    mapActivity.put("activityIconUrl", activityIconUrl);
                    //获取活动经纬度
                    double activityLon = 0d;
                    if (activity.getActivityLon() != null) {
                        activityLon = activity.getActivityLon();
                    }
                    double activityLat = 0d;
                    if (activity.getActivityLat() != null) {
                        activityLat = activity.getActivityLat();
                    }
                    double distance = 0d;
                    if (activity.getDistance() != null) {
                        distance = activity.getDistance();
                    }

                    mapActivity.put("activityLon", activityLon);
                    mapActivity.put("activityLat", activityLat);
                    if (StringUtils.isNotBlank(activity.getSysId()) && "1".equals(activity.getSysNo())) {
                        distance = 20 + (int) (Math.random() * 10000) % 10;
                        mapActivity.put("distance", distance);
                    } else {
                        mapActivity.put("distance", distance / 1000);
                    }

                    mapActivity.put("activityAbleCount", activity.getAvailableCount() != null ? activity.getAvailableCount() : "0");
                    //是否可预订 1：否 2：是
                    mapActivity.put("activityIsReservation", activity.getActivityIsReservation() != null ? activity.getActivityIsReservation() : 1);
                    mapActivity.put("activityArea", activity.getActivityArea() != null ? activity.getActivityArea() : "");
                    mapActivity.put("sysNo", activity.getSysNo() != null ? activity.getSysNo() : "");
                    mapActivity.put("sysId", activity.getSysId() != null ? activity.getSysId() : "");
                    // 判断是否是热
                    mapActivity.put("activityIsHot", (activity.getYearBrowseCount() != null && activity.getYearBrowseCount() > 500) ? 1 : 0);
                    mapActivity.put("activityRecommend", (StringUtils.isNotBlank(activity.getActivityRecommend()) && "Y".equals(activity.getActivityRecommend())) ? "Y" : "N");
                    mapActivity.put("activityIsCollect", activity.getCollectNum() != null ? (activity.getCollectNum() > 0 ? 1 : 0) : 0);
                    mapActivity.put("priceType", activity.getPriceType() != null ? activity.getPriceType() : "");
                    mapActivity.put("spikeType", activity.getSpikeType() != null ? activity.getSpikeType() : "");
                    listMap.add(mapActivity);
                }
            }
            return listMap;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return listMap;
    }

    /**
     * why3.5 app日历下每天活动场数
     *
     * @param startDate
     * @param endDate
     * @return
     */
    @Override
    public String queryEventDateActivityCount(String startDate, String endDate) throws Exception {
        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
        Calendar cal = Calendar.getInstance();
        cal.setTime(format.parse(startDate));
        Map<String, Object> resultMap = new HashMap<String, Object>();
        while (CompareTime.timeCompare1(startDate, endDate) <= 0) {
            Map<String, Object> map = new HashMap<String, Object>();
            map.put("everyDate", format.format(cal.getTime()));
            int count = activityMapper.queryAppEveryDateActivityCount(map);
            resultMap.put(format.format(cal.getTime()), count);
            cal.add(Calendar.DATE, 1);
            startDate = format.format(cal.getTime());
        }
        return JSONResponse.toAppResultFormat(1, resultMap);
    }

    /**
     * why3.5 app日历下某一天活动列表
     *
     * @param pageApp
     * @param everyDate
     * @param lon
     * @param lat
     * @return
     */
    @Override
    public String queryAppEveryDateActivityList(PaginationApp pageApp, String everyDate, String lon, String lat) {
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("everyDate", everyDate);
        if (pageApp != null && pageApp.getFirstResult() != null && pageApp.getRows() != null) {
            map.put("firstResult", pageApp.getFirstResult());
            map.put("rows", pageApp.getRows());
        }
        if (StringUtils.isNotBlank(lon) && StringUtils.isNotBlank(lat)) {
            map.put("lon", lon);
            map.put("lat", lat);
        }

        List<CmsActivity> activityList = activityMapper.queryAppEveryDateActivityList(map);
        List<Map<String, Object>> listMap = this.getAppCmsActivityListResult(activityList, staticServer);
        if (CollectionUtils.isEmpty(listMap)) {
            listMap = new ArrayList<Map<String, Object>>();
        }
        return JSONResponse.toAppResultFormat(1, listMap);
    }

    /**
     * why3.5 app附近活动列表
     *
     * @param pageApp
     * @param activityType
     * @param activityIsFree
     * @param activityIsReservation
     * @param sortType
     * @param lon
     * @param lat
     * @return
     */
    @Override
    public String queryAppNearActivityList(PaginationApp pageApp, String activityType, String activityIsFree, String activityIsReservation,
                                           String sortType, String lon, String lat) {
        Map<String, Object> map = new HashMap<String, Object>();
        if (pageApp != null && pageApp.getFirstResult() != null && pageApp.getRows() != null) {
            map.put("firstResult", pageApp.getFirstResult());
            map.put("rows", pageApp.getRows());
        }
        if (StringUtils.isNotBlank(lon) && StringUtils.isNotBlank(lat)) {
            map.put("lon", lon);
            map.put("lat", lat);
        }
        if (StringUtils.isNotBlank(activityType)) {
            map.put("activityType", activityType.split(","));
        }
        if (StringUtils.isNotBlank(activityIsFree)) {
            map.put("activityIsFree", Integer.parseInt(activityIsFree));
        }
        if (StringUtils.isNotBlank(activityIsReservation)) {
            map.put("activityIsReservation", Integer.parseInt(activityIsReservation));
        }
        if (StringUtils.isNotBlank(sortType)) {
            map.put("sortType", Integer.parseInt(sortType));
        }
        List<CmsActivity> activityList = activityMapper.queryAppNearActivityList(map);
        List<Map<String, Object>> listMap = this.getAppCmsActivityListResult(activityList, staticServer);
        if (CollectionUtils.isEmpty(listMap)) {
            listMap = new ArrayList<Map<String, Object>>();
        }
        return JSONResponse.toAppResultFormat(1, listMap);
    }

    /**
     * why3.5 app活动浏览量
     *
     * @param activityId
     * @return
     */
    @Override
    public String queryAppCmsActivityBrowseCount(String activityId) {
        CmsStatistics statistics = statisticService.queryStatistics(activityId, Constant.type2);
        if (null != statistics && null != statistics.getYearBrowseCount()) {
            return JSONResponse.toAppResultFormat(1, statistics.getYearBrowseCount());
        } else {
            return JSONResponse.toAppResultFormat(1, 0);
        }
    }

    /**
     * why3.5 app根据场馆id获取相关活动列表
     *
     * @param venueId 展馆id
     * @param pageApp 分页对象
     */
    @Override
    public String queryAppCmsActivityListById(String venueId, PaginationApp pageApp) {
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("venueId", venueId);
        //数据状态
        map.put("activityIsDel", Constant.NORMAL);
        map.put("activityState", Constant.PUBLISH);
        if (pageApp != null && pageApp.getFirstResult() != null && pageApp.getRows() != null) {
            map.put("firstResult", pageApp.getFirstResult());
            map.put("rows", pageApp.getRows());
        }

        int count = activityMapper.queryAppActivityCountById(map);
        List<Map<String, Object>> listMap = new ArrayList<Map<String, Object>>();
        try {
            List<CmsActivity> activityList = activityMapper.queryAppActivityListById(map);
            if (activityList != null && activityList.size() > 0) {
                String staticUrl = staticServer.getStaticServerUrl();
                for (CmsActivity activity : activityList) {
                    Map<String, Object> activityMap = new HashMap<String, Object>();
                    activityMap.put("activityId", activity.getActivityId() != null ? activity.getActivityId() : "");
                    activityMap.put("activityName", activity.getActivityName() != null ? activity.getActivityName() : "");//活动名称
                    activityMap.put("activityStartTime", activity.getActivityStartTime() != null ? activity.getActivityStartTime() : "");//活动开始时间
                    activityMap.put("activityEndTime", activity.getActivityEndTime() != null ? activity.getActivityEndTime() : "");//活动结束时间
                    activityMap.put("activityIsHot", (activity.getYearBrowseCount() != null && activity.getYearBrowseCount() > 500) ? 1 : 0);//活动是否热门
                    activityMap.put("activityIconUrl", staticUrl + activity.getActivityIconUrl());//图片路径
                    activityMap.put("activityAbleCount", activity.getAvailableCount());//剩余票数
                    activityMap.put("activityPrice", activity.getActivityPrice() != null ? activity.getActivityPrice() : "");
                    activityMap.put("activityIsFree", activity.getActivityIsFree() != null ? activity.getActivityIsFree() : "");
                    activityMap.put("sysNo", activity.getSysNo() != null ? activity.getSysNo() : "");
                    activityMap.put("sysId", activity.getSysId() != null ? activity.getSysId() : "");
                    if (activity.getActivityIsReservation() == 2) {
                        if (activity.getSpikeType() == 1) {
                            activityMap.put("activitySubject", (StringUtils.isNotBlank(activity.getActivitySubject()) ? activity.getActivitySubject() + "." : "") + "抢票秒杀");
                        } else {
                            activityMap.put("activitySubject", (StringUtils.isNotBlank(activity.getActivitySubject()) ? activity.getActivitySubject() + "." : "") + "在线预定");
                        }
                    } else {
                        activityMap.put("activitySubject", (StringUtils.isNotBlank(activity.getActivitySubject()) ? activity.getActivitySubject() + "." : "") + "直接前往");
                    }
                    //是否可预订 1：否 2：是
                    activityMap.put("activityIsReservation", activity.getActivityIsReservation() != null ? activity.getActivityIsReservation() : "");
                    activityMap.put("tagName", activity.getTagName() != null ? activity.getTagName() : "");
                    activityMap.put("activityUpdateTime", activity.getActivityUpdateTime() != null ? DateUtils.convertToSS(activity.getActivityUpdateTime()) : "");
                    activityMap.put("activityRecommend", (StringUtils.isNotBlank(activity.getActivityRecommend()) && "Y".equals(activity.getActivityRecommend())) ? "Y" : "N");
                    activityMap.put("priceType", activity.getPriceType() != null ? activity.getPriceType() : "");
                    activityMap.put("spikeType", activity.getSpikeType() != null ? activity.getSpikeType() : "");
                    listMap.add(activityMap);
                }
            }
        } catch (Exception e) {
            logger.error("app根据展馆id获取活动列表出错!", e);
        }
        return JSONResponse.toAppActivityResultFormat(0, listMap, count);
    }

    /**
     * why3.5 app根据不同条件筛选活动列表(搜索功能)
     *
     * @param activityArea
     * @param activityType
     * @param activityName
     * @param pageApp
     * @param lon
     * @param lat
     * @return
     */
    @Override
    public String queryAppCmsActivityListByCondition(String activityArea, String activityType, String activityName, PaginationApp pageApp, String lon, String lat) {
        List<Map<String, Object>> listMap = new ArrayList<Map<String, Object>>();
        Map map = new HashMap();
        map.put("lat", lat);
        map.put("lon", lon);
        try {
            //区县代码
            if (StringUtils.isNotBlank(activityArea)) {
                map.put("activityArea", activityArea + ",%");
            }
            //类型
            if (StringUtils.isNotBlank(activityType)) {
                map.put("activityType", activityType.split(","));
            }
            //活动名称模糊查询
            if (StringUtils.isNotBlank(activityName)) {
                map.put("activityName", "%/" + activityName + "%");
            }
            if (pageApp != null && pageApp.getFirstResult() != null && pageApp.getRows() != null) {
                map.put("firstResult", pageApp.getFirstResult());
                map.put("rows", pageApp.getRows());
                int total = activityMapper.queryAppCmsActivityListCount(map);
                pageApp.setTotal(total);
            }
            List<CmsActivity> activityList = activityMapper.queryAppCmsActivityListByCondition(map);
            listMap = this.getAppCmsActivityListResult(activityList, staticServer);
        } catch (Exception e) {
            e.printStackTrace();
            logger.error("query activityList error" + e.getMessage());
        }
        return JSONResponse.toAppActivityResultFormat(0, listMap, pageApp.getTotal());
    }

    /**
     * why3.5 app查询推荐的活动
     *
     * @param pageApp 分页对象
     * @return
     */
    @Override
    public String queryRecommendActivityList(PaginationApp pageApp) {
        /*List<CmsActivity> activityList =  cacheService.getLikeActivityList(CacheConstant.APP_RECOMMEND_CMS_ACTIVITY);
        if(CollectionUtils.isEmpty(activityList)){
            final List<CmsActivity> list = activityMapper.queryAppRecommendActivityList();
            if(CollectionUtils.isNotEmpty(list)){
                activityList = list;
                Runnable runner = new Runnable() {
                    @Override
                    public void run() {
                        Calendar calendar = Calendar.getInstance();
                        calendar.setTime(new Date());
                        //设置过期时间为当前时间之后的24小时
                        calendar.add(Calendar.HOUR_OF_DAY, 24);
                        cacheService.setLikeActivityList(CacheConstant.APP_RECOMMEND_CMS_ACTIVITY, list, calendar.getTime());
                    }
                };
                new Thread(runner).start();
            }
        }

        // 分页
        if(CollectionUtils.isNotEmpty(activityList)){
            if(pageApp.getFirstResult() > activityList.size()){
                activityList = new ArrayList<CmsActivity>();
            }else{
                if((pageApp.getFirstResult() + pageApp.getRows()) > activityList.size()){
                    activityList = activityList.subList(pageApp.getFirstResult(), activityList.size());
                }else{
                    activityList = activityList.subList(pageApp.getFirstResult(), pageApp.getFirstResult() + pageApp.getRows());
                }
            }
        }*/
        Map<String, Object> map = new HashMap<String, Object>();
        if (pageApp != null && pageApp.getFirstResult() != null && pageApp.getRows() != null) {
            map.put("firstResult", pageApp.getFirstResult());
            map.put("rows", pageApp.getRows());
        }
        List<CmsActivity> list = activityMapper.queryAppRecommendActivityList(map);
        List<Map<String, Object>> listMap = this.getAppCmsActivityListResult(list, staticServer);
        if (CollectionUtils.isEmpty(listMap)) {
            listMap = new ArrayList<Map<String, Object>>();
        }
        return JSONResponse.toAppResultFormat(0, listMap);
    }

    /**
     * why3.5 app查询推荐的活动（带筛选）
     *
     * @param pageApp 分页对象
     * @return
     */
    @Override
    public String queryFilterActivityList(PaginationApp pageApp, String activityArea,
                                          String activityLocation, String activityIsFree, String activityIsReservation, String sortType) {

        Map<String, Object> map = new HashMap<String, Object>();
        if (pageApp != null && pageApp.getFirstResult() != null && pageApp.getRows() != null) {
            map.put("firstResult", pageApp.getFirstResult());
            map.put("rows", pageApp.getRows());
        }
        if (StringUtils.isNotBlank(activityArea)) {
            map.put("activityArea", activityArea + "%");
        }
        if (StringUtils.isNotBlank(activityLocation)) {
            map.put("activityLocation", activityLocation);
        }
        if (StringUtils.isNotBlank(activityIsFree)) {
            map.put("activityIsFree", Integer.parseInt(activityIsFree));
        }
        if (StringUtils.isNotBlank(activityIsReservation)) {
            map.put("activityIsReservation", Integer.parseInt(activityIsReservation));
        }
        if (StringUtils.isNotBlank(sortType)) {
            map.put("sortType", Integer.parseInt(sortType));
        }
        List<CmsActivity> list = activityMapper.queryFilterActivityList(map);
        List<Map<String, Object>> listMap = this.getAppCmsActivityListResult(list, staticServer);
        if (CollectionUtils.isEmpty(listMap)) {
            listMap = new ArrayList<Map<String, Object>>();
        }
        return JSONResponse.toAppResultFormat(0, listMap);
    }

    /**
     * why3.5 app查询置顶标签的活动
     *
     * @param pageApp 分页对象
     * @return
     */
    @Override
    public String queryTopActivityList(PaginationApp pageApp, final String tagId, String activityArea,
                                       String activityLocation, String activityIsFree, String activityIsReservation, String sortType) {
        if (StringUtils.isBlank(tagId)) {
            return JSONResponse.commonResultFormat(10107, "标签id缺失", null);
        }

        /*List<CmsActivity> activityList =  cacheService.getLikeActivityList(CacheConstant.APP_TOP_CMS_ACTIVITY + tagId);
        if(CollectionUtils.isEmpty(activityList)){
            Map<String, Object> map = new HashMap<String, Object>();
            map.put("tagId", tagId);
            final List<CmsActivity> list = activityMapper.queryAppTopActivityList(map);
            if(CollectionUtils.isNotEmpty(list)){
                activityList = list;
                Runnable runner = new Runnable() {
                    @Override
                    public void run() {
                        Calendar calendar = Calendar.getInstance();
                        calendar.setTime(new Date());
                        //设置过期时间为当前时间之后的24小时
                        calendar.add(Calendar.HOUR_OF_DAY, 24);
                        cacheService.setLikeActivityList(CacheConstant.APP_TOP_CMS_ACTIVITY + tagId, list, calendar.getTime());
                    }
                };
                new Thread(runner).start();
            }
        }

        // 分页
        if(CollectionUtils.isNotEmpty(activityList)){
            if(pageApp.getFirstResult() > activityList.size()){
                activityList = new ArrayList<CmsActivity>();
            }else{
                if((pageApp.getFirstResult() + pageApp.getRows()) > activityList.size()){
                    activityList = activityList.subList(pageApp.getFirstResult(), activityList.size());
                }else{
                    activityList = activityList.subList(pageApp.getFirstResult(), pageApp.getFirstResult() + pageApp.getRows());
                }
            }
        }*/

        Map<String, Object> map = new HashMap<String, Object>();
        if (pageApp != null && pageApp.getFirstResult() != null && pageApp.getRows() != null) {
            map.put("firstResult", pageApp.getFirstResult());
            map.put("rows", pageApp.getRows());
        }
        if (StringUtils.isNotBlank(activityArea)) {
            map.put("activityArea", activityArea + "%");
        }
        if (StringUtils.isNotBlank(activityLocation)) {
            map.put("activityLocation", activityLocation);
        }
        if (StringUtils.isNotBlank(activityIsFree)) {
            map.put("activityIsFree", Integer.parseInt(activityIsFree));
        }
        if (StringUtils.isNotBlank(activityIsReservation)) {
            map.put("activityIsReservation", Integer.parseInt(activityIsReservation));
        }
        if (StringUtils.isNotBlank(sortType)) {
            map.put("sortType", Integer.parseInt(sortType));
        }
        map.put("tagId", tagId);
        List<CmsActivity> list = activityMapper.queryAppTopActivityList(map);
        List<Map<String, Object>> listMap = this.getAppCmsActivityListResult(list, staticServer);
        if (CollectionUtils.isEmpty(listMap)) {
            listMap = new ArrayList<Map<String, Object>>();
        }
        return JSONResponse.toAppResultFormat(0, listMap);
    }

    /**
     * why3.5 app日历下时间段活动场数
     *
     * @param startDate
     * @param endDate
     * @return
     */
    @Override
    public String queryAppDatePartActivityCount(String startDate, String endDate) {
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("startDate", startDate);
        map.put("endDate", endDate);
        int count = activityMapper.queryAppDatePartActivityCount(map);
        return JSONResponse.toAppResultFormat(100, count);
    }

    /**
     * why3.5 app根据不同条件查询月、周下活动列表
     *
     * @param startDate
     * @param endDate
     * @param activityArea
     * @param activityLocation      区域商圈id
     * @param activityType
     * @param activityIsFree        是否收费 1-免费 2-收费
     * @param activityIsReservation 是否预定 1-不可预定 2-可预定
     * @param userId
     * @param pageApp
     * @param type                  (默认不传值，"month"：查询月开始活动)
     * @return
     */
    @Override
    public String queryAppActivityCalendarList(PaginationApp pageApp, String startDate, String endDate, String activityArea, String activityLocation,
                                               String activityType, String activityIsFree, String activityIsReservation, String userId, String type) {
        Map<String, Object> map = new HashMap<String, Object>();
        if (pageApp != null && pageApp.getFirstResult() != null && pageApp.getRows() != null) {
            map.put("firstResult", pageApp.getFirstResult());
            map.put("rows", pageApp.getRows());
        }
        map.put("startDate", startDate);
        map.put("endDate", endDate);
        if (StringUtils.isNotBlank(activityArea)) {
            map.put("activityArea", activityArea + "%");
        }
        if (StringUtils.isNotBlank(activityLocation)) {
            map.put("activityLocation", activityLocation);
        }
        if (StringUtils.isNotBlank(activityType)) {
            map.put("activityType", activityType);
        }
        if (StringUtils.isNotBlank(activityIsFree)) {
            map.put("activityIsFree", Integer.parseInt(activityIsFree));
        }
        if (StringUtils.isNotBlank(activityIsReservation)) {
            map.put("activityIsReservation", Integer.parseInt(activityIsReservation));
        }
        if (StringUtils.isNotBlank(userId)) {
            map.put("userId", userId);
        }
        if (StringUtils.isNotBlank(type)) {
            map.put("type", type);
        }
        List<CmsActivity> list = activityMapper.queryAppActivityCalendarList(map);
        List<Map<String, Object>> listMap = this.getAppCmsActivityListResult(list, staticServer);
        if (CollectionUtils.isEmpty(listMap)) {
            listMap = new ArrayList<Map<String, Object>>();
        }
        return JSONResponse.toAppResultFormat(100, listMap);
    }

    /**
     * why3.5 app我的活动日历（历史预定活动）列表
     *
     * @param pageApp
     * @param userId
     * @return
     */
    @Override
    public String queryAppHistoryActivityList(PaginationApp pageApp, String userId) {
        Map<String, Object> map = new HashMap<String, Object>();
        if (pageApp != null && pageApp.getFirstResult() != null && pageApp.getRows() != null) {
            map.put("firstResult", pageApp.getFirstResult());
            map.put("rows", pageApp.getRows());
        }
        map.put("userId", userId);
        List<CmsActivity> list = activityMapper.queryAppHistoryActivityList(map);

        List<Map<String, Object>> listMap = this.makeAppCmsActivityListResult(list, staticServer);
        if (CollectionUtils.isEmpty(listMap)) {
            listMap = new ArrayList<Map<String, Object>>();
        }
        return JSONResponse.toAppResultFormat(100, listMap);
    }

    /**
     * why3.5 app我的活动日历（月份预定活动及收藏）列表
     *
     * @param pageApp
     * @param userId
     * @return
     */
    @Override
    public String queryAppMonthActivityList(PaginationApp pageApp, String userId, String startDate, String endDate) {
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("userId", userId);
        map.put("startDate", startDate);
        map.put("endDate", endDate);
        List<CmsActivity> list = activityMapper.queryAppMonthActivityList(map);

        List<CmsActivity> activityList = new ArrayList<CmsActivity>();
        // 去除重复（订单中有的活动，收藏中就不显示）
        Set<String> set = new HashSet<String>();
        for (CmsActivity activity : list) {
            // 去除重复（订单中有的活动，收藏中就不显示）
            if (activity.getOrderOrCollect() == 2) {
                if (set.add(activity.getActivityId())) {
                    activityList.add(activity);
                }
            } else {
                set.add(activity.getActivityId());
                activityList.add(activity);
            }
        }

        // 排序
        Collections.sort(activityList, new Comparator() {
            public int compare(Object a, Object b) {
                CmsActivity one = (CmsActivity) a;
                CmsActivity two = (CmsActivity) b;
                return one.getActivityEndTime().compareTo(two.getActivityEndTime());
            }
        });

        // 分页
        if (CollectionUtils.isNotEmpty(activityList)) {
            if (pageApp.getFirstResult() > activityList.size()) {
                activityList = new ArrayList<CmsActivity>();
            } else {
                if ((pageApp.getFirstResult() + pageApp.getRows()) > activityList.size()) {
                    activityList = activityList.subList(pageApp.getFirstResult(), activityList.size());
                } else {
                    activityList = activityList.subList(pageApp.getFirstResult(), pageApp.getFirstResult() + pageApp.getRows());
                }
            }
        } else {
            activityList = new ArrayList<CmsActivity>();
        }

        List<Map<String, Object>> listMap = this.makeAppCmsActivityListResult(activityList, staticServer);
        return JSONResponse.toAppResultFormat(100, listMap);
    }

    /**
     * why3.5 app所有活动列表返回数据业务处理(目前只有微网站日历功能使用)
     */
    private List<Map<String, Object>> makeAppCmsActivityListResult(List<CmsActivity> activityList, StaticServer staticServer) {
        List<Map<String, Object>> listMap = new ArrayList<Map<String, Object>>();
        try {
            if (CollectionUtils.isNotEmpty(activityList)) {
                for (CmsActivity activity : activityList) {
                    Map<String, Object> mapActivity = new HashMap<String, Object>();
                    mapActivity.put("orderOrCollect", activity.getOrderOrCollect() != null ? activity.getOrderOrCollect() : activity.getOrderOrCollect());
                    mapActivity.put("activityId", activity.getActivityId() != null ? activity.getActivityId() : "");
                    mapActivity.put("activityName", activity.getActivityName() != null ? activity.getActivityName() : "");
                    mapActivity.put("activitySite", activity.getActivitySite() != null ? activity.getActivitySite() : "");
                    if (StringUtils.isNotBlank(activity.getVenueName())) {
                        mapActivity.put("activityLocationName", (StringUtils.isNotBlank(activity.getDictName()) ? activity.getDictName() + "." : "") +
                                activity.getVenueName());
                    } else {
                     	mapActivity.put("activityLocationName", (StringUtils.isNotBlank(activity.getDictName()) ? activity.getDictName() + "." : "") +
                                activity.getActivityAddress());
                    }

                    mapActivity.put("activityIconUrl", StringUtils.isNotBlank(activity.getActivityIconUrl()) ?
                            staticServer.getStaticServerUrl() + activity.getActivityIconUrl() : "");
                    mapActivity.put("sysNo", activity.getSysNo() != null ? activity.getSysNo() : "");
                    mapActivity.put("sysId", activity.getSysId() != null ? activity.getSysId() : "");

                    String eventDateTime = "";
                    if (activity.getOrderOrCollect() == 1) {
                        if (StringUtils.isNotBlank(activity.getEventDateTimes())) {
                            String[] event = activity.getEventDateTimes().split(" ");
                            String[] date = event[0].split("-");
                            eventDateTime = date[1] + "." + date[2] + " " + event[1];
                        }
                    } else {
                        eventDateTime = StringUtils.isNotBlank(activity.getEventDateTimes()) ? activity.getEventDateTimes() : "";
                    }
                    mapActivity.put("eventDateTime", eventDateTime);

                    if (activity.getOrderOrCollect() == 2) {
                        mapActivity.put("activityIsCollect", activity.getCollectNum() != null ? (activity.getCollectNum() > 0 ? 1 : 0) : 0);
                    }
                    // 是否已预定 1-已预定 0-未预定 3-直接前往（收藏）
                    if (activity.getOrderOrCollect() == 2) {
                        if (activity.getActivityIsReservation() != null && activity.getActivityIsReservation() != 2) {
                            activity.setActivityIsReserved(3);
                        }
                    }
                    mapActivity.put("activityIsReserved", activity.getActivityIsReserved() != null ? activity.getActivityIsReserved() : "");
                    listMap.add(mapActivity);
                }
            }
            return listMap;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return listMap;
    }

    /**
     * why3.5 app活动场次列表
     *
     * @param activityId
     * @return
     */
    @Override
    public String queryActivityEventList(String activityId) {
        List<Map<String, Object>> listMap = new ArrayList<Map<String, Object>>();
        List<CmsActivityEvent> list = cmsActivityEventMapper.queryActivityEventList(activityId);
        try {
            if (CollectionUtils.isNotEmpty(list)) {
                for (CmsActivityEvent cmsActivityEvent : list) {
                    Map<String, Object> mapActivityEvent = new HashMap<String, Object>();
                    mapActivityEvent.put("eventId", cmsActivityEvent.getEventId());
                    mapActivityEvent.put("eventDate", cmsActivityEvent.getEventDate() != null ? cmsActivityEvent.getEventDate() : "");
                    mapActivityEvent.put("eventEndDate", cmsActivityEvent.getEventEndDate() != null ? cmsActivityEvent.getEventEndDate() : cmsActivityEvent.getEventDate());
                    mapActivityEvent.put("eventTime", cmsActivityEvent.getEventTime() != null ? cmsActivityEvent.getEventTime() : "");
                    mapActivityEvent.put("availableCount", cmsActivityEvent.getAvailableCount() != null ? cmsActivityEvent.getAvailableCount() : 0);
                    mapActivityEvent.put("singleEvent", cmsActivityEvent.getSingleEvent() != null ? cmsActivityEvent.getSingleEvent() : "");
                    mapActivityEvent.put("spikeType", cmsActivityEvent.getSpikeType() != null ? cmsActivityEvent.getSpikeType() : "");
                    mapActivityEvent.put("spikeTime", cmsActivityEvent.getSpikeTime() != null ? cmsActivityEvent.getSpikeTime().getTime() / 1000 : "");
                    mapActivityEvent.put("orderPrice", cmsActivityEvent.getOrderPrice() != null ? cmsActivityEvent.getOrderPrice() : "");
                    long spikeDifference = 0;
                    if (cmsActivityEvent.getSpikeTime() != null) {
                        spikeDifference = (cmsActivityEvent.getSpikeTime().getTime() - new Date().getTime()) / 1000;
                    }
                    mapActivityEvent.put("spikeDifference", spikeDifference >= 0 ? spikeDifference : 0);
                    listMap.add(mapActivityEvent);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return JSONResponse.toAppResultFormat(200, listMap);
    }
}