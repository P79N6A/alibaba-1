package com.sun3d.why.dao;

import com.sun3d.why.model.CmsActivity;
import com.sun3d.why.model.CmsActivityOrder;

import java.util.List;
import java.util.Map;

/**
 * Created by lt on 2015/7/2.
 */
public interface CmsOrderMapper {

    CmsActivityOrder queryActivityOrderById(String activityOrderById);

    Map queryFrontOrderById(String activityOrderById);

    /**
     * 后台查询活动列表信息
     * @param map  查询条件
     * @return 活动列表信息
     */

     List<CmsActivity> queryUserActivityByCondition(Map<String, Object> map);
    /**
     * 后台查询活动列表信息
     * @param map  查询条件
     * @return 活动列表信息
     */

    List<CmsActivity> queryTerminalUserActivityByCondition(Map<String, Object> map);
    /**
     * 后台查询活动的总条数
     * @param map
     * @return
     */
    int queryUserActivityCountByCondition(Map<String, Object> map);
    /**
     * 后台查询活动的总条数
     * @param map
     * @return
     */
    int queryTerminalUserActivityCountByCondition(Map<String, Object> map);
    /**
     * 后台查询活动列表详细信息
     * @param map  查询条件
     * @return 活动列表信息
     */

    List<CmsActivity> queryUserActivityById(Map<String, Object> map);

    /**
     * 后台查询活动详细的总条数
     * @param map
     * @return
     */
    int queryUserActivityCountById(Map<String, Object> map);

    /**
     * 取消订单  将cms_activit_order表中的ORDER_PAY_STATUS字段修改掉
     * @param map
     * @return
     */
    int updateOrderByActivityOrderId(Map<String, Object> map);


    /**
     * 取消订单失败信息还原  将cms_activit_order表中的ORDER_PAY_STATUS字段修改掉
     * @param map
     * @return
     */
    int returnOrderByActivityOrderId(Map<String, Object> map);

    /**
     * 通过activityOrderId查询预订人的手机号码
     * @param map
     * @return
     */
    String selectPhoneByActivityOrderId(Map<String, Object> map);


    /**
     * 根据活动订单id 查询订单详情
     * @param activityOrderId
     * @return
     */
    public CmsActivityOrder queryActivityOrderByOrderId(String activityOrderId);


}
