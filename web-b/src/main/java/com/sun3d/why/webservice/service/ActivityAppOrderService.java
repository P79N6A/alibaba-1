package com.sun3d.why.webservice.service;

import com.sun3d.why.util.PaginationApp;

public interface ActivityAppOrderService {
    /**
     * app根据用户id查询当前我的活动订单信息
     * @param pageApp 分页对象
     * @param userId 用户id
     * @return
     */
    public String queryAppCurrentOrdersByUserId(PaginationApp pageApp, String userId) throws Exception;

    /**
     * app根据用户id查询过去我的活动订单
     * @param userId
     * @param pageApp
     * @return
     */
   public String queryAppPastOrdersByUserId(String userId, PaginationApp pageApp);

    /**
     * app删除我的历史订单记录
     * @param activityOrderId 活动订单id
     * @param userId 用户id
     * @return
     */
    public int deleteUserActivityHistory(String activityOrderId, String userId);

    /**
     * 取票机活动取票流程
     * @param validateCode 取票码
     * @param seats 座位号
     * @return
     */
    public  String takeAppActivityValidateCode(String validateCode,String seats) throws Exception;

    /**
     * 验票系统获取活动订单信息
     * @param orderValidateCode 取票码
     * @return
     */
    public String queryActvityOrderByValidateCode(String orderValidateCode) throws Exception;

    /**
     * 验证系统验证座位信息
     * @param orderValidateCode 取票码
     * @param seats 座位号
     * @param userId 用户id
     * @param orderPayStatus 订单状态 1-未出票 2-已取消 3-已出票 4-已验票 5-已失效
     * @return
     */
    public String queryActvityOrderSeatsByValidateCode(String orderValidateCode,String seats, String userId,String orderPayStatus)throws Exception;

    /**
     * app获取电子票订单信息
     * @param activityOrderId 活动订单id
     * @return
     */
     public String queryAppELectronicTicketById(String activityOrderId) throws Exception;

    /**
     * 取票机获取订单详情(活动或活动室)
     * @param orderValidateCode 取票码
     * @return
     */
     public String queryAppOrderDetails(String orderValidateCode);

}
