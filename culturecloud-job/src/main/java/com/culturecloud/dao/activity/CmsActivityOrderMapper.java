package com.culturecloud.dao.activity;

import java.util.List;
import java.util.Map;

import com.culturecloud.dao.dto.activity.CmsActivityOrderDto;
import com.culturecloud.dao.dto.activity.CmsCancelOrderDto;
import com.culturecloud.model.bean.activity.CmsActivityOrder;

public interface CmsActivityOrderMapper {

	 /**
     * 查询检查订单列表
     * @param map
     * @return
     */
    List<CmsActivityOrderDto> queryCheckOrderList(Map<String, Object> map);
    
    String [] queryOrderRepeatSeat(Map<String, Object> map);
    
    /**
     * 查询过期未核销的订单
     * 
     * @param dayAgo 几天之前的活动
     * @return
     */
    List<CmsActivityOrderDto> queryTimeOutNotVerificationOrder(String date);
    
    CmsActivityOrder queryCmsActivityOrderById(String activityOrderId);
    
    List<CmsCancelOrderDto> cancelOrder();
}
