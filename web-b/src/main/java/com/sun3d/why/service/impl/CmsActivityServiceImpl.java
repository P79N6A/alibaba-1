package com.sun3d.why.service.impl;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.sun3d.why.dao.*;
import com.sun3d.why.model.*;
import com.sun3d.why.model.extmodel.BookActivitySeatInfo;
import com.sun3d.why.model.temp.ActivityForCompare;
import com.sun3d.why.service.*;
import com.sun3d.why.util.*;
import com.sun3d.why.util.redis.ListTranscoder;
import com.sun3d.why.webservice.api.model.CmsApiOrder;
import com.sun3d.why.webservice.api.service.CmsApiService;
import com.sun3d.why.webservice.api.util.CmsApiOtherServer;
import com.sun3d.why.webservice.api.util.HttpClientConnection;
import com.sun3d.why.webservice.api.util.HttpResponseText;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;


@Transactional(rollbackFor = Exception.class)
@Service
public class CmsActivityServiceImpl implements CmsActivityService {

    @Autowired
    private CmsActivityMapper activityMapper;

    @Autowired
    private CmsActivityVenueRelevanceMapper relevanceMapper;

    @Autowired
    private CmsActivityVenueRelevanceMapper venueRelevanceMapper;

    @Autowired
    private CmsUserService cmsUserService;

    @Autowired
    private CmsVenueMapper cmsVenueMapper;

    @Autowired
    private CmsStatisticsMapper cmsStatisticsMapper;

    @Autowired
    private CacheService cacheService;

    @Autowired
    private CmsActivitySeatService cmsActivitySeatService;

    @Autowired
    private CmsRecommendService cmsRecommendService;

    @Autowired
    private CmsActivityEventService cmsActivityEventService;

    @Autowired
    private CmsActivityOrderMapper cmsActivityOrderMapper;

    @Autowired
    private SysShareDeptService sysShareDeptService;

    @Autowired
    private CmsApiService cmsApiService;

    @Autowired
    private CmsApiOtherServer cmsApiOtherServer;

    @Autowired
    private CmsUserWantgoMapper cmsUserWantgoMapper;

    @Autowired
    private CmsTerminalUserMapper userMapper;

    @Autowired
    private UserAddressMapper userAddressMapper;

    private Logger logger = Logger.getLogger(CmsActivityServiceImpl.class);

    @Autowired
    private CmsTagService cmsTagService;

    @Autowired
    private RecommendRelatedService recommendRelatedService;

    @Autowired
    private SysUserMapper sysUserMapper;

    @Autowired
    private CmsActivitySeatMapper cmsActivitySeatMapper;

    @Autowired
    private CmsActivityOrderService cmsActivityOrderService;

    @Autowired
    private CmsUserMessageService userMessageService;

    @Autowired
    private CmsActivityOrderDetailMapper cmsActivityOrderDetailMapper;


    @Override
    public boolean queryActivityNameIsExists(String activityName) {

        if (StringUtils.isNotBlank(activityName)) {
            return activityMapper.queryActivityNameIsExists(activityName) > 0;
        }
        return false;
    }

    @Override
    public boolean updateActivityDelStatus(String id, Integer status) {
        if (StringUtils.isNotBlank(id)) {
            CmsActivity activity = new CmsActivity();
            activity.setActivityIsDel(status == null ? Constant.DELETE : status);
            activity.setActivityState(Constant.TRASH);
            activity.setActivityId(id);
            return activityMapper.editCmsActivity(activity) > 0;
        }
        return false;
    }


    @Override
    public boolean updateActivityPushStatus(String id, Integer status) {
        if (StringUtils.isNotBlank(id)) {
            CmsActivity activity = new CmsActivity();
            activity.setActivityIsDel(status == null ? Constant.PULL : status);
            activity.setActivityId(id);
            activity.setActivityUpdateTime(new Date());
            return activityMapper.editCmsActivity(activity) > 0;
        }
        return false;
    }


    @Override
    public boolean backActivityStatus(String id) {
        if (StringUtils.isNotBlank(id)) {
            CmsActivity activity = new CmsActivity();
            activity.setActivityIsDel(1);
            activity.setActivityState(1);
            activity.setActivityId(id);
            return activityMapper.editCmsActivity(activity) > 0;
        }
        return false;
    }

    @Override
    public boolean backActivityAPI(String id, String sysNo) {
        if (StringUtils.isNotBlank(id)) {
            if ("1".equals(sysNo)) {
                CmsActivity activity = new CmsActivity();
                activity.setActivityIsDel(1);
                activity.setActivityState(1);
                activity.setActivityId(id);
                return activityMapper.editCmsActivity(activity) > 0;
            } else {
                CmsActivity activity = new CmsActivity();
                activity.setActivityIsDel(1);
                activity.setActivityState(6);
                activity.setActivityId(id);
                return activityMapper.editCmsActivity(activity) > 0;
            }
        }
        return false;
    }

    @Override
    public CmsActivity queryCmsActivityByActivityId(String activityId) {
        return activityMapper.queryCmsActivityByActivityId(activityId);
    }

    @Override
    public int queryOrderCountByActivityId(String activityId) {
        int orderCount = activityMapper.queryOrderCountByActivityId(activityId);
        return orderCount;
    }


    /**
     * 前台热点推荐活动收藏数量
     *
     * @param map
     * @param page
     * @return
     */
    public List<Map> frontRecommendActivityCollectNum(Map map, Pagination page) {
        //分页
        if (page != null && page.getFirstResult() != null && page.getRows() != null) {
            map.put("firstResult", page.getFirstResult());
            map.put("rows", page.getRows());
        }
        map.put("activityRecommend", "Y");
        map.put("activityIsDel", 1);
        map.put("activityState", 6);
        List<Map> activityList = activityMapper.frontRecommendActivityCollectNum(map);

        return activityList;
    }

    @Override
    public List<CmsActivity> queryRecommendActivityList(Map map, Pagination page) {
        //分页
        if (page != null && page.getFirstResult() != null && page.getRows() != null) {
            map.put("firstResult", page.getFirstResult());
            map.put("rows", page.getRows());
        }
        map.put("activityRecommend", "Y");
        map.put("activityIsDel", 1);
        map.put("activityState", 6);
        List<CmsActivity> activityList = activityMapper.queryRecommendActivityList(map);

        return activityList;
    }


    /**
     * 得到需要生成的场次信息
     * 如 2015-10-17 08:00-09:00
     * 2015-10-17 13:00-15:00
     * 2015-10-18 08:00-09:00
     * 2015-10-19 13:00-15:00 这类信息
     *
     * @param cmsActivity
     * @param eventTimes
     * @return
     */
    public List<String> getEventTimeList(CmsActivity cmsActivity, List<String> eventTimes) {
        Calendar ca = Calendar.getInstance();
        List<String> dayList = new Vector<String>();
        try {
            Date activityEndTime = null;
            String cmsActivityStartTime = cmsActivity.getActivityStartTime();
            String cmsActivityEndTime = cmsActivity.getActivityEndTime();
            SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
            Date activityStartTime = df.parse(cmsActivityStartTime);
            if (cmsActivity.getActivityEndTime() != "" && StringUtils.isNotBlank(cmsActivity.getActivityEndTime())) {
                activityEndTime = df.parse(cmsActivityEndTime);
                //比较两个日期相隔多少天
                while (activityStartTime.compareTo(activityEndTime) <= 0) {
                    ca.setTime(activityStartTime);
                    //得到年月日
                    String dateInfo = df.format(activityStartTime);
                    ca.setTime(activityStartTime);
                    ca.add(Calendar.DATE, 1);
                    activityStartTime = ca.getTime();
                    dayList.add(dateInfo);
                }
            }
            List<String> dateInfoList = new Vector<String>();
            if (eventTimes != null && eventTimes.size() > 0) {
                if (dayList != null && dayList.size() > 0) {
                    for (String dayInfo : dayList) {
                        for (String eventTime : eventTimes) {
                            String dateInfo = dayInfo + " " + eventTime;
                            dateInfoList.add(dateInfo);
                        }
                    }
                }
                return dateInfoList;
            } else {
                return null;
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            throw new RuntimeException(ex);
        }
    }


    @Override
    public String addActivity(final CmsActivity activity, final SysUser sysUser) {
        try {

            if (activity != null) {
                UserAddress address = new UserAddress();
                if (StringUtils.isNotBlank(activity.getAddressId())) {
                    address = userAddressMapper.selectAddressById(activity.getAddressId());
                    if (address.getActivityLon() != null) {
                        activity.setActivityLon(address.getActivityLon());
                    }
                    if (address.getActivityLat() != null) {
                        activity.setActivityLat(address.getActivityLat());
                    }
                } else {
                    if (activity.getActivityLon() == null) {
                        activity.setActivityLon((double) 0);
                    }
                    if (activity.getActivityLat() == null) {
                        activity.setActivityLat((double) 0);
                    }
                }

                if (activity.getActivityLon() == null) {
                    activity.setActivityLon((double) 0);
                }
                if (activity.getActivityLat() == null) {
                    activity.setActivityLat((double) 0);
                }
                if (StringUtils.isBlank(activity.getActivityId())) {
                    activity.setActivityId(UUIDUtils.createUUId());
                }
                activity.setActivityCreateTime(new Date());
                activity.setPublicTime(new Date());
                activity.setActivityUpdateTime(new Date());
                if(StringUtils.isNotBlank(activity.getActivityProvince()) && activity.getActivityProvince().equals("44,上海市")){
					activity.setActivityIsDel(Constant.NORMAL);
				}else{
					activity.setActivityIsDel(Constant.EXAMINE);
				}
                if (activity.getActivityState() == 6) {
                    activity.setPublicTime(new Date());
                }
                if (activity.getActivityPrice() == null || StringUtils.isBlank(activity.getActivityPrice()))
                    activity.setActivityPrice("0");
                if (StringUtils.isBlank(activity.getActivityProvince())) {
                    activity.setActivityProvince(sysUser.getUserProvince());
                }
                if (StringUtils.isBlank(activity.getActivityCity())) {
                    activity.setActivityCity(sysUser.getUserCity());
                }
                if (StringUtils.isBlank(activity.getActivityArea())) {
                    activity.setActivityArea(sysUser.getUserCounty());
                }
                if (activity.getCreateActivityCode() != null) {
                    if (activity.getCreateActivityCode() == 1) {
                        activity.setActivityArea("45,上海市");
                    }
                }
                if (sysUser != null) {
                    activity.setActivityCreateUser(sysUser.getUserId());
                    activity.setActivityUpdateUser(sysUser.getUserId());
                    //保存活动场馆权限
                    if (StringUtils.isNotBlank(activity.getVenueId())) {
                        CmsVenue venue = cmsVenueMapper.queryVenueById(activity.getVenueId());
                        if(venue!=null){
                            activity.setActivityDept(venue.getVenueDept());
                        }
                    }else{
                        activity.setActivityDept(sysUser.getUserDeptPath());
                    }
                }
                Integer activityIsReservation = activity.getActivityIsReservation() != null ? activity.getActivityIsReservation() : 1;
              	if (activityIsReservation == 1) {
					activity.setActivitySalesOnline("N");
					activity.setActivityIsReservation(1);
					activity.setActivitySupplementType(1);
				} else if (activityIsReservation == 2) {
					activity.setActivityIsReservation(2);
					activity.setActivitySalesOnline("Y");
				} else if (activityIsReservation == 3) {
					activity.setActivityIsReservation(2);
					activity.setActivitySalesOnline("N");
				}else if (activityIsReservation == 4) {
                    activity.setActivityIsReservation(1);
                    activity.setActivitySalesOnline("N");
                    activity.setActivitySupplementType(2);
                }else if (activityIsReservation == 5) {
                    activity.setActivityIsReservation(1);
                    activity.setActivitySalesOnline("N");
                    activity.setActivitySupplementType(3);
                }
                activity.setEventCount(activity.getActivityReservationCount());


                //保存活动场馆关联关系
                if (StringUtils.isNotBlank(activity.getVenueId())) {
                    CmsActivityVenueRelevance relevance = new CmsActivityVenueRelevance();
                    relevance.setActivityId(activity.getActivityId());
                    relevance.setVenueId(activity.getVenueId());
                    relevanceMapper.addActivityVenueRelevance(relevance);
                }
                String eventDate[] = activity.getEventDate().split(",");
                String eventTime[] = activity.getEventTime().split(",");
                String spikeTimes[] = null;
                if (StringUtils.isNotBlank(activity.getSpikeTimes())) {
                    spikeTimes = activity.getSpikeTimes().split(",");
                }
                String availableCount[] = null;
                if (StringUtils.isNotBlank(activity.getAvaliableCount())) {
                    availableCount = activity.getAvaliableCount().split(",");
                }
                
               
                
                
                
                
                
                String orderPrice[] = activity.getOrderPrice().split(",");
                String seatId[] = null;
                if (StringUtils.isNotBlank(activity.getSeatIds())) {
                    seatId = activity.getSeatIds().split(";");
                }
                if (activity.getActivityIsReservation() != 1) {
                    for (int i = 0; i < eventDate.length; i++) {
                        CmsActivityEvent activityEvent = new CmsActivityEvent();
                        activityEvent.setEventId(UUIDUtils.createUUId());
                        activityEvent.setActivityId(activity.getActivityId());
                        activityEvent.setEventDate(eventDate[i]);
                        activityEvent.setSingleEvent(activity.getSingleEvent());
                        if (activity.getSingleEvent() == 1) {
                            activityEvent.setEventDateTime(activity.getActivityEndTime() + " " + eventTime[i]);
                            activityEvent.setEventEndDate(activity.getActivityEndTime());
                        } else {
                            activityEvent.setEventDateTime(eventDate[i] + " " + eventTime[i]);
                            activityEvent.setEventEndDate(eventDate[i]);
                        }
                        if (StringUtils.isBlank(activity.getEndTimePoint())) {
                            activity.setEndTimePoint(activityEvent.getEventDateTime());
                        } else if (activityEvent.getEventDateTime().compareTo(activity.getEndTimePoint()) > 1) {
                            activity.setEndTimePoint(activityEvent.getEventDateTime());
                        }
                        activityEvent.setEventTime(eventTime[i]);
                        if(activity.getSpikeType()!=null&&activity.getSpikeType()!=0){
                        	  activityEvent.setSpikeType(activity.getSpikeType());
                              if (StringUtils.isNotBlank(activity.getSpikeTimes())) {
                                  activityEvent.setSpikeTime(new SimpleDateFormat("yyyy-MM-dd HH:mm").parse(spikeTimes[i]));
                              }
                        }
                      
                        if (activity.getActivityIsFree() == 2) {
                            activityEvent.setOrderPrice(orderPrice[i]);
                        }
                        if (activity.getActivityIsFree() == 3) {
                            activityEvent.setOrderPrice(String.valueOf(activity.getActivityPayPrice()));
                        }
                        
                        
                        
                        if (StringUtils.isNotBlank(availableCount[i])) {
                            activityEvent.setAvailableCount(Integer.parseInt(availableCount[i]));
                            activity.setEventCount(Integer.parseInt(availableCount[i]));
                        } else {
                            activityEvent.setAvailableCount(Integer.parseInt(activity.getAvaliableCount()));
                            activity.setEventCount(Integer.parseInt(activity.getAvaliableCount()));
                        }
                        cmsActivityEventService.addActivityEvent(activityEvent);
                        if (activity.getSingleEvent() == 0) {
                            if (StringUtils.isNotBlank(activity.getSeatIds())) {
                                activityEvent.setSeatIds(seatId[i]);
                                cmsActivitySeatService.addEventSeatInfo(activityEvent, sysUser);
                            }
                        } else {
                            if (i == 0 && StringUtils.isNotBlank(activity.getSeatIds())) {
                                activityEvent.setSeatIds(seatId[i]);
                                cmsActivitySeatService.addEventSeatInfo(activityEvent, sysUser);
                            }
                        }
                    }
                } else {
                    CmsActivityEvent activityEvent = new CmsActivityEvent();
                    activityEvent.setEventId(UUIDUtils.createUUId());
                    activityEvent.setActivityId(activity.getActivityId());
                    activityEvent.setEventDate(activity.getActivityStartTime());
                    activityEvent.setEventTime(activity.getActivityTime());
                    activityEvent.setEventEndDate(activity.getActivityEndTime());
                    activityEvent.setEventDateTime(activity.getActivityEndTime() + " " + activity.getActivityTime());
                    activity.setEndTimePoint(activity.getActivityEndTime() + " " + activity.getActivityTime());
                    activityEvent.setOrderPrice(String.valueOf(activity.getActivityPayPrice()));
                    cmsActivityEventService.addActivityEvent(activityEvent);
                }
            }
            
            
            
           
            activityMapper.addCmsActivity(activity);
        } catch (Exception e) {
            logger.error("addActivity error {}", e);
            e.printStackTrace();
            throw new RuntimeException();
        }
        return Constant.RESULT_STR_SUCCESS;
    }

    @Override
    public String deleteByActivityId(String id) {
        return activityMapper.deleteByActivityId(id) == 1 ? "success" : Constant.RESULT_STR_FAILURE;
    }


    @Override
    public String editAppNavigationRecommendActivity(CmsActivity activity, Pagination page, SysUser user) {
        Map<String, Object> map = new HashMap<String, Object>();
        if (activity != null) {
            if (StringUtils.isNotBlank(activity.getActivityTheme())) {
                map.put("activityTheme", "%" + activity.getActivityTheme() + "%");
                if (StringUtils.isNotBlank(activity.getActivityThemeTxt())) {
                    if ("免费看演出".equals(activity.getActivityThemeTxt())) {
                        //map.put("recommendColumnType", 1);
                    } else if ("孩子学艺术".equals(activity.getActivityThemeTxt())) {
                        //map.put("recommendColumnType", 2);
                    } else if ("周末去哪儿".equals(activity.getActivityThemeTxt())) {
                        //  map.put("recommendColumnType", 3);
                    }
                } else {
                    //map.put("recommendColumnType", 1);
                }
            } else {
                Map<String, Object> tagMap = new HashMap<String, Object>();
                tagMap.put("dictCode", Constant.ACTIVITY_THEME);
                tagMap.put("tagName", "免费看演出");
                String tagId = cmsTagService.queryTagIdByTagName(tagMap);
                if (StringUtils.isNotBlank(tagId)) {
                    map.put("activityTheme", "%" + tagId + "%");
                    // map.put("recommendColumnType", 1);
                }
            }

            if (StringUtils.isNotBlank(activity.getActivityArea())) {
                map.put("activityArea", activity.getActivityArea() + "%");
            }

            //分页
            if (page != null && page.getFirstResult() != null && page.getRows() != null) {
                map.put("firstResult", page.getFirstResult());
                map.put("rows", page.getRows());
            }
        }
        List<CmsActivity> activityList = activityMapper.queryAppRecommendCmsActivityByCondition(map);
        if (CollectionUtils.isNotEmpty(activityList) && activityList.size() == 3) {
            CmsActivity cmsActivity = activityList.get(2);
            if (StringUtils.isNotBlank(cmsActivity.getRecommendId())) {
                recommendRelatedService.deleteById(cmsActivity.getRecommendId());
            }
        }

        CmsRecommendRelated related = new CmsRecommendRelated();
        related.setRecommendId(UUIDUtils.createUUId());
        related.setRelatedId(activity.getActivityId());
        related.setRecommendType(1);
        related.setRecommendTime(new Date());
        related.setUpdateUserId(user.getUserId());
        related.setUpdateTime(new Date());
        related.setRecommendTarget(2);
        // related.setRecommendColumnType(map.get("recommendColumnType") == null ? 1 : Integer.parseInt(map.get("recommendColumnType").toString()));
        int count = recommendRelatedService.addRecommendRelated(related);
        if (count > 0) {
            return "success";
        }
        return "failure";
    }

    @Override
    public String editAppHomeNavigationRecommendActivity(String recommendId) {
        try {
            recommendRelatedService.deleteById(recommendId);
            return "success";
        } catch (Exception e) {
            return "failure";
        }
    }

    @Override
    public String editRecommendCmsActivity(String activityId) {
        CmsActivity activity = new CmsActivity();
        activity.setActivityId(activityId);
        activity.setActivityRecommendTime(null);
        int count = activityMapper.editRecommendCmsActivity(activity);
        if (count > 0) {
            return "success";
        }
        return "failure";
    }

    /**
     * 将首页最新的数据数据保存到内存中  减少数据库压力
     */
    public void setIndexListInfoToRedis() {

        Runnable runnable = new Runnable() {
            @Override
            public void run() {
                //将首页热点推荐保存至首页中
                Pagination page = new Pagination();
                page.setRows(10);
                // 热点推荐数据放至 内存中
                List<CmsActivity> cmsActivities = queryRecommendActivityList(new HashMap(), page);
                cacheService.setActivityList(Constant.RecommendActivityList, cmsActivities);
                //将首页最新活动放至内存中
                Pagination page2 = new Pagination();
                page2.setRows(15);
                List<CmsActivity> cmsActivities2 = null;
                try {

                    cmsActivities2 = queryFrontActivityList(new CmsActivity(), "", null, null, null, null, page2, null, null);
                } catch (Exception e) {
                    e.printStackTrace();
                    throw new RuntimeException(e);
                }
                //最新活动放至内存中
                cacheService.setActivityList(Constant.FrontNewestActivity, cmsActivities2);
            }
        };
        Thread thread = new Thread(runnable);
        thread.start();
    }

    /**
     * 根据活动对象查询活动列表信息
     *
     * @param cur     活动对象
     * @param
     * @param sysUser 用户对象
     * @return 活动列表信息
     */
    @Override
    public String editActivity(final CmsActivity cur, final SysUser sysUser, final String seatIds, final boolean hadOrder) {
        try {
            if (cur != null) {
                CmsActivity activity = queryCmsActivityByActivityId(cur.getActivityId());
                if (activity.getPublicTime() == null && cur.getActivityState() == 6) {
                    cur.setPublicTime(new Date());
                }
                Integer activityIsReservation = cur.getActivityIsReservation() != null ? cur.getActivityIsReservation() : 1;
                if (activityIsReservation == 1) {
                    cur.setActivitySalesOnline("N");
                    cur.setActivityIsReservation(1);
                    cur.setActivitySupplementType(1);
                } else if (activityIsReservation == 2) {
                    cur.setActivityIsReservation(2);
                    cur.setActivitySalesOnline("Y");
                } else if (activityIsReservation == 3) {
                    cur.setActivityIsReservation(2);
                    cur.setActivitySalesOnline("N");
                }else if (activityIsReservation == 4) {
					cur.setActivityIsReservation(1);
					cur.setActivitySalesOnline("N");
					cur.setActivitySupplementType(2);
                }else if (activityIsReservation == 5) {
                	cur.setActivityIsReservation(1);
                	cur.setActivitySalesOnline("N");
                	cur.setActivitySupplementType(3);
                }
//                //存在订单时该值不能修改
//                if (!hadOrder) {
//
//                    cur.setEventCount(cur.getActivityReservationCount());
//                } else {
//                    cur.setActivityReservationCount(activity.getActivityReservationCount());
//
//                }
                UserAddress address = new UserAddress();
                if (StringUtils.isNotBlank(cur.getAddressId())) {
                    address = userAddressMapper.selectAddressById(cur.getAddressId());
                    if (address.getActivityLon() != null) {
                        cur.setActivityLon(address.getActivityLon());
                    }
                    if (address.getActivityLat() != null) {
                        cur.setActivityLat(address.getActivityLat());
                    }
                } else {
                    if (cur.getActivityLon() == null) {
                        cur.setActivityLon((double) 0);
                    }
                    if (cur.getActivityLat() == null) {
                        cur.setActivityLat((double) 0);
                    }
                }
                if (activity != null && StringUtils.isNotBlank(activity.getActivityName())
                        && StringUtils.isNotBlank(cur.getActivityName()) && !activity.getActivityName().trim().equals(cur.getActivityName().trim()))
                    //验证活动名称
                    if (StringUtils.isNotBlank(cur.getActivityName())) {
                        boolean exists = queryActivityNameIsExists(cur.getActivityName().trim());
                        if (exists) {
                            return Constant.RESULT_STR_REPEAT;
                        }
                    }
            }
            if (sysUser != null && StringUtils.isNotBlank(sysUser.getUserId())) {
                cur.setActivityUpdateUser(sysUser.getUserId());
                cur.setActivityUpdateTime(new Date());
                //保存活动场馆权限
                if (StringUtils.isNotBlank(cur.getVenueId())) {
                    CmsVenue venue = cmsVenueMapper.queryVenueById(cur.getVenueId());
                    if(venue!=null){
                        cur.setActivityDept(venue.getVenueDept());
                    }
                }else{
                    cur.setActivityDept(sysUser.getUserDeptPath());
                }

            }
            if (cur.getCreateActivityCode() != null) {
                if (cur.getCreateActivityCode() == 1) {
                    cur.setActivityArea("45,上海市");
                }
            }

            //删除活动场馆原有关联关系
            relevanceMapper.deleteActivityVenueRelevance(cur.getActivityId());
            //保存活动场馆新的关联关系
            if (StringUtils.isNotBlank(cur.getVenueId()) && cur.getCreateActivityCode() == 0) {
                CmsActivityVenueRelevance relevance = new CmsActivityVenueRelevance();
                relevance.setActivityId(cur.getActivityId());
                relevance.setVenueId(cur.getVenueId());
                relevanceMapper.addActivityVenueRelevance(relevance);
            }
            if (!hadOrder) {
                cmsActivityEventService.deleteEventInfoByActivityId(cur.getActivityId());
//                cmsActivitySeatMapper.deleteByActivityId(cur.getActivityId());
                String eventDate[] = cur.getEventDate().split(",");
                String eventTimes[] = cur.getEventTime().split(",");
                String eventIds[] = null;
                if (StringUtils.isNotBlank(cur.getEventIds())) {
                    eventIds = cur.getEventIds().split(",");
                }
                String spikeTimes[] = null;
                if (StringUtils.isNotBlank(cur.getSpikeTimes())) {
                    spikeTimes = cur.getSpikeTimes().split(",");
                }
                String availableCount[] = null;
                if (StringUtils.isNotBlank(cur.getAvaliableCount())) {
                    availableCount = cur.getAvaliableCount().split(",");
                }
                String orderPrice[] = cur.getOrderPrice().split(",");
                String seatId[] = null;
                if (StringUtils.isNotBlank(cur.getSeatIds())) {
                    seatId = cur.getSeatIds().split(";");
                }

                if (cur.getActivityIsReservation() != 1) {
                    for (int i = 0; i < eventDate.length; i++) {
                        CmsActivityEvent activityEvent = new CmsActivityEvent();
                        activityEvent.setEventId(UUIDUtils.createUUId());
                        activityEvent.setActivityId(cur.getActivityId());
                        activityEvent.setEventDate(eventDate[i]);
                        activityEvent.setSingleEvent(cur.getSingleEvent());
                        if (cur.getSingleEvent() == 1) {
                            activityEvent.setEventDateTime(cur.getActivityEndTime() + " " + eventTimes[i]);
                            activityEvent.setEventEndDate(cur.getActivityEndTime());
                        } else {
                            activityEvent.setEventDateTime(eventDate[i] + " " + eventTimes[i]);
                            activityEvent.setEventEndDate(eventDate[i]);
                        }
                        activityEvent.setEventTime(eventTimes[i]);
                        
                        if(cur.getSpikeType()!=null&&cur.getSpikeType()!=0){
                        	activityEvent.setSpikeType(cur.getSpikeType());
                            if (StringUtils.isNotBlank(cur.getSpikeTimes())) {
                                activityEvent.setSpikeTime(new SimpleDateFormat("yyyy-MM-dd HH:mm").parse(spikeTimes[i]));
                            }
                        }
                        
                        if (cur.getActivityIsFree() == 2) {
                            activityEvent.setOrderPrice(orderPrice[i]);
                        }
                        if (StringUtils.isNotBlank(availableCount[i])) {
                            activityEvent.setAvailableCount(Integer.parseInt(availableCount[i]));
                        } else {
                            activityEvent.setAvailableCount(Integer.parseInt(cur.getAvaliableCount()));
                        }
                        if (StringUtils.isBlank(cur.getEndTimePoint())) {
                            cur.setEndTimePoint(activityEvent.getEventDateTime());
                        } else if (activityEvent.getEventDateTime().compareTo(cur.getEndTimePoint()) > 1) {
                            cur.setEndTimePoint(activityEvent.getEventDateTime());
                        }
                        if(cur.getActivityIsFree() == 3)
                        {
                        	activityEvent.setOrderPrice(String.valueOf(cur.getActivityPayPrice()));
                        }
                        cmsActivityEventService.addActivityEvent(activityEvent);
                        if (cur.getSingleEvent() == 0) {
                            if (StringUtils.isNotBlank(cur.getSeatIds()) ) {
                                activityEvent.setSeatIds(seatId[i]);
                                if (i < eventIds.length) {
                                    cmsActivitySeatService.deleteByEventId(eventIds[i]);
                                }
                                cmsActivitySeatService.addEventSeatInfo(activityEvent, sysUser);
                            } else if (i < eventIds.length) {
                                Map map = new HashMap();
                                map.put("activityId", eventIds[i]);
                                map.put("eventId", activityEvent.getEventId());
                                cmsActivitySeatMapper.editEventSeat(map);
                            }
                        } else {
                            if (i == 0 && StringUtils.isNotBlank(cur.getSeatIds())) {
                                activityEvent.setSeatIds(seatId[i]);
                                cmsActivitySeatService.deleteByEventId(eventIds[0]);
                                cmsActivitySeatService.addEventSeatInfo(activityEvent, sysUser);
                            } else if (i == 0 && i < eventIds.length) {
                                Map map = new HashMap();
                                map.put("activityId", eventIds[i]);
                                map.put("eventId", activityEvent.getEventId());
                                cmsActivitySeatMapper.editEventSeat(map);
                            }
                        }
                    }
                } else {
                    CmsActivityEvent activityEvent = new CmsActivityEvent();
                    activityEvent.setEventId(UUIDUtils.createUUId());
                    activityEvent.setActivityId(cur.getActivityId());
                    activityEvent.setEventDate(cur.getActivityStartTime());
                    activityEvent.setEventTime(cur.getActivityTime());
                    activityEvent.setEventEndDate(cur.getActivityEndTime());
                    activityEvent.setEventDateTime(cur.getActivityEndTime() + " " + cur.getActivityTime());
                    activityEvent.setOrderPrice(String.valueOf(cur.getActivityPayPrice()));
                    cur.setEndTimePoint(activityEvent.getEventDateTime());
                    cmsActivityEventService.addActivityEvent(activityEvent);
                }
            }
            int count = activityMapper.editCmsActivity(cur);
            if (count <= 0) {
                return Constant.RESULT_STR_FAILURE;
            }
        } catch (Exception e) {
            logger.error("editActivity error {}", e);
            throw new RuntimeException(e);
           /* return Constant.RESULT_STR_FAILURE;*/
        }

        this.appActivitySetRedis();
        this.appActivityListSetRedis();
        return Constant.RESULT_STR_SUCCESS;
    }

    // why3.5 app首页推荐活动和首页标签活动存入redis by qww 2016-04-19
    @Override
    public void appActivitySetRedis() {
        Runnable runner = new Runnable() {
            @Override
            public void run() {
                // why3.4 app首页推荐活动存入redis
                List<CmsActivity> list = activityMapper.queryAppRecommendCmsActivity();
                if (CollectionUtils.isNotEmpty(list)) {
                    Calendar calendar = Calendar.getInstance();
                    calendar.setTime(new Date());
                    //设置过期时间为当前时间之后的24小时
                    calendar.add(Calendar.HOUR_OF_DAY, 24);
                    cacheService.setLikeActivityList(CacheConstant.APP_RECOMMEND_ACTIVITY, list, calendar.getTime());
                }

                // why3.4 app首页标签活动存入redis
                List<CmsActivity> activityList = activityMapper.queryActivityThemeByCode(Constant.ACTIVITY_TYPE);
                if (CollectionUtils.isNotEmpty(activityList)) {
                    Map<String, Object> map = new HashMap<String, Object>();
                    for (CmsActivity cmsActivity : activityList) {
                        map.put("tagId", cmsActivity.getTagId());
                        List<CmsActivity> cmsActivityList = activityMapper.queryAppTopCmsActivity(map);
                        if (CollectionUtils.isNotEmpty(cmsActivityList)) {
                            Calendar calendar = Calendar.getInstance();
                            calendar.setTime(new Date());
                            //设置过期时间为当前时间之后的24小时
                            calendar.add(Calendar.HOUR_OF_DAY, 24);
                            cacheService.setLikeActivityList(CacheConstant.APP_TOP_ACTIVITY + cmsActivity.getTagId(), cmsActivityList, calendar.getTime());
                        }
                    }
                }
            }
        };
        new Thread(runner).start();
    }

    /**
     * why3.5 app首页推荐活动和首页标签活动存入redis by qww 2016-04-19
     */
    @Override
    public void appActivityListSetRedis() {
        Runnable runner = new Runnable() {
            @Override
            public void run() {
                // why3.5 app首页推荐活动存入redis
                List<CmsActivity> list = activityMapper.queryAppRecommendActivityList(new HashMap<String, Object>());
                if (CollectionUtils.isNotEmpty(list)) {
                    Calendar calendar = Calendar.getInstance();
                    calendar.setTime(new Date());
                    //设置过期时间为当前时间之后的24小时
                    calendar.add(Calendar.HOUR_OF_DAY, 24);
                    cacheService.setLikeActivityList(CacheConstant.APP_RECOMMEND_CMS_ACTIVITY, list, calendar.getTime());
                }

                // why3.5 app首页标签活动存入redis
                List<CmsActivity> activityList = activityMapper.queryActivityThemeByCode(Constant.ACTIVITY_TYPE);
                if (CollectionUtils.isNotEmpty(activityList)) {
                    Map<String, Object> map = new HashMap<String, Object>();
                    for (CmsActivity cmsActivity : activityList) {
                        map.put("tagId", cmsActivity.getTagId());
                        List<CmsActivity> cmsActivityList = activityMapper.queryAppTopActivityList(map);
                        if (CollectionUtils.isNotEmpty(cmsActivityList)) {
                            Calendar calendar = Calendar.getInstance();
                            calendar.setTime(new Date());
                            //设置过期时间为当前时间之后的24小时
                            calendar.add(Calendar.HOUR_OF_DAY, 24);
                            cacheService.setLikeActivityList(CacheConstant.APP_TOP_CMS_ACTIVITY + cmsActivity.getTagId(), cmsActivityList, calendar.getTime());
                        }
                    }
                }
            }
        };
        new Thread(runner).start();
    }

    @Override
    public boolean editRatingsInfo(String ratingsInfo, String activityId) {
        if (StringUtils.isEmpty(ratingsInfo) || StringUtils.isEmpty(activityId)) {
            return false;
        }
        try {
            int count = activityMapper.editRatingsInfo(ratingsInfo, activityId);
            return count > 0;
        } catch (Exception e) {
            logger.error("editRatingsInfo error", e);
            return false;
        }

    }

    @Override
    public String queryRatingsInfoByActivityId(String activityId) {
        return activityMapper.queryRatingsInfoByActivityId(activityId);
    }

    /**
     * 根据传入的map查询后台活动列表信息 new
     *
     * @param
     * @return 活动列表信息
     */
    public List<CmsActivity> queryCmsActivityByAdminCondition(CmsActivity activity, Pagination page, SysUser sysUser) {
        Map<String, Object> map = new HashMap<String, Object>();

        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        if (activity != null) {
            if (StringUtils.isNoneBlank(activity.getActivityId())) {
                map.put("activityId", activity.getActivityId());
            }
            if (StringUtils.isNotBlank(activity.getActivityStartTime())) {
                try {
                    map.put("activityStartTime", df.parse(activity.getActivityStartTime() + " 00:00:00"));
                } catch (ParseException e) {
                    e.printStackTrace();
                }
            }
            if (StringUtils.isNotBlank(activity.getActivityEndTime())) {
                try {
                    map.put("activityEndTime", df.parse(activity.getActivityEndTime() + " 23:59:59"));
                } catch (ParseException e) {
                    e.printStackTrace();
                }
            }
        }

        //数据状态
 		if (activity != null && activity.getActivityIsDel() != null) {
 			map.put("activityIsDel", activity.getActivityIsDel());
 		}
 		
        //是否推荐
//        if (activity != null && StringUtils.isNotBlank(activity.getActivityRecommend()) && "Y".equals(activity.getActivityRecommend())) {
//            map.put("activityRecommend", "Y");
//            if (activity != null && StringUtils.isNotBlank(activity.getActivityArea())) {
//                map.put("activityRecommendArea", activity.getActivityArea() + "%");
//            }
//        }
 		if (StringUtils.isNotBlank(activity.getActivityRecommend())){
 			map.put("activityRecommend", activity.getActivityRecommend());
 		}
        //
        //活动名称
        if (activity != null && StringUtils.isNotBlank(activity.getActivityName())) {
            map.put("activityName", "%" + activity.getActivityName() + "%");
        }
        //场馆名称
        if (activity != null && StringUtils.isNotBlank(activity.getVenueName())) {
            map.put("venueName", "%" + activity.getVenueName() + "%");
        }
        //活动区域
        if (activity != null && StringUtils.isNotBlank(activity.getActivityArea())) {
            map.put("activityArea", activity.getActivityArea() + "%");
        }
        //是否有余票
        if (activity != null && activity.getAvailableCount() != null) {
            map.put("availableCount", activity.getAvailableCount());

        }
        //时间选择方式
        if (activity != null && activity.getActivityIsDetails() != null) {
            map.put("activityIsDetails", activity.getActivityIsDetails());

        }
        //活动状态
        if (activity != null && activity.getActivityState() != null) {
            map.put("activityState", activity.getActivityState());

        }
        // 场馆区域
        if (activity != null && StringUtils.isNotBlank(activity.getVenueArea())) {
            map.put("venueArea", "%" + activity.getVenueArea() + "%");

        }
        // 场馆类型
        if (activity != null && StringUtils.isNotBlank(activity.getVenueType())) {
            map.put("venueType", activity.getVenueType());

        }
        // 场馆
        if (activity != null && StringUtils.isNotBlank(activity.getVenueId())) {
            map.put("venueId", activity.getVenueId());
        }

        // 场馆主题
        if (activity != null && StringUtils.isNotBlank(activity.getActivityType())) {
            map.put("activityType", "%" + activity.getActivityType() + "%");

        }// 场馆主题
        if (activity != null && StringUtils.isNotBlank(activity.getActivityTheme())) {
            map.put("activityTheme", "%" + activity.getActivityTheme() + ",%");

        }
        //权限验证
        if (sysUser != null && StringUtils.isNotBlank(sysUser.getUserDeptPath())) {

            List<SysShareDept> sysShareDepts = new ArrayList<SysShareDept>();
            //判断用户在部门分享表中是否有共享的信息
            sysShareDepts = sysShareDeptService.queryShareDeptByTargetDeptId(sysUser.getUserDeptId());
            SysShareDept sysShareDept = new SysShareDept();
            sysShareDept.setShareDepthPath(sysUser.getUserDeptPath());
            sysShareDepts.add(sysShareDept);
            map.put("activityDepts", sysShareDepts);
        }

        //是否免费
        if (activity != null && activity.getActivityIsFree() != null) {
            map.put("activityIsFree", activity.getActivityIsFree());
        }
        //现在选坐
     		if (activity != null && StringUtils.isNotBlank(activity.getActivitySalesOnline())) {
     			if ("Z".equals(activity.getActivitySalesOnline())) {
     				map.put("activityIsReservation", 1);
     				map.put("activitySupplementType", 1);
     			} else if ("X".equals(activity.getActivitySalesOnline())){
     				map.put("activityIsReservation", 1);
     				map.put("activitySupplementType", 2);
     			} else if ("W".equals(activity.getActivitySalesOnline())){
     				map.put("activityIsReservation", 1);
     				map.put("activitySupplementType", 3);
     			}
     			else {
     				map.put("activitySalesOnline", activity.getActivitySalesOnline());
     			}
     		}
        //自由如坐
        if (activity != null && "N".equals(activity.getActivitySalesOnline())) {
            map.put("activityIsReservation", 2);
        }

        if (StringUtils.isNotBlank(activity.getTemplId())) {
            map.put("templId", activity.getTemplId());
        }
        //活动评级
        if (activity != null && StringUtils.isNotBlank(activity.getRatingsInfo())) {
            map.put("ratingsInfo", activity.getRatingsInfo());
        }
        //分页
        if (page != null && page.getFirstResult() != null && page.getRows() != null) {
            map.put("firstResult", page.getFirstResult());
            map.put("rows", page.getRows());
            int total = activityMapper.queryCmsActivityCountByCondition(map);
            page.setTotal(total);
        }

        return activityMapper.queryCmsActivityByAdminCondition(map);

    }


    @Override
    public List<CmsActivity> queryCmsActivityByCondition(CmsActivity activity, Pagination page, SysUser sysUser) {
        Map<String, Object> map = new HashMap<String, Object>();

        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        if (activity != null) {
            if (StringUtils.isNoneBlank(activity.getActivityId())) {
                map.put("activityId", activity.getActivityId());
            }
            if (StringUtils.isNotBlank(activity.getActivityStartTime())) {
                try {
                    map.put("activityStartTime", df.parse(activity.getActivityStartTime() + " 00:00:00"));
                } catch (ParseException e) {
                    e.printStackTrace();
                }
            }
            if (StringUtils.isNotBlank(activity.getActivityEndTime())) {
                try {
                    map.put("activityEndTime", df.parse(activity.getActivityEndTime() + " 23:59:59"));
                } catch (ParseException e) {
                    e.printStackTrace();
                }
            }
        }

        //数据状态
        if (activity != null && activity.getActivityIsDel() != null && activity.getActivityIsDel() == Constant.DELETE) {
            map.put("activityIsDel", Constant.DELETE);
        } else if (activity != null && activity.getActivityIsDel() != null && activity.getActivityIsDel() == Constant.NORMAL) {
            map.put("activityIsDel", Constant.NORMAL);

        }
        //是否推荐
        if (activity != null && StringUtils.isNotBlank(activity.getActivityRecommend()) && "Y".equals(activity.getActivityRecommend())) {
            map.put("activityRecommend", "Y");
            if (activity != null && StringUtils.isNotBlank(activity.getActivityArea())) {
                map.put("activityRecommendArea", activity.getActivityArea() + "%");
            }
        }
        //
        //活动名称
        if (activity != null && StringUtils.isNotBlank(activity.getActivityName())) {
            map.put("activityName", "%" + activity.getActivityName() + "%");
        }
        //活动开始时间
        if (activity != null && StringUtils.isNotBlank(activity.getActivityStartTime())) {
            map.put("activityStartTime", activity.getActivityStartTime());
        }
        //活动结束时间
        if (activity != null && StringUtils.isNotBlank(activity.getActivityEndTime())) {
            map.put("activityEndTime", activity.getActivityEndTime());
        }

        //活动区域
        if (activity != null && StringUtils.isNotBlank(activity.getActivityArea())) {
            map.put("activityArea", activity.getActivityArea() + "%");
        }
        //活动状态
        if (activity != null && activity.getActivityState() != null) {
            map.put("activityState", activity.getActivityState());

        }
        // 场馆区域
        if (activity != null && StringUtils.isNotBlank(activity.getVenueArea())) {
            map.put("venueArea", "%" + activity.getVenueArea() + "%");

        }
        // 场馆类型
        if (activity != null && StringUtils.isNotBlank(activity.getVenueType())) {
            map.put("venueType", activity.getVenueType());

        }
        // 场馆
        if (activity != null && StringUtils.isNotBlank(activity.getVenueId())) {
            map.put("venueId", activity.getVenueId());
        }

        // 场馆主题
        if (activity != null && StringUtils.isNotBlank(activity.getActivityType())) {
            map.put("activityType", "%" + activity.getActivityType() + "%");

        }// 场馆主题
        if (activity != null && StringUtils.isNotBlank(activity.getActivityTheme())) {
            map.put("activityTheme", "%" + activity.getActivityTheme() + ",%");

        }
        //权限验证
        if (sysUser != null && StringUtils.isNotBlank(sysUser.getUserDeptPath())) {

            List<SysShareDept> sysShareDepts = new ArrayList<SysShareDept>();
            //判断用户在部门分享表中是否有共享的信息
            sysShareDepts = sysShareDeptService.queryShareDeptByTargetDeptId(sysUser.getUserDeptId());
            SysShareDept sysShareDept = new SysShareDept();
            sysShareDept.setShareDepthPath(sysUser.getUserDeptPath());
            sysShareDepts.add(sysShareDept);
            map.put("activityDepts", sysShareDepts);
        }

        //是否免费
        if (activity != null && activity.getActivityIsFree() != null) {
            map.put("activityIsFree", activity.getActivityIsFree());
        }
        //现在选坐
        if (activity != null && StringUtils.isNotBlank(activity.getActivitySalesOnline())) {
            if ("Z".equals(activity.getActivitySalesOnline())) {
                map.put("activityIsReservation", 1);
            } else {
                map.put("activitySalesOnline", activity.getActivitySalesOnline());
            }
        }
        //自由如坐
        if (activity != null && "N".equals(activity.getActivitySalesOnline())) {
            map.put("activityIsReservation", 2);
        }

        if (StringUtils.isNotBlank(activity.getTemplId())) {
            map.put("templId", activity.getTemplId());
        }

        //分页
        if (page != null && page.getFirstResult() != null && page.getRows() != null) {
            map.put("firstResult", page.getFirstResult());
            map.put("rows", page.getRows());
            int total = activityMapper.queryCmsActivityCountByCondition(map);
            page.setTotal(total);
        }

        return activityMapper.queryCmsActivityByCondition(map);

    }

    /**
     * 根据活动对象查询前台用户个人发布活动列表信息
     *
     * @param activity 活动对象
     * @param page     分页对象
     * @param sysUser  用户对象
     * @return 活动列表信息
     */
    @Override
    public List<CmsActivity> queryPersonalActivityByCondition(CmsActivity activity, Pagination page, SysUser sysUser) {
        Map<String, Object> map = new HashMap<String, Object>();

        //数据状态
        if (activity != null && activity.getActivityIsDel() != null && activity.getActivityIsDel() == Constant.DELETE) {
            map.put("activityIsDel", Constant.DELETE);
        } else if (activity != null && activity.getActivityIsDel() != null && activity.getActivityIsDel() == Constant.NORMAL) {
            map.put("activityIsDel", Constant.NORMAL);

        }
        //是否推荐
        if (activity != null && StringUtils.isNotBlank(activity.getActivityRecommend()) && "Y".equals(activity.getActivityRecommend())) {
            map.put("activityRecommend", "Y");
            if (activity != null && StringUtils.isNotBlank(activity.getActivityArea())) {
                map.put("activityRecommendArea", activity.getActivityArea() + "%");
            }
        }
        //
        //活动名称
        if (activity != null && StringUtils.isNotBlank(activity.getActivityName())) {
            map.put("activityName", "%" + activity.getActivityName() + "%");
        }
        //活动开始时间
        if (activity != null && StringUtils.isNotBlank(activity.getActivityStartTime())) {
            map.put("activityStartTime", activity.getActivityStartTime());
        }
        //活动结束时间
        if (activity != null && StringUtils.isNotBlank(activity.getActivityEndTime())) {
            map.put("activityEndTime", activity.getActivityEndTime());
        }

        //活动区域
        if (activity != null && StringUtils.isNotBlank(activity.getActivityArea())) {
            map.put("activityArea", activity.getActivityArea() + "%");
        }

        //活动状态
        if (activity != null && activity.getActivityState() != null) {
            map.put("activityState", activity.getActivityState());

        }
        // 场馆区域
        if (activity != null && StringUtils.isNotBlank(activity.getVenueArea())) {
            map.put("venueArea", "%" + activity.getVenueArea() + "%");

        }
        // 场馆类型
        if (activity != null && StringUtils.isNotBlank(activity.getVenueType())) {
            map.put("venueType", activity.getVenueType());

        }
        // 场馆
        if (activity != null && StringUtils.isNotBlank(activity.getVenueId())) {
            map.put("venueId", activity.getVenueId());
        }

        // 场馆主题
        if (activity != null && StringUtils.isNotBlank(activity.getActivityType())) {
            map.put("activityType", activity.getActivityType());

        }
/*        //权限验证
        if (sysUser != null && StringUtils.isNotBlank(sysUser.getUserDeptPath())) {
            map.put("activityDept", sysUser.getUserDeptPath() + "%");
        }*/

        // 是否是个人活动
        if (activity != null && activity.getActivityPersonal() != null) {
            map.put("activityPersonal", activity.getActivityPersonal());
        }
        //是否免费
        if (activity != null && activity.getActivityIsFree() != null) {
            map.put("activityIsFree", activity.getActivityIsFree());
        }
        //现在选坐
        if (activity != null && StringUtils.isNotBlank(activity.getActivitySalesOnline())) {
            if ("Z".equals(activity.getActivitySalesOnline())) {
                map.put("activityIsReservation", 1);
            } else {
                map.put("activitySalesOnline", activity.getActivitySalesOnline());
            }
        }
        //自由如坐
        if (activity != null && "N".equals(activity.getActivitySalesOnline())) {
            map.put("activityIsReservation", 2);
        }


        //分页
        if (page != null && page.getFirstResult() != null && page.getRows() != null) {
            map.put("firstResult", page.getFirstResult());
            map.put("rows", page.getRows());
            int total = activityMapper.queryPersonalCmsActivityCountByCondition(map);
            page.setTotal(total);
        }

        return activityMapper.queryPersonalActivityByCondition(map);

    }


    /**
     * 查询最新发布活动
     *
     * @param activity 活动对象
     * @param page     分页对象
     * @return 活动对象集合
     */
    @Override
    public List<CmsActivity> queryBestNewPublishActivity(CmsActivity activity, Pagination page) {

        Map<String, Object> map = new HashMap<String, Object>();
        return activityMapper.queryBestNewPublishActivity(map);
    }


    @Override
    public List<CmsActivity> queryRecommendCmsActivityList(CmsActivity activity) {

        Map<String, Object> map = new HashMap<String, Object>();
        map.put("activityType", activity.getActivityType());
        return activityMapper.queryBestNewPublishActivity(map);
    }

    /**
     * 展馆前台获取活动
     *
     * @param activity
     * @param page
     * @return
     */
    @Override
    public List<CmsActivity> queryCmsVenueActivity(CmsActivity activity, Pagination page) {
        Map<String, Object> map = new HashMap<String, Object>();

        //数据状态
        if (activity != null && activity.getActivityIsDel() != null && activity.getActivityIsDel() == 2) {
            map.put("activityIsDel", Constant.DELETE);
        } else {
            map.put("activityIsDel", Constant.NORMAL);

        }
        //活动名称
        if (activity != null && StringUtils.isNotBlank(activity.getActivityName())) {
            map.put("activityName", "%" + activity.getActivityName() + "%");
        }
        //活动时间
        if (activity != null && StringUtils.isNotBlank(activity.getActivityStartTime())) {
            map.put("activityStartTime", activity.getActivityStartTime());
        }
        //活动区域
        if (activity != null && StringUtils.isNotBlank(activity.getActivityArea())) {
            map.put("activityArea", "%" + activity.getActivityArea() + "%");
        }

        //状态
        if (activity != null && activity.getActivityState() != null) {
            map.put("activityState", activity.getActivityState());

        }
        // 场馆区域
        if (activity != null && StringUtils.isNotBlank(activity.getVenueArea())) {
            map.put("venueArea", "%" + activity.getVenueArea() + "%");

        }
        // 场馆类型
        if (activity != null && StringUtils.isNotBlank(activity.getVenueType())) {
            map.put("venueType", activity.getVenueType());

        }
        // 场馆名称
        if (activity != null && StringUtils.isNotBlank(activity.getVenueId())) {
            map.put("venueId", activity.getVenueId());

        }

        //分页
        if (page != null && page.getFirstResult() != null && page.getRows() != null) {
            map.put("firstResult", page.getFirstResult());
            map.put("rows", page.getRows());
        }

        return activityMapper.queryCmsVenueActivity(map);
    }


    /**
     * 前端2.0活动收藏列表
     *
     * @param user         会员对象
     * @param activityName 活动名称
     * @param pageApp
     * @return 活动对象集合
     */
    @Override
    public List<CmsActivity> queryCollectActivity(CmsTerminalUser user, Pagination page, String activityName, PaginationApp pageApp) {
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("userId", user.getUserId());
        map.put("type", Constant.COLLECT_ACTIVITY);
        if (StringUtils.isNotBlank(activityName)) {
            map.put("activityName", "%" + activityName + "%");
        }
        //网页分页
        if (page != null && page.getFirstResult() != null && page.getRows() != null) {
            map.put("firstResult", page.getFirstResult());
            map.put("rows", page.getRows());
            page.setTotal(queryCollectActivityCount(map));
        }
        //app分页
        if (pageApp != null && pageApp.getFirstResult() != null && pageApp.getRows() != null) {
            map.put("firstResult", pageApp.getFirstResult());
            map.put("rows", pageApp.getRows());
        }
        return activityMapper.queryCollectActivity(map);
    }

    /**
     * 前端2.0活动收藏个数
     *
     * @param map
     * @return
     */
    @Override
    public int queryCollectActivityCount(Map<String, Object> map) {
        return activityMapper.queryCollectActivityCount(map);
    }

    /**
     * 个数
     */
    public Integer queryCountByActivity(CmsActivity cmsActivity) {

        return activityMapper.queryCountByActivity(cmsActivity);
    }

    /**
     * 前段首页活动
     *
     * @param activity
     * @param page
     * @param startDate
     * @param endDate
     * @param type
     * @return
     */
    @Override
    public List<CmsActivity> queryActivityByCondition(CmsActivity activity, Pagination page, Date startDate, Date endDate, int type) {
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("type", type);
        if (type == 1) {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            if (startDate != null) {
                map.put("startDate", sdf.format(startDate));
            }
            if (endDate != null) {
                map.put("endDate", sdf.format(endDate));
            }
        }

        if (activity.getActivityIsDel() != null) {
            map.put("activityIsDel", activity.getActivityIsDel());
        }

        if (activity.getActivityState() != null) {
            map.put("activityState", activity.getActivityState());
        }

        return null;
    }

    @Override
    public CmsActivity queryFrontActivityByActivityId(String activityId) {
        return queryCmsActivityByActivityId(activityId);

    }


    @Override
    public List<CmsActivity> queryFrontActivityList(CmsActivity activity, String areaCode,
                                                    String type, String theme,
                                                    String activityStartTime, String activityEndTime, Pagination page, PaginationApp pageApp, String timeType) throws Exception {
        SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
        String nowDate = null;
        Map map = new HashMap();
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

            }
        }

        //位置
        if (activity != null && StringUtils.isNotBlank(activity.getActivityLocation())) {
            map.put("activityLocation", activity.getActivityLocation());
        }
        //区县代码
        if (areaCode != null && !"".equals(areaCode)) {
            activity.setActivityArea(areaCode);
            map.put("activityArea", areaCode + ",%");
        }
        //主题
        if (!StringUtils.isBlank(theme) && !"".equals(theme)) {
            activity.setActivityType(theme);
            map.put("activityType", "%" + theme + ",%");
        }
        //主题
        if (activity != null && StringUtils.isNotBlank(activity.getActivityType())) {
            map.put("activityType", "%" + activity.getActivityType() + ",%");
        }


        //心情
        if (activity.getActivityMood() != null && StringUtils.isNotBlank(activity.getActivityMood())) {
            map.put("activityMood", "%" + activity.getActivityMood() + ",%");
        }
        //活动名称
        if (activity.getActivityName() != null && StringUtils.isNotBlank(activity.getActivityName())) {
            map.put("activityName", "%" + activity.getActivityName() + "%");
        }
        //活动价格
        if (activity.getActivityPrice() != null && StringUtils.isNotBlank(activity.getActivityPrice())) {
            // 1代表 0  2代表0到100   3代表100到200   4 代表200以上
            if ("1".equals(activity.getActivityPrice())) {
                // map.put("activityPrice", 0);
                map.put("activityPrice", 0);
            } else if ("2".equals(activity.getActivityPrice())) {
                map.put("activityPrice", 0);
                map.put("activityPriceEnd", 100);
            } else if ("3".equals(activity.getActivityPrice())) {
                map.put("activityPrice", 100);
                map.put("activityPriceEnd", 200);
            } else if ("4".equals(activity.getActivityPrice())) {
                map.put("activityPrice", 200);
            }
        }
        //活动时间
        if (activityStartTime != null && !StringUtils.isBlank(activityStartTime)) {
            Calendar calendar = Calendar.getInstance();
            calendar.setTime(new Date());
            if ("1".equals(activityStartTime)) {
                calendar.set(Calendar.DATE, calendar.get(Calendar.DATE) - 7);
            } else if ("2".equals(activityStartTime)) {
                calendar.add(Calendar.MONTH, -1);
            } else if ("3".equals(activityStartTime)) {
                calendar.add(Calendar.MONTH, -3);
            } else if ("4".equals(activityStartTime)) {
                calendar.add(Calendar.YEAR, -1);
            } else {
                calendar.setTime(DateUtils.string2Date2(activityStartTime));
            }
            activity.setStartTime(calendar.getTime());
            String date = DateUtils.formatDate(calendar.getTime());
            activity.setActivityStartTime(date);
            map.put("activityStartTime", date);
        }
        if (activityEndTime != null && StringUtils.isNotBlank(activityEndTime)) {
            Calendar calendar = Calendar.getInstance();
            calendar.setTime(DateUtils.string2Date2(activityEndTime));
            String date = DateUtils.formatDate(calendar.getTime());
            activity.setActivityStartTime(date);
            map.put("activityEndTime", date);
        }

        //人群
        if (activity != null && StringUtils.isNotBlank(activity.getActivityCrowd())) {
            map.put("activityCrowd", "%" + activity.getActivityCrowd() + ",%");
        }
        //app活动名称模糊查询
        if (activity != null && StringUtils.isNotBlank(activity.getActivityName())) {
            map.put("activityName", "%" + activity.getActivityName() + "%");
        }
        activity.setActivityIsDel(1);
        map.put("activityIsDel", 1);
        activity.setActivityState(6);
        map.put("activityState", 6);


        //网页分页
        if (page != null && page.getFirstResult() != null && page.getRows() != null) {
            map.put("firstResult", page.getFirstResult());
            map.put("rows", page.getRows());
            int total = queryFrontActivityListCount(activity, areaCode, type, theme, activityStartTime, activityEndTime, timeType);
            page.setTotal(total);
        }

        List<CmsActivity> activityList = activityMapper.queryFrontActivityList(map);

        return activityList;
    }


//    @Override
//    public List<Map> queryIndexListCollectViewNum(CmsActivity activity, String areaCode,
//                                                  String type, String theme,
//                                                  String activityStartTime, String activityEndTime, Pagination page, PaginationApp pageApp, String timeType) throws Exception {
//        SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
//        String nowDate = null;
//        Map map = new HashMap();
//        //1 代表今天 2代表明天 3代表本周末
//        if (StringUtils.isNotBlank(timeType) && !timeType.equals("")) {
//            Date date = new Date();
//            nowDate = sf.format(date);
//            if (timeType.equals("1")) {
//                map.put("activityTime", nowDate);
//            } else if (timeType.equals("2")) {
//                Calendar cal = Calendar.getInstance();
//                cal.setTime(sf.parse(nowDate));
//                cal.add(Calendar.DAY_OF_YEAR, +1);
//                String nextDate = sf.format(cal.getTime());
//                map.put("activityTime", nextDate);
//            } else if (timeType.equals("3")) {
//                Calendar currentDate = Calendar.getInstance();
//                currentDate.setFirstDayOfWeek(Calendar.MONDAY);
//                currentDate.set(Calendar.HOUR_OF_DAY, 23);
//                currentDate.set(Calendar.MINUTE, 59);
//                currentDate.set(Calendar.SECOND, 59);
//                currentDate.set(Calendar.DAY_OF_WEEK, Calendar.SUNDAY);
//                map.put("activityTime", sf.format(currentDate.getTime()));
//
//            }
//        }
//
//        //位置
//        if (activity != null && StringUtils.isNotBlank(activity.getActivityLocation())) {
//            map.put("activityLocation", activity.getActivityLocation());
//        }
//        //区县代码
//        if (areaCode != null && !"".equals(areaCode)) {
//            activity.setActivityArea(areaCode);
//            map.put("activityArea", areaCode + ",%");
//        }
//        //主题
//        if (!StringUtils.isBlank(theme) && !"".equals(theme)) {
//            activity.setActivityType(theme);
//            map.put("activityType", "%" + theme + ",%");
//        }
//        //主题
//        if (activity != null && StringUtils.isNotBlank(activity.getActivityType())) {
//            map.put("activityType", "%" + activity.getActivityType() + ",%");
//        }
//
//
//        //心情
//        if (activity.getActivityMood() != null && StringUtils.isNotBlank(activity.getActivityMood())) {
//            map.put("activityMood", "%" + activity.getActivityMood() + ",%");
//        }
//        //活动名称
//        if (activity.getActivityName() != null && StringUtils.isNotBlank(activity.getActivityName())) {
//            map.put("activityName", "%" + activity.getActivityName() + "%");
//        }
//        //活动价格
//        if (activity.getActivityPrice() != null && StringUtils.isNotBlank(activity.getActivityPrice())) {
//            // 1代表 0  2代表0到100   3代表100到200   4 代表200以上
//            if ("1".equals(activity.getActivityPrice())) {
//                // map.put("activityPrice", 0);
//                map.put("activityPrice", 0);
//            } else if ("2".equals(activity.getActivityPrice())) {
//                map.put("activityPrice", 0);
//                map.put("activityPriceEnd", 100);
//            } else if ("3".equals(activity.getActivityPrice())) {
//                map.put("activityPrice", 100);
//                map.put("activityPriceEnd", 200);
//            } else if ("4".equals(activity.getActivityPrice())) {
//                map.put("activityPrice", 200);
//            }
//        }
//        //活动时间
//        if (activityStartTime != null && !StringUtils.isBlank(activityStartTime)) {
//            Calendar calendar = Calendar.getInstance();
//            calendar.setTime(new Date());
//            if ("1".equals(activityStartTime)) {
//                calendar.set(Calendar.DATE, calendar.get(Calendar.DATE) - 7);
//            } else if ("2".equals(activityStartTime)) {
//                calendar.add(Calendar.MONTH, -1);
//            } else if ("3".equals(activityStartTime)) {
//                calendar.add(Calendar.MONTH, -3);
//            } else if ("4".equals(activityStartTime)) {
//                calendar.add(Calendar.YEAR, -1);
//            } else {
//                calendar.setTime(DateUtils.string2Date2(activityStartTime));
//            }
//            activity.setStartTime(calendar.getTime());
//            String date = DateUtils.formatDate(calendar.getTime());
//            activity.setActivityStartTime(date);
//            map.put("activityStartTime", date);
//        }
//        if (activityEndTime != null && StringUtils.isNotBlank(activityEndTime)) {
//            Calendar calendar = Calendar.getInstance();
//            calendar.setTime(DateUtils.string2Date2(activityEndTime));
//            String date = DateUtils.formatDate(calendar.getTime());
//            activity.setActivityStartTime(date);
//            map.put("activityEndTime", date);
//        }
//
//        //人群
//        if (activity != null && StringUtils.isNotBlank(activity.getActivityCrowd())) {
//            map.put("activityCrowd", "%" + activity.getActivityCrowd() + ",%");
//        }
//        //app活动名称模糊查询
//        if (activity != null && StringUtils.isNotBlank(activity.getActivityName())) {
//            map.put("activityName", "%" + activity.getActivityName() + "%");
//        }
//        activity.setActivityIsDel(1);
//        map.put("activityIsDel", 1);
//        activity.setActivityState(6);
//        map.put("activityState", 6);
//
//        //网页分页
//        if (page != null && page.getFirstResult() != null && page.getRows() != null) {
//            map.put("firstResult", page.getFirstResult());
//            map.put("rows", page.getRows());
//        }
//
//        List<Map> activityList = activityMapper.queryIndexListCollectViewNum(map);
//
//        return activityList;
//    }

    @Override
    public int queryActivityListLoadCount(Map map) {
        return activityMapper.queryActivityListLoadCount(map);
    }


    @Override
    public List queryActivityListLoad(CmsActivity activity, String areaCode,
                                      String type, String theme, String orderType,
                                      String activityStartTime, String activityEndTime, Pagination page) throws Exception {
        Map map = new HashMap();
        //位置
        if (activity != null && StringUtils.isNotBlank(activity.getActivityLocation())) {
            map.put("activityLocation", activity.getActivityLocation());
        }


        //区县代码
        //page.setRows(20);
        if (areaCode != null && !"".equals(areaCode)) {
            activity.setActivityArea(areaCode);
            map.put("activityArea", areaCode + ",%");
        } /*else {
            map.put("activityArea",  "45,%");
        }*/
        //主题
        if (!StringUtils.isBlank(theme) && !"".equals(theme)) {
            map.put("activityType", "%" + theme + ",%");
        }
        //主题
        if (activity != null && StringUtils.isNotBlank(activity.getActivityType())) {
            map.put("activityType", "%" + activity.getActivityType() + ",%");
        }
        //心情
        if (activity.getActivityMood() != null && StringUtils.isNotBlank(activity.getActivityMood())) {
            map.put("activityMood", "%" + activity.getActivityMood() + ",%");
        }
        //活动名称
        if (activity.getActivityName() != null && StringUtils.isNotBlank(activity.getActivityName())) {
            map.put("activityName", "%" + activity.getActivityName().replace("_", "\\_").replace("%", "\\%") + "%");
        }
        //活动价格
        if (activity.getActivityPrice() != null && StringUtils.isNotBlank(activity.getActivityPrice())) {
            // 1代表 0  2代表0到100   3代表100到200   4 代表200以上
            if ("1".equals(activity.getActivityPrice())) {
                // map.put("activityPrice", 0);
                map.put("activityPrice", 0);
            } else if ("2".equals(activity.getActivityPrice())) {
                map.put("activityPrice", 0);
                map.put("activityPriceEnd", 100);
            } else if ("3".equals(activity.getActivityPrice())) {
                map.put("activityPrice", 100);
                map.put("activityPriceEnd", 200);
            } else if ("4".equals(activity.getActivityPrice())) {
                map.put("activityPrice", 200);
            }
        }
        //活动时间
        if (activityStartTime != null && !StringUtils.isBlank(activityStartTime)) {
            Calendar calendar = Calendar.getInstance();
            calendar.setTime(new Date());
            if ("1".equals(activityStartTime)) {
                calendar.set(Calendar.DATE, calendar.get(Calendar.DATE) - 7);
            } else if ("2".equals(activityStartTime)) {
                calendar.add(Calendar.MONTH, -1);
            } else if ("3".equals(activityStartTime)) {
                calendar.add(Calendar.MONTH, -3);
            } else if ("4".equals(activityStartTime)) {
                calendar.add(Calendar.YEAR, -1);
            } else {
                calendar.setTime(DateUtils.string2Date2(activityStartTime));
            }
            activity.setStartTime(calendar.getTime());
            String date = DateUtils.formatDate(calendar.getTime());
            activity.setActivityStartTime(activityStartTime);
            map.put("activityStartTime", activityStartTime);
        }
        if (activityEndTime != null && StringUtils.isNotBlank(activityEndTime)) {
            Calendar calendar = Calendar.getInstance();
            calendar.setTime(DateUtils.string2Date2(activityEndTime));
            String date = DateUtils.formatDate(calendar.getTime());
            activity.setActivityStartTime(date);
            map.put("activityEndTime", activityEndTime);
        }

        //人群
        if (activity != null && StringUtils.isNotBlank(activity.getActivityCrowd())) {
            map.put("activityCrowd", "%" + activity.getActivityCrowd() + ",%");
        }

        activity.setActivityIsDel(1);
        map.put("activityIsDel", 1);
        activity.setActivityState(6);
        map.put("activityState", 6);

        //网页分页
        if (page != null && page.getFirstResult() != null && page.getRows() != null) {
            map.put("firstResult", page.getFirstResult());
            map.put("rows", page.getRows());
            int total = queryActivityListLoadCount(map);
            page.setTotal(total);
        }
        if (orderType != null && StringUtils.isNotBlank(orderType)) {
            map.put("orderType", orderType);
        } else {
            map.put("orderType", orderType);
        }

        List<CmsActivity> activityList = activityMapper.queryActivityListLoad(map);

        return activityList;
    }


    /**
     * 前端3.2查询活动列表
     *
     * @param activity 活动对象
     * @param page
     * @return
     * @throws Exception
     */
    @Override
    public List queryActivityListCollectNumLoad(CmsActivity activity, Pagination page) throws Exception {
        Map map = new HashMap();
        //位置
        if (activity != null && StringUtils.isNotBlank(activity.getActivityLocation())) {
            map.put("activityLocation", activity.getActivityLocation());
        }


        //区县代码
        //page.setRows(20);
        if (StringUtils.isNotBlank(activity.getActivityArea())) {
            map.put("activityArea", activity.getActivityArea() + ",%");
        }
        //主题
        if (StringUtils.isNotBlank(activity.getActivityType())) {
            map.put("activityType", "%" + activity.getActivityType() + ",%");
        }
        //心情
        if (StringUtils.isNotBlank(activity.getActivityMood())) {
            map.put("activityMood", "%" + activity.getActivityMood() + ",%");
        }
        //活动名称
        if (StringUtils.isNotBlank(activity.getActivityName())) {
            map.put("activityName", "%" + activity.getActivityName().replace("_", "\\_").replace("%", "\\%") + "%");
        }
        //活动价格
        if (StringUtils.isNotBlank(activity.getActivityPrice())) {
            // 1代表 0  2代表0到100   3代表100到200   4 代表200以上
            if ("1".equals(activity.getActivityPrice())) {
                // map.put("activityPrice", 0);
                map.put("activityPrice", 0);
            } else if ("2".equals(activity.getActivityPrice())) {
                map.put("activityPrice", 0);
                map.put("activityPriceEnd", 100);
            } else if ("3".equals(activity.getActivityPrice())) {
                map.put("activityPrice", 100);
                map.put("activityPriceEnd", 200);
            } else if ("4".equals(activity.getActivityPrice())) {
                map.put("activityPrice", 200);
            }
        }
        //活动时间
        if (StringUtils.isNotBlank(activity.getActivityStartTime())) {
            Calendar calendar = Calendar.getInstance();
            calendar.setTime(new Date());
            if ("1".equals(activity.getActivityStartTime())) {
                calendar.set(Calendar.DATE, calendar.get(Calendar.DATE) - 7);
            } else if ("2".equals(activity.getActivityStartTime())) {
                calendar.add(Calendar.MONTH, -1);
            } else if ("3".equals(activity.getActivityStartTime())) {
                calendar.add(Calendar.MONTH, -3);
            } else if ("4".equals(activity.getActivityStartTime())) {
                calendar.add(Calendar.YEAR, -1);
            } else {
                calendar.setTime(DateUtils.string2Date2(activity.getActivityStartTime()));
            }
            activity.setStartTime(calendar.getTime());
            activity.setActivityStartTime(activity.getActivityStartTime());
            map.put("activityStartTime", activity.getActivityStartTime());
        }
        if (StringUtils.isNotBlank(activity.getActivityEndTime())) {
            Calendar calendar = Calendar.getInstance();
            calendar.setTime(DateUtils.string2Date2(activity.getActivityEndTime()));
            String date = DateUtils.formatDate(calendar.getTime());
            activity.setActivityStartTime(date);
            map.put("activityEndTime", activity.getActivityEndTime());
        }

        //人群
        if (StringUtils.isNotBlank(activity.getActivityCrowd())) {
            map.put("activityCrowd", "%" + activity.getActivityCrowd() + ",%");
        }

        activity.setActivityIsDel(1);
        map.put("activityIsDel", 1);
        activity.setActivityState(6);
        map.put("activityState", 6);

        //网页分页
        if (page != null && page.getFirstResult() != null && page.getRows() != null) {
            map.put("firstResult", page.getFirstResult());
            map.put("rows", page.getRows());
            int total = queryActivityListLoadCount(map);
            page.setTotal(total);
        }

        return activityMapper.queryActivityListCollectNumLoad(map);
    }


    @Override
    public Integer queryFrontActivityListCount(CmsActivity activity, String areaCode,
                                               String type, String theme,
                                               String activityStartTime, String activityEndTime, String timeType) throws Exception {
        SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
        String nowDate = null;
        Map map = new HashMap();
        //区县代码
        //page.setRows(20);
        if (areaCode != null && !"".equals(areaCode)) {
            activity.setActivityArea(areaCode);
            map.put("activityArea", "" + areaCode + ",%");
        }
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

            }
        }
        //主题
        if (!StringUtils.isBlank(theme) && !"".equals(theme)) {
            activity.setActivityType(theme);
            map.put("activityType", "%" + theme + "%");
        }
        //位置
        if (activity != null && StringUtils.isNotBlank(activity.getActivityLocation())) {
            map.put("activityLocation", activity.getActivityLocation());
        }
        //主题
        if (activity != null && StringUtils.isNotBlank(activity.getActivityType())) {
            map.put("activityType", "%" + activity.getActivityType() + ",%");
        }
        //心情
        if (activity.getActivityMood() != null && StringUtils.isNotBlank(activity.getActivityMood())) {
            map.put("activityMood", "%" + activity.getActivityMood() + "%");
        }
        //活动名称
        if (activity.getActivityName() != null && StringUtils.isNotBlank(activity.getActivityName())) {
            map.put("activityName", "%" + activity.getActivityName() + "%");
        }
        //活动价格
        if (activity.getActivityPrice() != null && StringUtils.isNotBlank(activity.getActivityPrice())) {
            // 1代表 0  2代表0到100   3代表100到200   4 代表200以上
            if ("1".equals(activity.getActivityPrice())) {
                map.put("activityPrice", 0);
                //   map.put("activityPriceEnd", 100);
            } else if ("2".equals(activity.getActivityPrice())) {
                map.put("activityPrice", 0);
                map.put("activityPriceEnd", 100);
            } else if ("3".equals(activity.getActivityPrice())) {
                map.put("activityPrice", 100);
                map.put("activityPriceEnd", 200);
            } else if ("4".equals(activity.getActivityPrice())) {
                map.put("activityPrice", 200);
            }
        }
        //活动时间
        if (activityStartTime != null && !StringUtils.isBlank(activityStartTime)) {
            Calendar calendar = Calendar.getInstance();
            calendar.setTime(new Date());
            if ("1".equals(activityStartTime)) {
                calendar.set(Calendar.DATE, calendar.get(Calendar.DATE) - 7);
            } else if ("2".equals(activityStartTime)) {
                calendar.add(Calendar.MONTH, -1);
            } else if ("3".equals(activityStartTime)) {
                calendar.add(Calendar.MONTH, -3);
            } else if ("4".equals(activityStartTime)) {
                calendar.add(Calendar.YEAR, -1);
            } else {
                calendar.setTime(DateUtils.string2Date2(activityStartTime));
            }
            activity.setStartTime(calendar.getTime());
            String date = DateUtils.formatDate(calendar.getTime());
            activity.setActivityStartTime(date);
            map.put("activityStartTime", date);
        }
        if (activityEndTime != null && StringUtils.isNotBlank(activityEndTime)) {
            Calendar calendar = Calendar.getInstance();
            calendar.setTime(DateUtils.string2Date2(activityEndTime));
            String date = DateUtils.formatDate(calendar.getTime());
            activity.setActivityStartTime(date);
            map.put("activityEndTime", date);
        }

        //人群
        if (activity != null && StringUtils.isNotBlank(activity.getActivityCrowd())) {
            map.put("activityCrowd", "%" + activity.getActivityCrowd() + "%");
        }

        activity.setActivityIsDel(1);
        map.put("activityIsDel", 1);
        activity.setActivityState(6);
        map.put("activityState", 6);

        return activityMapper.queryFrontActivityListCount(map);
    }


    @Override
    public List<CmsActivity> queryYearHotActivity(String area, CmsActivity cmsActivity, Pagination page) {
        if (area != null && StringUtils.isNotBlank(area)) {
            cmsActivity.setActivityArea(area + ",%");
        }
        //主题
        if (cmsActivity != null && StringUtils.isNotBlank(cmsActivity.getActivityType())) {
            cmsActivity.setActivityType("," + cmsActivity.getActivityType() + ",%");
        }
        //心情
        if (cmsActivity != null && StringUtils.isNotBlank(cmsActivity.getActivityMood())) {
            cmsActivity.setActivityMood("," + cmsActivity.getActivityMood() + ",%");
        }
        //人群
        if (cmsActivity != null && StringUtils.isNotBlank(cmsActivity.getActivityCrowd())) {
            cmsActivity.setActivityCrowd("," + cmsActivity.getActivityCrowd() + ",%");
        }
        if (cmsActivity != null && StringUtils.isNotBlank(cmsActivity.getActivityName())) {
            cmsActivity.setActivityName("%" + cmsActivity.getActivityName() + ",%");
        }
        cmsActivity.setActivityRecommend(null);
        cmsActivity.setRows(page.getRows());
        return activityMapper.queryYearHotActivity(cmsActivity);
    }

    @Override
    public List<CmsActivity> getRelateActivity(CmsActivity activity, Pagination page) {
        Map map = new HashMap();
        map.put("activityId", activity.getActivityId());
        map.put("activityIsDel", 1);
        map.put("activityState", 6);
        map.put("rows", page.getRows());
        map.put("firstResult", page.getFirstResult());
        map.put("activityArea", "%" + activity.getActivityArea() + "%");
        List<Map> tagsList = queryActivityLabelById(activity.getActivityId());
        if (tagsList != null && tagsList.size() > 0) {
            map.put("tagIds", tagsList);
        }
        List list = activityMapper.getRelateActivity(map);
        if (list == null || list.size() < page.getRows()) {
            map.remove("tagIds");
            map.remove("activityArea");
            map.put("rows", page.getRows() - list.size());
            list.addAll(activityMapper.getRelateActivity(map));
            return list;
        } else {
            return list;
        }
    }

    @Override
    public int queryCmsActivityCountByCondition(Map<String, Object> map) {
        map.put("activityIsDel", 1);
        map.put("activityState", 6);
        return activityMapper.queryCmsActivityCountByCondition(map);
    }


    /**
     * 根据传入的map查询前台活动的总条数
     *
     * @param map 查询条件
     * @return 活动总条数
     */
    public int queryFrontCmsActivityCountByCondition(Map<String, Object> map) {
        map.put("activityIsDel", 1);
        map.put("activityState", 6);
        return activityMapper.queryFrontCmsActivityCountByCondition(map);
    }

    /**
     * 保存活动预定信息
     *
     * @param seatId
     * @param activityId
     * @return
     */
    public String saveFrontActivityBook(String[] seatId, String activityId, String phone, String userId, Integer bookCount) {
        if (activityId == null || StringUtils.isBlank(activityId)) {
            return "activityEmpty";
        }
        if (bookCount == null || bookCount == 0) {
            if (seatId == null || seatId.length == 0) {
                return "seatEmpty";
            } else if (seatId.length > 5) {
                return "more";
            }
        }
        //从redic 里面判断座位的状态  如果都为可以使用的话 执行下一步  否则提示
        BookActivitySeatInfo seatInfo = new BookActivitySeatInfo();
        seatInfo.setActivityId(activityId);
        String checkRs = cacheService.checkActivitySeatStatus(seatInfo, seatId, bookCount, userId);
        if (!Constant.RESULT_STR_SUCCESS.equals(checkRs)) {
            //不成功返回错误提示
            return checkRs;
        } else {
            //成功进入下一步
            String rs = cacheService.checkActivitySeatStatus(seatInfo, seatId, bookCount, userId);
            if (!Constant.RESULT_STR_SUCCESS.equals(rs)) {
                //失败返回
                return rs;
            } else {

            }

        }
        return Constant.RESULT_STR_SUCCESS;
    }

    /**
     * 根据活动id查询活动座位信息
     *
     * @param activityId
     * @return
     */
    @Override
    public List queryActivitySeatInfoById(String activityId) {
        Map map = new HashMap();
        map.put("activityId", activityId);
        return activityMapper.queryActivitySeatByCondition(map);
    }

    @Override
    public List<CmsActivity> queryActivityListByCity(String areaCode, String[] activityIds, String activityName, CmsActivity cmsActivity, Pagination page) {
        Map map = new HashMap();
        if (areaCode != null && StringUtils.isNotBlank(areaCode) && !"45".equals(areaCode)) {
            map.put("activityArea", areaCode + ",%");
        }
        if (activityIds != null && activityIds.length > 0) {
            map.put("activityIds", activityIds);
        }
        if (activityName != null && StringUtils.isNotBlank(activityName)) {
            map.put("activityName", "%" + activityName + "%");
        }
        //主题
        if (cmsActivity != null && StringUtils.isNotBlank(cmsActivity.getActivityType())) {

            map.put("activityType", "%" + cmsActivity.getActivityType() + ",%");
        }
        //心情
        if (cmsActivity != null && StringUtils.isNotBlank(cmsActivity.getActivityMood())) {

            map.put("activityMood", "%" + cmsActivity.getActivityMood() + ",%");
        }
        //人群
        if (cmsActivity != null && StringUtils.isNotBlank(cmsActivity.getActivityCrowd())) {

            map.put("activityCrowd", "%" + cmsActivity.getActivityCrowd() + ",%");
        }

        //分页
        if (page != null && page.getFirstResult() != null && page.getRows() != null) {
            map.put("firstResult", page.getFirstResult());
            map.put("rows", page.getRows());
        }
        map.put("activityIsDel", 1);
        map.put("activityState", 6);
        return activityMapper.queryActivityListByCity(map);
    }

    /**
     * app根据展馆id获取相关活动
     *
     * @param venueId 展馆id
     * @param pageApp 分页对象
     * @return
     */
    @Override
    public String queryActivityList(String venueId, PaginationApp pageApp) {
        Map<String, Object> map = new HashMap<String, Object>();
        if (StringUtils.isNotBlank(venueId)) {
            map.put("venueId", venueId);
        }
        //数据状态
        map.put("activityIsDel", Constant.NORMAL);
        map.put("activityState", Constant.PUBLISH);
        //app分页
        if (pageApp != null && pageApp.getFirstResult() != null && pageApp.getRows() != null) {
            map.put("firstResult", pageApp.getFirstResult());
            map.put("rows", pageApp.getRows());
        }
        List<CmsActivity> activityList = activityMapper.queryActivityListById(map);
        List<Map<String, Object>> listMap = new ArrayList<Map<String, Object>>();
        try {
            if (activityList.size() > 0) {
                for (CmsActivity activity : activityList) {
                    Map<String, Object> activityMap = new HashMap<String, Object>();
                    activityMap.put("activityId", activity.getActivityId() != null ? activity.getActivityId() : "");
                    activityMap.put("activityName", activity.getActivityName() != null ? activity.getActivityName() : "");
                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
                    Date startDate = sdf.parse(activity.getActivityStartTime());
                    long activityStartTime = startDate.getTime();
                    activityMap.put("activityStartTime", activityStartTime / 1000);
                    Date endDate = sdf.parse(activity.getActivityEndTime());
                    long activityEndTime = endDate.getTime();
                    activityMap.put("activityEndTime", activityEndTime / 1000);
                    activityMap.put("activityPrice", activity.getActivityPrice());
                    listMap.add(activityMap);
                }
            }
        } catch (Exception e) {
            logger.error("app根据展馆id获取活动列表出错!", e);
        }
        return JSONResponse.toAppResultFormat(0, listMap);
    }

    /**
     * app查询标签下当天是否有活动
     * app查询标签下附近是否有活动
     *
     * @param
     * @param tagId
     * @param dictCode
     * @param date
     * @param pageApp
     */
    @Override
    public List<CmsActivity> queryAppCountByActivity(String tagId, String dictCode, String date, PaginationApp pageApp) {
        Map<String, Object> map = new HashMap<String, Object>();
        if (date != null && StringUtils.isNotBlank(date)) {
            map.put("date", date);
        }
        //主题
        if (dictCode != null && dictCode.equals("ACTIVITY_THEME")) {
            map.put("activityType", "%" + tagId + ",%");
        }
        //心情
        if (dictCode != null && dictCode.equals("ACTIVITY_MOOD")) {
            map.put("activityMood", "%" + tagId + ",%");
        }
        //人群
        if (dictCode != null && dictCode.equals("ACTIVITY_CROWD")) {
            map.put("activityCrowd", "%" + tagId + ",%");
        }
        //app分页
        if (pageApp != null && pageApp.getFirstResult() != null && pageApp.getRows() != null) {
            map.put("firstResult", pageApp.getFirstResult());
            map.put("rows", pageApp.getRows());
        }
        map.put("activityIsDel", 1);
        map.put("activityState", 6);
        int total = activityMapper.queryAppCount(map);
        if (pageApp != null && total > 0) {
            //设置分页的总条数来获取总页数
            pageApp.setTotal(total);
        }
        return activityMapper.queryAppCountByActivity(map);
    }


    /**
     * 根据活动id 获得该活动的标签值
     *
     * @param activityId
     * @return
     */
    @Override
    public List<Map> queryActivityLabelById(String activityId) {
        CmsActivity cmsActivity = queryFrontActivityByActivityId(activityId);
        StringBuffer sb = new StringBuffer();
        if (cmsActivity != null) {
            if (cmsActivity.getActivityType() != null && StringUtils.isNotBlank(cmsActivity.getActivityType())) {
                sb.append(cmsActivity.getActivityType());
            }
            if (cmsActivity.getActivityCrowd() != null && StringUtils.isNotBlank(cmsActivity.getActivityCrowd())) {
                sb.append(cmsActivity.getActivityCrowd());
            }
            if (cmsActivity.getActivityMood() != null && StringUtils.isNotBlank(cmsActivity.getActivityMood())) {
                sb.append(cmsActivity.getActivityMood());
            }
            if (cmsActivity.getActivityTheme() != null && StringUtils.isNotBlank(cmsActivity.getActivityTheme())) {
                sb.append(cmsActivity.getActivityTheme());
            }
        }

        String strs = sb.toString();
        String[] labels = strs.split(",");
        Map map = new HashMap();
        map.put("tagIds", labels);
        return activityMapper.queryActivityLabelById(map);
    }

    /**
     * 查询活动中存在的区县
     *
     * @param activityState
     * @return
     */
    public List<Map> queryExistArea(String activityState) {
        return activityMapper.queryExistArea(activityState);
    }

    /**
     * app查询最新活动列表
     *
     * @param tagId
     * @param dictCode
     * @param pageApp
     * @return
     */
    @Override
    public List<CmsActivity> queryAppLatestByActivity(String tagId, String dictCode, PaginationApp pageApp) {
        Map<String, Object> map = new HashMap<String, Object>();
        //主题
        if (dictCode != null && dictCode.equals("ACTIVITY_THEME")) {
            map.put("activityType", "%" + tagId + ",%");
        }
        //心情
        if (dictCode != null && dictCode.equals("ACTIVITY_MOOD")) {
            map.put("activityMood", "%" + tagId + ",%");
        }
        //人群
        if (dictCode != null && dictCode.equals("ACTIVITY_CROWD")) {
            map.put("activityCrowd", "%" + tagId + ",%");
        }
        //app分页
        if (pageApp != null && pageApp.getFirstResult() != null && pageApp.getRows() != null) {
            map.put("firstResult", pageApp.getFirstResult());
            map.put("rows", pageApp.getRows());
        }
        map.put("activityIsDel", 1);
        map.put("activityState", 6);
        int total = activityMapper.queryAppCount(map);
        //设置分页的总条数来获取总页数
        pageApp.setTotal(total);
        return activityMapper.queryAppLatestByActivity(map);
    }

   /* @Override
    public List<CmsActivity> queryAppHotByActivity(CmsActivity activity, String areaCode, String activityStartTime, String activityEndTime, PaginationApp pageApp, String timeType) throws ParseException {
        SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
        String nowDate = null;
        Map map = new HashMap();
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
                map.put("activityTime", sf.format((Date) currentDate.getTime()));
            }
        }

        //位置
        if (activity != null && StringUtils.isNotBlank(activity.getActivityLocation())) {
            map.put("activityLocation", activity.getActivityLocation());
        }
        //区县代码
        if (areaCode != null && !"".equals(areaCode) && !areaCode.equals("null")) {
            map.put("activityArea", areaCode + ",%");
        }
        //主题
        if (activity != null && StringUtils.isNotBlank(activity.getActivityType())) {
            map.put("activityType", "%" + activity.getActivityType() + ",%");
        }
        //心情
        if (activity.getActivityMood() != null && StringUtils.isNotBlank(activity.getActivityMood())) {
            map.put("activityMood", "%" + activity.getActivityMood() + ",%");
        }
        //活动名称
        if (activity.getActivityName() != null && StringUtils.isNotBlank(activity.getActivityName())) {
            map.put("activityName", "%" + activity.getActivityName() + "%");
        }
        //活动时间
        if (activityStartTime != null && !StringUtils.isBlank(activityStartTime)) {
            Calendar calendar = Calendar.getInstance();
            calendar.setTime(new Date());
            if ("1".equals(activityStartTime)) {
                calendar.set(Calendar.DATE, calendar.get(Calendar.DATE) - 7);
            } else if ("2".equals(activityStartTime)) {
                calendar.add(Calendar.MONTH, -1);
            } else if ("3".equals(activityStartTime)) {
                calendar.add(Calendar.MONTH, -3);
            } else if ("4".equals(activityStartTime)) {
                calendar.add(Calendar.YEAR, -1);
            } else {
                calendar.setTime(DateUtils.string2Date2(activityStartTime));
            }
            activity.setStartTime(calendar.getTime());
            String date = DateUtils.formatDate(calendar.getTime());
            map.put("activityStartTime", date);
        }
        if (activityEndTime != null && StringUtils.isNotBlank(activityEndTime)) {
            Calendar calendar = Calendar.getInstance();
            calendar.setTime(DateUtils.string2Date2(activityEndTime));
            String date = DateUtils.formatDate(calendar.getTime());
            map.put("activityEndTime", date);
        }

        //人群
        if (activity != null && StringUtils.isNotBlank(activity.getActivityCrowd())) {
            map.put("activityCrowd", "%" + activity.getActivityCrowd() + ",%");
        }
        //app活动名称模糊查询
        if (activity != null && StringUtils.isNotBlank(activity.getActivityName())) {
            map.put("activityName", "%" + activity.getActivityName() + "%");
        }
        map.put("activityIsDel", 1);
        map.put("activityState", 6);
        //app分页
        if (pageApp != null && pageApp.getFirstResult() != null && pageApp.getRows() != null) {
            map.put("firstResult", pageApp.getFirstResult());
            map.put("rows", pageApp.getRows());
            int total = activityMapper.queryAppHotByActivityListCount(map);
            pageApp.setTotal(total);
        }
        List<CmsActivity> activityList = activityMapper.queryAppHotByActivity(map);
        return activityList;
    }*/


    /**
     * @Par type 1周  2月 3季 4年
     * 查询需要统计的活动数据
     */
    public List<Map> queryActivityStatistic(Map map, int type) {
        Calendar calendar = Calendar.getInstance();
        DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd 00:00:00");
        DateFormat dateFormat2 = new SimpleDateFormat("yyyy-MM-dd 00:00:00");
        Date date = new Date();
        try {
            date = dateFormat2.parse(dateFormat.format(new Date()));
        } catch (ParseException e) {
            e.printStackTrace();
        }
        calendar.setTime(date);
        if (type == 1) {
            calendar.set(Calendar.DATE, calendar.get(Calendar.DATE) - 7);
        } else if (type == 2) {
            calendar.set(Calendar.MONTH, calendar.get(Calendar.MONTH) - 1);
        } else if (type == 3) {
            calendar.set(Calendar.MONTH, calendar.get(Calendar.MONTH) - 3);
        } else if (type == 4) {
            calendar.set(Calendar.YEAR, calendar.get(Calendar.YEAR) - 1);
        }
        //周统计  7天的

        map.put("activityCreateTimeBegin", calendar.getTime());
        map.put("activityCreateTimeEnd", date);
        map.put("activityIsDel", 1);
        map.put("activityState", 6);
        map.put("queryType", type);
        return activityMapper.queryActivityStatistic(map);
    }

    public List<Map> queryActivityCircleStatistic(Map<String, Object> map) {
        map.put("activityIsDel", 1);
        map.put("activityState", 6);
        return activityMapper.queryActivityCircleStatistic(map);
    }

    /**
     * 后台首页活动  各区县数量统计
     */
    public List<Map> queryActivityGroupByArea(Map<String, Object> map) {
        map.put("activityIsDel", 1);
        map.put("activityState", 6);
        return activityMapper.queryActivityGroupByArea(map);
    }

    /**
     * 活动草稿箱发布活动
     *
     * @param activityId
     * @return
     */
    @Override
    public String updateStateByActivityId(String activityId, Integer activityState, SysUser sysUser) {
        if (StringUtils.isNoneBlank(activityId)) {
            CmsActivity activity = queryCmsActivityByActivityId(activityId);
            //个人发布活动需要设置部门路径
            //if (StringUtils.isBlank(activity.getActivityDept())) {
            //    activity.setActivityDept(sysUser.getUserDeptPath());
            //}
            activity.setActivityIsDel(1);
            activity.setActivityState(activityState == null ? 6 : activityState);
            if (activity.getPublicTime() == null) {
                activity.setPublicTime(new Date());
            }
            activity.setActivityUpdateTime(new Date());
            activity.setActivityUpdateUser(sysUser.getUserId());
            //activity.setActivityCreateUser(sysUser.getUserId());
            activityMapper.editCmsActivity(activity);
            return Constant.RESULT_STR_SUCCESS;
        }
        return Constant.RESULT_STR_FAILURE;
    }


    /**
     * 拒绝会员用户发布的活动申请
     *
     * @param activityId
     * @return
     */
    @Override
    public String refuseTuserActivityByActivityId(String activityId, Integer activityState, SysUser sysUser, String[] reason) {
        if (reason == null || reason.length == 0) {
            return "请输入未通过审核原因";
        }
        if (StringUtils.isNoneBlank(activityId)) {
            CmsActivity activity = queryCmsActivityByActivityId(activityId);
            //个人发布活动需要设置部门路径
            if (StringUtils.isBlank(activity.getActivityDept())) {
                activity.setActivityDept(sysUser.getUserDeptPath());
            }
            activity.setActivityState(activityState == null ? 6 : activityState);
            activity.setActivityUpdateTime(new Date());
            activity.setActivityUpdateUser(sysUser.getUserId());
            activity.setActivityCreateUser(sysUser.getUserId());
            activityMapper.editCmsActivity(activity);
            //成功后发送站内短消息
            Map<String, Object> params = new HashMap<String, Object>();
            CmsTerminalUser cmsTerminalUser = userMapper.queryTerminalUserById(activity.getActivityTerminalUserId());
            params.put("userName", cmsTerminalUser.getUserName());
            params.put("activityName", activity.getActivityName());
            String reasons = "";
            if (reason != null && reason.length > 0) {
                for (String rs : reason) {
                    reasons += rs + " ";
                }
            }
            params.put("reasons", reasons);
            userMessageService.sendSystemMessage(Constant.SYSTEM_NOTICE_REFUSEUSER_ACTIVITY, params, cmsTerminalUser.getUserId());
            return Constant.RESULT_STR_SUCCESS;
        }
        return Constant.RESULT_STR_FAILURE;
    }

    /**
     * 将老数据 无场次的活动 添加成新的数据格式内容
     */
    public void setOldEvent() {
        List<CmsActivity> cmsActivityList = activityMapper.setOldEvent();
        if (cmsActivityList != null && cmsActivityList.size() > 0) {
            for (CmsActivity activity : cmsActivityList) {
                String startEventTime = "";
                String endEventTime = "";
                String eventDate = "";
                if (StringUtils.isNotBlank(activity.getActivityStartTime())) {
                    String[] startTimeInfo = activity.getActivityStartTime().split(" ");
                    if (startTimeInfo.length == 2) {
                        activity.setActivityStartTime(startTimeInfo[0]);
                        startEventTime = startTimeInfo[1].length() > 5 ? startTimeInfo[1].substring(0, 5) : startTimeInfo[1];
                        eventDate = startTimeInfo[0];
                    }
                }
                if (StringUtils.isNotBlank(activity.getActivityEndTime())) {
                    String[] endTimeInfo = activity.getActivityEndTime().split(" ");
                    if (endTimeInfo.length == 2) {
                        activity.setActivityEndTime(endTimeInfo[0]);
                        endEventTime = endTimeInfo[1].length() > 5 ? endTimeInfo[1].substring(0, 5) : endTimeInfo[1];
                    }
                }
                activity.setEventCount(activity.getActivityReservationCount());
                //修改活动表的日期格式
                activityMapper.editCmsActivity(activity);
                //增加活动的场次信息
                CmsActivityEvent cmsActivityEvent = new CmsActivityEvent();
                cmsActivityEvent.setEventId(UUIDUtils.createUUId());
                cmsActivityEvent.setEventDateTime(eventDate + " " + startEventTime + "-" + endEventTime);
                cmsActivityEvent.setAvailableCount(activity.getActivityReservationCount());
                cmsActivityEvent.setEventDate(eventDate);
                cmsActivityEvent.setActivityId(activity.getActivityId());
                cmsActivityEvent.setEventTime(startEventTime + "-" + endEventTime);
                cmsActivityEventService.addActivityEvent(cmsActivityEvent);
                //订单表中添加场次管理
                cmsActivityOrderMapper.updateOrderEventByActivityId(cmsActivityEvent.getEventId(), activity.getActivityId());
            }
        }
    }


    /**
     * 数字文化管活动列表
     *
     * @return
     */
    @Override
    public List<CmsActivity> queryCmsActivityListLoad(CmsActivity activity, Pagination page) {
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("activityState", Constant.PUBLISH);
        map.put("activityIsDel", Constant.NORMAL);
        if (activity != null) {
            if (StringUtils.isNotBlank(activity.getActivityName())) {
                map.put("activityName", "%" + activity.getActivityName() + "%");
            }
            if (StringUtils.isNotBlank(activity.getActivityArea())) {
                map.put("activityArea", "%" + activity.getActivityArea() + "%");
            }
            if (StringUtils.isNotBlank(activity.getVenueId())) {
                map.put("venueId", activity.getVenueId());
            } else {
                List<String> venueIds = new ArrayList<String>();
                if (activity.getType() == 1) {
                    venueIds.add("bef466c630e44fbfbc2a599dba6eba35");
                    venueIds.add("c47e9bbdb86f4ac697643a4e6b947b00");
                    venueIds.add("4bf29ff59fc940fab57320c62133c356");
                    venueIds.add("65b1848d22814f2a954b396e115ddd0c");
                    venueIds.add("b380c6e7302f4804aaadaa521c217fbc");
                    venueIds.add("f413dc0e9c55446990b25c7a6964f8d8");
                    venueIds.add("18848c46a3eb449c9cb4caa361acca87");
                    venueIds.add("f46bdd086c164ffe9dbce38231b26f28");
                    venueIds.add("601bd98bd52d41119f83853424c3f0c8");
                    venueIds.add("15c3141477284ae785f4e50f2e153c14");
                    venueIds.add("f5b84ce14ceb434c94178df2e4e3d821");
                    venueIds.add("1ea1c41e5a234c26b80a32c063e8fc23");
                    venueIds.add("3b3ea6123221493288824587ddd310d0");
                    venueIds.add("fc26cd3dd20a400db0dea521e4d863da");
                    venueIds.add("272769af62604b289ff77d20d0cab405");
                    venueIds.add("9be32185a691484582ea78e44c6d8475");
                    venueIds.add("7a963356734c40b193bb4581d61fac40");
                    venueIds.add("b25e4337b251482e923ea5219a70e5af");
                    venueIds.add("7c50a6ee7ded41359d3313fe68fd9484");
                    venueIds.add("776c6567244d438eac825ee0b7a6097b");
                    venueIds.add("02508da4a5d94bf79cd88dedd1968fca");
                    venueIds.add("ef7a293fd39743e88a83889a923dd826");
                    venueIds.add("3c51c341a9ce4addae3bbe2833467932");
                    venueIds.add("f9c6b7fa2a44414aba95002349ae0090");
                } else if (activity.getType() == 2) {
                    venueIds.add("ac2d54aa291a41af93095cc5395466f9");
                    venueIds.add("a88e739284d241e489376f9bb423b39b");
                } else if (activity.getType() == 3) {
                    venueIds.add("1c0f86cc3b7d4d12b5caebaf82fc98cc");
                    venueIds.add("af2848a910d84ac193b15b3b33defadb");
                    venueIds.add("65862815c354432bb5f0915297efcfd5");
                    venueIds.add("c4a9631323704d9a8a04b9fad96f386e");
                    venueIds.add("f3b6adadf5044b6abd36616c2d9e6de8");
                    venueIds.add("19c05f19c07143069141c2fb03108540");
                    venueIds.add("b1bd76bff8334115ba1513a003b5aa36");
                    venueIds.add("3e62219c49734e4090c42e9fb33c82e3");
                    venueIds.add("0c3ebaf153884a04b2a316d931800c3b");
                    venueIds.add("49ed6c3c5368446d8e96fd6323b4e3e8");
                    venueIds.add("5e019e7ccbf9477bbd291ebde91918ff");
                    venueIds.add("8a6d1c381e3041deb311500c1de53da4");
                    venueIds.add("561d99fbd51f44bba25b287843c8d023");
                    venueIds.add("ca0a0d350a664b6a8aaa4e90bde60e7b");
                    venueIds.add("3951aa258a03483fbb68ef0b9607186a");
                    venueIds.add("eae22f63ecf945d6be1dc9f78b1e417c");
                    venueIds.add("f530b8e329cb4f50ba9a0614979a3e39");
                    venueIds.add("493bce056e4e4b4ea4a8f3564cc2129e");
                    venueIds.add("ab552926adbc4651b7223a5a541114be");
                    venueIds.add("19f9bdc5d9ce4bd58d80caeb10e1bf55");
                    venueIds.add("2e6e5d262acd4bc2ba4f9c87c928ea14");
                    venueIds.add("cdc8fbc00a414488a88516f32eaca69c");
                    venueIds.add("6305d3fdb018428089335d7c32d8e8cf");
                    venueIds.add("235756a944654f14b8fd1e1e22e8d866");
                    venueIds.add("5e8739f0511b4caeb05c974273b83b96");
                }
                map.put("venueIds", venueIds);
            }
        }
        //网页分页
        if (page != null && page.getFirstResult() != null && page.getRows() != null) {
            map.put("firstResult", page.getFirstResult());
            map.put("rows", page.getRows());
            page.setTotal(activityMapper.queryCmsActivityListLoadCount(map));
        }
        return activityMapper.queryCmsActivityListLoad(map);
    }

    /**
     * 数字文化管活动下属活动列表
     *
     * @return
     */
    @Override
    public List<CmsActivity> queryUnderlingActivityByCondition(CmsActivity activity, Pagination page) {
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("activityState", Constant.PUBLISH);
        map.put("activityIsDel", Constant.NORMAL);
        List<String> venueIds = new ArrayList<String>();
        if (activity.getType() == 1) {
            venueIds.add("bef466c630e44fbfbc2a599dba6eba35");
            venueIds.add("c47e9bbdb86f4ac697643a4e6b947b00");
            venueIds.add("4bf29ff59fc940fab57320c62133c356");
            venueIds.add("65b1848d22814f2a954b396e115ddd0c");
            venueIds.add("b380c6e7302f4804aaadaa521c217fbc");
            venueIds.add("f413dc0e9c55446990b25c7a6964f8d8");
            venueIds.add("18848c46a3eb449c9cb4caa361acca87");
            venueIds.add("f46bdd086c164ffe9dbce38231b26f28");
            venueIds.add("601bd98bd52d41119f83853424c3f0c8");
            venueIds.add("15c3141477284ae785f4e50f2e153c14");
            venueIds.add("f5b84ce14ceb434c94178df2e4e3d821");
            venueIds.add("1ea1c41e5a234c26b80a32c063e8fc23");
            venueIds.add("3b3ea6123221493288824587ddd310d0");
            venueIds.add("fc26cd3dd20a400db0dea521e4d863da");
            venueIds.add("272769af62604b289ff77d20d0cab405");
            venueIds.add("9be32185a691484582ea78e44c6d8475");
            venueIds.add("7a963356734c40b193bb4581d61fac40");
            venueIds.add("b25e4337b251482e923ea5219a70e5af");
            venueIds.add("7c50a6ee7ded41359d3313fe68fd9484");
            venueIds.add("776c6567244d438eac825ee0b7a6097b");
            venueIds.add("02508da4a5d94bf79cd88dedd1968fca");
            venueIds.add("ef7a293fd39743e88a83889a923dd826");
            venueIds.add("3c51c341a9ce4addae3bbe2833467932");
            venueIds.add("f9c6b7fa2a44414aba95002349ae0090");
        } else if (activity.getType() == 2) {
            venueIds.add("ac2d54aa291a41af93095cc5395466f9");
            venueIds.add("a88e739284d241e489376f9bb423b39b");
        } else if (activity.getType() == 3) {
            venueIds.add("1c0f86cc3b7d4d12b5caebaf82fc98cc");
            venueIds.add("af2848a910d84ac193b15b3b33defadb");
            venueIds.add("65862815c354432bb5f0915297efcfd5");
            venueIds.add("c4a9631323704d9a8a04b9fad96f386e");
            venueIds.add("f3b6adadf5044b6abd36616c2d9e6de8");
            venueIds.add("19c05f19c07143069141c2fb03108540");
            venueIds.add("b1bd76bff8334115ba1513a003b5aa36");
            venueIds.add("3e62219c49734e4090c42e9fb33c82e3");
            venueIds.add("0c3ebaf153884a04b2a316d931800c3b");
            venueIds.add("49ed6c3c5368446d8e96fd6323b4e3e8");
            venueIds.add("5e019e7ccbf9477bbd291ebde91918ff");
            venueIds.add("8a6d1c381e3041deb311500c1de53da4");
            venueIds.add("561d99fbd51f44bba25b287843c8d023");
            venueIds.add("ca0a0d350a664b6a8aaa4e90bde60e7b");
            venueIds.add("3951aa258a03483fbb68ef0b9607186a");
            venueIds.add("eae22f63ecf945d6be1dc9f78b1e417c");
            venueIds.add("f530b8e329cb4f50ba9a0614979a3e39");
            venueIds.add("493bce056e4e4b4ea4a8f3564cc2129e");
            venueIds.add("ab552926adbc4651b7223a5a541114be");
            venueIds.add("19f9bdc5d9ce4bd58d80caeb10e1bf55");
            venueIds.add("2e6e5d262acd4bc2ba4f9c87c928ea14");
            venueIds.add("cdc8fbc00a414488a88516f32eaca69c");
            venueIds.add("6305d3fdb018428089335d7c32d8e8cf");
            venueIds.add("235756a944654f14b8fd1e1e22e8d866");
            venueIds.add("5e8739f0511b4caeb05c974273b83b96");
        }
        map.put("venueIds", venueIds);
        if (activity != null && StringUtils.isNotBlank(activity.getActivityName())) {
            map.put("activityName", "%" + activity.getActivityName() + "%");
        }

        //网页分页
        if (page != null && page.getFirstResult() != null && page.getRows() != null) {
            map.put("firstResult", page.getFirstResult());
            map.put("rows", page.getRows());
            page.setTotal(activityMapper.queryUnderlingActivityCountByCondition(map));
        }
        return activityMapper.queryUnderlingActivityByCondition(map);
    }

    /**
     * 子系统和文化云数据对接活动添加  hucheng
     */
    @Override
    public String addAPIActivity(final CmsActivity activity, final SysUser sysUser, final String seatIds) {
        try {
            if (activity != null) {
                //获取活动的开始时间字符串，给下面方法用
                String activityStartTimesStr = activity.getActivityStartTime();
                String activityEndTimesStr = activity.getActivityEndTime();
                //文化云这边活动只保存年月日
                activity.setActivityStartTime(activity.getActivityStartTime().substring(0, 10));
                if (!"".equals(activityEndTimesStr)) {
                    activity.setActivityEndTime(activity.getActivityEndTime().substring(0, 10));
                }

                if (activity.getActivityLon() == null) {
                    activity.setActivityLon((double) 0);
                }
                if (activity.getActivityLat() == null) {
                    activity.setActivityLat((double) 0);
                }
                activity.setActivityId(UUIDUtils.createUUId());
                activity.setActivityCreateTime(new Date());
                activity.setPublicTime(new Date());
                activity.setActivityUpdateTime(new Date());
                activity.setActivityIsDel(Constant.NORMAL);
                if (activity.getActivityPrice() == null || StringUtils.isBlank(activity.getActivityPrice()))
                    activity.setActivityPrice("0");
                if (StringUtils.isBlank(activity.getActivityProvince())) {
                    activity.setActivityProvince(sysUser.getUserProvince());
                }
                if (StringUtils.isBlank(activity.getActivityCity())) {
                    activity.setActivityCity(sysUser.getUserCity());
                }
                if (StringUtils.isBlank(activity.getActivityArea())) {
                    activity.setActivityArea(sysUser.getUserCounty());
                }
                if (activity.getCreateActivityCode() != null) {
                    if (activity.getCreateActivityCode() == 1) {
                        activity.setActivityArea("45,上海市");
                    }
                }

                //保存用户信息上海子系统同步统一用 chuangtu_sh用户名
                SysUser syncUser = sysUserMapper.querySysUserByUserAccount("chuangtu_sh");
                activity.setActivityCreateUser(syncUser.getUserId());
                activity.setActivityUpdateUser(syncUser.getUserId());
                activity.setActivityDept(syncUser.getUserDeptPath());

//                Integer activityIsReservation = activity.getActivityIsReservation() != null ? activity.getActivityIsReservation() : 1;
//                if (activityIsReservation == 1) {
//                    activity.setActivitySalesOnline("N");
//                    activity.setActivityIsReservation(1);
//                } else if (activityIsReservation == 2) {
//                    activity.setActivityIsReservation(2);
//                    activity.setActivitySalesOnline("Y");
//                } else if (activityIsReservation == 3) {
//                    activity.setActivityIsReservation(2);
//                    activity.setActivitySalesOnline("N");
//                }
                //子系统过来的活动都不能预定
//                activity.setActivityIsReservation(activity.getActivityIsReservation() == null ? 1 : activity.getActivityIsReservation());
//                activity.setActivitySalesOnline(StringUtils.isBlank(activity.getActivitySalesOnline()) ? "N" : activity.getActivitySalesOnline());
                activity.setEventCount(activity.getActivityReservationCount());
                activityMapper.addCmsActivity(activity);

                //保存活动场馆关联关系
                if (StringUtils.isNotBlank(activity.getVenueId())) {
                    CmsActivityVenueRelevance relevance = new CmsActivityVenueRelevance();
                    relevance.setActivityId(activity.getActivityId());
                    relevance.setVenueId(activity.getVenueId());
                    relevanceMapper.addActivityVenueRelevance(relevance);
                }

                //得到时间段的信息
                String eventStartTimes[] = null;
                String eventEndTimes[] = null;
                List<String> eventTimeList = new ArrayList<String>();
                if (StringUtils.isNotBlank(activity.getEventStartTimes()) && StringUtils.isNotBlank(activity.getEventEndTimes())) {
                    eventStartTimes = activity.getEventStartTimes().split(",");
                    eventEndTimes = activity.getEventEndTimes().split(",");
                    if (eventStartTimes != null && eventStartTimes.length > 0) {
                        int index = 0;
                        for (String eventStart : eventStartTimes) {
                            String eventTime = eventStartTimes[index] + "-" + eventEndTimes[index];
                            eventTimeList.add(eventTime);
                            index++;
                        }
                    }
                }
                //保存座位 场次关联关系表
                //时间段信息 eventTimeList
                final List<String> eventTimeInfo = getEventTimeList(activity, eventTimeList);

                CmsActivityEvent cmsActivityEvent = new CmsActivityEvent();
                cmsActivityEvent.setEventId(UUIDUtils.createUUId());
                cmsActivityEvent.setActivityId(activity.getActivityId());
                cmsActivityEvent.setAvailableCount(activity.getActivityReservationCount());
                String[] dateStart = activityStartTimesStr.split(" ");
                cmsActivityEvent.setEventDate(dateStart[0].toString());
                if (!"".equals(activityEndTimesStr)) {
                    String[] dateEnd = activityEndTimesStr.split(" ");
                    cmsActivityEvent.setEventTime(dateStart[1].toString() + "-" + dateEnd[1].toString());
                    cmsActivityEvent.setEventDateTime(activityStartTimesStr + "-" + dateEnd[1].toString());
                } else {
                    cmsActivityEvent.setEventTime(dateStart[1].toString());
                    cmsActivityEvent.setEventDateTime(activityStartTimesStr + "-" + "23:59");
                }

                cmsActivityEvent.setAvailableCount(activity.getActivityReservationCount());
                cmsActivityEventService.addActivityEvent(cmsActivityEvent);


                //保存座位信息
                if ((seatIds != null && StringUtils.isNotBlank(seatIds)) || (activity.getActivityReservationCount() != null && activity.getActivityReservationCount() != 0)) {
                    try {
                        Runnable runnable = new Runnable() {
                            @Override
                            public void run() {
                                try {
                                    String activityEndTimeStr = activity.getActivityEndTime();
                                    if (StringUtils.isNotBlank(activity.getActivityEndTime())) {
                                        cmsActivitySeatService.addActivitySeatInfo(activity.getActivityId(), seatIds,
                                                activity.getActivityReservationCount(), sysUser,
                                                new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").parse(activity.getActivityStartTime() + " 23:59:59"), activity, eventTimeInfo);
                                    } else {
                                        cmsActivitySeatService.addActivitySeatInfo(activity.getActivityId(), seatIds,
                                                activity.getActivityReservationCount(), sysUser,
                                                new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").parse(activityEndTimeStr + " 23:59:59"), activity, eventTimeInfo);
                                    }

                                } catch (Exception e) {
                                    e.printStackTrace();
                                    throw new RuntimeException(e);
                                }
                            }
                        };
                        Thread thread = new Thread(runnable);
                        thread.start();
                    } catch (Exception ex) {
                        throw new RuntimeException(ex);
                    }
                }
            }
        } catch (Exception e) {
            logger.error("addActivity error {}", e);
            e.printStackTrace();
            throw new RuntimeException();
            // return Constant.RESULT_STR_FAILURE;
        }
        return Constant.RESULT_STR_SUCCESS;
    }


    @Override
    public String editActivityAPI(final CmsActivity cur, final SysUser sysUser, final String seatIds, final boolean hadOrder) {


        try {
            if (cur != null) {
                CmsActivity activity = queryCmsActivityByActivityId(cur.getActivityId());
                //存在订单时该值不能修改
                if (!hadOrder) {
//                    Integer activityIsReservation = cur.getActivityIsReservation() != null ? cur.getActivityIsReservation() : 1;
//                    if (activityIsReservation == 1) {
//                        cur.setActivitySalesOnline("N");
//                        cur.setActivityIsReservation(1);
//                    } else if (activityIsReservation == 2) {
//                        cur.setActivityIsReservation(2);
//                        cur.setActivitySalesOnline("Y");
//                    } else if (activityIsReservation == 3) {
//                        cur.setActivityIsReservation(2);
//                        cur.setActivitySalesOnline("N");
//                    }
                    cur.setEventCount(cur.getActivityReservationCount());
                } else {
                    cur.setActivityReservationCount(activity.getActivityReservationCount());
                }
                if (cur.getActivityLon() == null) {
                    cur.setActivityLon((double) 0);
                }
                if (cur.getActivityLat() == null) {
                    cur.setActivityLat((double) 0);
                }
                if (activity != null && StringUtils.isNotBlank(activity.getActivityName())
                        && StringUtils.isNotBlank(cur.getActivityName()) && !activity.getActivityName().trim().equals(cur.getActivityName().trim()))
                    //验证活动名称
                    if (StringUtils.isNotBlank(cur.getActivityName())) {
                        boolean exists = queryActivityNameIsExists(cur.getActivityName().trim());
                        if (exists) {
                            return Constant.RESULT_STR_REPEAT;
                        }
                    }
            }
            if (sysUser != null && StringUtils.isNotBlank(sysUser.getUserId())) {
/*                cur.setActivityUpdateUser(sysUser.getUserId());
                cur.setActivityUpdateTime(new Date());*/
                //编辑活动的时候保存用户信息上海子系统同步统一用 chuangtu_sh用户名
                SysUser syncUser = sysUserMapper.querySysUserByUserAccount("chuangtu_sh");
                cur.setActivityUpdateUser(syncUser.getUserId());
                cur.setActivityUpdateTime(new Date());
                /*cur.setActivityDept(syncUser.getUserDeptPath());*/
            }
            if (cur.getCreateActivityCode() != null) {
                if (cur.getCreateActivityCode() == 1) {
                    cur.setActivityArea("45,上海市");
                }
            }
            //cur.setActivityIsReservation(1);
            //获取活动的开始时间字符串，给下面方法用
            String activityStartTimesStr = cur.getActivityStartTime();
            cur.setActivityStartTime(cur.getActivityStartTime().substring(0, 10));

            //文化云这边活动只保存年月日
            String activityEndTimesStr = cur.getActivityEndTime();
            if (!"".equals(activityEndTimesStr)) {
                cur.setActivityEndTime(cur.getActivityEndTime().substring(0, 10));
            }

            int count = activityMapper.editCmsActivity(cur);
            if (count <= 0) {
                return Constant.RESULT_STR_FAILURE;
            }

            //删除活动场馆原有关联关系
            relevanceMapper.deleteActivityVenueRelevance(cur.getActivityId());
            //保存活动场馆新的关联关系
            if (StringUtils.isNotBlank(cur.getVenueId())) {
                CmsActivityVenueRelevance relevance = new CmsActivityVenueRelevance();
                relevance.setActivityId(cur.getActivityId());
                relevance.setVenueId(cur.getVenueId());
                relevanceMapper.addActivityVenueRelevance(relevance);
            }
            List<String> eventTimeInfo = new ArrayList<>();

            //根据活动id删除相对应的时间段记录，再重新插入数据
            cmsActivityEventService.deleteEventInfoByActivityId(cur.getActivityId());

            CmsActivityEvent cmsActivityEvent = new CmsActivityEvent();
            cmsActivityEvent.setEventId(UUIDUtils.createUUId());
            cmsActivityEvent.setActivityId(cur.getActivityId());
            cmsActivityEvent.setAvailableCount(cur.getActivityReservationCount());


            String[] dateStart = activityStartTimesStr.split(" ");
            cmsActivityEvent.setEventDate(dateStart[0].toString());

            if (!"".equals(activityEndTimesStr)) {
                String[] dateEnd = activityEndTimesStr.split(" ");
                cmsActivityEvent.setEventTime(dateStart[1].toString() + "-" + dateEnd[1].toString());
                cmsActivityEvent.setEventDateTime(activityStartTimesStr + "-" + dateEnd[1].toString());
            } else {
                cmsActivityEvent.setEventTime(dateStart[1].toString() + "-23:59");//+ "-23:00");
                cmsActivityEvent.setEventDateTime(activityStartTimesStr + "-23:59");//+"-23:00");
            }
            cmsActivityEvent.setAvailableCount(cur.getActivityReservationCount());
            cmsActivityEventService.addActivityEvent(cmsActivityEvent);
            //在没有生成订单的时候保存编辑后的座位信息
            if (((seatIds != null && StringUtils.isNotBlank(seatIds)) || cur.getActivityReservationCount() != null) && !hadOrder) {
                int seatCount = cmsActivitySeatService.queryCountByActivityId(cur.getActivityId());
                if (seatCount > 0 && seatIds != null && seatIds.length() > 0) {
                    //删除原来保存活动座位的信息
                    cmsActivitySeatService.deleteByActivityId(cur.getActivityId());
                }
                final List eventTimeInfos = eventTimeInfo;
                Runnable runnable = new Runnable() {
                    @Override
                    public void run() {
                        try {
                            if (StringUtils.isNotBlank(cur.getActivityEndTime())) {
                                cmsActivitySeatService.addActivitySeatInfo(cur.getActivityId(), seatIds, cur.getActivityReservationCount(), sysUser, new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").parse(cur.getActivityEndTime() + " 23:59:59"), cur, eventTimeInfos);
                            } else {
                                cmsActivitySeatService.addActivitySeatInfo(cur.getActivityId(), seatIds, cur.getActivityReservationCount(), sysUser, new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").parse(cur.getActivityStartTime() + " 23:59:59"), cur, eventTimeInfos);
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                            throw new RuntimeException(e);
                        }
                    }
                };
                Thread thread = new Thread(runnable);
                thread.start();

                /********编辑活动时 删除redis里的可能喜欢********/
                final String[] areaArr = cur.getActivityArea().split(",");
                Runnable command = new Runnable() {
                    @Override
                    public void run() {
                        cacheService.deleteValueByKey(CacheConstant.LIKE_ACTIVITY + areaArr[0]);
                    }
                };
                new Thread(command).start();

                //cmsActivitySeatService.addActivitySeatInfo(cur.getActivityId(), seatIds, cur.getActivityReservationCount(), sysUser, new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").parse(cur.getActivityEndTime() + ":00"),cur,eventTimeInfo);
            }
        } catch (Exception e) {
            logger.error("editActivity error {}", e);
            throw new RuntimeException(e);
           /* return Constant.RESULT_STR_FAILURE;*/
        }
        return Constant.RESULT_STR_SUCCESS;
    }


    /**
     * 图书管活动下属活动列表
     *
     * @return
     */
    @Override
    public List<CmsActivity> queryBookUnderlingActivityByCondition(CmsActivity activity, Pagination page) {
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("activityState", Constant.PUBLISH);
        map.put("activityIsDel", Constant.NORMAL);
        List<String> venueIds = new ArrayList<String>();
        if (activity.getType() == 1) {
            venueIds.add("552298559cd84541989b77b42c81168d");
        } else if (activity.getType() == 2) {
            venueIds.add("240f1e5988a143a49775d4152251e1f4");
        } else if (activity.getType() == 3) {
            venueIds.add("5845b3043a5344a0bbd561e5522fdb60");
        }
        map.put("venueIds", venueIds);
        if (activity != null && StringUtils.isNotBlank(activity.getActivityName())) {
            map.put("activityName", "%" + activity.getActivityName() + "%");
        }

        //网页分页
        if (page != null && page.getFirstResult() != null && page.getRows() != null) {
            map.put("firstResult", page.getFirstResult());
            map.put("rows", page.getRows());
            page.setTotal(activityMapper.queryUnderlingActivityCountByCondition(map));
        }
        return activityMapper.queryUnderlingActivityByCondition(map);
    }

    /**
     * 图书管活动列表
     *
     * @return
     */
    @Override
    public List<CmsActivity> queryBookCmsActivityListLoad(CmsActivity activity, Pagination page) {
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("activityState", Constant.PUBLISH);
        map.put("activityIsDel", Constant.NORMAL);
        if (activity != null) {
            if (StringUtils.isNotBlank(activity.getActivityName())) {
                map.put("activityName", "%" + activity.getActivityName() + "%");
            }
            if (StringUtils.isNotBlank(activity.getActivityArea())) {
                map.put("activityArea", "%" + activity.getActivityArea() + "%");
            }
            if (StringUtils.isNotBlank(activity.getVenueId())) {
                map.put("venueId", activity.getVenueId());
            } else {
                List<String> venueIds = new ArrayList<String>();
                if (activity.getType() == 1) {
                    venueIds.add("552298559cd84541989b77b42c81168d");
                } else if (activity.getType() == 2) {
                    venueIds.add("240f1e5988a143a49775d4152251e1f4");
                } else if (activity.getType() == 3) {
                    venueIds.add("5845b3043a5344a0bbd561e5522fdb60");
                }
                map.put("venueIds", venueIds);
            }
        }
        //网页分页
        if (page != null && page.getFirstResult() != null && page.getRows() != null) {
            map.put("firstResult", page.getFirstResult());
            map.put("rows", page.getRows());
            page.setTotal(activityMapper.queryCmsActivityListLoadCount(map));
        }
        return activityMapper.queryCmsActivityListLoad(map);
    }


    @Override
    public CmsActivity queryCmsActivityByActivityName(String activityName) {

        if (StringUtils.isNotBlank(activityName)) {
            return activityMapper.queryCmsActivityByActivityName(activityName);
        }
        return null;
    }


    /**
     * 根据活动对象查询首页栏目推荐活动列表信息
     *
     * @param activity 活动对象
     * @param page     分页对象
     * @return 活动列表信息
     */
    @Override
    public List<CmsActivity> queryAppRecommendCmsActivityByCondition(CmsActivity activity, Pagination page) {
        Map<String, Object> map = new HashMap<String, Object>();

        if (activity != null) {
            //活动名称
            if (activity != null && StringUtils.isNotBlank(activity.getActivityName())) {
                map.put("activityName", "%" + activity.getActivityName() + "%");
            }

            //活动区域
            if (activity != null && StringUtils.isNotBlank(activity.getActivityArea())) {
                map.put("activityArea", activity.getActivityArea() + "%");
            }

            if (StringUtils.isNotBlank(activity.getActivityTheme())) {

                //由于后台jsp页面选择的条件可能是活动主题，也可能是类型，所以以下代码用于判断
                // String resultStr =  sysDictMapper.queryDictNameByActivityTheme( activity.getActivityTheme());
                // if("活动类型".equals(resultStr)){
                //  map.put("activityType","%" + activity.getActivityTheme() + "%");
                // }else{
                map.put("activityTheme", "%" + activity.getActivityTheme() + "%");
                if (StringUtils.isNotBlank(activity.getActivityThemeTxt())) {
                    if ("免费看演出".equals(activity.getActivityThemeTxt())) {
                        // map.put("recommendColumnType", 1);
                    } else if ("孩子学艺术".equals(activity.getActivityThemeTxt())) {
                        // map.put("recommendColumnType", 2);
                    } else if ("周末去哪儿".equals(activity.getActivityThemeTxt())) {
                        // map.put("recommendColumnType", 3);
                    }
                } else {
                    //  map.put("recommendColumnType", 1);
                }
                // }


            } else {
                Map<String, Object> tagMap = new HashMap<String, Object>();
                tagMap.put("dictCode", Constant.ACTIVITY_THEME);
                tagMap.put("tagName", "免费看演出");
                String tagId = cmsTagService.queryTagIdByTagName(tagMap);
                if (StringUtils.isNotBlank(tagId)) {
                    map.put("activityTheme", "%" + tagId + "%");
                    //map.put("recommendColumnType", 1);
                }
            }
        }

        //分页
        if (page != null && page.getFirstResult() != null && page.getRows() != null) {
            map.put("firstResult", page.getFirstResult());
            map.put("rows", page.getRows());
            int total = activityMapper.queryAppRecommendCmsActivityCountByCondition(map);
            page.setTotal(total);
        }
        return activityMapper.queryAppRecommendCmsActivityByCondition(map);
    }

    /**
     * 文化云3.1前端首页即将开始的活动
     *
     * @param activity 活动对象
     * @param page     分布对象
     * @return
     */
    @Override
    public List<CmsActivity> queryWillStartActivity(CmsActivity activity, Pagination page) {
        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("currentDate", format.format(new Date()));
        if (StringUtils.isNotBlank(activity.getActivityArea())) {
            map.put("activityArea", activity.getActivityArea() + "%");
        }

        //分页
        if (page != null && page.getFirstResult() != null && page.getRows() != null) {
            map.put("firstResult", page.getFirstResult());
            map.put("rows", page.getRows());
        }
        List<CmsActivity> activityList = activityMapper.queryWillStartActivity(map);
        if (activityList.size() > 5) {
            Object[] obj = RandomUtils.getRandomNumber(activityList.size(), 5);
            List<CmsActivity> cmsActivityList = new ArrayList<CmsActivity>();
            for (Object a : obj) {
                cmsActivityList.add(activityList.get((int) a));
            }
            activityList = cmsActivityList;
        }
        /*Collections.sort(activityList, new Comparator<CmsActivity>(){
            public int compare(CmsActivity arg0, CmsActivity arg1) {
                return arg0.getActivityStartTime().compareTo(arg1.getActivityStartTime());
            }
        });*/
        return activityList;
    }

    /**
     * 文化云3.1前端首页本周活动
     *
     * @param activity 活动对象
     * @param page     分布对象
     * @return
     */
    @Override
    public List<CmsActivity> queryThisWeekActivity(CmsActivity activity, Pagination page) {
        Map<String, Object> map = new HashMap<String, Object>();
        if (StringUtils.isNotBlank(activity.getActivityStartTime())) {
            map.put("activityStartTime", activity.getActivityStartTime());
        }

        if (StringUtils.isNotBlank(activity.getActivityArea())) {
            map.put("activityArea", activity.getActivityArea() + "%");
        }

        //分页
        if (page != null && page.getFirstResult() != null && page.getRows() != null) {
            map.put("firstResult", page.getFirstResult());
            map.put("rows", page.getRows());
        }
        return activityMapper.queryThisWeekActivity(map);
    }

    /**
     * 文化云3.1前端首页猜你喜欢的活动
     *
     * @param activity 活动对象
     * @param page     分布对象
     * @return
     */
    @Override
    public List<CmsActivity> queryMayLikeActivity(CmsActivity activity, Pagination page) {
        Map<String, Object> map = new HashMap<String, Object>();
        if (StringUtils.isNotBlank(activity.getActivityArea())) {
            map.put("activityArea", activity.getActivityArea() + "%");
        }

        //分页
        if (page != null && page.getFirstResult() != null && page.getRows() != null) {
            map.put("firstResult", page.getFirstResult());
            map.put("rows", page.getRows());
        }
        return activityMapper.queryMayLikeActivity(map);
    }

    /**
     * 文化云3.1前端首页栏目(免费看演出、孩子学艺术、周末去哪儿)活动
     *
     * @return
     */
    @Override
    public List<CmsActivity> queryNavigationActivity() {

        return activityMapper.queryNavigationActivity();
    }

    /**
     * 活动我想去接口
     *
     * @param activityId 活动id
     * @param userId     用户id
     *                   return 是否报名成功 (成功：success；失败：false)
     */
    @Override
    public String addActivityUserWantgo(String activityId, String userId) {
        CmsUserWantgo activityUserWantgo = new CmsUserWantgo();
        activityUserWantgo.setSid(UUIDUtils.createUUId());
        activityUserWantgo.setCreateTime(new Date());
        activityUserWantgo.setRelateType(Constant.WANT_GO_ACTIVITY);
        if (StringUtils.isNotBlank(activityId)) {
            activityUserWantgo.setRelateId(activityId);
        }
        if (StringUtils.isNotBlank(userId)) {
            activityUserWantgo.setUserId(userId);
            CmsTerminalUser user = userMapper.queryTerminalUserById(userId);
            activityUserWantgo.setUserName(user.getUserName());
        }
        int result = cmsUserWantgoMapper.addUserWantgo(activityUserWantgo);
        if (result == 1) {
            return "success";
        } else {
            return "false";
        }
    }

    /**
     * 获取活动我想去列表接口
     *
     * @param activityUserWantgo
     * @return
     */
    @Override
    public List<CmsUserWantgo> queryActivityUserWantgoByCondition(Pagination page, CmsUserWantgo activityUserWantgo) {
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("relateType", Constant.WANT_GO_ACTIVITY);
        if (StringUtils.isNotBlank(activityUserWantgo.getRelateId())) {
            map.put("relateId", activityUserWantgo.getRelateId());
        }
        if (StringUtils.isNotBlank(activityUserWantgo.getUserId())) {
            map.put("userId", activityUserWantgo.getUserId());
        }
        //分页
        if (page != null && page.getFirstResult() != null && page.getRows() != null) {
            map.put("firstResult", page.getFirstResult());
            map.put("rows", page.getRows());
            int total = cmsUserWantgoMapper.queryUserWantgoCount(map);
            page.setTotal(total);
        }
        return cmsUserWantgoMapper.queryAppUserWantgoList(map);
    }

    /**
     * 获取活动我想去总人数
     *
     * @param activityUserWantgo
     * @return
     */
    @Override
    public int queryActivityUserWantgoCount(CmsUserWantgo activityUserWantgo) {
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("relateType", Constant.WANT_GO_ACTIVITY);
        if (StringUtils.isNotBlank(activityUserWantgo.getRelateId())) {
            map.put("relateId", activityUserWantgo.getRelateId());
        }
        return cmsUserWantgoMapper.queryUserWantgoCount(map);
    }

    /**
     * 前台用户的发布的活动列表
     *
     * @param cmsTerminalUser
     * @param states
     * @param page
     * @return
     */
    public List<CmsActivity> queryUserPublicActivityList(CmsTerminalUser cmsTerminalUser, Integer[] states, Pagination page) {
        Map map = new HashMap();
        map.put("activityTerminalUserId", cmsTerminalUser.getUserId());
        map.put("activityStates", states);
        map.put("activityIsDel", 1);
        map.put("activityPersonal", 1);
        if (page != null && page.getFirstResult() != null && page.getRows() != null) {
            map.put("firstResult", page.getFirstResult());
            map.put("rows", page.getRows());
            int total = queryUserPublicActivityListCount(map);
            page.setTotal(total);
        }
        return activityMapper.queryUserPublicActivityList(map);
    }


    /**
     * 前台用户的发布的活动列表的总数量
     *
     * @param map
     * @return
     */
    public int queryUserPublicActivityListCount(Map map) {
        return activityMapper.queryUserPublicActivityListCount(map);
    }


    /**
     * 保存前台用户发布的活动
     *
     * @param cmsActivity
     * @param cmsTerminalUser
     * @param count
     * @return
     */
    public String addActivity(final CmsActivity cmsActivity, CmsTerminalUser cmsTerminalUser, Integer count) {
        if (cmsActivity.getActivityState() != null && cmsActivity.getActivityState() != 3 && cmsActivity.getActivityState() != 8) {
            return "error info";
        }
        //表示可以预定
        if (cmsActivity.getActivityIsReservation() != 2) {
            cmsActivity.setActivityIsReservation(1);
        }
        cmsActivity.setActivityUpdateTime(new Date());
        cmsActivity.setActivityCreateTime(new Date());
        cmsActivity.setActivityIsDel(1);
        cmsActivity.setActivityReservationCount(cmsActivity.getEventCount());
        cmsActivity.setActivityId(UUIDUtils.createUUId());
        cmsActivity.setActivityTerminalUserId(cmsTerminalUser.getUserId());
        cmsActivity.setActivityIsFree(1);
        cmsActivity.setActivitySalesOnline("N");
        cmsActivity.setActivityPersonal(1);

        //得到时间段的信息
        String eventStartTimes[] = null;
        String eventEndTimes[] = null;
        List<String> eventTimeList = new ArrayList<String>();
        if (StringUtils.isNotBlank(cmsActivity.getEventStartTimes()) && StringUtils.isNotBlank(cmsActivity.getEventEndTimes())) {
            eventStartTimes = cmsActivity.getEventStartTimes().split(",");
            eventEndTimes = cmsActivity.getEventEndTimes().split(",");
            if (eventStartTimes != null && eventStartTimes.length > 0) {
                int index = 0;
                for (String eventStart : eventStartTimes) {
                    String eventTime = eventStartTimes[index] + "-" + eventEndTimes[index];
                    eventTimeList.add(eventTime);
                    index++;
                }
            }
        }
        //保存座位 场次关联关系表
        //时间段信息 eventTimeList
        final List<String> eventTimeInfo = getEventTimeList(cmsActivity, eventTimeList);
        if (eventTimeInfo != null && eventTimeInfo.size() > 0) {
            for (String eventTime : eventTimeInfo) {
                CmsActivityEvent cmsActivityEvent = new CmsActivityEvent();
                cmsActivityEvent.setEventId(UUIDUtils.createUUId());
                cmsActivityEvent.setActivityId(cmsActivity.getActivityId());
                cmsActivityEvent.setAvailableCount(cmsActivity.getEventCount());
                cmsActivityEvent.setEventDate(eventTime.split(" ")[0]);
                cmsActivityEvent.setEventTime(eventTime.split(" ")[1]);
                cmsActivityEvent.setEventDateTime(eventTime);
                cmsActivityEventService.addActivityEvent(cmsActivityEvent);
            }
        }
        if (cmsActivity.getActivityIsReservation() == 2) {
            Runnable runnable = new Runnable() {
                @Override
                public void run() {
                    try {
                        cmsActivitySeatService.addActivitySeatInfoByFrontUser(cmsActivity.getActivityId(), cmsActivity.getEventCount(), new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").parse(cmsActivity.getActivityEndTime() + " 23:59:59"), cmsActivity, eventTimeInfo);
                    } catch (Exception e) {
                        e.printStackTrace();
                        throw new RuntimeException(e);
                    }
                }
            };
            Thread thread = new Thread(runnable);
            thread.start();
        }
        return activityMapper.addCmsActivity(cmsActivity) > 0 ? Constant.RESULT_STR_SUCCESS : Constant.RESULT_STR_FAILURE;
    }


    /**
     * 更新前台用户发布的活动
     *
     * @param cmsActivity
     * @param cmsTerminalUser
     * @return
     */
    public String editPublicActivity(final CmsActivity cmsActivity, final CmsTerminalUser cmsTerminalUser) {
        //判断订单状态  如果已经审核通过不能进行修改
        CmsActivity preActivity = activityMapper.queryCmsActivityByActivityId(cmsActivity.getActivityId());
        if (preActivity == null) {
            return "error activity";
        } else if (preActivity.getActivityState() == 6) {
            return "该活动已经被发布,不能修改";
        }
        //判断重名
        if (preActivity != null && StringUtils.isNotBlank(preActivity.getActivityName())
                && StringUtils.isNotBlank(cmsActivity.getActivityName()) && !preActivity.getActivityName().trim().equals(cmsActivity.getActivityName().trim()))
            //验证活动名称
            if (StringUtils.isNotBlank(cmsActivity.getActivityName())) {
                boolean exists = queryActivityNameIsExists(cmsActivity.getActivityName().trim());
                if (exists) {
                    return "活动名称不能重复";
                }
            }

        //得到时间段的信息
        String eventStartTimes[] = null;
        String eventEndTimes[] = null;
        List<String> eventTimeList = new ArrayList<String>();
        if (StringUtils.isNotBlank(cmsActivity.getEventStartTimes()) && StringUtils.isNotBlank(cmsActivity.getEventEndTimes())) {
            eventStartTimes = cmsActivity.getEventStartTimes().split(",");
            eventEndTimes = cmsActivity.getEventEndTimes().split(",");
            if (eventStartTimes != null && eventStartTimes.length > 0) {
                int index = 0;
                for (String eventStart : eventStartTimes) {
                    String eventTime = eventStartTimes[index] + "-" + eventEndTimes[index];
                    eventTimeList.add(eventTime);
                    index++;
                }
            }
        }
        //保存座位 场次关联关系表
        //删除原来的 活动的场次信息
        int i = cmsActivityEventService.deleteEventInfoByActivityId(cmsActivity.getActivityId());
        //没有订单时 删除原来的场次信息
        final List<String> eventTimeInfo = getEventTimeList(cmsActivity, eventTimeList);
        if (eventTimeInfo != null && eventTimeInfo.size() > 0) {
            for (String eventTime : eventTimeInfo) {
                CmsActivityEvent cmsActivityEvent = new CmsActivityEvent();
                cmsActivityEvent.setEventId(UUIDUtils.createUUId());
                cmsActivityEvent.setActivityId(cmsActivity.getActivityId());
                cmsActivityEvent.setAvailableCount(cmsActivity.getActivityReservationCount());
                cmsActivityEvent.setEventDate(eventTime.split(" ")[0]);
                cmsActivityEvent.setEventTime(eventTime.split(" ")[1]);
                cmsActivityEvent.setEventDateTime(eventTime);
                cmsActivityEventService.addActivityEvent(cmsActivityEvent);
            }
        }
        if (cmsActivity.getActivityIsReservation() == 2) {
            Runnable runnable = new Runnable() {
                @Override
                public void run() {
                    try {
                        cmsActivitySeatService.addActivitySeatInfoByFrontUser(cmsActivity.getActivityId(), cmsActivity.getEventCount(), new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").parse(cmsActivity.getActivityEndTime() + " 23:59:59"), cmsActivity, eventTimeInfo);
                    } catch (Exception e) {
                        e.printStackTrace();
                        throw new RuntimeException(e);
                    }
                }
            };
            Thread thread = new Thread(runnable);
            thread.start();
        }


        return activityMapper.editCmsActivity(cmsActivity) > 0 ? Constant.RESULT_STR_SUCCESS : Constant.RESULT_STR_FAILURE;
    }


    @Override
    public String recommendActivity(String id, SysUser user, String platform) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM:dd HH:mm:ss");
        CmsActivity activity = queryCmsActivityByActivityId(id);
        if ("Y".equals(activity.getActivityRecommend())) {
            activity.setActivityRecommend(null);
            activity.setActivityRecommendTime(null);
//            CmsRecommend cmsRecommend = new CmsRecommend();
//            cmsRecommend.setRecommendType(Constant.RECOMMENT_ACTIVITY);
//            cmsRecommend.setRecommendLoc(1);
//            cmsRecommend.setRelatedId(activity.getActivityId());
//            List<CmsRecommend> recommendList = cmsRecommendService.queryCmsRecommend(cmsRecommend);
//            if (recommendList != null) {
//                for (int i = 0; i < recommendList.size(); i++) {
//                    cmsRecommend = recommendList.get(i);
//                    cmsRecommendService.deleteCmsRecommendById(cmsRecommend.getRecommendId());
//                }
//            }
        } else {
            activity.setActivityRecommend("Y");
            activity.setActivityRecommendTime(new Date());
//            CmsRecommend cmsRecommend = new CmsRecommend();
//            cmsRecommend.setRecommendId(UUIDUtils.createUUId());
//            cmsRecommend.setRelatedId(activity.getActivityId());
//            cmsRecommend.setRecommendType(Constant.RECOMMENT_ACTIVITY);
//            cmsRecommend.setRecommendLoc(1);
//            cmsRecommend.setRecommendUser(user.getUserId());
//            cmsRecommend.setRecommendTime(new Date());
//            cmsRecommendService.addCmsRecommend(cmsRecommend);
        }
        /**************2015.11.12 add niu  推荐_取消推荐 时不更新最后更新时间***************/
        //activity.setActivityUpdateTime(new Date());
        activity.setActivityUpdateUser(user.getUserId());
        int count = activityMapper.editRecommendCmsActivity(activity);
//        if ("APP".equals(platform)) {
//            if ("Y".equals(activity.getActivityRecommend())) {
//                CmsRecommendRelated cmsRecommendRelated = new CmsRecommendRelated();
//                cmsRecommendRelated.setRecommendId(UUIDUtils.createUUId());
//                cmsRecommendRelated.setRelatedId(activity.getActivityId());
//                cmsRecommendRelated.setRecommendType(1);
//                cmsRecommendRelated.setRecommendTime(new Date());
//                cmsRecommendRelated.setUpdateUserId(user.getUserId());
//                cmsRecommendRelated.setUpdateTime(new Date());
//                cmsRecommendRelated.setRecommendTarget(2);
//                cmsRecommendRelated.setRelatedName(activity.getActivityName());
//                recommendRelatedService.addRecommendRelated(cmsRecommendRelated);
//            } else {
//                recommendRelatedService.deleteById(activity.getActivityId());
//            }
//        }
        if (count == 0) {
            return Constant.RESULT_STR_FAILURE;
        } else {
            return Constant.RESULT_STR_SUCCESS;
        }

    }


    /**
     * 前台用户删除活动
     *
     * @param activityId
     * @return
     */
    public String delPublicActivityByFrontUser(String activityId) {
        CmsActivity cmsActivity = queryCmsActivityByActivityId(activityId);
        if (cmsActivity != null) {
            if (cmsActivity.getActivityState() == 6) {
                return "活动已经通过审核不能删除";
            }
            cmsActivity.setActivityIsDel(2);
            return activityMapper.editCmsActivity(cmsActivity) > 0 ? Constant.RESULT_STR_SUCCESS : Constant.RESULT_STR_FAILURE;
        } else {
            return "error activity";
        }
    }

    /**
     * 当redis 内存座位数量为空时手动的往redis 里面添加数据  防止线上出现票数为0的情况
     *
     * @param activityId
     * @return
     */
    public String frontSetRedisTicketCount(String activityId) throws ParseException {
        CmsActivity cmsActivity = queryCmsActivityByActivityId(activityId);
        //当活动为可预定时
        if (cmsActivity.getActivityIsReservation() == 2) {
            //得到该活动所有的场次
            List<CmsActivityEvent> activityEvents = cmsActivityEventService.queryCmsActivityEventByActivityId(activityId);
            DateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm");
            if (activityEvents != null && activityEvents.size() > 0) {
                //在线选座
                if ("Y".equals(cmsActivity.getActivitySalesOnline())) {
                    for (CmsActivityEvent activityEvent : activityEvents) {
                        //String ticketCountKey = activityId + activityEvent.getEventDateTime();
                        //内存数量
                        Integer redisTicketCount = cacheService.getSeatCountByActivityIdAndTime(activityId, activityEvent.getEventDateTime());
                        //数据库数量
                        Integer dataBaseCount = activityEvent.getAvailableCount();
                        if (redisTicketCount != dataBaseCount) {

                        }
                    }
                } else {
                    //自由入座
                    for (CmsActivityEvent activityEvent : activityEvents) {
                        //内存数量
                        Integer redisTicketCount = cacheService.getSeatCountByActivityIdAndTime(activityId, activityEvent.getEventDateTime());
                        //数据库数量
                        Integer dataBaseCount = activityEvent.getAvailableCount();
                        //得到预定的数量
                        Integer bookCount = cmsActivityOrderMapper.queryActivityBookCount(activityId);
                        Date eventDate = df.parse(activityEvent.getEventDateTime().substring(0, 16));
                        Date nowDate = new Date();
                        //判断场次是否过期
                        Date endDate = new SimpleDateFormat("yyyy-MM-dd").parse(cmsActivity.getActivityEndTime());
                        //未过期时
                        if (nowDate.before(eventDate)) {
                            if (redisTicketCount != dataBaseCount && redisTicketCount == 0) {
                                if (cmsActivity.getEventCount() - bookCount != redisTicketCount) {
                                    Integer count = cmsActivity.getEventCount() - bookCount;
                                    cacheService.addActivityTicketCount(activityId, count, endDate, activityEvent.getEventDateTime());
                                }
                            }
                        }
                    }
                }
            }
        } else {
            return "can not book";
        }
        return Constant.RESULT_STR_SUCCESS;
    }


    /**
     * 向数据库和内存 插入正确的余票数
     *
     * @param activityId
     * @return
     */
    public String setRightToRedisAndDataBase(String activityId, String eventId) throws Exception {
        CmsActivity cmsActivity = queryCmsActivityByActivityId(activityId);

        //计算出可以被预定的剩余票数
        int effectiveTicketCount = cmsActivityOrderMapper.queryEffectiveTicketCountByActivityId(activityId, eventId);
        CmsActivityEvent cmsActivityEvent = cmsActivityEventService.queryByEventId(eventId);
        //自由入座的情况
        if ("N".equals(cmsActivity.getActivitySalesOnline()) && cmsActivity.getActivityIsReservation() == 2) {
            cmsActivityEvent.setAvailableCount(effectiveTicketCount);
            //修改数据库数量
            int count = cmsActivityEventService.editByActivityEvent(cmsActivityEvent);
/*            if (count > 0) {*/
            //修改内存数量
            DateFormat df = new SimpleDateFormat("yyyy-MM-dd 23:59");
            cacheService.updateSeatCountByIdAndTime(activityId, df.parse(cmsActivityEvent.getEventDate() + " 23:59"), cmsActivityEvent.getEventDateTime(), String.valueOf(effectiveTicketCount));
/*            }*/
        } else if ("Y".equals(cmsActivity.getActivitySalesOnline())) {
            //  在线选坐情况
            Map map = new HashMap();
            map.put("activityId", activityId);
            //查询活动座位模板
            List<CmsActivitySeat> seatList = cmsActivitySeatService.queryCmsActivitySeatCondition(map);
            //
            List<CmsActivitySeat> newSeatList = new ArrayList<CmsActivitySeat>();
            //查询已经产生的有效订单
            map.put("eventId", eventId);
            List<CmsActivityOrderDetail> orderDetailList = cmsActivityOrderDetailMapper.queryCmsActivityOrderDetailByActivityIdAndEventId(map);
           /* if (orderDetailList != null && orderDetailList.size() > 0) {*/
            //工具方法 将 orderDetailList 的值放置Map 中
            LinkedHashMap seatStatuMap = new LinkedHashMap();
            for (CmsActivityOrderDetail orderDetail : orderDetailList) {
                seatStatuMap.put(orderDetail.getSeatCode(), orderDetail.getSeatStatus());
            }
               /* if (orderDetailList != null && orderDetailList.size() > 0) {*/
            //有订单的时候 比较哪些订单是有效的  放至座位的时候根据订单来座位状态来放
            LinkedHashMap seatMap = new LinkedHashMap();
            for (CmsActivitySeat cmsActivitySeat : seatList) {
                if (seatStatuMap.containsKey(cmsActivitySeat.getSeatCode())) {
                    //修改座位状态放置 重新放至内存中
                    cmsActivitySeat.setSeatStatus(2);
                }
                if (cmsActivitySeat.getSeatStatus() == 1) {

                }
                seatMap.put(cmsActivitySeat.getSeatCode(), cmsActivitySeat);
            }
               /* }*/
            //得到活动中可能存在的其他内存的数据
            Map eventMap = cacheService.getSeatEventMapById(activityId);
            if (eventMap == null || eventMap.size() == 0) {
                eventMap = new HashMap();
            }
/*                if (eventMap.containsKey(cmsActivityEvent.getEventDateTime())) {
                    eventMap.put(cmsActivityEvent.getEventDateTime(),seatMap);

                } else {*/
            eventMap.put(cmsActivityEvent.getEventDateTime(), seatMap);
/*                }*/
            //重新将座位信息放至内存中
            DateFormat df = new SimpleDateFormat("yyyy-MM-dd 23:59");
            cacheService.setValueToRedis(activityId.getBytes(), ListTranscoder.serialize(eventMap), df.parse(cmsActivityEvent.getEventDate() + " 23:59"));
            //设置nei座位的票数]
               /* cacheService.setSeatCount(activityId,String.valueOf(effectiveTicketCount),df.parse(cmsActivityEvent.getEventDate() + " 23:59"))*/
            String key = (CacheConstant.ACTIVITY_TICKET_COUNT + activityId + "_" + cmsActivityEvent.getEventDateTime());
            cacheService.setValueToRedis(key, String.valueOf(effectiveTicketCount), df.parse(cmsActivityEvent.getEventDate() + " 23:59"));
            cmsActivityEvent.setAvailableCount(effectiveTicketCount);
            //修改数据库数量
            int count = cmsActivityEventService.editByActivityEvent(cmsActivityEvent);
           /* } else {
                //无订单的时候 整个重新放至内存中
                DateFormat df = new SimpleDateFormat("yyyy-MM-dd 23:59");
                List eventDateTimeList = new ArrayList();
                eventDateTimeList.add(cmsActivityEvent.getEventDateTime());
                cacheService.setActivitySeat(activityId, seatList ,df.parse(cmsActivityEvent.getEventDate()),cmsActivity,eventDateTimeList);
            }*/
        }
        return Constant.RESULT_STR_SUCCESS;
    }


    /**
     * 查询所有正在进行未过期的活动 且数据库剩余票数和 redis 票数不一致
     *
     * @return
     */
    public List<ActivityForCompare> queryOngoingActivityCanBook() {
        List<CmsActivity> cmsActivities = activityMapper.queryOngoingActivityCanBook();
        List<ActivityForCompare> compareList = new ArrayList<>();
        if (cmsActivities != null && cmsActivities.size() > 0) {
            for (CmsActivity cmsActivity : cmsActivities) {
                String activityId = cmsActivity.getActivityId();
                String eventDateTime = cmsActivity.getEventDateTimes();
                Integer redisCount = cacheService.getSeatCountByActivityIdAndTime(activityId, eventDateTime);
                Integer dataBaseCount = cmsActivity.getAvailableCount();
                //应该剩余的余票数
                Integer effectiveTicketCount = cmsActivityOrderMapper.queryEffectiveTicketCountByActivityId(activityId, cmsActivity.getEventIds());
                //比较数据库  和redis 的票数是否一直  以及根据数据库订单计算出来的值
                if (redisCount != dataBaseCount || redisCount != effectiveTicketCount) {
                    ActivityForCompare activityForCompare = new ActivityForCompare();
                    activityForCompare.setActivityId(cmsActivity.getActivityId());
                    activityForCompare.setActivityName(cmsActivity.getActivityName());
                    activityForCompare.setDataBaseCount(dataBaseCount);
                    activityForCompare.setRedisCount(redisCount);
                    activityForCompare.setType(cmsActivity.getActivitySalesOnline());
                    activityForCompare.setTotalCount(cmsActivity.getActivityReservationCount());
                    activityForCompare.setEventDateTime(eventDateTime);
                    activityForCompare.setEventId(cmsActivity.getEventIds());
                    //活动预定的总票数  有效的票数
                    Integer bookCount = cmsActivityOrderMapper.queryBookTicketCountByActivityId(cmsActivity.getActivityId(), cmsActivity.getEventIds());
                    activityForCompare.setBookCount(bookCount);
                    activityForCompare.setRightCount(effectiveTicketCount);
                    compareList.add(activityForCompare);
                }
            }
            return compareList;
        } else

        {
            return null;
        }
    }


    /**
     * 根据查询出的座位列表绘制前台展示座位信息
     *
     * @param activitySeatList
     * @return
     */
    public Map<String, Object> getSeatInfoByList(List<CmsActivitySeat> activitySeatList) {
        StringBuilder seatInfoBuilder = new StringBuilder();
        StringBuilder vipInfoBuilder = new StringBuilder();
        StringBuilder maintananceBuilder = new StringBuilder();
        String normalSeat = "a";        //正常
        String deleteSeat = "D";        //删除
        String occupySeat = "U";        //占用
        String giveSeat = "G";          //赠票
        String maintenanceSeat = "m";
        String vipSeat = "v";
        //可预订的余票数量
        Integer canBookCount = 0;
        int tmpVar = 1;
        Integer maxColumn = 0;
        for (int i = 0; i < activitySeatList.size(); i++) {
            CmsActivitySeat activitySeat = activitySeatList.get(i);
            String row = activitySeat.getSeatRow().toString();
            String column = activitySeat.getSeatColumn().toString();
            if (Integer.parseInt(column) > maxColumn) {
                maxColumn = Integer.parseInt(column);
            }
            if (tmpVar != activitySeat.getSeatRow()) {
                seatInfoBuilder.append(",");
                tmpVar++;
            }
/*            //判断是否在放票时间断
            if ((activitySeat.getSeatOpenTime() != null && activitySeat.getSeatOpenTime().after(new Date()))){
                seatInfoBuilder.append(normalSeat + "[" + row + "_" + column  +"-" +activitySeat.getSeatVal() + "]");
                vipInfoBuilder.append( row + "_" + column + ",");
            } else {*/
            if (Integer.valueOf(activitySeat.getSeatStatus()) == Constant.VENUE_SEAT_STATUS_NORMAL) {
                seatInfoBuilder.append(normalSeat + "[" + row + "_" + column + "-" + activitySeat.getSeatVal().split("_")[1] + "]");
                canBookCount++;
            }
            if (Integer.valueOf(activitySeat.getSeatStatus()) == Constant.VENUE_SEAT_STATUS_NONE) {
                seatInfoBuilder.append("_");
            }
            //占用
            if (Integer.valueOf(activitySeat.getSeatStatus()) == Constant.VENUE_SEAT_STATUS_MAINTANANCE) {
                //seatInfoBuilder.append(maintenanceSeat);
                seatInfoBuilder.append(normalSeat + "[" + row + "_" + column + "-" + activitySeat.getSeatVal().split("_")[1] + "]");
                //maintananceBuilder.append(venueSeat.getSeatCode()+",");
                vipInfoBuilder.append(activitySeat.getSeatCode() + ",");
            }
/*                if(Integer.valueOf(activitySeat.getSeatStatus()) == Constant.VENUE_SEAT_STATUS_OCCUPY){
                    seatInfoBuilder.append(normalSeat + "[" + row + "_" + column  +"-" +activitySeat.getSeatVal() + "]");
                    vipInfoBuilder.append( row + "_" + column + ",");
                }*/
            if (Integer.valueOf(activitySeat.getSeatStatus()) == Constant.VENUE_SEAT_STATUS_VIP) {
                seatInfoBuilder.append(occupySeat);
                seatInfoBuilder.append(normalSeat + "[" + row + "_" + column + "-" + activitySeat.getSeatVal().split("_")[1] + "]");
                vipInfoBuilder.append(row + "_" + column + ",");
            }
        }
       /* }*/
        if (vipInfoBuilder.length() > 0)
            vipInfoBuilder.deleteCharAt(vipInfoBuilder.length() - 1);
        String seatInfo = seatInfoBuilder.toString();
        Map map = new HashMap();
        map.put("seatInfo", seatInfo);
        map.put("vipInfo", vipInfoBuilder.toString());
        map.put("maxColumn", maxColumn);
        return map;
    }


    private Map getSubSystemSeatInfo(CmsActivity cmsActivity, String eventDateTime) throws Exception {
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
                        CmsActivityEvent cmsActivityEvent = cmsActivityEventService.queryEventByActivityAndTime(cmsActivity.getActivityId(), eventDateTime);
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
     * 返回活动的座位信息 判断是文化云系统还是嘉定子系统信息
     *
     * @param activityId
     * @return
     */
    public Map queryActivitySeatInfo(String activityId, String eventDateTime) throws Exception {
        CmsActivity cmsActivity = queryCmsActivityByActivityId(activityId);
        //嘉定活动座位
        if ("1".equals(cmsActivity.getSysNo())) {
            // 发送http 请求至嘉定系统中获取座位信息
            return getSubSystemSeatInfo(cmsActivity, eventDateTime);
        } else {
            //文化云座位信息
            Map rsMap = new HashMap();
            List<CmsActivitySeat> list = cacheService.getSeatInfoByIdAndTime(activityId, eventDateTime);
            //可以预定的票数
            Integer ticketCount = cacheService.getSeatCountByActivityIdAndTime(activityId, eventDateTime);
            //得到场次id
            CmsActivityEvent cmsActivityEvent = cmsActivityEventService.queryEventByActivityAndTime(activityId, eventDateTime);
            if (cmsActivityEvent != null) {
                rsMap.put("eventId", cmsActivityEvent.getEventId());
            } else {
                rsMap.put("success", "N");
                return rsMap;
            }
            if (list != null) {
                Map<String, Object> map = getSeatInfoByList(list);
                String seatInfo = map.get("seatInfo") == null ? "" : map.get("seatInfo").toString();
                Integer maxColumn = Integer.valueOf(map.get("maxColumn").toString());
                String maintananceInfo = map.get("maintananceInfo") == null ? "" : map.get("maintananceInfo").toString();
                String vipInfo = map.get("vipInfo") == null ? "" : map.get("vipInfo").toString();
                rsMap.put("venueSeatList", list);
                rsMap.put("seatInfo", seatInfo);
                rsMap.put("maintananceInfo", maintananceInfo);
                rsMap.put("vipInfo", vipInfo);
                rsMap.put("maxColumn", maxColumn.toString());
                rsMap.put("ticketCount", ticketCount);
                rsMap.put("success", "Y");
            }
            return rsMap;
        }
    }


    /**
     * 查询活动详情页面内容
     *
     * @param activityId
     * @return
     */
    public Map queryFrontDetailInfo(String activityId) throws Exception {
        Map map = new HashMap();
        CmsActivity cmsActivity = queryCmsActivityByActivityId(activityId);
        if (cmsActivity == null) {
            return null;
        }
        if ("1".equals(cmsActivity.getSysNo()) && StringUtils.isNotBlank(cmsActivity.getSysId())) {
            //为嘉定活动时
            Map map1 = getSubSystemTicketCount(cmsActivity);
            if (map1 != null && "Y".equals(map1.get("success"))) {
                Integer ticketCount = Integer.valueOf(map1.get("ticketCount") == null ? "0" : map1.get("ticketCount").toString());
                cmsActivity.setActivityReservationCount(ticketCount);
            }
        }
        map.put("cmsActivity", cmsActivity);
        //推荐活动
        Pagination page = new Pagination();
        page.setRows(3);
        List<CmsActivity> cmsActivityList = getRelateActivity(cmsActivity, page);
        map.put("cmsActivityList", cmsActivityList);
        //得到时间段
        List<CmsActivityEvent> activityEventList = cmsActivityEventService.queryEventTimeByActivityId(activityId);
        map.put("activityEventList", activityEventList);
        try {
            String createTime = new SimpleDateFormat("yyyy-MM-dd HH:mm").format(cmsActivity.getActivityCreateTime());
            map.put("createTime", createTime);
            //判断时间是否过期
            String endDate = "";
            if (activityEventList != null && activityEventList.size() > 0) {
                endDate = activityEventList.get(activityEventList.size() - 1).getEventTime();
            }
            if (StringUtils.isNotBlank(cmsActivity.getActivityEndTime())) {
                if (new SimpleDateFormat("yyyy-MM-dd HH:mm").parse(cmsActivity.getActivityEndTime() + " " + endDate.split("-")[0]).before(new Date())) {
                    map.put("isOver", "Y");
                } else {
                    map.put("isOver", "N");
                }
            } else {
                if (new SimpleDateFormat("yyyy-MM-dd HH:mm").parse(cmsActivity.getActivityStartTime() + " " + endDate.split("-")[0]).before(new Date())) {
                    map.put("isOver", "Y");
                } else {
                    map.put("isOver", "N");
                }
            }

        } catch (Exception ex) {
            //判断时间是否过期
            map.put("isOver", "Y");
        }
        return map;
    }


    /**
     * 得到嘉定子系统的可预定票数
     *
     * @param cmsActivity
     * @param
     * @return
     * @throws Exception
     */
    private Map getSubSystemTicketCount(CmsActivity cmsActivity) throws Exception {
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


    /**
     * @param activity
     * @param page
     * @param isWeekend  1-周末 0-工作日
     * @param chooseType 筛选类别1(5天之内) 2(5-10天) 3(10-15天) 4(15天以后)
     * @param bookType   1-可预订 0-不可预订 空表示所有
     * @return
     */
    public List<CmsActivity> queryIndexActivityByCondition(CmsActivity activity, Pagination page, String isWeekend, String chooseType, String sortType, String bookType, CmsTerminalUser terminalUser) {
        Map map = new HashMap();
        //
        if (terminalUser != null && StringUtils.isNotBlank(terminalUser.getUserId())) {
            map.put("userId", terminalUser.getUserId());
        }
        if (StringUtils.isNotBlank(activity.getActivityType())) {
            map.put("activityType", "%" + activity.getActivityType() + "%");
        }
        if (StringUtils.isNotBlank(activity.getActivityName())) {
            map.put("activityName", "%" + activity.getActivityName() + "%");
        }
        if (StringUtils.isNotBlank(activity.getActivityArea())) {
            map.put("activityArea", "%" + activity.getActivityArea() + ",%");
        }
        if (StringUtils.isNotBlank(activity.getActivityLocation())) {
            map.put("activityLocation", activity.getActivityLocation());
        }
        if (StringUtils.isNotBlank(sortType)) {
            map.put("sortType", Integer.parseInt(sortType));
        }
        if (StringUtils.isNotBlank(chooseType)) {
            SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm");
            Calendar cal = Calendar.getInstance();
            switch (chooseType) {
                case "1":
                    map.put("startTime", format.format(cal.getTime()));
                    cal.add(Calendar.DATE, 5);
                    map.put("endTime", format.format(cal.getTime()));
                    break;
                case "2":
                    cal.add(Calendar.DATE, 5);
                    map.put("startTime", format.format(cal.getTime()));
                    cal.add(Calendar.DATE, 5);
                    map.put("endTime", format.format(cal.getTime()));
                    break;
                case "3":
                    cal.add(Calendar.DATE, 10);
                    map.put("startTime", format.format(cal.getTime()));
                    cal.add(Calendar.DATE, 5);
                    map.put("endTime", format.format(cal.getTime()));
                    break;
                case "4":
                    cal.add(Calendar.DATE, 15);
                    map.put("startTime", format.format(cal.getTime()));
                    break;
                default:
                    break;
            }

        }
        if (StringUtils.isNotBlank(bookType)) {
            map.put("bookType", bookType);
        }
        if (page != null && page.getFirstResult() != null && page.getRows() != null) {
            map.put("firstResult", page.getFirstResult());
            map.put("rows", page.getRows());
//            page.setTotal(activityMapper.queryIndexActivityCountByCondition(map));
        }

        return activityMapper.queryIndexActivityByCondition(map);
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
     * 后台查询活动下的场次
     *
     * @param activityId
     * @return
     */
    public List<CmsActivityEvent> queryCmsActivityEventByActivityId(String activityId) {
        if (activityId != null) {
            return cmsActivityEventService.queryCmsActivityEventByActivityId(activityId);
        } else {
            return null;
        }
    }

    @Override
    public int addActivity(CmsActivity activity) {

        return activityMapper.addCmsActivity(activity);
    }

    @Override
    public String copyActivity(final String activityId, final SysUser sysUser) {
        try {
            CmsActivity activity = this.queryCmsActivityByActivityId(activityId);
            if (activity != null) {
                UserAddress address = new UserAddress();
                if (StringUtils.isNotBlank(activity.getAddressId())) {
                    address = userAddressMapper.selectAddressById(activity.getAddressId());
                    if (address.getActivityLon() != null) {
                        activity.setActivityLon(address.getActivityLon());
                    }
                    if (address.getActivityLat() != null) {
                        activity.setActivityLat(address.getActivityLat());
                    }
                } else {
                    if (activity.getActivityLon() == null) {
                        activity.setActivityLon((double) 0);
                    }
                    if (activity.getActivityLat() == null) {
                        activity.setActivityLat((double) 0);
                    }
                }

                if (activity.getActivityLon() == null) {
                    activity.setActivityLon((double) 0);
                }
                if (activity.getActivityLat() == null) {
                    activity.setActivityLat((double) 0);
                }
                if (StringUtils.isBlank(activity.getActivityId())) {
                    activity.setActivityId(UUIDUtils.createUUId());
                }
                activity.setActivityCreateTime(new Date());
                activity.setPublicTime(new Date());
                activity.setActivityUpdateTime(new Date());
                activity.setActivityIsDel(Constant.NORMAL);
                if (activity.getActivityState() == 6) {
                    activity.setPublicTime(new Date());
                }
                if (activity.getActivityPrice() == null || StringUtils.isBlank(activity.getActivityPrice()))
                    activity.setActivityPrice("0");
                if (StringUtils.isBlank(activity.getActivityProvince())) {
                    activity.setActivityProvince(sysUser.getUserProvince());
                }
                if (StringUtils.isBlank(activity.getActivityCity())) {
                    activity.setActivityCity(sysUser.getUserCity());
                }
                if (StringUtils.isBlank(activity.getActivityArea())) {
                    activity.setActivityArea(sysUser.getUserCounty());
                }
                if (activity.getCreateActivityCode() != null) {
                    if (activity.getCreateActivityCode() == 1) {
                        activity.setActivityArea("45,上海市");
                    }
                }
                if (sysUser != null) {
                    activity.setActivityCreateUser(sysUser.getUserId());
                    activity.setActivityUpdateUser(sysUser.getUserId());
                    activity.setActivityDept(sysUser.getUserDeptPath());
                }
                Integer activityIsReservation = activity.getActivityIsReservation() != null ? activity.getActivityIsReservation() : 1;
                if (activityIsReservation == 1) {
                    activity.setActivitySalesOnline("N");
                    activity.setActivityIsReservation(1);
                    activity.setActivitySupplementType(1);
                } else if (activityIsReservation == 2) {
                    activity.setActivityIsReservation(2);
                    activity.setActivitySalesOnline("Y");
                } else if (activityIsReservation == 3) {
                    activity.setActivityIsReservation(2);
                    activity.setActivitySalesOnline("N");
                }else if (activityIsReservation == 4) {
                    activity.setActivityIsReservation(1);
                    activity.setActivitySalesOnline("N");
                    activity.setActivitySupplementType(2);
                }else if (activityIsReservation == 5) {
                    activity.setActivityIsReservation(1);
                    activity.setActivitySalesOnline("N");
                    activity.setActivitySupplementType(3);
                }
                activity.setEventCount(activity.getActivityReservationCount());
                activityMapper.addCmsActivity(activity);

                //保存活动场馆关联关系
                if (StringUtils.isNotBlank(activity.getVenueId())) {
                    CmsActivityVenueRelevance relevance = new CmsActivityVenueRelevance();
                    relevance.setActivityId(activity.getActivityId());
                    relevance.setVenueId(activity.getVenueId());
                    relevanceMapper.addActivityVenueRelevance(relevance);
                }
                String eventDate[] = activity.getEventDate().split(",");
                String eventTime[] = activity.getEventTime().split(",");
                String spikeTimes[] = null;
                if (StringUtils.isNotBlank(activity.getSpikeTimes())) {
                    spikeTimes = activity.getSpikeTimes().split(",");
                }
                String availableCount[] = null;
                if (StringUtils.isNotBlank(activity.getAvaliableCount())) {
                    availableCount = activity.getAvaliableCount().split(",");
                }
                String orderPrice[] = activity.getOrderPrice().split(",");
                String seatId[] = null;
                if (StringUtils.isNotBlank(activity.getSeatIds())) {
                    seatId = activity.getSeatIds().split(";");
                }
                if (activity.getActivityIsReservation() != 1) {
                    for (int i = 0; i < eventDate.length; i++) {
                        CmsActivityEvent activityEvent = new CmsActivityEvent();
                        activityEvent.setEventId(UUIDUtils.createUUId());
                        activityEvent.setActivityId(activity.getActivityId());
                        activityEvent.setEventDate(eventDate[i]);
                        activityEvent.setSingleEvent(activity.getSingleEvent());
                        if (activity.getSingleEvent() == 1) {
                            activityEvent.setEventDateTime(activity.getActivityEndTime() + " " + eventTime[i]);
                            activityEvent.setEventEndDate(activity.getActivityEndTime());
                        } else {
                            activityEvent.setEventDateTime(eventDate[i] + " " + eventTime[i]);
                            activityEvent.setEventEndDate(eventDate[i]);
                        }
                        activityEvent.setEventTime(eventTime[i]);
                        if(activity.getSpikeType()!=null&&activity.getSpikeType()!=0){
                        	 activityEvent.setSpikeType(activity.getSpikeType());
                             if (StringUtils.isNotBlank(activity.getSpikeTimes())) {
                                 activityEvent.setSpikeTime(new SimpleDateFormat("yyyy-MM-dd HH:mm").parse(spikeTimes[i]));
                             }
                        }
                       
                        if (activity.getActivityIsFree() == 2) {
                            activityEvent.setOrderPrice(orderPrice[i]);
                        }
                        if (StringUtils.isNotBlank(availableCount[i])) {
                            activityEvent.setAvailableCount(Integer.parseInt(availableCount[i]));
                        } else {
                            activityEvent.setAvailableCount(Integer.parseInt(activity.getAvaliableCount()));
                        }
                        cmsActivityEventService.addActivityEvent(activityEvent);
                        if (activity.getSingleEvent() == 0) {
                            if (StringUtils.isNotBlank(activity.getSeatIds())) {
                                activityEvent.setSeatIds(seatId[i]);
                                cmsActivitySeatService.addEventSeatInfo(activityEvent, sysUser);
                            }
                        } else {
                            if (i == 0 && StringUtils.isNotBlank(activity.getSeatIds())) {
                                activityEvent.setSeatIds(seatId[i]);
                                cmsActivitySeatService.addEventSeatInfo(activityEvent, sysUser);
                            }
                        }
                    }
                } else {
                    CmsActivityEvent activityEvent = new CmsActivityEvent();
                    activityEvent.setEventId(UUIDUtils.createUUId());
                    activityEvent.setActivityId(activity.getActivityId());
                    activityEvent.setEventDate(activity.getActivityStartTime());
                    activityEvent.setEventTime(activity.getActivityTime());
                    activityEvent.setEventEndDate(activity.getActivityEndTime());
                    activityEvent.setEventDateTime(activity.getActivityEndTime() + " " + activity.getActivityTime());
                    cmsActivityEventService.addActivityEvent(activityEvent);
                }
            }
        } catch (Exception e) {
            logger.error("addActivity error {}", e);
            e.printStackTrace();
            throw new RuntimeException();
        }
        return Constant.RESULT_STR_SUCCESS;
    }

	@Override
	public List<CmsActivity> queryActivityFromSpecialPage(String activityName,String pageId,String tagSubName,String selectType, Pagination page) {
		Map<String, Object> map = new HashMap<String, Object>();

        if (StringUtils.isNotBlank(activityName)) {
            map.put("activityName", "%" + activityName + "%");
        }
        if(StringUtils.isNotBlank(tagSubName)){
        	map.put("tagSubName", tagSubName);
        }
        if(StringUtils.isNotBlank(pageId)){
        	map.put("pageId", pageId);
        }
        if(StringUtils.isNotBlank(selectType)){
        	map.put("selectType", selectType);
        }
        
        //分页
        if (page != null && page.getFirstResult() != null && page.getRows() != null) {
            map.put("firstResult", page.getFirstResult());
            map.put("rows", page.getRows());
            int total = activityMapper.queryActivityFromSpecialPageCount(map);
            page.setTotal(total);
        }
        return activityMapper.queryActivityFromSpecialPage(map);
	}

}
