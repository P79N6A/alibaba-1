package com.sun3d.why.service;

import com.sun3d.why.model.*;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.PaginationApp;

import java.util.List;
import java.util.Map;

public interface CmsActivityOrderService {

    int deleteCmsActivityOrderById(String activityOrderId);

    int addCmsActivityOrder(CmsActivityOrder record);

    CmsActivityOrder queryCmsActivityOrderById(String activityOrderId);

    int editCmsActivity(CmsActivityOrder record);

    List<Map> queryUserOrderByMap(Map map, Pagination page);

    Integer queryUserOrderCountByMap(Map map);

    int queryCountByOrderNo(String orderNumber);

    public  Map queryFrontOrderById(String activityOrderId);

    public int updateOrderByActivityOrderId(String activityOrderId,CmsActivityOrder cmsActivityOrder,CmsActivityEvent cmsActivityEvent,List<CmsActivityOrderDetail> cmsActivityOrderDetails,String orderSeat,Integer cancelCount);

    public Map cancelUserOrder(String activityOderId,CmsTerminalUser cmsTerminalUser,String orderSeat,Integer cancelCount);

    /**
     * 发送短消息接口
     * @param userMobileNo 手机号码
     * @param smsContent 消息内容
     * @return
     */
    //String sendSmsMessage(String userMobileNo,String smsContent);


    /**
     * 我的活动列表
     * @param userId
     * @param page
     * @param pageApp
     * @return
     */
    List<CmsActivityOrder> queryUserOrderListById(String userId, Pagination page, String activityName, PaginationApp pageApp);
    /**
     * 前端2.0我的活动总数
     * @param map
     * @return
     */
    int queryUserActivityListCount(Map<String, Object> map);

    /**
     *  前端2.0我的活动  未完成列表
     * @param user
     * @param page
     * @param activityName
     * @return
     */
    List<CmsActivityOrder> queryUserActivityUn(String user,Pagination page,String activityName);

    /**
     *前端2.0我的活动 未完成列表总数
     * @param map
     * @return
     */
    int queryUserActivityUnCount(Map<String, Object> map);

    /**
     *  前端2.0我的活动  未完成列表
     * @param user
     * @param page
     * @param activityName
     * @param pageApp
     * @return
     */
    List<CmsActivityOrder> queryUserActivityHistory(String user, Pagination page, String activityName, PaginationApp pageApp);

    /**
     *前端2.0我的活动 未完成列表总数
     * @param map
     * @return
     */
    int queryUserActivityHistoryCount(Map<String, Object> map);


    /**
     * 添加我的活动
     * @param cmsActivityOrder
     * @return
     */
    String  addActivityOrder(CmsActivityOrder cmsActivityOrder);

   String checkActivitySeatStatus(CmsActivityOrder cmsActivityOrder,String[] seatIds);

    /**
     * 带条件编辑活动室预定信息
     * @param cmsActivityOrder 活动室预定信息
     * @return
     */
    int editActivityOrder(CmsActivityOrder cmsActivityOrder);



    public List<Map> queryActivityOrderInfoById(String activityOrderId);

    /**
     * 删除我的活动历史活动
     * @param activityOrderId
     * @param userId
     * @return
     */
    int deleteUserActivityHistory(String activityOrderId , String userId);

    /**
     * 查询前端我的活动吗，已经预定但是没有参加的个数
     * @return
     */
    int queryAllReserveAndNotReserved(String userId);

    /**
     * 获取评论数
     * @param userId
     * @return
     */
    int queryActivityCommentByActivityId(String userId , int commentType);

    /**\
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

    /**
     * 发送短信
     * @param terminalUser
     * @param cmsActivityOrder
     * @param cmsActivity
     */
    public void sendPhoneMsg(final CmsTerminalUser terminalUser,final CmsActivityOrder cmsActivityOrder,final CmsActivity cmsActivity);



    /**
     * 根据区域统计总订票数
     * @param map
     * @return
     */
    public List<Map> queryTicketCountByArea(Map map);

    /**
     * app根据取票码改变票状态
     * @param cmsActivityOrder
     * @return
     */
    int editAppActivityOrder(CmsActivityOrder cmsActivityOrder);
    
    int queryCountRoomOrderOfVenue(Map<String,Object> map);


    /**
     * 根据活动id查询订单List
     * @param activityId
     * @return  List<CmsActivityOrder>
     */
    public List<CmsActivityOrder> queryCmsActivityOrderListByActivityId(String activityId);


    /**
     * 活动撤销时批量给有效的订单用户 发送短信 通知
     * @param activityId
     * @param msgSMS
     */
    public void revocationActivitySendSMS(String activityId,String msgSMS,String userId);

    /**
     * 单个活动票务或所有活动的订单
     * @param map
     * @return
     */
    public List<CmsActivityOrder> queryActivityOrderByActivityId(Map map,Pagination page,CmsActivityOrder activity,SysUser sysUser);


    /**
     * 自由入座取消整个订单
     */
    int updateOrderByActivityOrderId(Map map);


    /**
     * 添加子系统的活动订单
     * @param cmsActivityOrder
     * @return
     */
    int addSubSystemActivityOrder(CmsActivityOrder cmsActivityOrder, String seatValues);


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
    public List<CmsActivityOrder> queryTimeOutNotVerificationOrder(int dayAgo);

}