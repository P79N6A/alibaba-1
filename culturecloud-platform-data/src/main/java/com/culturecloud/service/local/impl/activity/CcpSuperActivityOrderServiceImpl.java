package com.culturecloud.service.local.impl.activity;

import java.text.DateFormat;
import java.text.NumberFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

import javax.annotation.Resource;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

import com.culturecloud.coreutils.UUIDUtils;
import com.culturecloud.dao.activity.CmsActivityEventMapper;
import com.culturecloud.dao.activity.CmsActivityMapper;
import com.culturecloud.dao.activity.CmsActivityOrderDetailMapper;
import com.culturecloud.dao.activity.CmsActivityOrderMapper;
import com.culturecloud.dao.activity.CmsActivitySeatMapper;
import com.culturecloud.dao.common.CmsTagSubMapper;
import com.culturecloud.dao.common.CmsTagSubRelateMapper;
import com.culturecloud.kafka.PpsConfig;
import com.culturecloud.model.bean.activity.CmsActivity;
import com.culturecloud.model.bean.activity.CmsActivityEvent;
import com.culturecloud.model.bean.activity.CmsActivityOrder;
import com.culturecloud.model.bean.activity.CmsActivityOrderDetail;
import com.culturecloud.model.bean.activity.CmsActivitySeat;
import com.culturecloud.model.bean.analyse.SysUserAnalyse;
import com.culturecloud.model.request.activity.SysUserAnalyseVO;
import com.culturecloud.model.request.common.AddOrderIntegralReqVO;
import com.culturecloud.service.BaseService;
import com.culturecloud.service.local.activity.CcpActivityOrderService;
import com.culturecloud.service.local.activity.CcpSuperActivityOrderService;
import com.culturecloud.util.HttpRequest;
import com.fasterxml.jackson.databind.ObjectMapper;

@Service
public class CcpSuperActivityOrderServiceImpl implements CcpSuperActivityOrderService {

    @Resource
    private CmsActivityMapper cmsActivityMapper;

    @Resource
    private CmsActivityEventMapper cmsActivityEventMapper;

    @Resource
    private CmsActivityOrderMapper cmsActivityOrderMapper;

    @Resource
    private CmsActivityOrderDetailMapper cmsActivityOrderDetailMapper;

    @Resource
    private CmsActivitySeatMapper cmsActivitySeatMapper;

    @Resource
    private CmsTagSubMapper cmsTagSubMapper;

    @Resource
    private CmsTagSubRelateMapper cmsTagSubRelateMapper;

    @Resource
    private BaseService baseService;

    private String chinaPlatformDataUrl=PpsConfig.getString("chinaPlatformDataUrl");
    
    @Override
    public String addActivityOrder(CmsActivityOrder cmsActivityOrder, String seatId) {
        //获取活动和场次
        CmsActivity cmsActivity = this.cmsActivityMapper.selectByPrimaryKey(cmsActivityOrder.getActivityId());
        CmsActivityEvent cmsActivityEvent = this.cmsActivityEventMapper.selectByPrimaryKey(cmsActivityOrder.getEventId());

        //传座位信息时，以作为信息为主
        String[] orderSummary;
        String[] seatIds = null;
        if (seatId != null) {
            orderSummary = cmsActivityOrder.getOrderSummary().split(",");
            seatIds = seatId.split(",");
        }
        if (StringUtils.isNotBlank(cmsActivityOrder.getOrderSummary())) {
            cmsActivityOrder.setOrderVotes(seatIds.length);
        }
        String checkResult = checkActivitySeatStatus(cmsActivityOrder, cmsActivityEvent, cmsActivity);
        if (checkResult != "success") {
            return checkResult;
        }
        int count = 0;
        if (cmsActivityEvent.getOrderCount() != null) {
            count = cmsActivityEvent.getOrderCount().intValue() - cmsActivityOrderDetailMapper.queryOrderCountByEvent(cmsActivityEvent.getEventId());
        } else {
            count = cmsActivityEvent.getAvailableCount().intValue();
        }
        if (count >= cmsActivityOrder.getOrderVotes().intValue()) {
            count -= cmsActivityOrder.getOrderVotes().intValue();
            cmsActivityEvent.setAvailableCount(Integer.valueOf(count));
        } else {
            return "余票不足";
        }
        cmsActivityOrder.setSurplusCount(count);
        int result = this.cmsActivityEventMapper.updateByPrimaryKeySelective(cmsActivityEvent);
        if (result > 0) {
            cmsActivityOrder.setOrderNumber(genOrderNumber());
            cmsActivityOrder.setOrderCreateTime(new Date());
            cmsActivityOrder.setOrderPayStatus(Short.valueOf((short) 1));
            cmsActivityOrder.setOrderIsValid(Short.valueOf((short) 1));
            String phonenum=cmsActivityOrder.getOrderPhoneNo().substring(7,11);
            String orderNumber = cmsActivityOrder.getOrderNumber().substring(6,cmsActivityOrder.getOrderNumber().length())+phonenum;
            
            cmsActivityOrder.setOrderValidateCode(orderNumber);
            
            
            int addOrder = this.cmsActivityOrderMapper.insertSelective(cmsActivityOrder);
            if (addOrder > 0) {
                if (StringUtils.isNotBlank(cmsActivityOrder.getOrderSummary())) {
                    int index = 1;
                    StringBuilder seatWhere = new StringBuilder();
                    seatWhere.append(" where (");
                    for (int i = 0; i < seatIds.length; i++) {
                        if (i < seatIds.length - 1) {
                            seatWhere.append(" SEAT_CODE ='" + seatIds[i] + "' or");
                        } else {
                            seatWhere.append(" SEAT_CODE ='" + seatIds[i] + "' )");
                        }
                    }
                    seatWhere.append("and EVENT_ID='" + cmsActivityOrder.getEventId() + "'");
                    List<CmsActivitySeat> cmsActivitySeats = baseService.find(CmsActivitySeat.class, seatWhere.toString());
                    for (CmsActivitySeat seat : cmsActivitySeats) {
                        if (seat.getSeatIsSold() == 2) {
                            return "该座位已被预定";
                        } else {
                            CmsActivityOrderDetail cmsActivityOrderDetail = new CmsActivityOrderDetail();
                            cmsActivityOrderDetail.setSeatVal(seat.getSeatVal());
                            cmsActivityOrderDetail.setSeatCode(seat.getSeatCode());
                            cmsActivityOrderDetail.setActivityOrderId(cmsActivityOrder.getActivityOrderId());
                            cmsActivityOrderDetail.setSeatStatus(Integer.valueOf(1));
                            cmsActivityOrderDetail.setOrderLine(Integer.valueOf(index));
                            cmsActivityOrderDetail.setUpdateTime(new Date());
                            cmsActivityOrderDetail.setUpdateUser(cmsActivityOrder.getUserId());
                            seat.setSeatIsSold(Integer.valueOf(2));
                            seat.setSeatStatus(Integer.valueOf(2));
                            this.cmsActivitySeatMapper.updateByPrimaryKeySelective(seat);
                            cmsActivityOrderDetail.setSeatVal(seat.getSeatVal());
                            this.cmsActivityOrderDetailMapper.insert(cmsActivityOrderDetail);
                            index++;
                        }
                    }
                    Map seatMap = new HashMap();
                    seatMap.put("activityId", cmsActivityOrder.getActivityId());
                } else {
                    for (int i = 1; i <= cmsActivityOrder.getOrderVotes().intValue(); i++) {
                        CmsActivityOrderDetail cmsActivityOrderDetail = new CmsActivityOrderDetail();
                        cmsActivityOrderDetail.setSeatCode("" + i);
                        cmsActivityOrderDetail.setActivityOrderId(cmsActivityOrder.getActivityOrderId());
                        cmsActivityOrderDetail.setSeatStatus(Integer.valueOf(1));
                        cmsActivityOrderDetail.setOrderLine(Integer.valueOf(i));
                        cmsActivityOrderDetail.setSeatVal(String.valueOf(i));
                        cmsActivityOrderDetail.setUpdateTime(new Date());
                        cmsActivityOrderDetail.setUpdateUser(cmsActivityOrder.getUserId());
                        this.cmsActivityOrderDetailMapper.insert(cmsActivityOrderDetail);
                    }
                }
            } else {
                return "添加订单失败";
            }
        } else {
            return "更改票数失败";
        }
        return cmsActivityOrder.getOrderValidateCode();
    }

    public String checkActivitySeatStatus(CmsActivityOrder cmsActivityOrder, CmsActivityEvent cmsActivityEvent, CmsActivity cmsActivity) {
        int bookCount = cmsActivityOrder.getOrderVotes();
        String activityId = cmsActivityOrder.getActivityId();
        String userId = cmsActivityOrder.getUserId();
        String eventId = cmsActivityOrder.getEventId();
        String phoneNum = cmsActivityOrder.getOrderPhoneNo();
        if (cmsActivity.getIdentityCard() == 1 && StringUtils.isBlank(cmsActivityOrder.getOrderIdentityCard())) {
            return "请上传身份证号！";
        }
        if (StringUtils.isBlank(cmsActivityOrder.getOrderSummary()) && cmsActivity.getActivitySalesOnline() == "Y") {
            return "请选择座位！";
        }

        //判断活动时间已经过期 或已经结束 
        if (cmsActivityOrder.getOrderName().length() < 15)//判断Y码长度
        {
            if (cmsActivity != null) {
                if (cmsActivity.getActivityState() != 6 || cmsActivity.getActivityIsDel() != 1) {
                    return "活动已失效!";
                }
            } else {
                return "活动不存在";
            }
            if (StringUtils.isBlank(phoneNum)) {
                return "请填写手机号";
            }
        }

        try {
            DateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm");
            Calendar calendar = Calendar.getInstance();
            calendar.setTime(new Date());
            if (cmsActivityEvent == null) {
                return "该活动场次不存在！";
            }
            if (cmsActivityEvent.getEventDateTime() != null) {
                if (df.parse(cmsActivityEvent.getEventDateTime()).before(calendar.getTime())) {
                    //不在规定时间内 不能进行订票
                    return "该活动场次已过期！";
                }
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return "success";
    }

    public String genOrderNumber() {
        try {
            long value = new Random().nextInt(99999);
            NumberFormat numberFormat = NumberFormat.getIntegerInstance();
            numberFormat.setGroupingUsed(false);
            numberFormat.setMaximumIntegerDigits(6);
            numberFormat.setMinimumIntegerDigits(6);
            Date current = new Date();
            SimpleDateFormat orderPrefixFormat = new SimpleDateFormat("yyMMdd");
            String orderSuffix = numberFormat.format(value);
            String orderPrefix = orderPrefixFormat.format(current);
            String str1 = orderPrefix + orderSuffix;
            return str1;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
        }
        return "123123123123";
    }

}