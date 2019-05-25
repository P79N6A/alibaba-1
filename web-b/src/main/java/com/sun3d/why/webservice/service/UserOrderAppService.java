package com.sun3d.why.webservice.service;

import com.sun3d.why.util.PaginationApp;

/**
 * Created by wangkun on 2016/2/17.
 */
public interface UserOrderAppService {
    /**
     * app显示或搜索用户活动与活动室订单（当前与历史）
     * @param pageApp 分页对象
     * @param userId  用户id
     * @param orderValidateCode 取票码
     * @param venueName 展馆名称
     * @param activityName 活动名称
     * @param orderNumber   订单编号
     * @return
     */
     public String queryAppOrdersById(PaginationApp pageApp, String userId,String orderValidateCode,String venueName,String activityName,String orderNumber) throws Exception;

     /**
      * why3.5.2 app显示或搜索用户活动室 待审核订单（当前未过期订单）
      * @param pageApp 分页对象
      * @param userId  用户id
      * @return
      */
     String queryAppUserCheckOrderByUserId(PaginationApp pageApp, String userId) throws Exception;
     
    /**
     * why3.5 app显示或搜索用户活动与活动室订单信息（当前未过期订单）
     * @param pageApp 分页对象
     * @param userId  用户id
     * @return
     */
    String queryAppUserOrderByUserId(PaginationApp pageApp, String userId) throws Exception;
    
    /**
     * why3.5 app用户活动订单详情
     * @param userId 用户id
     * @param activityOrderId 订单ID
     * @return json 10111:用户id不存在
     */
    String queryAppUserActivityOrderDetail(String userId,String activityOrderId) throws Exception;
    
    /**
     * why 3.5.2 app用户活动室订单详情
     * 
     * @param userId
     * @param roomOrderId
     * @return
     * @throws Exception
     */
    String queryAppUserRoomOrderDetail(String userId,String roomOrderId) throws Exception;


    /**
     * why3.5 app显示或搜索用户活动与活动室历史订单信息（过期订单，即历史订单）
     * @param pageApp 分页对象
     * @param userId  用户id
     * @return
     */
    String queryAppUserHistoryOrderByUserId(PaginationApp pageApp, String userId) throws Exception;
    
    /**
     * 3.5.2查询用户当前带参加 订单数
     * 
     * @param userId
     * @return
     */
    long queryAppUserOrderCountByUserId( String userId);
}
