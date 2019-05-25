package com.culturecloud.service.local.activity;

import java.util.List;

import com.culturecloud.dao.dto.activity.CmsActivityOrderDto;

public interface CmsActivityOrderService {

  
    /**
     * 查询过期未核销的订单
     * 
     * @param dayAgo 几天之前的活动
     * @return
     */
    public List<CmsActivityOrderDto> queryTimeOutNotVerificationOrder(int dayAgo);

}