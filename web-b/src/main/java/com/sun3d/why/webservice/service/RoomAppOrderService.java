package com.sun3d.why.webservice.service;

import com.sun3d.why.util.PaginationApp;

/**
 * 我的活动室订单
 */
public interface RoomAppOrderService {
    /**
     * app获取我的当前活动室订单
     * @param userId 用户id
     * @param pageApp 分页对象
     * @return
     */
   public  String queryCurrentRoomOrderListById(String userId, PaginationApp pageApp) throws Exception;

    /**
     * app获取我的过去活动室订单
     * @param userId
     * @param pageApp
     * @return
     */
   public   String queryPastRoomOrderListById(String userId, PaginationApp pageApp);

    /**
     * app删除以往活动室订单
     * @param roomOrderId 活动室订单id
     * @param userId 用户id
     * @return
     */
   public  int deleteRoomOrderById(String roomOrderId, String userId);

    /**
     * 验证系统获取活动室订单信息
     * @param orderValidateCode 取票码
     * @return
     */
   public String queryRoomOrderByValidateCode(String orderValidateCode);

    /**
     * 验证系统验证活动室订单
     * @param roomOderId 活动室订单id
     * @param userId 后台用户id
     * @param roomTime 活动室时间
     * @return
     */
    public   String checkCmsRoomOrderByRoomOrderId(String roomOderId,String userId,String roomTime);

    /**
     * 活动室取票流程
     * @param validateCode 取票码
     * @return
     */
    public String takeAppRoomValidateCode(String validateCode) throws Exception;
}
