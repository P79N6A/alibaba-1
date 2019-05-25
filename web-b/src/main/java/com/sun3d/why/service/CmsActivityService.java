package com.sun3d.why.service;

import com.sun3d.why.model.*;
import com.sun3d.why.model.temp.ActivityForCompare;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.PaginationApp;

import java.text.ParseException;
import java.util.Date;
import java.util.List;
import java.util.Map;

public interface CmsActivityService {


    /**
     * 根据活动对象查询活动列表信息
     *
     * @param activity 活动对象
     * @param page     分页对象
     * @param sysUser  用户对象
     * @return 活动列表信息
     */
    List<CmsActivity> queryCmsActivityByCondition(CmsActivity activity, Pagination page, SysUser sysUser);

    public void appActivitySetRedis();

    /**
     * 根据传入的map查询后台活动列表信息 new
     * @param
     * @return 活动列表信息
     */
    public List<CmsActivity> queryCmsActivityByAdminCondition(CmsActivity activity, Pagination page, SysUser sysUser);
    
    /**
     * app根据活动对象查询首页栏目推荐活动列表信息
     *
     * @param activity 活动对象
     * @param page     分页对象
     * @return 活动列表信息
     */
    List<CmsActivity> queryAppRecommendCmsActivityByCondition(CmsActivity activity, Pagination page);


    /**
     * 根据活动对象查询前台用户个人发布活动列表信息
     *
     * @param activity 活动对象
     * @param page     分页对象
     * @param sysUser  用户对象
     * @return 活动列表信息
     */
    List<CmsActivity> queryPersonalActivityByCondition(CmsActivity activity, Pagination page, SysUser sysUser);

    /**
     * 保存活动信息
     * 验证活动名称不能重复
     *
     * @param activity 活动对象
     * @param sysUser  用户对象
     * @return failure 失败,success 成功 ,repeat 活动名称重复
     */
    String addActivity(CmsActivity activity, SysUser sysUser);
    
    int  addActivity(CmsActivity activity);


    String deleteByActivityId(String id);


    public String recommendActivity(String id,SysUser user,String platform);


    String editAppNavigationRecommendActivity(CmsActivity activity, Pagination page, SysUser user);

    String editAppHomeNavigationRecommendActivity(String recommendId);

    String editRecommendCmsActivity(String activityId);
    /**
     * 修改活动信息
     *验证活动名称不能重复
     * @param activity 活动对象
     * @return failure 失败,success 成功 ,repeat 活动名称重复
     */
    String editActivity(CmsActivity activity, SysUser sysUser, String seatIds,boolean hadOrder);

    /**
     * 验证活动名称是否重复
     *
     * @param activityName 活动名称
     * @return false 不重复,true 重复
     */
    boolean queryActivityNameIsExists(String activityName);


    /**
     * 修改活动信息状态为已删除
     *
     * @param id 主键
     * @return false 修改失败,true 修改成功
     */
    boolean updateActivityDelStatus(String id, Integer status);

    /**
     * 修改活动信息状态为已下架
     *
     * @param id 主键
     * @return false 修改失败,true 修改成功
     */
    boolean updateActivityPushStatus(String id, Integer status);
    /**
     * 根据活动id查询活动对象
     *
     * @param activityId 活动id
     * @return 活动对象
     */
    CmsActivity queryCmsActivityByActivityId(String activityId);

    /**
     * 根据活动id查询活动订单数
     *
     * @param activityId 活动id
     * @return 活动订单数
     */
    int queryOrderCountByActivityId(String activityId);

    public boolean  backActivityStatus(String id);

    public boolean  backActivityAPI(String id,String sysNo);
    /**
     * 查询最新发布活动
     * @param activity 活动对象
     * @param page 分页对象
     * @return 活动对象集合
     */
    List<CmsActivity> queryBestNewPublishActivity(CmsActivity activity, Pagination page);


    /**
     * hucheng
     * */
    List<CmsActivity> queryRecommendCmsActivityList(CmsActivity activity);



    /**
     * 前台热点推荐活动
     * @param map
     * @param page
     * @return
     */
    List<CmsActivity> queryRecommendActivityList(Map map, Pagination page);


    /**
     * 前台热点推荐活动收藏数量
     * @param map
     * @param page
     * @return
     */
    List<Map> frontRecommendActivityCollectNum(Map map, Pagination page);





    /**
     * 前台获取正在进行的活动
     *
     * @param cmsActivity
     * @param page
     * @return
     */
    List<CmsActivity> queryCmsVenueActivity(CmsActivity cmsActivity, Pagination page);

   /**
     * 月推荐活动
     *
     * @param example
     * @return
     *//*

    List<CmsActivity> queryMonthHotActivity(CmsActivityExample example);*/


    /**
     * 前端2.0活动收藏列表
     * @param user 会员对象
     * @param activityName 活动名称
     * @param pageApp
     * @return 活动对象集合
     */
    List<CmsActivity> queryCollectActivity(CmsTerminalUser user, Pagination page, String activityName, PaginationApp pageApp);

    /**
     * 前端2.0活动收藏个数
     * @param map
     * @return
     */
    int queryCollectActivityCount(Map<String, Object> map);

    /**
     * 根据对象信息查询符合条件的数量
     * @param cmsActivity
     * @return
     */
    Integer queryCountByActivity(CmsActivity cmsActivity);

    /**
     * 前端首页活动
     * @param activity
     * @return
     */
    List<CmsActivity> queryActivityByCondition(CmsActivity activity,Pagination page, Date startDate,Date endDate, int type);

    /**
     * 前端活动详情信息
     * @param activityId
     * @return
     */
    CmsActivity queryFrontActivityByActivityId(String activityId);

    /**
     * 前台活动list
     * @param activity
     * @param areaCode
     * @param type
     * @param theme
     * @param dateTime
     * @param activityEndTime
     * @param page
     * @param timeType
     * @param integer
     * @return
     * @throws Exception
     */
    List queryFrontActivityList(CmsActivity activity, String areaCode, String type, String theme, String dateTime, String activityEndTime, Pagination page, PaginationApp pageApp, String timeType) throws Exception;




    /**
     * 前台活动列表页总数量
     * @param activity
     * @param areaCode
     * @param type
     * @param theme
     * @param dateTime
     * @param activityEndTime
     * @param
     * @return
     * @throws Exception
     */
    Integer queryFrontActivityListCount(CmsActivity activity,String areaCode,String type ,String theme,String dateTime,String activityEndTime,String timeType) throws Exception;

    /**
     * 热点活动
     *
     * @param page
     * @return 返回(不含text类型)的字段列表信息
     */
    List<CmsActivity> queryYearHotActivity(String area,CmsActivity cmsActivity, Pagination page);


    /**
     * 详细页中的得到推荐活动
     * @param activity
     * @param page
     * @return
     */
    List<CmsActivity> getRelateActivity(CmsActivity activity, Pagination page);


    /**
     * 根据传入的map查询活动的总条数
     * @param map 查询条件
     * @return 活动总条数
     */
    int queryCmsActivityCountByCondition(Map<String, Object> map);


    /**
     * 根据传入的map查询前台活动的总条数
     * @param map 查询条件
     * @return 活动总条数
     */
    int queryFrontCmsActivityCountByCondition(Map<String, Object> map);


    /**
     * 保存活动预定信息
     * @param seatId
     * @param activityId
     * @return
     */
    public String saveFrontActivityBook(String[] seatId,String activityId,String phone,String userId,Integer bookCount);

    /**
     * 查询活动对应的座位信息
     * @param activityId
     * @return
     */
    public List queryActivitySeatInfoById(String activityId);

    /**
     * 根据城市查询活动的活动的 可能喜欢的数据
     * @param areaCode
     * @param activityIds
     * @return
     */
    public List<CmsActivity> queryActivityListByCity(String areaCode,String[] activityIds,String activityName, CmsActivity cmsActivity, Pagination page);

    /**
     * app根据展馆id查询相关活动
     * @param venueId
     * @param pageApp
     * @return
     */
    String queryActivityList(String venueId, PaginationApp pageApp);



    /**
     * app根据标签id查询当天是否有活动
     * app标签下附近是否有活动
     * @param Lon 经度
     * @param Lat 纬度
     * @param tagId 标签id
     * @param dictCode 标签类型
     * @param date
     * @param pageApp
     */
 public List<CmsActivity> queryAppCountByActivity(String tagId, String dictCode, String date, PaginationApp pageApp);

    /**
     * 根据活动id 获得该活动的标签值
     * @param activityId
     * @return
     */
    public List<Map> queryActivityLabelById(String activityId);


    /**
     * 查询活动中存在的区县
     * @param activityState
     * @return
     */
    public List<Map> queryExistArea(String activityState);

    /**
     * app查询最新活动
     * @param tagId 标签id
     * @param dictCode 字典
     * @param o
     * @param pageApp
     * @return
     */
    List<CmsActivity> queryAppLatestByActivity(String tagId, String dictCode, PaginationApp pageApp);

    //List<CmsActivity> queryAppHotByActivity(CmsActivity activity, String areaCode, String activityStartTime, String activityEndTime, PaginationApp pageApp, String timeType) throws ParseException;



    /**\
     * 前台活动listLoad分页查询
     * @param activity
     * @param areaCode
     * @param type
     * @param theme
     * @param orderType
     * @param activityStartTime
     * @param activityEndTime
     * @param page
     * @return
     * @throws Exception
     */
    public List queryActivityListLoad(CmsActivity activity, String areaCode,
                                      String type, String theme,String orderType,
                                      String activityStartTime, String activityEndTime, Pagination page) throws Exception ;




    /**
     * 前台活动listLoad分页查询
     * @param activity
     * @param page
     * @return
     * @throws Exception
     */
    public List queryActivityListCollectNumLoad(CmsActivity activity, Pagination page) throws Exception;



    /**
     * 前台活动listLoad总数
     * @param map
     * @return
     */
    public int queryActivityListLoadCount(Map map);

    /**
     * 查询需要统计的活动数据
     */
    public List<Map> queryActivityStatistic(Map map,int type);

    /**
     * 统计活动标签的数量
     * @param map
     * @return
     */
    List<Map> queryActivityCircleStatistic(Map<String,Object> map);


    /**
     *后台首页活动  各区县数量统计
     */
    List<Map> queryActivityGroupByArea(Map<String,Object> map);

    /**
     * 活动草稿箱发布活动
     * @param activityId
     * @return
     */
    String updateStateByActivityId(String activityId ,Integer activityState,SysUser sysUser);


    /**
     * 拒绝会员用户发布的活动申请
     * @param activityId
     * @return
     */
    String refuseTuserActivityByActivityId(String activityId ,Integer activityState,SysUser sysUser,String[] reason);


    /**
     * 将首页的列表数据放至内存中
     */
    public void setIndexListInfoToRedis();


    /**
     * 将老数据 无场次的活动 添加成新的数据格式内容
     */
    public void setOldEvent();


    /**
     * 数字文化管活动列表
     * @return
     */
    List<CmsActivity> queryCmsActivityListLoad(CmsActivity activity, Pagination page);

    /**
     * 数字文化管活动下属活动列表
     * @return
     */
    List<CmsActivity> queryUnderlingActivityByCondition(CmsActivity activity, Pagination page);


    /**
     * 子系统和文化云数据对接活动添加
     * */
    String addAPIActivity(CmsActivity activity, SysUser sysUser, String seatIds);

    /**
     * 修改活动信息
     *验证活动名称不能重复
     * @param activity 活动对象
     * @return failure 失败,success 成功 ,repeat 活动名称重复
     */
    String editActivityAPI(CmsActivity activity, SysUser sysUser, String seatIds,boolean hadOrder);


    /**
     * 图书管活动下属活动列表
     * @return
     */
    List<CmsActivity> queryBookUnderlingActivityByCondition(CmsActivity activity, Pagination page);

    /**
     * 图书管活动列表
     * @return
     */
    List<CmsActivity> queryBookCmsActivityListLoad(CmsActivity activity, Pagination page);

    /**
     * 根据name查询活动信息
     * @param activityName 主键
     * @return 活动信息
     */
    CmsActivity queryCmsActivityByActivityName(String activityName);

    /**
     * 文化云3.1前端首页即将开始的活动
     * @param activity 活动对象
     * @param page 分布对象
     * @return
     */
    List<CmsActivity> queryWillStartActivity(CmsActivity activity, Pagination page);

    /**
     * 文化云3.1前端首页本周活动
     * @param activity 活动对象
     * @param page 分布对象
     * @return
     */
    List<CmsActivity> queryThisWeekActivity(CmsActivity activity, Pagination page);

    /**
     * 文化云3.1前端首页猜你喜欢的活动
     * @param activity 活动对象
     * @param page 分布对象
     * @return
     */
    List<CmsActivity> queryMayLikeActivity(CmsActivity activity, Pagination page);

    /**
     * 文化云3.5前端首页栏目周末去哪儿活动
     * @return
     */
    List<CmsActivity> queryNavigationActivity();
    
    /**
     * 活动我想去接口
     * @param activityId        活动id
     * @param userId            用户id
     * return 是否报名成功 (成功：success；失败：false)
     */
    String addActivityUserWantgo(String activityId,String userId);
    
    /**
     * 获取活动我想去列表接口
     * @param activityUserWantgo   
     * @return
     */
    List<CmsUserWantgo> queryActivityUserWantgoByCondition(Pagination page,CmsUserWantgo activityUserWantgo);
    
    /**
     * 获取活动我想去总人数
     * @param activityUserWantgo   
     * @return
     */
 	int queryActivityUserWantgoCount(CmsUserWantgo activityUserWantgo);


    /**
     * 前台用户的发布的活动列表
     * @param cmsTerminalUser
     * @param states
     * @param page
     * @return
     */
    List<CmsActivity> queryUserPublicActivityList(CmsTerminalUser cmsTerminalUser ,Integer[] states ,Pagination page);


    /**
     * 保存前台用户发布的活动
     * @param cmsActivity
     * @param cmsTerminalUser
     * @param count
     * @return
     */
    String addActivity(CmsActivity cmsActivity,CmsTerminalUser cmsTerminalUser,Integer count);


    /**
     * 更新前台用户发布的活动
     * @param cmsActivity
     * @param cmsTerminalUser
     * @return
     */
    String editPublicActivity(CmsActivity cmsActivity,CmsTerminalUser cmsTerminalUser);


    /**
     * 前台用户删除活动
     * @param activityId
     * @return
     */
    String delPublicActivityByFrontUser(String activityId);


    /**
     * 当redis 内存座位数量为空时手动的往redis 里面添加数据  防止线上出现票数为0的情况
     * @param activityId
     * @return
     */
    String frontSetRedisTicketCount(String activityId) throws ParseException;




    /**
     * 向数据库和内存 插入正确的余票数
     * @param activityId
     * @return
     */
    public String setRightToRedisAndDataBase(String activityId,String eventId) throws Exception;


    /**
     * 查询所有正在进行未过期的活动 且数据库剩余票数和 redis 票数不一致
     * @return
     */
    List<ActivityForCompare> queryOngoingActivityCanBook();

    /**
     * 返回活动的座位信息 判断是文化云系统还是嘉定子系统信息
     * @param activityId
     * @return
     */
    public Map queryActivitySeatInfo(String activityId ,String eventDateTime) throws Exception;



    /**
     * 查询Lucene活动索引列表
     * @authour hucheng
     * @date 2016/1/12
     * @content add
     * @return List<Activity> activityList
     * */

   // List<CmsActivity> queryLuceneActivityList();

    /**
     * 查询活动详情页面内容
     * @param activityId
     * @return
     */
    public Map queryFrontDetailInfo(String activityId) throws Exception;


/*
    public String getSubSystemActivityTicketCount();*/

    /**
     *文化云首页列表查询
     * @param activity
     * @param page
     * @param isWeekend 1-周末 0-工作日
     * @param chooseType 筛选类别1(5天之内) 2(5-10天) 3(10-15天) 4(15天以后)
     * @param bookType 1-可预订 0-不可预订 空表示所有
     * @return
     */
    public List<CmsActivity> queryIndexActivityByCondition(CmsActivity activity,Pagination page,String isWeekend,String chooseType,String sortType,String bookType,CmsTerminalUser terminalUser);

    /**
     * why3.5 app首页推荐活动和首页标签活动存入redis by qww 2016-04-19
     */
    void appActivityListSetRedis();

    /**
     * 修改活动评级信息
     * @param ratingsInfo 评级信息
     * @param activityId  活动ID
     * @return true 修改成功 ;false 修改失败
     */
    boolean editRatingsInfo(String ratingsInfo,String activityId);


    /**
     * 根据活动id查询评级信息
     * @param activityId 活动id
     * @return 评级信息
     */
    String queryRatingsInfoByActivityId(String activityId);


    /**
     * 后台查询活动下的场次
     *
     * @param activityId
     * @return
     */
    List<CmsActivityEvent> queryCmsActivityEventByActivityId(String activityId);

    /**
     * 保存活动信息
     * 验证活动名称不能重复
     *
     * @param activityId 活动对象
     * @param sysUser  用户对象
     * @return failure 失败,success 成功 ,repeat 活动名称重复
     */
    String copyActivity(String activityId, SysUser sysUser);
    
    /**
     * 专属页选择关联活动列表
     * @param
     * @return
     */
    public List<CmsActivity> queryActivityFromSpecialPage(String activityName,String pageId,String tagSubName,String selectType, Pagination page);
}

