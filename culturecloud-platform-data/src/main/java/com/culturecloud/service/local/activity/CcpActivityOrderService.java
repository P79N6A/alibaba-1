package com.culturecloud.service.local.activity;

import com.culturecloud.model.bean.activity.CmsActivityOrder;
import com.culturecloud.model.request.activity.SysUserAnalyseVO;

public interface CcpActivityOrderService {

    /**
     * 添加我的活动
     * @param cmsActivityOrder
     * @return
     */
    String  addActivityOrder(CmsActivityOrder cmsActivityOrder,String seatId);


    String insertSysUserAnalyse(SysUserAnalyseVO sysUserAnalyse);

}
