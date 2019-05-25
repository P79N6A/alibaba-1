package com.culturecloud.service.rs.openplatform.activity;

import com.culturecloud.annotations.SysBusinessLog;
import com.culturecloud.coreutils.UUIDUtils;
import com.culturecloud.exception.BizException;
import com.culturecloud.model.bean.activity.CmsActivity;
import com.culturecloud.model.bean.activity.CmsActivityOrder;
import com.culturecloud.model.bean.activity.CmsActivityOrderDetail;
import com.culturecloud.model.bean.common.CmsTerminalUser;
import com.culturecloud.model.request.api.ActivityOrderCreateApi;
import com.culturecloud.model.request.api.ActivityOrderCreateVO;
import com.culturecloud.model.response.api.CreateResponseApi;
import com.culturecloud.model.response.api.CreateResponseVO;
import com.culturecloud.service.BaseService;
import com.culturecloud.utils.StringUtils;
import org.apache.commons.beanutils.PropertyUtils;
import org.springframework.stereotype.Component;

import javax.annotation.Resource;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@Component
@Path("/api/order")
public class OrderResource {
    @Resource
    private BaseService baseService;

    /**
     * 新增订单
     */
    @POST
    @Path("/create")
    @SysBusinessLog(remark = "新增订单")
    @Produces(MediaType.APPLICATION_JSON)
    public CreateResponseVO createActivity(ActivityOrderCreateVO orders) {
        String source = orders.getPlatSource();
        if (StringUtils.isBlank(source)) {
            BizException.Throw("400", "平台来源不能为空");
        }
        CmsActivityOrder addOrder = new CmsActivityOrder();
        CreateResponseVO vo = new CreateResponseVO();
        CreateResponseApi api = new CreateResponseApi();
        List<CreateResponseApi> list = new ArrayList<CreateResponseApi>();

        for (ActivityOrderCreateApi order : orders.getOrderList()) {
            try {
                PropertyUtils.copyProperties(addOrder, order);
            } catch (IllegalAccessException | InvocationTargetException | NoSuchMethodException e) {
                e.printStackTrace();
            }
            if (StringUtils.isBlank(order.getActivityOrderId())) {
                BizException.Throw("400", "订单ID不能为空");
            } else {
                List<CmsActivityOrder> ven = baseService.find(CmsActivityOrder.class, " where SYS_ID='" + order.getActivityOrderId() + "'");
                if (ven.size() > 0) {
                    BizException.Throw("400", "该订单已存在");
                }
            }
            addOrder.setSysId(order.getActivityOrderId());
            addOrder.setSysNo(source);
            addOrder.setActivityOrderId(UUIDUtils.createUUId());
            addOrder.setOrderCreateTime(new Date());
            if (addOrder.getOrderPayStatus()==null) {
                addOrder.setOrderPayStatus((short)1);
                addOrder.setOrderIsValid((short)1);
            }
            if (StringUtils.isBlank(order.getActivityId())) {
                BizException.Throw("400", "活动ID不能为空");
            } else {
                List<CmsActivity> act = baseService.find(CmsActivity.class, " where SYS_ID='" + order.getActivityId() + "'");
                if (act.size() == 0) {
                    BizException.Throw("400", "该订单所对应的活动不存在");
                }
                addOrder.setActivityId(act.get(0).getActivityId());
            }
            if (StringUtils.isBlank(addOrder.getEventId())) {
                BizException.Throw("400", "场次ID不能为空");
            }
            if (StringUtils.isBlank(addOrder.getOrderPhoneNo())) {
                BizException.Throw("400", "订单手机号不能为空");
            }
            if (StringUtils.isBlank(addOrder.getUserId())) {
                BizException.Throw("400", "用户ID不能为空");
            } else {
                List<CmsTerminalUser> user = baseService.find(CmsTerminalUser.class, " where USER_ID='" + order.getUserId() + "'");
                if (user.size() == 0) {
                    BizException.Throw("400", "该订单所对应的用户不存在");
                }
                addOrder.setUserId(user.get(0).getUserId());
            }
            for (CmsActivityOrderDetail orderDetail : order.getOrderDetailList()) {
                if (orderDetail.getOrderLine() == null) {
                    BizException.Throw("400", "订单排序不能为空");
                }
                orderDetail.setActivityOrderId(addOrder.getActivityOrderId());
                baseService.create(orderDetail);
            }
            api.setInputId(order.getActivityOrderId());
            api.setOutputId(addOrder.getActivityOrderId());
            baseService.create(addOrder);
        }
        list.add(api);
        vo.setList(list);
        return vo;

    }

    /**
     * 更改订单
     */
    @POST
    @Path("/update")
    @SysBusinessLog(remark = "更改订单")
    @Produces(MediaType.APPLICATION_JSON)
    public CreateResponseVO updateActivity(ActivityOrderCreateVO orders) {
        CmsActivityOrder addOrder = new CmsActivityOrder();
        for (ActivityOrderCreateApi order : orders.getOrderList()) {
            try {
                PropertyUtils.copyProperties(addOrder, order);
            } catch (IllegalAccessException | InvocationTargetException | NoSuchMethodException e) {
                e.printStackTrace();
            }
            if (StringUtils.isBlank(order.getActivityOrderId())) {
                BizException.Throw("400", "订单ID不能为空");
            } else {
                List<CmsActivityOrder> ord = baseService.find(CmsActivityOrder.class, " where SYS_ID='" + order.getActivityOrderId() + "'");
                if (ord.size() == 0) {
                    BizException.Throw("400", "该订单不存在");
                }
                addOrder.setActivityOrderId(ord.get(0).getActivityOrderId());
            }
            if (StringUtils.isBlank(order.getActivityId())) {
                BizException.Throw("400", "活动ID不能为空");
            } else {
                List<CmsActivity> act = baseService.find(CmsActivity.class, " where SYS_ID='" + order.getActivityId() + "'");
                if (act.size() == 0) {
                    BizException.Throw("400", "该订单所对应的活动不存在");
                }
                addOrder.setActivityId(act.get(0).getActivityId());
            }
            baseService.update(addOrder, " where ACTIVITY_ORDER_ID='" + addOrder.getActivityOrderId() + "'");
            for (CmsActivityOrderDetail orderDetail : order.getOrderDetailList()) {
                List<CmsActivityOrderDetail> ordDet = baseService.find(CmsActivityOrderDetail.class, " where ACTIVITY_ORDER_ID='" + addOrder.getActivityOrderId() + "' and ORDER_LINE='" + orderDetail.getOrderLine() + "'");
                if (ordDet.size() == 0) {
                    BizException.Throw("400", "该订单详情不存在");
                }
                addOrder.setActivityOrderId(ordDet.get(0).getActivityOrderId());

                baseService.update(addOrder, " where ACTIVITY_ORDER_ID='" + addOrder.getActivityOrderId() + "' and ORDER_LINE='" + orderDetail.getOrderLine() + "'");
            }
        }
        CreateResponseVO vo = new CreateResponseVO();
        CreateResponseApi api = new CreateResponseApi();
        List<CreateResponseApi> list = new ArrayList<CreateResponseApi>();
        list.add(api);
        vo.setList(list);
        return vo;
    }

}
