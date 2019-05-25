package com.sun3d.why.util;

import com.sun3d.why.dao.CmsCollectMapper;
import com.sun3d.why.model.CmsActivity;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.service.CmsActivityService;
import org.apache.commons.lang3.StringUtils;

import java.util.*;

import static com.sun3d.why.util.appDistance.getDistance;

/**
 * app封装标签条件下与全部条件下活动列表
 * Created by Administrator on 2015/7/31.
 */
public class AppNearByActivity {

    public static List<Map<String, Object>> nearByActivity(String tagId, String dictCode, CmsActivityService activityService, String date, PaginationApp pageApp, String Lon, String Lat, String userId,
                                                           CmsCollectMapper cmsCollectMapper, StaticServer staticServer) {
        List<Map<String, Object>> listMap = new ArrayList<Map<String, Object>>();
        List<Map<String, Object>> mapList = new ArrayList<Map<String, Object>>();
        List<CmsActivity> nearByActivityCount = activityService.queryAppCountByActivity(tagId, dictCode, null, pageApp);
        if (nearByActivityCount.size() > 0) {
            for (CmsActivity nearByList : nearByActivityCount) {
                Map<String, Object> map = new HashMap<String, Object>();
                //活动id
                String activityId = nearByList.getActivityId();
                double nearByActivityLon = 0d;
                if (nearByList.getActivityLon() != null) {
                    nearByActivityLon = nearByList.getActivityLon();
                }
                double nearByActivityLat = 0d;
                if (nearByList.getActivityLat() != null) {
                    nearByActivityLat = nearByList.getActivityLat();
                }
                //根据活动经纬度与用户经纬度计算距离
                map.put("activityId", activityId);
                double distance = 0d;
                if (StringUtils.isNotBlank(Lat) && StringUtils.isNotBlank(Lon)) {
                    // distance = appDistance.getDistance(nearByActivityLat, nearByActivityLon, Double.parseDouble(Lat), Double.parseDouble(Lon));
                    appDistance startDistancs = new appDistance();
                    startDistancs.setLongitude(Double.parseDouble(Lon));
                    startDistancs.setDimensionality(Double.parseDouble(Lat));
                    appDistance endDistancs = new appDistance();
                    endDistancs.setLongitude(nearByActivityLon);
                    endDistancs.setDimensionality(nearByActivityLat);
                    distance = getDistance(startDistancs, endDistancs);
                }
                map.put("distance", distance);
                mapList.add(map);
            }
            //进行顺序排序
            Collections.sort(mapList, new ComparatorList("distance"));
            for (Object o : mapList) {
                Map m = (Map) o;
                String activityId = (String) m.get("activityId");
                CmsActivity cmsActivity = activityService.queryFrontActivityByActivityId(activityId);
                Map<String, Object> mapActivity = new HashMap<String, Object>();
                if (StringUtils.isNotBlank(userId)) {
                    int type = 2;
                    //查询该活动下的是否收藏
                    Map<String, Object> mapCollect = new HashMap<String, Object>();
                    mapCollect.put("relateId", cmsActivity.getActivityId());
                    mapCollect.put("userId", userId);
                    mapCollect.put("type", type);
                    int count = cmsCollectMapper.isHadCollect(mapCollect);
                    if (count > 0) {
                        //1代表已收藏
                        mapActivity.put("activityIsCollect", 1);
                    } else {
                        //0 代表未收藏
                        mapActivity.put("activityIsCollect", 0);
                    }
                } else {
                    //0代表未收藏
                    mapActivity.put("activityIsCollect", 0);
                }
                mapActivity.put("activityId", cmsActivity.getActivityId() != null ? cmsActivity.getActivityId() : "");
                //活动费用 0代表免费
                mapActivity.put("activityPrice", cmsActivity.getActivityPrice() != null ? cmsActivity.getActivityPrice() : 0);
                String activityIconUrl = "";
                if (StringUtils.isNotBlank(cmsActivity.getActivityIconUrl())) {
                    activityIconUrl = staticServer.getStaticServerUrl() + cmsActivity.getActivityIconUrl();
                }
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
                double distance = 0d;
                if (StringUtils.isNotBlank(Lat) && StringUtils.isNotBlank(Lon)) {
                    appDistance startDistancs = new appDistance();
                    startDistancs.setLongitude(Double.parseDouble(Lon));
                    startDistancs.setDimensionality(Double.parseDouble(Lat));
                    appDistance endDistancs = new appDistance();
                    endDistancs.setLongitude(activityLon);
                    endDistancs.setDimensionality(activityLat);
                    distance = getDistance(startDistancs, endDistancs);
                }
                mapActivity.put("distance", distance);
                mapActivity.put("activityIconUrl", activityIconUrl);
                mapActivity.put("activityName", cmsActivity.getActivityName() != null ? cmsActivity.getActivityName() : "");
                mapActivity.put("activityAddress", cmsActivity.getActivityAddress() != null ? cmsActivity.getActivityAddress() : "");
                listMap.add(mapActivity);
            }
        }
        return  listMap;
    }

}
