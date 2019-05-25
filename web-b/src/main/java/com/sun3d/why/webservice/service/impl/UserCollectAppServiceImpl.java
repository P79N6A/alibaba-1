package com.sun3d.why.webservice.service.impl;

import com.sun3d.why.dao.CmsActivityMapper;
import com.sun3d.why.dao.CmsVenueMapper;
import com.sun3d.why.model.CmsActivity;
import com.sun3d.why.model.CmsVenue;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.JSONResponse;
import com.sun3d.why.util.PaginationApp;
import com.sun3d.why.webservice.service.UserCollectAppService;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by wangkun on 2016/2/17.
 */
@Service
@Transactional
public class UserCollectAppServiceImpl implements UserCollectAppService {
    @Autowired
    private CmsActivityMapper activityMapper;
    @Autowired
    private StaticServer staticServer;
    @Autowired
    private CmsVenueMapper cmsVenueMapper;
    /**
     * app获取用户活动与展馆收藏列表
     * @param userId  用户id
     * @param activityType 活动类型
     * @param venueType 展馆类型
     * @param pageApp 分页对象
     * @return
     */
    @Override
    public String queryAppUserCollectByCondition(String userId, PaginationApp pageApp,int activityType,int venueType,String activityName,String venueName) {
        List<Map<String, Object>> listMapActivity = new ArrayList<Map<String, Object>>();
        List<Map<String, Object>> listMapVenue = new ArrayList<Map<String, Object>>();
        Map<String, Object> map = new HashMap<String, Object>();
        if(userId!=null && StringUtils.isNotBlank(userId)){
            map.put("userId", userId);
        }
        if (pageApp != null && pageApp.getFirstResult() != null && pageApp.getRows() != null) {
            map.put("firstResult", pageApp.getFirstResult());
            map.put("rows", pageApp.getRows());
        }
        if(activityType==1) {
             map.put("type", Constant.COLLECT_ACTIVITY);
            if(activityName!=null && StringUtils.isNotBlank(activityName)){
                map.put("activityName", "%/" + activityName + "%");
            }
            // 查询用户收藏活动列表
            List<CmsActivity> activityList = activityMapper.queryCollectActivity(map);
            if (CollectionUtils.isNotEmpty(activityList)) {
                if(activityName!=null && StringUtils.isNotBlank(activityName)){
                    venueType=0;
                }
                for (CmsActivity activity : activityList) {
                    Map<String, Object> mapActivity = new HashMap<String, Object>();
                    mapActivity.put("activityId", activity.getActivityId() != null ? activity.getActivityId() : "");
                    mapActivity.put("activityName", activity.getActivityName() != null ? activity.getActivityName() : "");
                    mapActivity.put("activitySite",activity.getActivitySite()!=null?activity.getActivitySite():"");
                    mapActivity.put("activityStartTime",activity.getActivityStartTime()!=null?activity.getActivityStartTime():"");
                    mapActivity.put("activityEndTime",activity.getActivityEndTime()!=null?activity.getActivityEndTime():"");
                    String activityIconUrl = "";
                    if (StringUtils.isNotBlank(activity.getActivityIconUrl())) {
                        activityIconUrl = staticServer.getStaticServerUrl() + activity.getActivityIconUrl();
                    }
                    mapActivity.put("activityIconUrl", activityIconUrl);
                    listMapActivity.add(mapActivity);
                }
            }
        }
        if(venueType==2){
            map.put("type", Constant.COLLECT_VENUE);
            if(venueName!=null && StringUtils.isNotBlank(venueName)){
                map.put("venueName", "%/" + venueName + "%");
            }
            List<CmsVenue> venueList= cmsVenueMapper.queryCollectVenue(map);
            if(CollectionUtils.isNotEmpty(venueList)){
                for(CmsVenue venue:venueList){
                    Map<String,Object> mapVenue=new HashMap<String, Object>();
                    mapVenue.put("venueId",venue.getVenueId()!=null?venue.getVenueId():"");
                    mapVenue.put("venueName",venue.getVenueName()!=null?venue.getVenueName():"");
                    mapVenue.put("venueAddress",venue.getVenueAddress()!=null?venue.getVenueAddress():"");
                    String venueIconUrl = "";
                    if(StringUtils.isNotBlank(venue.getVenueIconUrl())){
                        venueIconUrl=staticServer.getStaticServerUrl()+venue.getVenueIconUrl();
                    }
                    mapVenue.put("venueIconUrl",venueIconUrl);
                    listMapVenue.add(mapVenue);
                }
            }
        }
        return JSONResponse.toAppResultObject(0,listMapActivity,listMapVenue);
    }
}
