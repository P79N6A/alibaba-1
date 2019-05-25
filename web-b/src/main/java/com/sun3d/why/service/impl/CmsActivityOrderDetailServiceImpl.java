package com.sun3d.why.service.impl;

import com.sun3d.why.dao.CmsActivityOrderDetailMapper;
import com.sun3d.why.model.CmsActivityOrderDetail;
import com.sun3d.why.model.CmsActivityOrderDetailKey;
import com.sun3d.why.service.CmsActivityOrderDetailService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

@Transactional
@Service
public class CmsActivityOrderDetailServiceImpl implements CmsActivityOrderDetailService {


    @Autowired
    private CmsActivityOrderDetailMapper cmsActivityOrderDetailMapper;

    /**
     * 根据主键 删除订单详细表
     * @param key
     * @return
     */
    public int deleteByDetailKey(CmsActivityOrderDetailKey key) {
        return cmsActivityOrderDetailMapper.deleteByDetailKey(key);
    }

    /**
     * 添加活动订单详细信息
     * @param record
     * @return
     */
    public int addCmsActivityOrderDetail(CmsActivityOrderDetail record) {
        return cmsActivityOrderDetailMapper.addCmsActivityOrderDetail(record);
    }


    /**
     * 根据主键 查询活动详细信息
     * @param key
     * @return
     */
    public CmsActivityOrderDetail queryByDetailKey(CmsActivityOrderDetailKey key)  {
        return cmsActivityOrderDetailMapper.queryByDetailKey(key);
    }

    /**
     * 根据主键 编辑活动订单信息
     * @param record
     * @return
     */
    public int editByCmsActivityOrderDetail(CmsActivityOrderDetail record) {
        return cmsActivityOrderDetailMapper.editByCmsActivityOrderDetail(record);
    }

    /**
     * 根据订单号取消 订单中的座位被占用状态
     */
    public int updateDetailSeatStatue(CmsActivityOrderDetail record) {
        return cmsActivityOrderDetailMapper.updateDetailSeatStatue(record);
    }


    /**
     * 根据活动订单查询订单详情
     * @param activityOrderId
     * @return
     */
    public List<CmsActivityOrderDetail> queryCmsActivityOrderDetailsByOrderId(String activityOrderId) {
        return cmsActivityOrderDetailMapper.queryCmsActivityOrderDetailsByOrderId(activityOrderId);
    }

    /**
     * 自由入座取消所有的子表订单
     * @param map
     * @return
     */
    public int updateOrderSeatStatusByOrderId(Map map) {
        return cmsActivityOrderDetailMapper.updateOrderSeatStatusByOrderId(map) == null ? 0 : cmsActivityOrderDetailMapper.updateOrderSeatStatusByOrderId(map);
    }


    /**
     * 在线选坐根据座位code 取消子订单信息
     * @param map
     * @return
     */
    public int updateOrderSeatStatusBySeats(Map map) {
        return cmsActivityOrderDetailMapper.updateOrderSeatStatusBySeats(map) == null ? 0 : cmsActivityOrderDetailMapper.updateOrderSeatStatusBySeats(map);
    }

    /**
     * 根据订单号查询子订单的状态的数量
     * @param
     * @return
     */
    public int  queryCmsActivityOrderDetailByStatus(String activityOrderId, Integer payStatus) {
        return cmsActivityOrderDetailMapper.queryCmsActivityOrderDetailByStatus(activityOrderId,payStatus);
    }

    /**
     * 在线选坐根据座位code 取消子订单信息  可已传 座位的状态
     * @param map
     * @return
     */
    public Integer updateDetailSeatStatusBySeats(Map map) {
        return cmsActivityOrderDetailMapper.updateDetailSeatStatusBySeats(map);
    }

}