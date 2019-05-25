package com.culturecloud.service.rs.platformservice.activity;

import java.lang.reflect.InvocationTargetException;

import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import org.apache.commons.beanutils.PropertyUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Transactional;

import com.culturecloud.annotations.SysBusinessLog;
import com.culturecloud.exception.BizException;
import com.culturecloud.model.bean.activity.CmsActivityOrder;
import com.culturecloud.model.request.activity.ActivityOrderVO;
import com.culturecloud.model.request.activity.SysUserAnalyseVO;
import com.culturecloud.service.local.activity.CcpActivityOrderService;
import com.culturecloud.service.local.activity.CcpSuperActivityOrderService;

@Component
@Path("/superOrder")
public class CcpSuperActivityOrderResource {
    @Autowired
    private CcpSuperActivityOrderService ccpSuperActivityOrderService;

    @POST
    @Path("/add")
    @SysBusinessLog(remark = "下订单（超级账号）")
    @Produces(MediaType.APPLICATION_JSON)
    @Transactional(isolation = Isolation.SERIALIZABLE)
    public String add(ActivityOrderVO VO) {
        String json = "";
        try {
            CmsActivityOrder cmsActivityOrder = new CmsActivityOrder();
            String seatId = VO.getSeatIds();
            try {
                PropertyUtils.copyProperties(cmsActivityOrder, VO);
            } catch (IllegalAccessException | InvocationTargetException | NoSuchMethodException e) {
                e.printStackTrace();
            }
            json = ccpSuperActivityOrderService.addActivityOrder(cmsActivityOrder, seatId);
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        if(json.length()!=10){
            BizException.Throw("400", json);
        }
        return json;
    }

}
