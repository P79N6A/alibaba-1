package com.sun3d.why.service;

import com.sun3d.why.model.CmsActivity;
import com.sun3d.why.model.CmsActivityOrder;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.util.Pagination;

import java.util.List;
import java.util.Map;

/**
 * Created by Administrator on 2015/7/1.
 */
public interface CmsOrderService {
    /**
     * 后台活动列表
     * @param activity
     * @param page
     * @param sysUser
     * @return
     */
    List<CmsActivity> queryCmsOrderByCondition(CmsActivity activity, Pagination page, SysUser sysUser) throws Exception;

    /**
     * 后台活动列表
     * @param activity
     * @param page
     * @param sysUser
     * @return
     */
    List<CmsActivity> queryCmsTerminalOrderByCondition(CmsActivity activity, Pagination page, SysUser sysUser) throws Exception;
    /**
     * 后台活动列表
     * @param id
     * @param page
     * @param sysUser
     * @return
     */
    List<CmsActivity> queryCmsOrderById(CmsActivity activity, String id, Pagination page, SysUser sysUser) throws Exception;

    /**
     * 通过ID修改取消订单
     * @param activityOrderId
     * @return
     */
    Map updateOrderByActivityOrderId(String activityOrderId ,String[] cancelSeat);

    /**
     * 通过activityOrderId查询用户的手机号码
     * @param activityOrderId
     * @return
     */
    String selectPhoneByActivityOrderId(String activityOrderId);

    Map queryFrontOrderById(String orderId);

    /**
     * 根据活动订单id 查询订单详情
     * @param activityOrderId
     * @return
     */
    CmsActivityOrder queryActivityOrderByOrderId(String activityOrderId);

}

