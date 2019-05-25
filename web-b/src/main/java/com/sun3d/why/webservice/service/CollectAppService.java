package com.sun3d.why.webservice.service;

import com.sun3d.why.statistics.service.StatisticActivityUserService;
import com.sun3d.why.statistics.service.StatisticVenueUserService;

import javax.servlet.http.HttpServletRequest;

/**
 * 用户收藏活动与展馆
 */
public interface CollectAppService {
    /**
     * app用户收藏活动
     * @param userId 用户id
     * @param activityId 活动id
     * @param request
     * @param statisticActivityUserService 活动用户统计对象
     * @return
     */
   public   String addCollectActivity(String userId, String activityId, HttpServletRequest request, StatisticActivityUserService statisticActivityUserService) throws  Exception;

    /**
     * app取消用户收藏活动
     * @param userId 用户id
     * @param activityId 活动id
     * @param request
     * @param statisticActivityUserService 活动用户统计对象
     * @return
     * @throws Exception
     */
    public String delCollectActivity(String userId, String activityId, HttpServletRequest request, StatisticActivityUserService statisticActivityUserService) throws Exception;

    /**
     * app用户展馆
     * @param userId 用户id
     * @param venueId 展馆id
     * @param request
     * @param statisticVenueUserService 展馆用户统计对象
     * @return
     */
     public String addCollectVenue(String userId, String venueId, HttpServletRequest request, StatisticVenueUserService statisticVenueUserService) throws Exception;

    /**
     * app取消用户收藏展馆
     * @param userId 用户id
     * @param venueId 展馆id
     * @param request
     * @param statisticVenueUserService 展馆用户统计对象
     * @return
     */
     public String delCollectVenue(String userId, String venueId, HttpServletRequest request, StatisticVenueUserService statisticVenueUserService) throws Exception;
}
