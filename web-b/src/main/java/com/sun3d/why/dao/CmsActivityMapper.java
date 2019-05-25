package com.sun3d.why.dao;
import com.sun3d.why.model.CmsActivity;
import com.sun3d.why.model.extmodel.AppIndexData;

import java.util.List;
import java.util.Map;


public interface CmsActivityMapper {

    /**
     * 保存活动信息
     * @param activity 活动对象
     * @return 0 失败, 1成功
     */
    int addCmsActivity(CmsActivity activity);

    /**
     * 修改活动信息
     * @param activity  活动对象
     * @return 0 失败, 1成功
     */
    int editCmsActivity(CmsActivity activity);

    int deleteByActivityId(String activityId);

    /**
     * 根据传入的map查询活动列表信息
     * @param map  查询条件
     * @return 活动列表信息
     */
    public List<CmsActivity> queryCmsActivityByCondition(Map<String, Object> map);


    /**
     * 根据传入的map查询后台活动列表信息 new
     * @param map  查询条件
     * @return 活动列表信息
     */
    public List<CmsActivity> queryCmsActivityByAdminCondition(Map<String, Object> map);

    /**
     * 根据传入的map查询活动的总条数
     * @param map 查询条件
     * @return 活动总条数
     */
    int queryCmsActivityCountByCondition(Map<String, Object> map);
    
    /**
     * app根据传入的map查询活动的总条数,过滤过期的活动
     * @param map 查询条件
     * @return 活动总条数
     */
    int queryAppRecommendCmsActivityCountByCondition(Map<String, Object> map);

    List<CmsActivity> queryRecommendCmsActivityList(Map<String, Object> map);

    List<CmsActivity> queryAppRecommendCmsActivityList(Map<String, Object> map);


    /**
     * 根据传入的map查询活动列表信息
     * @param map  查询条件
     * @return 个人发布活动列表信息
     */
    public List<CmsActivity> queryPersonalActivityByCondition(Map<String, Object> map);


    /**
     * 根据传入的map查询个人发布活动的总条数
     * @param map 查询条件
     * @return 活动总条数
     */
    int queryPersonalCmsActivityCountByCondition(Map<String, Object> map);


    /**
     * 根据传入的map查询前台活动的总条数
     * @param map 查询条件
     * @return 活动总条数
     */
    public int queryFrontCmsActivityCountByCondition(Map<String, Object> map);

    /**
     * 查询活动名称是否已存在
     * @param activityName 活动名称
     * @return 0 不存在 1存在
     */
    int queryActivityNameIsExists(String activityName);


    /**
     * 查询活动名称是否已存在
     * @param map
     * @return 0 不存在 1存在
     */
    int queryAPIActivityNameIsExists(Map<String,Object> map);

    /**
     * 根据主键id查询活动信息
     * @param activityId 主键
     * @return 活动信息
     */
    CmsActivity queryCmsActivityByActivityId(String activityId);

    /**
     * 根据活动id查询活动订单数
     *
     * @param activityId 活动id
     * @return 活动订单数
     */
    int queryOrderCountByActivityId(String activityId);

    public List<CmsActivity> queryBestHotActivity(CmsActivity activity);

    int countBestHotActivity(CmsActivity example);

    List<CmsActivity> queryYearHotActivity(CmsActivity example);

    int countYearHotActivity(CmsActivity example);


    //展馆前台获取活动
    List<CmsActivity> queryCmsVenueActivity(Map<String, Object> map);

    int countMonthHotActivity(CmsActivity example);

    List<CmsActivity> queryMonthHotActivity(CmsActivity example);

    /**
     * 前端2.0活动收藏列表
     * @param map
     * @return 活动对象集合
     */
    List<CmsActivity> queryCollectActivity(Map<String, Object> map);

    /**
     * 前端2.0活动收藏个数
     * @param map
     * @return
     */
    int queryCollectActivityCount(Map<String, Object> map);

    public Integer queryCountByActivity(CmsActivity cmsActivity);

    /**
     * 查询最新发布活动
     * @param map
     * @return 活动对象集合
     */
    List<CmsActivity> queryBestNewPublishActivity(Map<String, Object> map);


    /**
     * 相关活动推荐
     * @param map
     * @return
     */
    public List<CmsActivity> getRelateActivity(Map map);

    /**\
     * 前台页面列表页面查询
     * @param map
     * @return
     */
    public List queryFrontActivityList(Map map);


//    /**\
//     * 前台首页页面列表收藏和浏览量查询
//     * @param map
//     * @return
//     */
//    public List<Map> queryIndexListCollectViewNum(Map map);

    /**\
     * 前台页面列表页面查询
     * @param map
     * @return
     */
    public List queryActivityListLoad(Map map);


    /**\
     * 前台页面列表页面查询 带出收藏数量
     * @param map
     * @return
     */
    public List queryActivityListCollectNumLoad(Map map);


    /**\
     * 前台页面列表页面总数查询
     * @param map
     * @return
     */
    public int queryActivityListLoadCount(Map map);


    /**
     * 前台页面列表总数量
     * @param map
     * @return
     */
    public Integer queryFrontActivityListCount(Map map);

    /**
     * 活动座位信息查询
     * @param map
     * @return
     */
    public List queryActivitySeatByCondition(Map map);


    /**
     * 推荐活动信息
     * @param map
     * @return
     */
    public List<CmsActivity> queryRecommendActivityList(Map map);

    /**
     * 推荐活动信息收藏数量
     * @param map
     * @return
     */
    public List<Map> frontRecommendActivityCollectNum(Map map);


    /**
     * 填补不足的推荐活动信息
     * @param map
     * @return
     */
    public List<CmsActivity> queryRecommendActivityLostList(Map map);


    /**
     * app获取后台推荐20条
     * @param map
     * @return
     */
    List<CmsActivity> queryCmsActivityAppByActivityNum(Map<String, Object> map);

    /**
     * app根据展馆id获取相关活动
     * @param map
     * @return
     */
    List<CmsActivity> queryActivityListById(Map<String, Object> map);


    /**
     * 查询可能喜欢的数据
     * @param map
     * @return
     */
    public List<CmsActivity> queryActivityListByCity(Map map);


    /**
     * app标签推荐今天是否有活动
     * @param map
     * @return
     */
    List<CmsActivity> queryAppCountByActivity(Map<String, Object> map);

    /**
     * 查询活动中存在的标签
     * @param map
     * @return
     */
    List<Map> queryActivityLabelById(Map map);


    List<Map>  queryExistArea(String activityId);

    /**
     * app查询最新活动
     * @param map
     * @return
     */
    List<CmsActivity> queryAppLatestByActivity(Map<String, Object> map);
    /**
     * app查询最热门活动
     * @param map
     * @return
     */
    List<CmsActivity> queryAppHotByActivity(Map<String, Object> map);

    /**
     * app查询标签下当天是否有活动
     * app标签下附近是否有活动
     * @param map
     * @return
     */
    int queryAppCount(Map<String, Object> map);

    /**
     * app查看所有活动
     * @param map
     * @return
     */
    List<CmsActivity> queryFrontAppAllActivityList(Map<String, Object> map);


    /**
     * 活动统计
     * @param map
     * @return
     */
    List<Map > queryActivityStatistic(Map<String, Object> map);

    /**
     * 商圈统计
     * @param map
     * @return
     */
    List<Map> queryActivityCircleStatistic(Map<String,Object> map);

    /**
     *后台首页活动  各区县数量统计
     */
    List<Map> queryActivityGroupByArea(Map<String,Object> map);

    /**
     * app获取最热门活动
     * @param map
     * @return
     */
    int queryAppHotByActivityListCount(Map map);

    /**
     * app根据活动类型筛选活动列表
     * @param map
     * @return
     */
    List<CmsActivity> queryActivityListPage(Map map);

    /**
     * app根据条件筛选活动数
     * @param map
     * @return
     */
    int queryAppActivityListCount(Map map);

    //CmsActivity queryAppActivityById(String activityId,String userId);

    /**
     * app根据活动id查询活动信息
     * @param map
     * @return
     */
    CmsActivity queryAppActivityById(Map<String, Object> map);

    /**
     * why3.5 app根据活动id查询活动信息
     * @param map
     * @return
     */
    CmsActivity queryAppCmsActivityById(Map<String, Object> map);

    /**
     * 活动草稿箱发布活动
     * @param activity
     * @return
     */
    int updateStateByActivityId(CmsActivity activity);


    /**
     * 将老数据 无场次的活动 添加成新的数据格式内容
     */
    public List<CmsActivity>  setOldEvent();

    /**
     * 数字文化管活动个数
     * @param map
     * @return
     */
    int queryCmsActivityListLoadCount(Map<String, Object> map);

    /**
     * 数字文化管活动列表
     * @param map
     * @return
     */
    List<CmsActivity> queryCmsActivityListLoad(Map<String, Object> map);

    /**
     * 数字文化管活动下属活动条数
     * @param map
     * @return
     */
    int queryUnderlingActivityCountByCondition(Map<String, Object> map);

    /**
     * 数字文化管活动下属活动列表
     * @param map
     * @return
     */
    List<CmsActivity> queryUnderlingActivityByCondition(Map<String, Object> map);

    /**
     * 根据name查询活动信息
     * @param activityName 主键
     * @return 活动信息
     */
    CmsActivity queryCmsActivityByActivityName(String activityName);
    
    /**
     * 根据TagId查询相关活动数目
     * @param tagId
     * @return 活动数目
     */
    int queryActivityCountByTag(String tagId);
    
    /**
     * app根据不同条件筛选活动列表
     * @param map
     * @return
     */
    List<CmsActivity> queryAppActivityListByCondition(Map map);




    /**
     * 修改活动信息
     * @param activity  活动对象
     * @return 0 失败, 1成功
     */
    int editRecommendCmsActivity(CmsActivity activity);


    /**
     * 前台用户的发布的活动列表
     * @param map
     * @return
     */
    List<CmsActivity> queryUserPublicActivityList(Map map);

    /**
     * 前台用户的发布的活动列表总数量
     * @param map
     * @return
     */
    int queryUserPublicActivityListCount(Map map);





    /**
     * app获取首页活动标签列表
     * @param activityTheme 活动主题
     * @return
     */
    List<CmsActivity> queryActivityThemeByCode(String activityTheme);





    /**
     * 文化云3.1前端首页即将开始的活动
     * @param map
     * @return
     */
    List<CmsActivity> queryWillStartActivity(Map<String, Object> map);

    /**
     * 文化云3.1前端首页本周活动
     * @param map
     * @return
     */
    List<CmsActivity> queryThisWeekActivity(Map<String, Object> map);

    /**
     * 文化云3.1前端首页猜你喜欢的活动
     * @param map
     * @return
     */
    List<CmsActivity> queryMayLikeActivity(Map<String, Object> map);

    /**
     * 文化云3.1前端首页栏目(免费看演出、孩子学艺术、周末去哪儿)活动
     * @param
     */
    List<CmsActivity> queryNavigationActivity();


    /**
     * 文化云3.1前端首页热点推荐，根据活动id统计票数
     * @param activityId
     * @return
     */
    CmsActivity queryAvailableCountByActivityId(String activityId);



    /**
     * app查询最新发布活动列表
     * @param param
     * @return
     */
    List<CmsActivity> queryAppCurrentActivityList(Map<String, Object> param);


    /**
     * 查询app首页栏目推荐
     *
     * @return 活动列表信息
     */
    List<CmsActivity> queryAppRecommendCmsActivityByCondition(Map<String,Object> map);


    /**
     * 查询Lucene活动索引列表
     * @authour hucheng
     * @date 2016/1/12
     * @content add
     * @return List<Activity> activityList
     * */
    public List<CmsActivity> queryLuceneActivityList();


    /**
     * 查询所有正在进行未过期的活动
     * @return
     */
    List<CmsActivity> queryOngoingActivityCanBook();

    /**
     * app查询推荐的活动
     * @param map
     * @return
     */
    List<CmsActivity> queryRecommendActivity(Map<String, Object> map);

    /**
     * app查询置顶标签的活动
     * @param map
     * @return
     */
    List<CmsActivity> queryTopActivity(Map<String, Object> map);

    // why3.4 app展示静态数据和余票
    List<AppIndexData> queryAppIndexData(Map<String, Object> map);

    /**
     * why3.4 app查询置顶标签的活动
     * @param map
     * @return
     */
    List<CmsActivity> queryAppTopCmsActivity(Map<String, Object> map);

    /**
     * why3.4 app查询推荐的活动
     * @return
     */
    List<CmsActivity> queryAppRecommendCmsActivity();

    /**
     * why3.4 app近期活动列表
     * @param map
     * @return
     */
    List<CmsActivity> queryNearActivityByCondition(Map<String, Object> map);


    /**
     * why3.4 首页活动列表查询
     * @param map
     * @return
     */
    List<CmsActivity> queryIndexActivityByCondition(Map<String, Object> map);

    /**
     * why3.4 首页活动列表数量
     * @param map
     * @return
     */
    Integer queryIndexActivityCountByCondition(Map<String, Object> map);

    /**
     * why3.5 app日历下每天活动场数
     * @param map
     * @return
     */
    int queryAppEveryDateActivityCount(Map<String, Object> map);

    /**
     * why3.5 app日历下某一天活动列表
     * @param map
     * @return
     */
    List<CmsActivity> queryAppEveryDateActivityList(Map<String, Object> map);

    /**
     * why3.5 app附近活动列表
     * @param map
     * @return
     */
    List<CmsActivity> queryAppNearActivityList(Map<String, Object> map);

    /**
     * why3.5 app根据展馆id获取相关活动列表
     * @param map
     * @return
     */
    List<CmsActivity> queryAppActivityListById(Map<String, Object> map);

    /**
     * why3.5 app根据展馆id获取相关活动个数
     * @param map
     * @return
     */
    int queryAppActivityCountById(Map<String, Object> map);

    /**
     * why3.5 app根据不同条件筛选活动列表(搜索功能)
     * @param map
     * @return
     */
    List<CmsActivity> queryAppCmsActivityListByCondition(Map<String, Object> map);

    /**
     * why3.5 app根据不同条件筛选活动个数(搜索功能)
     * @param map
     * @return
     */
    int queryAppCmsActivityListCount(Map<String, Object> map);

    /**
     * why3.5 app查询推荐的活动
     * @return
     */
    List<CmsActivity> queryAppRecommendActivityList(Map<String, Object> map);

    /**
     * why3.5 app查询推荐的活动（带筛选）
     * @return
     */
    List<CmsActivity> queryFilterActivityList(Map<String, Object> map);
    
    /**
     * why3.5 app查询置顶标签的活动
     * @param map
     * @return
     */
    List<CmsActivity> queryAppTopActivityList(Map<String, Object> map);


    /**
     * 修改活动评级信息
     * @param ratingsInfo 评级信息
     * @param activityId  活动ID
     * @return 0 修改成功,1 修改失败
     */
    int editRatingsInfo(String ratingsInfo,String activityId);


    /**
     * 根据活动id查询评级信息
     * @param activityId 活动id
     * @return 评级信息
     */
    String queryRatingsInfoByActivityId(String activityId);

    /**
     * why3.5 app日历下时间段活动场数
     * @param map
     * @return
     */
    int queryAppDatePartActivityCount(Map<String, Object> map);

    /**
     * why3.5 app根据不同条件查询月、周下活动列表
     * @param map
     * @return
     */
    List<CmsActivity> queryAppActivityCalendarList(Map<String, Object> map);

    /**
     * 我的活动日历（历史预定活动及收藏）列表
     * @param map
     * @return
     */
    List<CmsActivity> queryAppHistoryActivityList(Map<String, Object> map);

    /**
     * 我的活动日历（月份预定活动及收藏）列表
     * @param map
     * @return
     */
    List<CmsActivity> queryAppMonthActivityList(Map<String, Object> map);
    
    /**
     * 专属页选择关联活动列表(总数)
     * @param map
     * @return
     */
    int queryActivityFromSpecialPageCount(Map<String, Object> map);
    
    /**
     * 专属页选择关联活动列表
     * @param map
     * @return
     */
    List<CmsActivity> queryActivityFromSpecialPage(Map<String, Object> map);
}