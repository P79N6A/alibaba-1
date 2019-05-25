package com.sun3d.why.webservice.service;


import com.sun3d.why.model.CmsTerminalUser;
import com.sun3d.why.model.CmsVenue;
import com.sun3d.why.util.PaginationApp;

import java.util.List;
import java.util.Map;

public interface VenueAppService {
    /**
     * 获取展馆前3条推荐
     * @return
     * @param pageApp 分页对象
     * @param Lat   纬度
     * @param Lon   经度
     */
  public String queryAppVenueAppByNum(PaginationApp pageApp,String Lat, String Lon,String venueIsRecommend);
    /**
     * app根据条件筛选最近或最新展馆
     * @param cmsVenue 展馆对象
     * @param pageApp 分页对象
     * @param venueIsReserve 1-否 2 -是
     * @return
     */
    String queryAppVenueListByCondition(CmsVenue cmsVenue, PaginationApp pageApp,String Lon,String Lat,String venueIsReserve);
    /**
     * app根据条件筛选最热门展馆
     * @param cmsVenue 展馆对象
     * @param pageApp 分页
     * @param appType 标签中活动类型筛选  1->距离  2.最新 3.热门
     * @return
     */
    String queryAppHotByCondition(CmsVenue cmsVenue, PaginationApp pageApp, Integer appType, String Lon, String Lat, String venueIsReserve);

  /**
   * app根据展馆id查询展馆信息
   * @param venueId
   * @param userId
   */
    String  queryAppVenueDetailById(String venueId, String userId);

    /**
     * why3.5 显示用户收藏展馆列表
     * @param userId 用户Id
     * @param pageApp 分页对象
     * @return
     */
    String queryCollectVenue(String  userId, PaginationApp pageApp);

  /**
   * why3.5 app根据条件筛选场馆
   * @param pageApp
   * @return
   */
  String queryAppVenueList(PaginationApp pageApp, String venueArea, String venueMood, String venueType, String sortType, String venueIsReserve, String lon, String lat);

  /**
   * why3.5 app根据展馆id查询展馆信息
   * @param venueId
   * @param userId
   */
  String  queryAppCmsVenueDetailById(String venueId, String userId);

  /**
   * why3.5 app用户报名场馆接口
   * @param venueId           场馆id
   * @param userId            用户id
   * return 是否报名成功 (成功：success；失败：false)
   */
  String addAppVenueUserWantgo(String venueId,String userId);

  /**
   * why3.5 app取消用户报名场馆
   * @param venueId     场馆id
   * @param userId      用户id
   * @return
   */
  String deleteAppVenueUserWantgo(String venueId, String userId);

  /**
   * app获取场馆报名列表接口
   *  @param venueId        场馆id
   * @return
   */
  String queryAppVenueUserWantgoList(PaginationApp pageApp,String venueId);

  /**
   * why3.5 app场馆浏览量
   * @param venueId
   * @return
   */
  String queryAppCmsVenueBrowseCount(String venueId);

  /**
   * why3.5 app根据条件筛选场馆(搜索功能)
   * @param pageApp
   * @param venueType
   * @param venueArea
   * @param venueName
   * @return
   */
  String queryAppCmsVenueList(PaginationApp pageApp, String venueType, String venueArea, String venueName);
}
