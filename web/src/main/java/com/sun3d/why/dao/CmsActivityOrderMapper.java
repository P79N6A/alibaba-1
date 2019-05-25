package com.sun3d.why.dao;

import java.util.List;
import java.util.Map;

import com.sun3d.why.model.CmsActivityOrder;
import com.sun3d.why.util.Pagination;

public interface CmsActivityOrderMapper {

    int deleteCmsActivityOrderById(String activityOrderId);

    int addCmsActivityOrder(CmsActivityOrder record);

    CmsActivityOrder queryCmsActivityOrderById(String activityOrderId);
    
    CmsActivityOrder queryCmsActivityOrderByOrderValidateCode(String orderValidateCode);

    int editCmsActivity(CmsActivityOrder record);

    public  Map queryFrontOrderById(String activityOrderId);

    /**
     * 查询用户已经购买的总票数
     * @param map
     * @return
     */
    public Integer queryOrderTicketCountByUser(Map map);

    /**
     * 查询用户已经购买的总票数
     * @param map
     * @return
     */
    public Integer queryOrderCountByUser(Map map);



    List<Map> queryUserOrderByMap(Map map);

    Integer queryUserOrderCountByMap(Map map);

    List<CmsActivityOrder> queryUserOrderListById(String userId,Pagination page);

    /**
     * 前端2.0我的活动列表
     * @param map
     * @return 活动对象集合   queryUserActivityUn
     */
    List<CmsActivityOrder> queryUserActivityList(Map<String, Object> map);

    /**
     * 前端2.0我的活动总数
     * @param map
     * @return 活动对象集合
     */
    int queryUserActivityListCount(Map<String, Object> map);

    int queryCountByOrderNo(String orderNumber);

    /**
     *前端2.0我的活动  未完成列表
     * @param map
     * @return
     */
    List<CmsActivityOrder> queryUserActivityUnList(Map<String, Object> map);

    /**
     * 前端2.0我的活动 未完成列表总数
     * @param map
     * @return 活动对象集合
     */
    int queryUserActivityListUnCount(Map<String, Object> map);

    /**
     * 前端2.0我的活动  历史活动列表
     * @param map
     * @return
     */
    List<CmsActivityOrder> queryUserActivityHistoryList(Map<String, Object> map);

    /**
     * 前端2.0我的活动 历史活动总数
     * @param map
     * @return 活动对象集合
     */
    int queryActivityOrderHistoryCount(Map<String, Object> map);

    /**
     *
     * @param map
     * @return
     */
    int queryUserActivityCountByCondition(Map<String, Object> map);

    /**
     *添加我的活动  -- 前端
     * @param cmsActivityOrder
     * @return
     */
    int addActivityOrder(CmsActivityOrder cmsActivityOrder);

    /**
     * 修改我的活动 -- 前端
     * @param cmsActivityOrder
     * @return
     */
    int editActivityOrder(CmsActivityOrder cmsActivityOrder);


    public List<Map> queryActivityOrderInfoById(String activityOrderId);

    /**
     * 删除我的活动
     * @param map
     * @return
     */
    int deleteUserActivityHistory(Map<String,Object> map);

    /**
     * 前端查询我的活动  用户已经预定但是没有参加的条数
     * @return
     */
    int queryAllReserveAndNotReserved(Map<String , Object> map);

    /**
     * 查询评论数
     * @return
     */
    int queryActivityCommentByActivityId(Map<String ,Object> map);


    /**
     * 取消订单
     */
    int updateOrderByActivityOrderId(Map<String ,Object> map);

    /**
     * app根据订单票码获取信息
     * @param map
     * @return
     */
    CmsActivityOrder queryValidateCode(Map<String, Object> map);

    /**
     * 根据区域统计总订票数
     * @param map
     * @return
     */
    public List<Map> queryTicketCountByArea(Map map);

    /**
     * 
     * @Description:判断场馆下所有有效活动室被预订的总数
     * @author yanghui 
     * @Created 2015-10-20
     * @param map
     * @return
     */
    int queryCountRoomOrderOfVenue(Map<String,Object> map);

    /**
     * 根据活动id查询订单List
     * @param activityId
     * @return  List<CmsActivityOrder>
     */
    public List<CmsActivityOrder> queryCmsActivityOrderListByActivityId(String activityId);

    /**
     * app根据用户id获取我的当前活动订单
     * @param map
     * @return
     */
    List<CmsActivityOrder> queryAppCurrentOrdersByUserId(Map<String, Object> map);

    /**
     * app根据用户id获取我的历史活动订单
     * @param map
     * @return
     */
    List<CmsActivityOrder> queryAppPastOrdersByUserId(Map<String, Object> map);

    /**
     * 旧数据订单数据 关联场次信息
     * @param eventId
     * @param activityId
     * @return
     */
    int updateOrderEventByActivityId(String eventId, String activityId);




    /**
     * 验票系统验证活动订单信息
     * @param map
     * @return
     */
    CmsActivityOrder queryActvityOrderByValidateCode(Map<String, Object> map);

    /**
     * 根据活动Id查询有效的需要撤销的订单List
     * @param activityId 活动id
     * @return
     */
    public   List<CmsActivityOrder>  queryRevocationActivityOrdersByActivityId(String activityId);

    /**
     * 根据活动id 撤销该活动下的所有订单
     * @param userId
     * @return
     */
    int revocationActivityOrderByActivityId(String activityId,String userId);
    /**
     * 单个活动票务或所有活动的订单信息数量
     * @param map
     * @return
     */
    int queryActivityOrderCountByActivityId(Map map);

    /**
     * 单个活动票务或所有活动的订单信息
     * @param map
     * @return
     */
    public List<CmsActivityOrder> queryActivityOrderByActivityId(Map map);

    /**
     * app获取电子票订单信息
     * @param activityOrderId 活动订单id
     * @return
     */
    public CmsActivityOrder queryAppELectronicTicketById(String activityOrderId);


    /**
     * 查询活动已经预定的数量
     */
    public Integer queryActivityBookCount(String activityId);


    /**
     *  根据活动id 查询 活动下的有效订单剩余票数
     * @param activityId
     * @return
     */
    int queryEffectiveTicketCountByActivityId(String activityId,String eventId);


    /**
     *  根据活动id 查询 活动的订单票数
     * @param activityId
     * @return
     */
    int queryBookTicketCountByActivityId(String activityId,String eventId);

    /**
     * app获取活动订单（当前与历史）
     * @param map
     * @return
     */
    List<CmsActivityOrder> queryAppActivityOrdersById(Map<String, Object> map);

    /**
     * why3.5 app显示或搜索用户活动订单信息（当前未过期订单）
     * @param map
     * @return
     */
    List<CmsActivityOrder> queryAppActivityOrderByUserId(Map<String, Object> map);
    
    /**
     * why3.5 app用户活动订单详情
     * @param map
     * @return
     */
    CmsActivityOrder queryAppUserActivityOrderDetail(Map<String, Object> map);

    /**
     * why3.5 app显示或搜索用户活动历史订单信息（过期订单，即历史订单）
     * @param map
     * @return
     */
    List<CmsActivityOrder> queryAppHistoryActivityOrderByUserId(Map<String, Object> map);

    /**
     * 根据子系统中的订单id 查询文化云中的对应订单
     * @param sysId
     * @return
     */
    String queryActivityIdBySysId(String sysId);
    
    /**
     * 查询过期未核销的订单
     * 
     * @param dayAgo 几天之前的活动
     * @return
     */
    List<CmsActivityOrder> queryTimeOutNotVerificationOrder(String date);
    
    /**
     * 查询检查订单列表
     * @param map
     * @return
     */
    List<CmsActivityOrder> queryCheckOrderList(Map<String, Object> map);
    
    String [] queryOrderRepeatSeat(Map<String, Object> map);
    
    /**
     * 获取未取消订单
     * @param map
     * @return
     */
    List<CmsActivityOrder> queryNoCancelActivityOrder(Map<String, Object> map);
    
    /**
     * why3.6 app显示或搜索用户活动订单信息（待支付）
     * @param map
     * @return
     */
    List<CmsActivityOrder> queryAppActivityPayOrderByUserId(Map<String, Object> map);
}