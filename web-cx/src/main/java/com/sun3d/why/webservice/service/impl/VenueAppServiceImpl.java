package com.sun3d.why.webservice.service.impl;
import static com.sun3d.why.util.appDistance.getDistance;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.apache.taglibs.standard.lang.jstl.test.beans.PublicBean1;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.sun3d.why.dao.CmsActivityMapper;
import com.sun3d.why.dao.CmsActivityRoomMapper;
import com.sun3d.why.dao.CmsCommentMapper;
import com.sun3d.why.dao.CmsTagSubMapper;
import com.sun3d.why.dao.CmsUserWantgoMapper;
import com.sun3d.why.dao.CmsVenueMapper;
import com.sun3d.why.dao.CmsVideoMapper;
import com.sun3d.why.model.CmsStatistics;
import com.sun3d.why.model.CmsTag;
import com.sun3d.why.model.CmsTagSub;
import com.sun3d.why.model.CmsUserWantgo;
import com.sun3d.why.model.CmsVenue;
import com.sun3d.why.model.CmsVideo;
import com.sun3d.why.model.VenueUserStatistics;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.model.extmodel.shareUrl;
import com.sun3d.why.service.CollectService;
import com.sun3d.why.statistics.service.StatisticService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.DateUtils;
import com.sun3d.why.util.JSONResponse;
import com.sun3d.why.util.PaginationApp;
import com.sun3d.why.util.UUIDUtils;
import com.sun3d.why.util.appDistance;
import com.sun3d.why.webservice.service.VenueAppService;
@Service
@Transactional
public class VenueAppServiceImpl implements VenueAppService{
    private Logger logger = Logger.getLogger(VenueAppServiceImpl.class);
    @Autowired
    private CmsVenueMapper cmsVenueMapper;
    @Autowired
    private StaticServer staticServer;
    @Autowired
    private CollectService collectService;
    @Autowired
    private shareUrl shareUrlService;
    @Autowired
    private CmsVideoMapper cmsVideoMapper;
    @Autowired
    private CmsActivityRoomMapper cmsActivityRoomMapper;
    @Autowired
    private CmsUserWantgoMapper cmsUserWantgoMapper;
    @Autowired
    private CmsCommentMapper commentMapper;
    @Autowired
    private StatisticService statisticService;
    @Autowired
    private CmsActivityMapper activityMapper;
    
    @Autowired
    private CmsTagSubMapper cmsTagSubMapper;
    

    /**
     * app获取推荐前3条展馆数据
     * @param pageApp 分页对象
     * @param Lat 纬度
     * @param Lon 经度
     * @param venueIsRecommend 是否推荐  1-否 2-是
     */
    @Override
    public String queryAppVenueAppByNum(PaginationApp pageApp, String Lat, String Lon,String venueIsRecommend) {
        List<CmsVenue> venuesList = new ArrayList<CmsVenue>();
        List<Map<String,Object>> listMap=new ArrayList<Map<String,Object>>();
        Map<String, Object> map = new HashMap<String, Object>();
        Map<String, Object> param = new HashMap<String, Object>();
        try {
            map.put("venueIsDel", Constant.NORMAL);
            map.put("venueState",Constant.PUBLISH);
            if(StringUtils.isNotBlank(venueIsRecommend) && Integer.valueOf(venueIsRecommend)==2){
                map.put("venueIsRecommend",2);
            }
            if (pageApp != null && pageApp.getFirstResult() != null && pageApp.getRows() != null) {
                map.put("firstResult", pageApp.getFirstResult());
                map.put("rows", pageApp.getRows());
            }
            List<CmsVenue> venuesRecommendList=cmsVenueMapper.queryAppVenueAppByNum(map);
            venuesList.addAll(venuesRecommendList);
            param.put("venueIsDel", Constant.NORMAL);
            param.put("venueState",Constant.PUBLISH);
            if(venuesList!=null && venuesList.size()==0){
                if (pageApp != null && pageApp.getFirstResult() != null && pageApp.getRows() != null) {
                    param.put("firstResult",pageApp.getFirstResult());
                    param.put("rows", pageApp.getRows());
                }
                List<CmsVenue> venuesIsRecommendList=cmsVenueMapper.queryAppVenueAppByNum(param);
                venuesList.addAll(venuesIsRecommendList);
            }
            else if(venuesList!=null && venuesList.size()<3){
                if (pageApp != null && pageApp.getFirstResult() != null && pageApp.getRows() != null) {
                    param.put("firstResult",venuesList.size());
                    param.put("rows", 3-venuesList.size());
                }
                List<CmsVenue> venuesIsRecommendList=cmsVenueMapper.queryAppVenueAppByNum(param);
                venuesList.addAll(venuesIsRecommendList);
            }
            for(CmsVenue list :venuesList){
                Map<String, Object> venueMap = new HashMap<String, Object>();
                String venueIconUrl = "";
                if(StringUtils.isNotBlank(list.getVenueIconUrl())){
                    venueIconUrl=staticServer.getStaticServerUrl()+list.getVenueIconUrl();
                }
                venueMap.put("venueIconUrl",venueIconUrl);
                venueMap.put("venueStars",list.getVenueStars()!=null?list.getVenueStars():"");
                venueMap.put("venueHasBus",list.getVenueHasBus()!=null?list.getVenueHasBus():"");
                venueMap.put("venueHasMetro",list.getVenueHasMetro()!=null?list.getVenueHasMetro():"");
                venueMap.put("venueName",list.getVenueName()!=null?list.getVenueName():"");
                venueMap.put("venueMemo",list.getVenueMemo()!=null?list.getVenueMemo():"");
                venueMap.put("venueAddress",list.getVenueAddress()!=null?list.getVenueAddress():"");
                venueMap.put("venueId", list.getVenueId()!=null?list.getVenueId():"");
                //获取展馆经纬度
                double venueLon=0d;
                if(list.getVenueLon()!=null){
                    venueLon=list.getVenueLon();
                }
                double venueLat=0d;
                if(list.getVenueLat()!=null){
                    venueLat=list.getVenueLat();
                }
                venueMap.put("venueLon",venueLon);
                venueMap.put("venueLat",venueLat);
                double distance=0d;
                if(StringUtils.isNotBlank(Lat) && StringUtils.isNotBlank(Lon)) {
                    appDistance startDistancs=new appDistance();
                    startDistancs.setLongitude(Double.parseDouble(Lon));
                    startDistancs.setDimensionality(Double.parseDouble(Lat));
                    appDistance endDistancs=new appDistance();
                    endDistancs.setLongitude(venueLon);
                    endDistancs.setDimensionality(venueLat);
                    distance=getDistance(startDistancs,endDistancs);
                }
                venueMap.put("distance",distance);
                //获取最新一条展馆评论与评论人
                String commentRemark = "";
                if(list.getRemarks() != null){
                    String[] remarks=list.getRemarks().split(",");
                    commentRemark = remarks[0].toString();
                }
                venueMap.put("commentRemark",commentRemark);
                String remarkName = "";
                if(list.getUserNames()!=null){
                    String[] userNames=list.getUserNames().split(",");
                    remarkName=userNames[0].toString();
                }
                venueMap.put("remarkName",remarkName);
                listMap.add(venueMap);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return JSONResponse.toAppActivityResultFormat(0, listMap, pageApp.getTotal());
    }
    /**
     * app根据条件筛选最近展馆
     * @param pageApp 分页对象
     * @param venueIsReserve 1-否 2 -是
     * @return
     */
    @Override
    public String queryAppVenueListByCondition(CmsVenue cmsVenue, PaginationApp pageApp,String Lon,String Lat,String venueIsReserve) {
        Map<String, Object> map = new HashMap<String, Object>();
        List<Map<String, Object>> listMap = new ArrayList<Map<String, Object>>();
        if(cmsVenue!=null && StringUtils.isNotBlank(cmsVenue.getVenueName())){
            map.put("venueName", "%/"+cmsVenue.getVenueName()+"%");
        }
        if (cmsVenue != null && StringUtils.isNotBlank(cmsVenue.getVenueArea())) {
            map.put("venueArea", cmsVenue.getVenueArea() + ",%");
        }
        if(cmsVenue != null &&StringUtils.isNotBlank(cmsVenue.getVenueType())){
            map.put("venueType", cmsVenue.getVenueType());
        }
        if(cmsVenue!=null && StringUtils.isNotBlank(cmsVenue.getVenueCrowd())){
            map.put("venueCrowd", "%" + cmsVenue.getVenueCrowd() + ",%");
        }
        if(venueIsReserve!=null && StringUtils.isNotBlank(venueIsReserve)){
            map.put("venueIsReserve", Integer.valueOf(venueIsReserve));
        }
        map.put("venueIsDel",Constant.NORMAL);
        map.put("venueState",Constant.PUBLISH);
        map.put("lon",Lon);
        map.put("lat",Lat);
        //app分页
        if (pageApp != null && pageApp.getFirstResult() != null && pageApp.getRows() != null) {
            map.put("firstResult", pageApp.getFirstResult());
            map.put("rows", pageApp.getRows());
        }
        int total = cmsVenueMapper.queryAppCountByCondition(map);
        if(pageApp!=null && total>0){
            //设置分页的总条数来获取总页数
            pageApp.setTotal(total);
        }
        List<CmsVenue> venueList=cmsVenueMapper.queryAppVenueListByCondition(map);
        listMap=getAppVenueResult(venueList,staticServer,Lat,Lon);

        return JSONResponse.toAppActivityResultFormat(0, listMap, pageApp.getTotal());
    }

    @Override
    public String queryAppHotByCondition(CmsVenue cmsVenue, PaginationApp pageApp, Integer appType, String Lon, String Lat, String venueIsReserve) {
        Map<String, Object> map = new HashMap<String, Object>();
        List<Map<String, Object>> listMap = new ArrayList<Map<String, Object>>();
        if(cmsVenue!=null && StringUtils.isNotBlank(cmsVenue.getVenueName())){
            map.put("venueName", "%/"+cmsVenue.getVenueName()+"%");
        }
        if (cmsVenue!=null && StringUtils.isNotBlank(cmsVenue.getVenueArea())) {
            map.put("venueArea", cmsVenue.getVenueArea() + ",%");
        }
        if(cmsVenue != null &&StringUtils.isNotBlank(cmsVenue.getVenueType())){
            map.put("venueType", cmsVenue.getVenueType());
        }
        if(cmsVenue!=null && StringUtils.isNotBlank(cmsVenue.getVenueCrowd())){
            map.put("venueCrowd", "%" + cmsVenue.getVenueCrowd() + ",%");
        }
        if(StringUtils.isNotBlank(venueIsReserve)){
            map.put("venueIsReserve", venueIsReserve);
        }

        map.put("lon",Lon);
        map.put("lat",Lat);
        map.put("venueIsDel",Constant.NORMAL);
        map.put("venueState",Constant.PUBLISH);
        //app分页
        if (pageApp != null && pageApp.getFirstResult() != null && pageApp.getRows() != null) {
            map.put("firstResult", pageApp.getFirstResult());
            map.put("rows", pageApp.getRows());
        }
        int total = cmsVenueMapper.queryAppHotCountByCondition(map);
        if(pageApp!=null && total>0){
            //设置分页的总条数来获取总页数
            pageApp.setTotal(total);
        }
        List<CmsVenue> venueList=cmsVenueMapper.queryAppHotVenueListByCondition(map);
        listMap=getAppVenueResult(venueList, staticServer, Lat, Lon);
        return JSONResponse.toAppActivityResultFormat(0, listMap, pageApp.getTotal());
    }

    /**
     * 根据展馆id获取展馆信息
     * @param venueId 展馆id
     * @param userId  用户id
     * @return
     */
    @Override
    public String queryAppVenueDetailById(String venueId, String userId) {
        List<Map<String, Object>> listMap = new ArrayList<Map<String, Object>>();
        List<Map<String,Object>>  listVideo=new ArrayList<Map<String, Object>>();
        Map<String,Object> map=new HashMap<String, Object>();
        if(venueId!=null && StringUtils.isNotBlank(venueId)){
            map.put("relatedId",venueId);
        }
        if(userId!=null && StringUtils.isNotBlank(userId)){
            map.put("userId",userId);
            map.put("type",Constant.TYPE_VENUE);
        }
        map.put("videoType",Constant.VENUE_VIDEO_TYPE);
        CmsVenue cmsVenue=cmsVenueMapper.queryAppVenueDetailById(map);
        if (cmsVenue != null) {
            Map<String, Object> mapVenue = new HashMap<String, Object>();
            mapVenue.put("venueId",cmsVenue.getVenueId()!=null?cmsVenue.getVenueId():"");
            mapVenue.put("venueStars",cmsVenue.getVenueStars()!=null?cmsVenue.getVenueStars():"");
            
            String commentRemark = cmsVenue.getRemarks();
            mapVenue.put("commentRemark",commentRemark != null?commentRemark:"");
            String remarkName = cmsVenue.getUserNames();
            mapVenue.put("remarkName", remarkName!=null?remarkName:"");
            
            mapVenue.put("venueMobile",cmsVenue.getVenueMobile()!=null?cmsVenue.getVenueMobile():"");
            mapVenue.put("venueMemo",cmsVenue.getVenueMemo()!=null?cmsVenue.getVenueMemo():"");
            StringBuffer venueAddress=new StringBuffer();
            venueAddress.append(cmsVenue.getCity());
            venueAddress.append(cmsVenue.getArea());
            String address=cmsVenue.getVenueAddress()!=null?cmsVenue.getVenueAddress():"";
            venueAddress.append(address);
            mapVenue.put("venueAddress",venueAddress.toString());
            mapVenue.put("venueHasBus",cmsVenue.getVenueHasBus()!=null?cmsVenue.getVenueHasBus():"");
            mapVenue.put("venueHasMetro",cmsVenue.getVenueHasMetro()!=null?cmsVenue.getVenueHasMetro():"");
            mapVenue.put("venueName",cmsVenue.getVenueName()!=null?cmsVenue.getVenueName():"");
            mapVenue.put("venueOpenTime",cmsVenue.getVenueOpenTime()!=null?cmsVenue.getVenueOpenTime():"");
            mapVenue.put("venueEndTime",cmsVenue.getVenueEndTime()!=null?cmsVenue.getVenueEndTime():"");
            //展馆费用
            mapVenue.put("venuePrice",cmsVenue.getVenuePrice()!=null?cmsVenue.getVenuePrice():0);
            if (StringUtils.isNotBlank(String.valueOf(cmsVenue.getVenueHasRoom()))) {
                //展馆下是否有活动室  1：无活动室 2：有活动室
                mapVenue.put("venueHasRoom", cmsVenue.getVenueHasRoom() != null ? cmsVenue.getVenueHasRoom() : "");
            }
            if(StringUtils.isNotBlank(String.valueOf(cmsVenue.getVenueHasAntique()))){
                //展馆下是否有藏品 1：无馆藏 2：有馆藏
                mapVenue.put("venueHasAntique", cmsVenue.getVenueHasAntique() != null ? cmsVenue.getVenueHasAntique() : "");
            }
            mapVenue.put("venueMemo",cmsVenue.getVenueMemo()!=null?cmsVenue.getVenueMemo():"");
            String venueIconUrl = "";
            if (StringUtils.isNotBlank(cmsVenue.getVenueIconUrl())) {
                venueIconUrl = staticServer.getStaticServerUrl() + cmsVenue.getVenueIconUrl();
            }
            mapVenue.put("venueIconUrl", venueIconUrl);
            //获取活动室名称
            mapVenue.put("roomNames",cmsVenue.getRoomNames()!=null?cmsVenue.getRoomNames():"");
            //获取活动室图片
            String roomUrl="";
            if(cmsVenue.getRoomUrls()!=null && StringUtils.isNotBlank(cmsVenue.getRoomUrls())){
                String[] roomUrls=cmsVenue.getRoomUrls().split(",");
                for(String rooms :roomUrls){
                    roomUrl +=staticServer.getStaticServerUrl()+rooms + ",";
                }
                roomUrl=roomUrl.substring(0,roomUrl.length() - 1);
            }
            mapVenue.put("roomIconUrl",roomUrl);
            mapVenue.put("venueIsCollect",cmsVenue.getCollectNum()>0?1:0);
            //查询该展馆收藏数量
            int collectNum = collectService.getHotNum(cmsVenue.getVenueId(), Constant.TYPE_VENUE);
            mapVenue.put("collectNum", collectNum != 0 ? collectNum : 0);
            mapVenue.put("venueLat",cmsVenue.getVenueLat()!=null?cmsVenue.getVenueLat():"");
            mapVenue.put("venueLon",cmsVenue.getVenueLon()!=null?cmsVenue.getVenueLon():"");
            mapVenue.put("openNotice", cmsVenue.getOpenNotice()!=null?cmsVenue.getOpenNotice():"");//开放备注
            //添加分享的shareUrl
            StringBuffer sb=new StringBuffer();
            sb.append(shareUrlService.getShareUrl());
            sb.append(Constant.commentVenueUrl);
            sb.append("venueId="+cmsVenue.getVenueId());
            mapVenue.put("shareUrl", sb.toString());
            String venueVoiceUrl = "";
            if (StringUtils.isNotBlank(cmsVenue.getVenueVoiceUrl())) {
                venueVoiceUrl = staticServer.getStaticServerUrl() +cmsVenue.getVenueVoiceUrl();
            }
            mapVenue.put("venueVoiceUrl", venueVoiceUrl);
            mapVenue.put("venueIsReserve",cmsVenue.getVenueIsReserve());
            mapVenue.put("venueRemark",cmsVenue.getVenueRemark()!=null?cmsVenue.getVenueRemark():"");
            //获取活动视频信息
            List<CmsVideo> videoList=cmsVideoMapper.queryVideoById(map);
            if(CollectionUtils.isNotEmpty(videoList)){
                for(CmsVideo videos :videoList){
                    Map<String, Object> mapVideo= new HashMap<String, Object>();
                    mapVideo.put("videoTitle",videos.getVideoTitle()!=null?videos.getVideoTitle():"");
                    mapVideo.put("videoLink",videos.getVideoLink()!=null?videos.getVideoLink():"");
                    String videoImgUrl="";
                    if (StringUtils.isNotBlank(videos.getVideoImgUrl())) {
                        videoImgUrl = staticServer.getStaticServerUrl() + videos.getVideoImgUrl();
                    }
                    mapVideo.put("videoImgUrl",videoImgUrl);
                    mapVideo.put("videoCreateTime",DateUtils.formatDate(videos.getVideoCreateTime()));
                    listVideo.add(mapVideo);
                }
            }
            listMap.add(mapVenue);
        }
        return JSONResponse.toAppResultObject(0,listMap,listVideo);
    }

    /**
     * why3.5 app显示用户收藏展馆列表
     * @param userId 用户Id
     * @param pageApp 分页对象
     * @return
     */
    @Override
    public String queryCollectVenue(String userId, PaginationApp pageApp) {
        List<Map<String, Object>> listMapVenue = new ArrayList<Map<String, Object>>();
        Map<String, Object> map = new HashMap<String, Object>();
        if (userId!=null && StringUtils.isNotBlank(userId)) {
            map.put("userId",userId);
        }
        map.put("type", Constant.COLLECT_VENUE);
        //分页
        if (pageApp != null && pageApp.getFirstResult() != null && pageApp.getRows() != null) {
            map.put("firstResult", pageApp.getFirstResult());
            map.put("rows", pageApp.getRows());
        }
        List<CmsVenue> venueList= cmsVenueMapper.queryCollectVenue(map);
        if(venueList!=null && venueList.size()>0){
            for(CmsVenue venue:venueList){
                Map<String,Object> mapVenue=new HashMap<String, Object>();
                mapVenue.put("venueId",venue.getVenueId()!=null?venue.getVenueId():"");
                mapVenue.put("venueName",venue.getVenueName()!=null?venue.getVenueName():"");
                mapVenue.put("venueAddress",venue.getVenueAddress()!=null?venue.getVenueAddress():"");
                mapVenue.put("venueIconUrl",StringUtils.isNotBlank(venue.getVenueIconUrl())?staticServer.getStaticServerUrl()+venue.getVenueIconUrl():"");
                
                //子站调用统一数据格式
                mapVenue.put("relateId",venue.getVenueId()!=null?venue.getVenueId():"");
                mapVenue.put("name",venue.getVenueName()!=null?venue.getVenueName():"");
                mapVenue.put("info",venue.getVenueAddress()!=null?venue.getVenueAddress():"");
                mapVenue.put("iconUrl",StringUtils.isNotBlank(venue.getVenueIconUrl())?staticServer.getStaticServerUrl()+venue.getVenueIconUrl():"");
                
                listMapVenue.add(mapVenue);
            }
        }
        return  JSONResponse.toAppResultFormat(0, listMapVenue);
    }

    /**
     * 公共获取展馆信息
     */
    public List<Map<String, Object>> getAppVenueResult(List<CmsVenue> venueList,StaticServer staticServer,String Lat,String Lon){
        List<Map<String, Object>> listMap = new ArrayList<Map<String, Object>>();
        if(CollectionUtils.isNotEmpty(venueList)){
            for(CmsVenue list:venueList){
                Map<String,Object> venueMap=new HashMap<String, Object>();
                String venueIconUrl = "";
                if(StringUtils.isNotBlank(list.getVenueIconUrl())){
                    venueIconUrl=staticServer.getStaticServerUrl()+list.getVenueIconUrl();
                }
                venueMap.put("venueIconUrl",venueIconUrl);
                venueMap.put("venueStars",list.getVenueStars()!=null?list.getVenueStars():"");
                venueMap.put("venueHasBus",list.getVenueHasBus()!=null?list.getVenueHasBus():"");
                venueMap.put("venueHasMetro",list.getVenueHasMetro()!=null?list.getVenueHasMetro():"");
                venueMap.put("venueName",list.getVenueName()!=null?list.getVenueName():"");
                /*venueMap.put("venueMemo",list.getVenueMemo()!=null?list.getVenueMemo():"");*/
                StringBuffer venueAddress=new StringBuffer();
                venueAddress.append(list.getCity());
                venueAddress.append(list.getArea());
                String address=list.getVenueAddress()!=null?list.getVenueAddress():"";
                venueAddress.append(address);
                venueMap.put("venueAddress",venueAddress.toString());
                venueMap.put("venueId", list.getVenueId()!=null?list.getVenueId():"");
                //获取展馆经纬度
                double venueLon=0d;
                if(list.getVenueLon()!=null){
                    venueLon=list.getVenueLon();
                }
                double venueLat=0d;
                if(list.getVenueLat()!=null){
                    venueLat=list.getVenueLat();
                }
                venueMap.put("venueLon",venueLon);
                venueMap.put("venueLat",venueLat);
                double distance=0d;
                if(list.getDistance()!=null) {
                    distance=list.getDistance();
                }
                venueMap.put("distance",distance/1000);
                //获取最新一条展馆评论与评论人
                String commentRemark = "";
                if(list.getRemarks() != null){
                    String[] remarks=list.getRemarks().split(",");
                    if(remarks.length>0){
                    	commentRemark = remarks[0].toString();
                    }
                }
                venueMap.put("commentRemark",commentRemark);
                String remarkName = "";
                if(list.getUserNames()!=null){
                    String[] userNames=list.getUserNames().split(",");
                    if(userNames.length>0){
                    	remarkName=userNames[0].toString();
                    }
                }
                venueMap.put("remarkName", remarkName);
                String remarkUserImg="";
                if(StringUtils.isNotBlank(list.getUserHeadImgUrl())){
                    String[] userHeadImgUrl=list.getUserHeadImgUrl().split(",");
                     for(String url:userHeadImgUrl){
                         if(url.contains("http://")){
                             remarkUserImg=url;
                         }else {
                             remarkUserImg=staticServer.getStaticServerUrl()+url.toString();
                         }
                           break;
                     }
                }
                venueMap.put("remarkUserImgUrl", remarkUserImg);
                String remarkUserSex = "";
                if(list.getUserSexs()!=null){
                    String[] userSex=list.getUserSexs().split(",");
                    if(userSex.length>0){
                        remarkUserSex=userSex[0].toString();
                    }
                }
                venueMap.put("remarkUserSex", remarkUserSex);

                Map<String,Object> map = new HashMap<String, Object>();
                map.put("venueId", venueMap.get("venueId").toString());
                map.put("roomIsDel", Constant.NORMAL);
                int count = cmsActivityRoomMapper.queryAppActivityRoomCountById(map);
                if(count > 0){
                    venueMap.put("venueIsReserve", 2);
                }else{
                    venueMap.put("venueIsReserve", 1);
                }
                listMap.add(venueMap);
            }
        }
        return  listMap;
    }

    /**
     * why3.5 app根据条件筛选场馆
     * @param pageApp
     * @return
     */
    @Override
    public String queryAppVenueList(PaginationApp pageApp, String venueArea, String venueMood, String venueType, String sortType, String venueIsReserve,String tagSubId, String lon, String lat){
        Map<String, Object> map = new HashMap<String, Object>();
        if(StringUtils.isNotBlank(venueArea)){
            map.put("venueArea", venueArea+"%");
        }
        if(StringUtils.isNotBlank(venueMood)){
            map.put("venueMood", venueMood);
        }
        if(StringUtils.isNotBlank(venueType)){
            map.put("venueType", venueType.split(","));
        }
        if(StringUtils.isNotBlank(tagSubId)){
            map.put("tagSubId", tagSubId);
        }
        if(StringUtils.isNotBlank(sortType)){
            map.put("sortType", Integer.parseInt(sortType));
        }
        if(StringUtils.isNotBlank(venueIsReserve)){
            if(Integer.parseInt(venueIsReserve) == 2){
                map.put("venueIsReserve", Integer.parseInt(venueIsReserve));
            }
        }
        if(StringUtils.isNotBlank(lon) && StringUtils.isNotBlank(lat)){
            map.put("lon", lon);
            map.put("lat", lat);
        }
        if (pageApp != null && pageApp.getFirstResult() != null && pageApp.getRows() != null) {
            map.put("firstResult", pageApp.getFirstResult());
            map.put("rows", pageApp.getRows());
        }
        List<CmsVenue> venueList = cmsVenueMapper.queryAppVenueList(map);
        
        //如果按类别搜不到，重新按标签搜
        if(venueList.size()==0&&StringUtils.isNotBlank(venueType)){
        	map.remove("venueType");
        	map.put("tagSubId", venueType);
        	venueList = cmsVenueMapper.queryAppVenueList(map);
        }
        List<Map<String, Object>> listMap = this.getAppCmsVenueResult(venueList, staticServer);
        if(CollectionUtils.isEmpty(listMap)){
            listMap = new ArrayList<Map<String, Object>>();
        }
        return JSONResponse.toAppResultFormat(1, listMap);
    }

    /**
     * why3.5 公共获取展馆信息
     * @param venueList
     * @param staticServer
     * @return
     */
    private List<Map<String, Object>> getAppCmsVenueResult(List<CmsVenue> venueList,StaticServer staticServer){
        List<Map<String, Object>> listMap = new ArrayList<Map<String, Object>>();
        if(CollectionUtils.isNotEmpty(venueList)){
            for(CmsVenue list:venueList){
                Map<String,Object> venueMap=new HashMap<String, Object>();
                String venueIconUrl = "";
                if(StringUtils.isNotBlank(list.getVenueIconUrl())){
                    venueIconUrl=staticServer.getStaticServerUrl()+list.getVenueIconUrl();
                }
                venueMap.put("venueIconUrl",venueIconUrl);
                venueMap.put("venueName",list.getVenueName()!=null?list.getVenueName():"");
                String activityName = "";
                if(StringUtils.isNotBlank(list.getVenueId())){
                    activityName = cmsVenueMapper.queryAppActivityNameByVenueId(list.getVenueId());
                }
                venueMap.put("activityName",activityName!=null?activityName:"");
                venueMap.put("venueAddress", list.getVenueAddress());
                venueMap.put("venueId", list.getVenueId()!=null?list.getVenueId():"");
                venueMap.put("venueIsReserve", list.getVenueIsReserve() != null ? list.getVenueIsReserve() : 1);
                
                venueMap.put("tagName", list.getTagName()!=null?list.getTagName():"");
                
                List<CmsTagSub>subList=new ArrayList<CmsTagSub>();
                
                if(StringUtils.isNotBlank(list.getVenueId()))
                {
                	subList=cmsTagSubMapper.queryRelateTagSubList(list.getVenueId());
                }
                venueMap.put("subList", subList);
                
                listMap.add(venueMap);
            }
        }
        return  listMap;
    }

    /**
     * why3.5 app根据展馆id查询展馆信息
     * @param venueId 展馆id
     * @param userId  用户id
     * @return
     */
    @Override
    public String queryAppCmsVenueDetailById(String venueId, String userId) {
        List<Map<String, Object>> listMap = new ArrayList<Map<String, Object>>();
        List<Map<String,Object>>  listVideo=new ArrayList<Map<String, Object>>();
        Map<String,Object> map=new HashMap<String, Object>();
        if(venueId!=null && StringUtils.isNotBlank(venueId)){
            map.put("relatedId",venueId);
        }
        if(userId!=null && StringUtils.isNotBlank(userId)){
            map.put("userId",userId);
            map.put("type",Constant.TYPE_VENUE);
        }
        map.put("videoType",Constant.VENUE_VIDEO_TYPE);
        try {
			CmsVenue cmsVenue=cmsVenueMapper.queryAppCmsVenueDetailById(map);
			if (cmsVenue != null) {
			    Map<String, Object> mapVenue = new HashMap<String, Object>();
			    mapVenue.put("venueId",cmsVenue.getVenueId()!=null?cmsVenue.getVenueId():"");
			    mapVenue.put("venueStars",cmsVenue.getVenueStars()!=null?cmsVenue.getVenueStars():"");
    
			    String commentRemark = cmsVenue.getRemarks();
			    mapVenue.put("commentRemark",commentRemark != null?commentRemark:"");
			    String remarkName = cmsVenue.getUserNames();
			    mapVenue.put("remarkName", remarkName!=null?remarkName:"");
			    
			    mapVenue.put("venueMobile",cmsVenue.getVenueMobile()!=null?cmsVenue.getVenueMobile():"");
			    mapVenue.put("venueMemo",cmsVenue.getVenueMemo()!=null?cmsVenue.getVenueMemo():"");
			    StringBuffer venueAddress=new StringBuffer();
			    venueAddress.append(cmsVenue.getCity());
			    venueAddress.append(cmsVenue.getArea());
			    String address=cmsVenue.getVenueAddress()!=null?cmsVenue.getVenueAddress():"";
			    venueAddress.append(address);
			    mapVenue.put("venueAddress",venueAddress.toString());
			    mapVenue.put("venueHasBus",cmsVenue.getVenueHasBus()!=null?cmsVenue.getVenueHasBus():"");
			    mapVenue.put("venueHasMetro",cmsVenue.getVenueHasMetro()!=null?cmsVenue.getVenueHasMetro():"");
			    mapVenue.put("venueName",cmsVenue.getVenueName()!=null?cmsVenue.getVenueName():"");
			    mapVenue.put("venueOpenTime",cmsVenue.getVenueOpenTime()!=null?cmsVenue.getVenueOpenTime():"");
			    mapVenue.put("venueEndTime",cmsVenue.getVenueEndTime()!=null?cmsVenue.getVenueEndTime():"");
			    //展馆费用
			    mapVenue.put("venuePrice",cmsVenue.getVenuePrice()!=null?cmsVenue.getVenuePrice():"");
			    mapVenue.put("venueIsFree",cmsVenue.getVenueIsFree()!=null?cmsVenue.getVenueIsFree():"");
			    if (StringUtils.isNotBlank(String.valueOf(cmsVenue.getVenueHasRoom()))) {
			        //展馆下是否有活动室  1：无活动室 2：有活动室
			        mapVenue.put("venueHasRoom", cmsVenue.getVenueHasRoom() != null ? cmsVenue.getVenueHasRoom() : "");
			    }
			    if(StringUtils.isNotBlank(String.valueOf(cmsVenue.getVenueHasAntique()))){
			        //展馆下是否有藏品 1：无馆藏 2：有馆藏
			        mapVenue.put("venueHasAntique", cmsVenue.getVenueHasAntique() != null ? cmsVenue.getVenueHasAntique() : "");
			    }
			    mapVenue.put("venueMemo",cmsVenue.getVenueMemo()!=null?cmsVenue.getVenueMemo():"");
			    String venueIconUrl = "";
			    if (StringUtils.isNotBlank(cmsVenue.getVenueIconUrl())) {
			        venueIconUrl = staticServer.getStaticServerUrl() + cmsVenue.getVenueIconUrl();
			    }
			    mapVenue.put("venueIconUrl", venueIconUrl);
			    //获取活动室名称
			    mapVenue.put("roomNames",cmsVenue.getRoomNames()!=null?cmsVenue.getRoomNames():"");
			    //获取活动室图片
			    String roomUrl="";
			    if(cmsVenue.getRoomUrls()!=null && StringUtils.isNotBlank(cmsVenue.getRoomUrls())){
			        String[] roomUrls=cmsVenue.getRoomUrls().split(",");
			        for(String rooms :roomUrls){
			            roomUrl +=staticServer.getStaticServerUrl()+rooms + ",";
			        }
			        roomUrl=roomUrl.substring(0,roomUrl.length() - 1);
			    }
			    mapVenue.put("roomIconUrl",roomUrl);
			    mapVenue.put("venueIsCollect",cmsVenue.getCollectNum()>0?1:0);
			    //查询该展馆收藏数量
			    int collectNum = collectService.getHotNum(cmsVenue.getVenueId(), Constant.TYPE_VENUE);
			    mapVenue.put("collectNum", collectNum != 0 ? collectNum : 0);
			    mapVenue.put("venueLat",cmsVenue.getVenueLat()!=null?cmsVenue.getVenueLat():"");
			    mapVenue.put("venueLon",cmsVenue.getVenueLon()!=null?cmsVenue.getVenueLon():"");
			    mapVenue.put("openNotice", cmsVenue.getOpenNotice()!=null?cmsVenue.getOpenNotice():"");//开放备注
			    mapVenue.put("tagName", cmsVenue.getTagName()!=null?cmsVenue.getTagName():"");
			    
			    List<CmsTagSub>subList=new ArrayList<CmsTagSub>();
			    
			    if(StringUtils.isNotBlank(cmsVenue.getVenueId()))
			    {
			    	subList=cmsTagSubMapper.queryRelateTagSubList(cmsVenue.getVenueId());
			    }
			    mapVenue.put("subList", subList);
			    
			    mapVenue.put("dictName", cmsVenue.getDictName()!=null?cmsVenue.getDictName():"");
			    //添加分享的shareUrl
			    StringBuffer sb=new StringBuffer();
			    sb.append(shareUrlService.getShareUrl());
			    sb.append(Constant.commentVenueUrl);
			    sb.append("venueId="+cmsVenue.getVenueId());
			    mapVenue.put("shareUrl", sb.toString());
			    //该用户是否已报名该场馆 0.该用户未参加 1.参加
			    mapVenue.put("venueIsWant", (cmsVenue.getVenueIsWant() != null && cmsVenue.getVenueIsWant() > 0) ? cmsVenue.getVenueIsWant() : 0);
			    String venueVoiceUrl = "";
			    if (StringUtils.isNotBlank(cmsVenue.getVenueVoiceUrl())) {
			        venueVoiceUrl = staticServer.getStaticServerUrl() +cmsVenue.getVenueVoiceUrl();
			    }
			    mapVenue.put("venueVoiceUrl", venueVoiceUrl);
			    mapVenue.put("venueIsReserve",cmsVenue.getVenueIsReserve());
			    mapVenue.put("venueRemark",cmsVenue.getVenueRemark()!=null?cmsVenue.getVenueRemark():"");
			    mapVenue.put("venuePriceNotice",cmsVenue.getVenuePriceNotice()!=null?cmsVenue.getVenuePriceNotice():"");
			    //获取活动视频信息
			    List<CmsVideo> videoList=cmsVideoMapper.queryVideoById(map);
			    if(CollectionUtils.isNotEmpty(videoList)){
			        for(CmsVideo videos :videoList){
			            Map<String, Object> mapVideo= new HashMap<String, Object>();
			            mapVideo.put("videoTitle",videos.getVideoTitle()!=null?videos.getVideoTitle():"");
			            mapVideo.put("videoLink",videos.getVideoLink()!=null?videos.getVideoLink():"");
			            String videoImgUrl="";
			            if (StringUtils.isNotBlank(videos.getVideoImgUrl())) {
			                videoImgUrl = staticServer.getStaticServerUrl() + videos.getVideoImgUrl();
			            }
			            mapVideo.put("videoImgUrl",videoImgUrl);
			            mapVideo.put("videoCreateTime",DateUtils.formatDate(videos.getVideoCreateTime()));
			            listVideo.add(mapVideo);
			        }
			    }
			    listMap.add(mapVenue);
			}
		} catch (Exception e) {
			JSONResponse.toAppResultObject(500,e.getMessage(),null);
			e.printStackTrace();
		}
        return JSONResponse.toAppResultObject(0,listMap,listVideo);
    }

    /**
     * why3.5 app用户报名场馆接口
     * @param venueId 场馆id
     * @param userId     用户id
     * return 是否报名成功 (成功：success；失败：false)
     */
    @Override
    public String addAppVenueUserWantgo(String venueId, String userId) {
        CmsUserWantgo userWantgo = new CmsUserWantgo();
        if (StringUtils.isNotBlank(venueId)) {
            userWantgo.setRelateId(venueId);
        }
        if (StringUtils.isNotBlank(userId)) {
            userWantgo.setUserId(userId);
        }
        int status = cmsUserWantgoMapper.queryAppUserWantCountById(userWantgo);
        if (status > 0) {
            return JSONResponse.commonResultFormat(14111, "该用户已报名该场馆,不可重复报名", null);
        }
        userWantgo.setSid(UUIDUtils.createUUId());
        userWantgo.setCreateTime(new Date());
        userWantgo.setRelateType(Constant.WANT_GO_VENUE);
        int flag = cmsUserWantgoMapper.addUserWantgo(userWantgo);
        if (flag > 0) {
            return JSONResponse.commonResultFormat(0, "用户报名场馆成功", null);
        } else {
            return JSONResponse.commonResultFormat(1, "用户报名场馆失败", null);
        }
    }

    /**
     * why3.5 app取消用户报名场馆
     *
     * @param venueId    场馆id
     * @param userId     用户id
     * @return
     */
    @Override
    public String deleteAppVenueUserWantgo(String venueId, String userId) {
        CmsUserWantgo userWantgo = new CmsUserWantgo();
        if (StringUtils.isNotBlank(venueId)) {
            userWantgo.setRelateId(venueId);
        }
        if (StringUtils.isNotBlank(userId)) {
            userWantgo.setUserId(userId);
        }
        int flag = cmsUserWantgoMapper.deleteUserWantgo(userWantgo);
        if (flag > 0) {
            return JSONResponse.commonResultFormat(0, "用户取消报名场馆成功", null);
        } else {
            return JSONResponse.commonResultFormat(1, "用户取消报名场馆失败", null);
        }
    }

    /**
     * why3.5 app获取场馆报名列表接口(点赞人列表)
     *  @param venueId        场馆id
     * @return
     */
    @Override
    public String queryAppVenueUserWantgoList(PaginationApp pageApp,String venueId){
        List<Map<String, Object>> listMap = new ArrayList<Map<String, Object>>();
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("relateType", Constant.WANT_GO_VENUE);
        map.put("relateId", venueId);
        int count = cmsUserWantgoMapper.queryUserWantgoCount(map);
        if (pageApp != null && pageApp.getFirstResult() != null && pageApp.getRows() != null) {
            map.put("firstResult", pageApp.getFirstResult());
            map.put("rows", pageApp.getRows());
        }
        try {
            List<CmsUserWantgo> wgList = cmsUserWantgoMapper.queryAppUserWantgoList(map);
            listMap = this.getAppVenueUserWantgoResult(wgList);
        } catch (Exception e) {
            e.printStackTrace();
            logger.error("query activityUserWantgoList error!" + e.getMessage());
        }
        return JSONResponse.toAppActivityResultFormat(1, listMap, count);
    }

    /**
     * why3.5 获得我想去用户map格式
     */
    private List<Map<String, Object>> getAppVenueUserWantgoResult(List<CmsUserWantgo> list) {
        List<Map<String, Object>> listMap = new ArrayList<Map<String, Object>>();
        if (CollectionUtils.isNotEmpty(list)) {
            for (CmsUserWantgo userWantgo : list) {
                Map<String, Object> mapWg = new HashMap<String, Object>();
                mapWg.put("userId", userWantgo.getUserId() != null ? userWantgo.getUserId() : "");
                mapWg.put("userName", userWantgo.getUserName() != null ? userWantgo.getUserName() : "");
                String userHeadImgUrl = "";
                if (StringUtils.isNotBlank(userWantgo.getUserHeadImgUrl()) && userWantgo.getUserHeadImgUrl().contains("http://")) {
                    userHeadImgUrl = userWantgo.getUserHeadImgUrl();
                } else if (StringUtils.isNotBlank(userWantgo.getUserHeadImgUrl())) {
                    userHeadImgUrl = staticServer.getStaticServerUrl() + userWantgo.getUserHeadImgUrl();
                }
                mapWg.put("userHeadImgUrl", userHeadImgUrl);
                mapWg.put("userSex", userWantgo.getUserSex() != null ? userWantgo.getUserSex() : "");
                SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
                mapWg.put("userBirth", userWantgo.getUserBirth() != null ? df.format(userWantgo.getUserBirth()) : "");
                listMap.add(mapWg);
            }
        }
        return listMap;
    }

    /**
     * why3.5 app场馆浏览量
     * @param venueId
     * @return
     */
    @Override
    public String queryAppCmsVenueBrowseCount(String venueId){
        CmsStatistics statistics = statisticService.queryStatistics(venueId, Constant.type1);
        if(null != statistics && null != statistics.getYearBrowseCount()){
            return JSONResponse.toAppResultFormat(1, statistics.getYearBrowseCount());
        }else{
            return JSONResponse.toAppResultFormat(1, 0);
        }
    }

    /**
     * why3.5 app根据条件筛选场馆(搜索功能)
     * @param pageApp
     * @param venueType
     * @param venueArea
     * @param venueName
     * @return
     */
    @Override
    public String queryAppCmsVenueList(PaginationApp pageApp,String venueType, String venueArea, String venueName,String tagSubId){
        Map<String, Object> map = new HashMap<String, Object>();
        if(StringUtils.isNotBlank(venueType)){
            map.put("venueType", venueType);
        }
        if(StringUtils.isNotBlank(venueArea)){
            map.put("venueArea", venueArea+",%");
        }
        if(StringUtils.isNotBlank(venueName)){
            map.put("venueName", "%"+venueName+"%");
        }
        if(StringUtils.isNotBlank(tagSubId)){
            map.put("tagSubId", tagSubId);
        }
        if (pageApp != null && pageApp.getFirstResult() != null && pageApp.getRows() != null) {
            map.put("firstResult", pageApp.getFirstResult());
            map.put("rows", pageApp.getRows());
        }
        int count = cmsVenueMapper.queryAppCmsVenueListCount(map);
        List<CmsVenue> venueList = cmsVenueMapper.queryAppCmsVenueList(map);
        List<Map<String, Object>> listMap = getAppCmsVenueResult(venueList, staticServer);
        if(CollectionUtils.isEmpty(listMap)){
            listMap = new ArrayList<Map<String, Object>>();
        }
        return JSONResponse.toAppActivityResultFormat(1, listMap, count);
    }
    
    /**
     * 热门场馆点赞数、评论数
     * @param venueId
     * @param userId
     */
	@Override
	public String queryHotVenueInfo(String venueId, String userId) {
		//点赞人数
		Map<String, Object> wantGoMap = new HashMap<String, Object>();
		wantGoMap.put("relateType", Constant.WANT_GO_VENUE);
		wantGoMap.put("relateId", venueId);
        int wantGoCount = cmsUserWantgoMapper.queryUserWantgoCount(wantGoMap);
        
        //评论人数
        Map<String, Object> commentMap = new HashMap<String, Object>();
        commentMap.put("commentRkId", venueId);
        commentMap.put("commentType", 1);
        int commentCount = commentMapper.queryCmsCommentCount(commentMap);
        
        Integer isWantGo = 0;
        if(StringUtils.isNotBlank(userId)){
        	Map<String,Object> venueMap=new HashMap<String, Object>();
            venueMap.put("relatedId",venueId);
        	venueMap.put("userId",userId);
        	isWantGo=cmsVenueMapper.queryIsWantGo(venueMap);
        }
        isWantGo = isWantGo>0?1:0;
		return JSONResponse.toThreeParamterResult(0, wantGoCount, commentCount,isWantGo);
	}
	
	/**
	 * 场馆在线活动及活动室数
	 */
	@Override
	public String queryVenueCountInfo(String venueId) {
        Map<String,Object> map = new HashMap<String, Object>();
        Map<String,Object> resultMap = new HashMap<String, Object>();
        map.put("activityIsDel", Constant.NORMAL);
        map.put("activityState", Constant.PUBLISH);
        map.put("roomIsDel", Constant.NORMAL);
        map.put("venueId", venueId);
        int actCount = activityMapper.queryAppActivityCountById(map);
        int roomCount = cmsActivityRoomMapper.queryAppActivityRoomCountById(map);
        resultMap.put("actCount", actCount);
        resultMap.put("roomCount", roomCount);
        return JSONResponse.toAppResultFormat(1, resultMap);
	}
	
	@Override
	public String queryVenueByType(String venueType, String venueName){
	  List<Map<String, Object>> mapMoodList = new ArrayList<Map<String, Object>>();
	  Map<String,Object> map = new HashMap<String, Object>();
	  Map<String,Object> resultMap = new HashMap<String, Object>();
	  map.put("venueType", venueType);
	  if(StringUtils.isNotBlank(venueName)){
		  map.put("venueName", venueName);
	  }
	  
	  List<CmsVenue> venueList=cmsVenueMapper.queryVenueByType(map);
          if(CollectionUtils.isNotEmpty(venueList)){
              for (CmsVenue venue : venueList) {
                  Map<String, Object> mapMood = new HashMap<String, Object>();
                  mapMood.put("venueId",venue.getVenueId());
                  mapMood.put("venueName", venue.getVenueName());
                  mapMood.put("venueAddre",venue.getVenueAddress());
                  mapMood.put("venueLat", venue.getVenueLat());
                  mapMood.put("venueLon", venue.getVenueLon());
                  mapMood.put("venueIconUrl", venue.getVenueIconUrl());
                  mapMoodList.add(mapMood);
              }
          }
      
	  resultMap.put("venueList", venueList);
	  return JSONResponse.toAppResultFormat(1, mapMoodList);
	}
}
