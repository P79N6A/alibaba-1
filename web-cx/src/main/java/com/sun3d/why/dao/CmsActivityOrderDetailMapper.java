package com.sun3d.why.dao;

import com.sun3d.why.model.CmsActivityOrderDetail;
import com.sun3d.why.model.CmsActivityOrderDetailKey;

import java.util.List;
import java.util.Map;

public interface CmsActivityOrderDetailMapper {


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
     * app查询活动订单明细信息
     * @param activityOrderId  订单号id
     * @param seat 座位号
     * @return
     */
    public  CmsActivityOrderDetail queryCmsActivityOrderDetailById(String activityOrderId, String seat);

    /**
     * app更新活动订单明细信息
     * @param cmsActivityOrderDetail
     * @return
     */
    public  int editCmsActivityOrderDetailByStatus(CmsActivityOrderDetail cmsActivityOrderDetail);

    /**
     * 根据活动订单查询订单详情
     * @param activityOrderId
     * @return
     */
    public List<CmsActivityOrderDetail> queryCmsActivityOrderDetailsByOrderId(String activityOrderId);

    /**
     * 根据订单id查询所有的 该订单的座位预订信息
     * @param orderId
     * @return
     */
    List<CmsActivityOrderDetail> queryCmsActivityOrderDetailByOrderId(String orderId);


    /**
     * 自由入座取消所有的子表订单
     * @param map
     * @return
     */
    Integer updateOrderSeatStatusByOrderId(Map map);


    /**
     * 在线选坐根据座位code 取消子订单信息
     * @param map
     * @return
     */
    Integer updateOrderSeatStatusBySeats(Map map);

    /**
     * 在线选坐根据座位code 取消子订单信息  可已传 座位的状态
     * @param map
     * @return
     */
    Integer updateDetailSeatStatusBySeats(Map map);

    /**
     * app验证系统查询订单明细表中是否还有未验票的座位
     * @param activityOrderId 订单id
     * @param orderPayStatus 订单状态  1-支付成功 2-已取消 3-已出票 4-已验票 5-已失效
     * @return
     */
    int queryCmsActivityOrderDetailByStatus(String activityOrderId, Integer orderPayStatus);


    /**
     * 根据活动查询该活动所有的有效订单
     * @param map
     * @return
     */
    List<CmsActivityOrderDetail> queryCmsActivityOrderDetailByActivityIdAndEventId(Map map);

}