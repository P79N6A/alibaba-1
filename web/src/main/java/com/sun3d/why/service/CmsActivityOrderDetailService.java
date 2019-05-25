package com.sun3d.why.service;

import com.sun3d.why.model.CmsActivityOrderDetail;
import com.sun3d.why.model.CmsActivityOrderDetailKey;

import java.util.List;
import java.util.Map;

public interface CmsActivityOrderDetailService {


    /**
     * 根据主键 删除订单详细表
     * @param key
     * @return
     */
    int deleteByDetailKey(CmsActivityOrderDetailKey key);

    /**
     * 添加活动订单详细信息
     * @param record
     * @return
     */
    int addCmsActivityOrderDetail(CmsActivityOrderDetail record);


    /**
     * 根据主键 查询活动详细信息
     * @param key
     * @return
     */
    CmsActivityOrderDetail queryByDetailKey(CmsActivityOrderDetailKey key);

    /**
     * 根据主键 编辑活动订单信息
     * @param record
     * @return
     */
    int editByCmsActivityOrderDetail(CmsActivityOrderDetail record);


    /**
     * 根据订单号取消 订单中的座位被占用状态
     */
    int updateDetailSeatStatue(CmsActivityOrderDetail record);


    /**
     * 根据活动订单查询订单详情
     * @param activityOrderId
     * @return
     */
    List<CmsActivityOrderDetail> queryCmsActivityOrderDetailsByOrderId(String activityOrderId);

    /**
     * 自由入座取消所有的子表订单
     * @param map
     * @return
     */
    int updateOrderSeatStatusByOrderId(Map map);


    /**
     * 在线选坐根据座位code 取消子订单信息
     * @param map
     * @return
     */
    int updateOrderSeatStatusBySeats(Map map);


    /**
     * 根据订单号查询子订单的状态的数量
     * @param
     * @return
     */
    public int  queryCmsActivityOrderDetailByStatus(String activityOrderId, Integer payStatus);

    /**
     * 在线选坐根据座位code 取消子订单信息  可已传 座位的状态
     * @param map
     * @return
     */
    public Integer updateDetailSeatStatusBySeats(Map map);
}