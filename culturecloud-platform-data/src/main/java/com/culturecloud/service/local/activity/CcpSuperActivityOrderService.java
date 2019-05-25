package com.culturecloud.service.local.activity;

import com.culturecloud.model.bean.activity.CmsActivityOrder;

public interface CcpSuperActivityOrderService {

    /**
     * 添加我的活动（超级账号）
     * @param cmsActivityOrder
     * @return
     */
    String  addActivityOrder(CmsActivityOrder cmsActivityOrder,String seatId);

}
