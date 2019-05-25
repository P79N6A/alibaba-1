package com.sun3d.why.webservice.service;

import com.sun3d.why.model.CmsActivity;
import com.sun3d.why.model.extmodel.AppIndexData;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.PaginationApp;

import java.text.ParseException;
import java.util.List;
import java.util.Map;

/**
 * Created by Administrator on 2015/7/2.
 */
public interface ActivityAppService {



    /**
     * app首页栏目推荐活动列表
     * @param pageApp 分页对象
     * @param lon
     * @param lat
     * @param freeActivity 免费看演出
     * @param childrenActivity 孩子学艺术
     * @param whereActivity 周末去哪儿
     */
    String queryAppActivityList(PaginationApp pageApp, String lon, String lat, String freeActivity, String childrenActivity, String whereActivity);
    /**
     * app根据条件筛选活动列表
     * @param appType       活动类型筛选  1.距离  2.即将开始 3.热门
     * @param pageApp       分页对象
     * @param Lon            用户经度
     * @param Lat            用户纬度
     * @param activityTime 活动时间
     * @param activityTypeId 活动类型标签id
     * @return
     */
      public String queryActivityListPage(String appType, PaginationApp pageApp,String Lon, String Lat, String activityTime, String activityTypeId,String userId) throws ParseException;

    /**
     * app获取最热门活动列表
     * @param pageApp              分页对象
     * @param activityTypeId      活动类型标签id
     * @param appType              1.距离  2.即将开始 3.热门
     * @param userId               用户id
     * @return
     */
    public String queryAppHotByActivity(PaginationApp pageApp,String Lon,String Lat,String activityTypeId,String appType,String userId) throws ParseException;
     
     /**
      * app根据场馆id获取相关活动列表
      * @param venueId 展馆id
      * @param pageApp 分页对象
      * @return
      */
     public String queryAppActivityListById(String venueId,PaginationApp pageApp);

    /**
     * 根据id获取活动详情
     * @param activityId 活动id
     * @param userId  用户id
     * @return
     */
    public  String queryAppActivityById(String activityId,String userId);

    /**
     * why3.5 根据id获取活动详情
     * @param activityId 活动id
     * @param userId  用户id
     * @return
     */
    String queryAppCmsActivityById(String activityId,String userId);

    /**
     * why3.5 app用户收藏活动
     * @param userId 用户Id
     * @param pageApp 分页对象
     * @return
     */
     String queryUserAppCollectAct(String userId, PaginationApp pageApp);

    /**
     * app获取活动座位
     * @param activityId 活动id
     * @param userId 用户id
     * @param activityEventimes 活动具体时间
     * @return
     */
     public String queryAppActivitySeatsById(String activityId, String userId,String activityEventimes);

    /**
     * app活动预定
     * @param activityId 活动id
     * @param userId 用户id
     * @param activityEventIds 活动场次id
     * @param bookCount 预定数目
     * @param orderMobileNum 预定电话号码
     * @param orderName		姓名
     * @param orderIdentityCard		身份证
     * @param orderPrice 票价
     * @param activityEventimes 活动具体时间
     * @param costTotalCredit 	参与此活动消耗的总积分数
     * @return
     */
     public String appActivityOrderByCondition(String activityId, String userId, String activityEventIds, String bookCount, String orderMobileNum, String orderPrice, String activityEventimes, String seatId, String seatValues, String orderName, String orderIdentityCard, String costTotalCredit);

    /**
     * app根据不同条件筛选活动列表
     * @param activity  活动对象
     * @param timeType 时间类型
     * @param pageApp 分页对象
     * @param lon
     * @param lat
     */
     public  String queryAppActivityListByCondition(CmsActivity activity, String timeType, PaginationApp pageApp, String lon, String lat) throws ParseException;

     
     /**
      * app获取首页活动（类型）标签列表接口
      * @param userId 用户id
      * @return
      */
     public String queryAppActivityTagList(String userId);
     
     /**
      * app用户报名活动接口
      * @param activityId        活动id
      * @param userId            用户id
      * return 是否报名成功 (成功：success；失败：false)
      */
     public String addActivityUserWantgo(String activityId,String userId);
     
     /**
      * app获取活动报名列表接口
     *  @param activityId        活动id
      * @return
      */
     public String queryAppActivityUserWantgoList(PaginationApp pageApp,String activityId);

    /**
     * why3.5 app获取活动报名列表接口(点赞人列表)
     *  @param activityId        活动id
     * @return
     */
    String queryAppCmsActivityUserWantgoList(PaginationApp pageApp,String activityId);


    /**
     * app用户浏览标签随机推送活动
     * @param userId 用户id
     * @param activityId 活动id
     * @return
     */
     public String addRandActivity(String userId, String activityId);

    /**
     * app端点击即将开始时的活动数目
     * @param userId 用户id
     * @param tagId   类型标签id
     * @return
     */
    public String queryAppWillStartActivityCount(String userId,String tagId);

    /**
     * app端点击即将开始时新增数据
     * @param userId 用户id
     * @return
     */
    public String addAppWillStart(String userId, String versionNo, String tagId);

    /**
     * app取消用户报名活动
     * @param activityId 活动id
     * @param userId      用户id
     * @return
     */
    public String deleteActivityUserWantgo(String activityId, String userId);

    /**
     * app查询推荐的活动
     * @param pageApp 分页对象
     * @return
     */
    String queryRecommendActivity(PaginationApp pageApp);

    /**why3.4 app查询推荐的活动
     * @param pageApp 分页对象
     * @return
     */
    String queryRecommendCmsActivity(PaginationApp pageApp);

    /**
     * app查询置顶标签的活动
     * @param pageApp 分页对象
     * @return
     */
    String queryTopActivity(PaginationApp pageApp,String tagId);

    /**
     * why3.4 app查询置顶标签的活动
     * @param pageApp 分页对象
     * @return
     */
    String queryTopCmsActivity(PaginationApp pageApp,String tagId);

    String queryAppIndexData(List<String> dataList, String lon, String lat);

    /**
     * why3.4 app近期活动列表
     * @param activityType
     * @param activityLocation
     * @param sortType
     * @param chooseType
     * @return
     */
    String queryNearActivityByCondition(PaginationApp pageApp, String activityType, String activityArea, String activityLocation,
                                        String sortType, String lon, String lat, String chooseType, String isWeekend, String bookType);

    /**
     * why3.5 app日历下每天活动场数
     * @param startDate
     * @param endDate
     * @return
     */
    String queryEventDateActivityCount(String startDate, String endDate, String version) throws Exception;

    /**
     *why3.5 app日历下某一天活动列表
     * @param pageApp
     * @param eventDate
     * @param lon
     * @param lat
     * @return
     */
    String queryAppEveryDateActivityList(PaginationApp pageApp, String eventDate, String lon, String lat);

    /**
     * why3.5 app附近活动列表
     * @param pageApp
     * @param activityType
     * @param activityIsFree
     * @param activityIsReservation
     * @param sortType
     * @param lon
     * @param lat
     * @return
     */
    String queryAppNearActivityList(PaginationApp pageApp, String activityType, String activityIsFree, String activityIsReservation, String sortType, String lon, String lat);

    /**
     * why3.5 app活动浏览量
     * @param activityId
     * @return
     */
    String queryAppCmsActivityBrowseCount(String activityId);

    /**
     * why3.5 app根据场馆id获取相关活动列表
     * @param venueId 展馆id
     * @param pageApp 分页对象
     * @return
     */
   String queryAppCmsActivityListById(String venueId,PaginationApp pageApp);
   
   /**
    * 文化地图场馆相关活动列表
    * @param venueId
    * @param pageApp
    * @return
    */
   String queryCultureMapActivityListById(String venueId,PaginationApp pageApp);
   
	/**
	* why3.5 app根据场馆id获取相关(历史)活动列表
	* @param venueId 展馆id
	* @param pageApp 分页对象
	* @return
	*/
	String queryHisActivityListByVenueId(String venueId,PaginationApp pageApp);

    /**
     * why3.5 app根据不同条件筛选活动列表(搜索功能)
     * @param activityArea
     * @param activityType
     * @param activityName
     * @param pageApp
     * @param lon
     * @param lat
     * @return
     */
    String queryAppCmsActivityListByCondition(String activityArea, String activityType, String activityName, String activityIsReservation, PaginationApp pageApp, String lon, String lat);

    /**why3.5 app查询推荐的活动
     * @param pageApp 分页对象
     * @return
     */
    String queryRecommendActivityList(PaginationApp pageApp);

    /**
     * why3.5 app查询置顶标签的活动
     * @param pageApp 分页对象
     * @return
     */
    String queryTopActivityList(PaginationApp pageApp,String tagId,String activityArea,String activityLocation,
    				String activityIsFree,String activityIsReservation,String sortType,String Lon,String Lat);
    
    /**
     * why3.5 app查询推荐的活动（带筛选）
     * @param pageApp 分页对象
     * @return
     */
    String queryFilterActivityList(PaginationApp pageApp,String activityArea,String activityLocation,
    		String activityIsFree,String activityIsReservation,String sortType);
    
    /**
     * why3.5 app日历下时间段活动场数
     * @param startDate
     * @param endDate
     * @return
     */
    String queryAppDatePartActivityCount(String startDate, String endDate);

    /**
     * why3.5 app根据不同条件查询月、周下活动列表
     * @param response
     * @param startDate
     * @param endDate
     * @param activityArea
     * @param activityLocation 区域商圈id
     * @param activityType
     * @param activityIsFree	是否收费 1-免费 2-收费
     * @param activityIsReservation		是否预定 1-不可预定 2-可预定
     * @param pageIndex
     * @param userId
     * @param pageNum
     * @param pageApp
     * @param type	(默认不传值，"month"：查询月开始活动)
     * @return
     */
    String queryAppActivityCalendarList(PaginationApp pageApp, String startDate, String endDate, String activityArea,String activityLocation, String activityType,
                                String activityIsFree, String activityIsReservation, String userId, String type);

    /**
     * why3.5 app我的活动日历（历史预定活动及收藏）列表
     * @param pageApp
     * @param userId
     * @return
     */
    String queryAppHistoryActivityList(PaginationApp pageApp, String userId);

    /**
     * why3.5 app我的活动日历（月份预定活动及收藏）列表
     * @param pageApp
     * @param userId
     * @param startDate
     * @param endDate
     * @return
     */
    String queryAppMonthActivityList(PaginationApp pageApp, String userId, String startDate, String endDate);
    
    /**
     * why3.5 app活动场次列表
     * @param activityId
     * @return
     */
    String queryActivityEventList(String activityId);
 
    /**
     * 3.6文化日历
     * @param pageApp
     * @param selectDate
     * @param activityType
     * @param userId
     * @return
     */
    String queryCultureCalendarList(PaginationApp pageApp, String selectDate,String activityType,String userId,String lon, String lat);
    
    /**
     * 3.6我的文化日历（月份预定活动、体系内活动收藏和采集活动收藏）列表
     * @param userId
	 * @param pageApp
	 * @param startDate
	 * @param endDate
     * @return
     */
    String queryMyCultureCalendarList(PaginationApp pageApp,String userId, String startDate,String endDate);
    
    /**
     * 3.6活动列表-标签位
     * @return
     */
    String queryActivityListTagSub();

    List<CmsActivity> queryActivityThemeByCode(String activityType);
}
