package com.sun3d.why.service.impl;

import com.sun3d.why.dao.CmsActivityOrderMapper;
import com.sun3d.why.dao.CmsOrderMapper;
import com.sun3d.why.model.*;
import com.sun3d.why.model.extmodel.SmsConfig;
import com.sun3d.why.service.*;
import com.sun3d.why.util.CompareTime;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.SmsUtil;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * Created by Administrator on 2015/7/1.
 */
@Service
@Transactional
public class CmsOrderServiceImpl implements CmsOrderService {

    @Autowired
    private CmsOrderMapper cmsOrderMapper;
    @Autowired
    private CmsActivityOrderMapper cmsActivityOrderMapper;
    @Autowired
    private CacheService cacheService;

    @Autowired
    private CmsActivityService cmsActivityService;
    @Autowired
	private SmsUtil SmsUtil;

    @Autowired
    private CmsUserMessageService userMessageService;

    @Autowired
    private CmsTerminalUserService terminalUserService;

    @Autowired
    private SmsConfig smsConfig;

    @Autowired
    private CmsActivityEventService cmsActivityEventService;

    @Autowired
    private CmsActivityOrderDetailService cmsActivityOrderDetailService;


    private Logger logger = Logger.getLogger(CmsActivityServiceImpl.class);

    /**
     * 根据活动对象查询活动列表信息
     *
     * @param activity 活动对象
     * @param page     分页对象
     * @param sysUser  用户对象
     * @return 活动列表信息
     */
    @Override
    public List<CmsActivity> queryCmsOrderByCondition(CmsActivity activity, Pagination page, SysUser sysUser) throws Exception {
        Map<String, Object> map = new HashMap<String, Object>();
        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm");
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        if (activity != null) {
            if (StringUtils.isNoneBlank(activity.getActivityId())) {
                map.put("activityId", activity.getActivityId());
            }
            if (StringUtils.isNotBlank(activity.getActivityStartTime())) {
                try {
                    map.put("activityStartTime", df.parse(activity.getActivityStartTime() + " 00:00:00"));
                } catch (ParseException e) {
                    e.printStackTrace();
                }
            }
            if (StringUtils.isNotBlank(activity.getActivityEndTime())) {
                try {
                    map.put("activityEndTime", df.parse(activity.getActivityEndTime() + " 23:59:59"));
                } catch (ParseException e) {
                    e.printStackTrace();
                }
            }
        }
        Date currentDate = format.parse(format.format(new Date()));

        if (StringUtils.isNotBlank(activity.getSearchKey())) {
            map.put("searchKey", "%" + activity.getSearchKey() + "%");
        }
        if (StringUtils.isNotBlank(activity.getUserId())) {
            map.put("userId", "%" + activity.getUserId() + "%");
        }
        //活动名称
        if (activity != null && StringUtils.isNotBlank(activity.getOrderNumber())) {
            map.put("orderNumber", "%" + activity.getOrderNumber() + "%");
        }
        //订单电话
        if (activity != null && StringUtils.isNotBlank(activity.getOrderPhoneNo())) {
            map.put("orderPhoneNo", "%" + activity.getOrderPhoneNo() + "%");
        }
        //订单状态
        if (activity != null && activity.getOrderPayStatus() != null && activity.getOrderPayStatus() != 5) {
            map.put("orderPayStatus", activity.getOrderPayStatus());
            if (activity.getOrderPayStatus() == 1) {
                map.put("activityStartTime", new Date());
            }
        }
        // 场馆区域
        if (activity != null && StringUtils.isNotBlank(activity.getActivityArea())) {
            map.put("activityArea", "%" + activity.getActivityArea() + "%");
        }
        //是否免费
        if (activity != null && activity.getActivityIsFree() != null) {
            map.put("activityIsFree", activity.getActivityIsFree());
        }
        if (sysUser != null) {
            map.put("activityDept", sysUser.getUserDeptPath() + "%");
        }
        //现在选坐
        if (activity != null && StringUtils.isNotBlank(activity.getActivitySalesOnline())) {
            map.put("activitySalesOnline", activity.getActivitySalesOnline());
        }
        //判断订单状态是否为已失效  根据时间来判断 不是根据 payStatus 来判断
        if (activity != null && activity.getOrderPayStatus() != null && activity.getOrderPayStatus() == 5) {
            map.put("eventDateTimes", new Date());
        }
        //预定的票数
        if (activity != null && activity.getOrderVotes() != null) {
            map.put("orderVotes", activity.getOrderVotes());
        }
        //活动开始时间
        if (activity != null && StringUtils.isNotBlank(activity.getActivityStartTime())) {
            map.put("activityStartTime", activity.getActivityStartTime());
        }
        //活动结束时间
        if (activity != null && StringUtils.isNotBlank(activity.getActivityEndTime())) {
            map.put("activityEndTime", activity.getActivityEndTime());
        }
        //分页
        if (page != null && page.getFirstResult() != null && page.getRows() != null) {
            int total = cmsOrderMapper.queryUserActivityCountByCondition(map);
            page.setTotal(total);
            map.put("firstResult", page.getFirstResult());
            map.put("rows", page.getRows());
        }
        List<CmsActivity> activityList = cmsOrderMapper.queryUserActivityByCondition(map);
        List<CmsActivity> rsList = new ArrayList<CmsActivity>();
        Date date = new Date();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
        String nowDate = sdf.format(date);
        if (CollectionUtils.isNotEmpty(activityList)) {
            for (CmsActivity cmsActivity : activityList) {
                if ((short) 1 == cmsActivity.getOrderPayStatus()) {
                    if (StringUtils.isNoneBlank(cmsActivity.getEventDateTimes())) {
                        String eventDateTime = cmsActivity.getEventDateTimes();
                        int statusDate = CompareTime.timeCompare2(eventDateTime, nowDate);
                        //返回 0 表示时间日期相同
                        //返回 1 表示日期1>日期2
                        //返回 -1 表示日期1<日期2
                        if (statusDate ==  -1) {
                            cmsActivity.setOrderPayStatus((short) 5);
                        }
                    }
                }
                rsList.add(cmsActivity);
            }
        }
        return rsList;
    }

    /**
     * 根据活动对象查询活动列表信息
     *
     * @param activity 活动对象
     * @param page     分页对象
     * @param sysUser  用户对象
     * @return 活动列表信息
     */
    @Override
    public List<CmsActivity> queryCmsTerminalOrderByCondition(CmsActivity activity, Pagination page, SysUser sysUser) throws Exception {
        Map<String, Object> map = new HashMap<String, Object>();
        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm");
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        if (activity != null) {
            if (StringUtils.isNoneBlank(activity.getActivityId())) {
                map.put("activityId", activity.getActivityId());
            }
            if (StringUtils.isNotBlank(activity.getActivityStartTime())) {
                try {
                    map.put("activityStartTime", df.parse(activity.getActivityStartTime() + " 00:00:00"));
                } catch (ParseException e) {
                    e.printStackTrace();
                }
            }
            if (StringUtils.isNotBlank(activity.getActivityEndTime())) {
                try {
                    map.put("activityEndTime", df.parse(activity.getActivityEndTime() + " 23:59:59"));
                } catch (ParseException e) {
                    e.printStackTrace();
                }
            }
        }
        Date currentDate = format.parse(format.format(new Date()));

        if (StringUtils.isNotBlank(activity.getSearchKey())) {
            map.put("searchKey", "%" + activity.getSearchKey() + "%");
        }
        if (StringUtils.isNotBlank(activity.getUserId())) {
            map.put("userId", "%" + activity.getUserId() + "%");
        }
        //活动名称
        if (activity != null && StringUtils.isNotBlank(activity.getOrderNumber())) {
            map.put("orderNumber", "%" + activity.getOrderNumber() + "%");
        }
        //订单电话
        if (activity != null && StringUtils.isNotBlank(activity.getOrderPhoneNo())) {
            map.put("orderPhoneNo", "%" + activity.getOrderPhoneNo() + "%");
        }
        //订单状态
        if (activity != null && activity.getOrderPayStatus() != null && activity.getOrderPayStatus() != 5) {
            map.put("orderPayStatus", activity.getOrderPayStatus());
            if (activity.getOrderPayStatus() == 1) {
                map.put("activityStartTime", new Date());
            }
        }
        // 场馆区域
        if (activity != null && StringUtils.isNotBlank(activity.getActivityArea())) {
            map.put("activityArea", "%" + activity.getActivityArea() + "%");
        }
        //是否免费
        if (activity != null && activity.getActivityIsFree() != null) {
            map.put("activityIsFree", activity.getActivityIsFree());
        }
        if (sysUser != null) {
            map.put("activityDept", sysUser.getUserDeptPath() + "%");
        }
        //现在选坐
        if (activity != null && StringUtils.isNotBlank(activity.getActivitySalesOnline())) {
            map.put("activitySalesOnline", activity.getActivitySalesOnline());
        }
        //判断订单状态是否为已失效  根据时间来判断 不是根据 payStatus 来判断
        if (activity != null && activity.getOrderPayStatus() != null && activity.getOrderPayStatus() == 5) {
            map.put("eventDateTime", new Date());
        }
        //预定的票数
        if (activity != null && activity.getOrderVotes() != null) {
            map.put("orderVotes", activity.getOrderVotes());
        }
//        //活动开始时间
//        if (activity != null && StringUtils.isNotBlank(activity.getActivityStartTime())) {
//            map.put("activityStartTime", activity.getActivityStartTime());
//        }
//        //活动结束时间
//        if (activity != null && StringUtils.isNotBlank(activity.getActivityEndTime())) {
//            map.put("activityEndTime", activity.getActivityEndTime());
//        }
        //分页
        if (page != null && page.getFirstResult() != null && page.getRows() != null) {
            int total = cmsOrderMapper.queryTerminalUserActivityCountByCondition(map);
            page.setTotal(total);
            map.put("firstResult", page.getFirstResult());
            map.put("rows", page.getRows());
        }
        List<CmsActivity> activityList = cmsOrderMapper.queryTerminalUserActivityByCondition(map);
        if (CollectionUtils.isNotEmpty(activityList)) {
            for (CmsActivity cmsActivity : activityList) {
                if ((short) 1 == cmsActivity.getOrderPayStatus()) {
                    if (StringUtils.isNoneBlank(cmsActivity.getEventDate()) && StringUtils.isNoneBlank(cmsActivity.getEventTime())) {
                        Date eventDateTime = format.parse(cmsActivity.getEventDate() + " " + cmsActivity.getEventTime().split("-")[0]);
                        if (currentDate.getTime() > eventDateTime.getTime()) {
                            cmsActivity.setOrderPayStatus((short) 5);
                        }
                    }
                }
            }
        }
        return activityList;
    }

    @Override
    public List<CmsActivity> queryCmsOrderById(CmsActivity activity, String id, Pagination page, SysUser sysUser) throws Exception {
        Map<String, Object> map = new HashMap<String, Object>();

        //活动名称
        if (id != null && !id.isEmpty()) {
            map.put("activityId", id);
        }
        //活动名称
        if (activity != null && StringUtils.isNotBlank(activity.getOrderNumber())) {
            map.put("orderNumber", "%" + activity.getOrderNumber() + "%");
        }
        
        
        //订单状态
        if (activity != null && activity.getOrderPayStatus() != null && activity.getOrderPayStatus() != 5) {
            map.put("orderPayStatus", activity.getOrderPayStatus());
            if (activity.getOrderPayStatus() == 1) {
                map.put("activityStartTime", new Date());
            }
        }
        //判断订单状态是否为已失效  根据时间来判断 不是根据 payStatus 来判断
        if (activity != null && activity.getOrderPayStatus() != null && activity.getOrderPayStatus() == 5) {
            map.put("eventDateTimes", new Date());
        }
        //订单票数
        if (activity != null && activity.getOrderVotes() != null) {
            map.put("OrderVotes", activity.getOrderVotes() + "%");
        }
        /*if (sysUser != null) {
            map.put("venueDept",sysUser.getUserDeptPath() + "%");
        }*/

        //分页
        if (page != null && page.getFirstResult() != null && page.getRows() != null) {
            map.put("firstResult", page.getFirstResult());
            map.put("rows", page.getRows());
            int total = cmsOrderMapper.queryUserActivityCountById(map);
            page.setTotal(total);
        }

        List<CmsActivity> activityList = cmsOrderMapper.queryUserActivityById(map);
        List<CmsActivity> rsList = new ArrayList<CmsActivity>();
        Date date = new Date();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
        String nowDate = sdf.format(date);
       /* if (CollectionUtils.isNotEmpty(activityList)) {
            for (CmsActivity cmsActivity : activityList) {
                if ((short) 1 == cmsActivity.getOrderPayStatus()) {
                    if (StringUtils.isNoneBlank(cmsActivity.getEventDateTimes())) {
                        Date eventDateTime = format.parse(cmsActivity.getEventEndTimes() + " " + cmsActivity.getEventTime().split("-")[0]);
                        if (currentDate.getTime() > eventDateTime.getTime()) {
                            cmsActivity.setOrderPayStatus((short) 5);
                        }
                    }
                }
            }
        }*/
        
        if (CollectionUtils.isNotEmpty(activityList)) {
            for (CmsActivity cmsActivity : activityList) {
                if ((short) 1 == cmsActivity.getOrderPayStatus()) {
                    if (StringUtils.isNoneBlank(cmsActivity.getEventDateTimes())) {
                        String eventDateTime = cmsActivity.getEventDateTimes();
                        int statusDate = CompareTime.timeCompare2(eventDateTime, nowDate);
                        //返回 0 表示时间日期相同
                        //返回 1 表示日期1>日期2
                        //返回 -1 表示日期1<日期2
                        if (statusDate ==  -1) {
                            cmsActivity.setOrderPayStatus((short) 5);
                        }
                    }
                }
                rsList.add(cmsActivity);
            }
        }
        
        
        return rsList;
    }

    /**
     * 通过活动的ID取消订单
     *
     * @param activityOrderId
     * @return
     */
    @Override
    public Map updateOrderByActivityOrderId(String activityOrderId, String[] cancelSeat) {
        Map map = new HashMap();
        map.put("success", "Y");
        //检查订单能否被取消
        Map map2 = cmsActivityOrderMapper.queryFrontOrderById(activityOrderId);
        CmsActivityOrder cmsActivityOrder = cmsActivityOrderMapper.queryCmsActivityOrderById(activityOrderId);
        if (map2 != null) {
            CmsActivityEvent cmsActivityEvent = cmsActivityEventService.queryByEventId(cmsActivityOrder.getEventId());
            if (cmsActivityEvent == null) {
                map.put("success", "N");
                map.put("msg", "场次信息不能为空");
                return map;
            }
            if (map2.get("activityStartTime") != null) {
                try {
                    Date activityStartTime = new SimpleDateFormat("yyyy-MM-dd HH:mm").parse(cmsActivityEvent.getEventDateTime());
                    if (activityStartTime.before(new Date())) {
                        map.put("success", "N");
                        map.put("msg", "活动已经开始不能取消订单");
                        return map;
                    }
                } catch (Exception ex) {
                    ex.printStackTrace();
                }
            }
            if (map2.get("orderPayStatus") != null && Integer.parseInt(map2.get("orderPayStatus").toString()) == 2) {
                map.put("success", "N");
                map.put("msg", "订单已经被取消 不能重复取消");
                map.put("orderValidateCode", map2.get("orderValidateCode"));
                return map;
            }
        }
        //检查订单能否被取消
        if (map2 != null) {
            CmsActivityEvent cmsActivityEvent = cmsActivityEventService.queryByEventId(cmsActivityOrder.getEventId());
            if (cmsActivityEvent == null) {
                map.put("success", "N");
                map.put("msg", "场次错误");
                return map;
            }
        }
        Map<String, Object> queryMap = new HashMap<String, Object>();
        if (activityOrderId != null && !activityOrderId.isEmpty()) {
            queryMap.put("activityOrderId", activityOrderId);
        }
        CmsActivityOrder activityOrder = cmsOrderMapper.queryActivityOrderById(activityOrderId);
        String orderPayStatus = activityOrder.getOrderPayStatus().toString();
        CmsActivityEvent cmsActivityEvent = cmsActivityEventService.queryByEventId(activityOrder.getEventId());
        int count = 0;
        int cancelCount = activityOrder.getOrderVotes();
        String seatInfo = "";
        List<CmsActivityOrderDetail> cmsActivityOrderDetails = new ArrayList<CmsActivityOrderDetail>();

        // 判断是整个订单取消 还是单个座位取消
        if (cancelSeat != null && cancelSeat.length > 0) {
            //单个座位取消订单
            for (String orderLine : cancelSeat) {
                //检查订单座位状态
                CmsActivityOrderDetailKey detailKey = new CmsActivityOrderDetailKey();
                detailKey.setActivityOrderId(activityOrderId);
                detailKey.setOrderLine(Integer.parseInt(orderLine));
                CmsActivityOrderDetail cmsActivityOrderDetail = cmsActivityOrderDetailService.queryByDetailKey(detailKey);
                if (cmsActivityOrderDetail == null) {
                    map.put("success", "N");
                    map.put("msg", "座位错误");
                    return map;
                } else if (cmsActivityOrderDetail.getSeatStatus() != 1) {
                    map.put("success", "N");
                    map.put("msg", "座位已经被取消或者已经取票");
                    return map;
                }
                cmsActivityOrderDetails.add(cmsActivityOrderDetail);
            }
            // 座位检查完成后 修改座位状态
            for (CmsActivityOrderDetail cmsActivityOrderDetail : cmsActivityOrderDetails) {
                cmsActivityOrderDetail.setSeatStatus((int) Constant.ACTIVITY_ORDER_PAY_STATUS_CANCELLED);
                cmsActivityOrderDetail.setUpdateTime(new Date());
                cmsActivityOrderDetailService.updateDetailSeatStatue(cmsActivityOrderDetail);
                seatInfo += cmsActivityOrderDetail.getSeatCode() + ",";
            }
            cancelCount = cancelSeat.length;
            //修改主表的票数
            activityOrder.setOrderVotes(activityOrder.getOrderVotes() - cancelSeat.length);
            //票数为0 时 修改订单状态
            if (activityOrder.getOrderVotes() == 0) {
                activityOrder.setOrderPayStatus(Constant.ACTIVITY_ORDER_PAY_STATUS_CANCELLED);
            }
            count = cmsActivityOrderMapper.editActivityOrder(activityOrder);
        } else {
            seatInfo = activityOrder.getOrderSummary();
            //整个订单取消
            count = cmsOrderMapper.updateOrderByActivityOrderId(queryMap);
        }

        if (count > 0) {
            CmsActivity cmsActivity = cmsActivityService.queryFrontActivityByActivityId(activityOrder.getActivityId());
            cmsActivityEvent.setAvailableCount(cmsActivityEvent.getAvailableCount() + cancelCount);
            cmsActivityEventService.editByActivityEvent(cmsActivityEvent);

            //发送取消订单的短信
            Map tempMap = new HashMap();
            CmsTerminalUser terminalUser = terminalUserService.queryTerminalUserById(activityOrder.getUserId());
            tempMap.put("userName", terminalUser.getUserName());
            tempMap.put("activityName", cmsActivity.getActivityName());
            if ("Y".equals(cmsActivityOrder.getActivitySalesOnline())) {
                tempMap.put("seatInfo", seatInfo.substring(0, seatInfo.length() - 1));
            }else{
                tempMap.put("ticketCount", activityOrder.getOrderVotes());
            }
            if ("Y".equals(activityOrder.getActivitySalesOnline())) {
                //在线选坐
                SmsUtil.cancelActivitySeatOrderSms(activityOrder.getOrderPhoneNo(), tempMap);
            } else {
                //自由入座
                SmsUtil.cancelActivityFreeOrderSms(activityOrder.getOrderPhoneNo(), tempMap);
            }
            if (true) {
                try {
                    Date endDate = new SimpleDateFormat("yyyy-MM-dd 23:59:59").parse(cmsActivity.getActivityEndTime() + " 23:59:59");
                   // String rs = cacheService.cancelOrder(activityOrder.getActivityId(), activityOrder, cmsActivityEvent, seatInfo, cancelCount, endDate, cmsActivity.getActivitySalesOnline());
                   // if (!Constant.RESULT_STR_SUCCESS.equals(rs)) {
                        map.put("orderPayStatus", orderPayStatus);
                        cmsOrderMapper.returnOrderByActivityOrderId(map);
                   // }
                } catch (ParseException e) {
                    e.printStackTrace();
                }
            }
            return map;
        } else {
            return map;
        }
    }

    /**
     * 取消订单时给预订人发送短消息
     *
     * @param activityOrderId
     * @return
     */
    @Override
    public String selectPhoneByActivityOrderId(String activityOrderId) {
//        //定义发送短消息返回消息是否成功
        //发送取消订单的短信
        try {
            CmsActivityOrder activityOrder = cmsOrderMapper.queryActivityOrderById(activityOrderId);
            CmsActivityEvent cmsActivityEvent = cmsActivityEventService.queryByEventId(activityOrder.getEventId());
            String seatInfo = "";
            CmsActivity cmsActivity = cmsActivityService.queryFrontActivityByActivityId(activityOrder.getActivityId());
            Map tempMap = new HashMap();
            CmsTerminalUser terminalUser = terminalUserService.queryTerminalUserById(activityOrder.getUserId());
            tempMap.put("userName", terminalUser.getUserName());
            String[] eventDateTime = cmsActivityEvent.getEventDateTime().split(" ");
            String[] data = eventDateTime[0].split("-");
            tempMap.put("activityName", data[1] + "月" + data[2] + "日" + cmsActivity.getActivityName());
            tempMap.put("ticketCount", activityOrder.getOrderVotes().toString());
            String ticketCode = activityOrder.getOrderValidateCode();
            tempMap.put("time", eventDateTime[1]);
            //发送验证码
            tempMap.put("ticketNum", ticketCode + "]");
            tempMap.put("ticketCode",  ticketCode );
            //为在线选座的时候 短信中需要提示那个座位被取消
            SmsUtil.sendActivityOrderSms(activityOrder.getOrderPhoneNo(), tempMap);

//            SmsUtil.cancelActivityOrderSms(activityOrder.getOrderPhoneNo(),tempMap);
            return Constant.RESULT_STR_SUCCESS;
            //String msgContent =  userMessageService.getSmsTemplate(Constant.ACTIVITY_ORDER_SMS,tempMap);
            //String code = sendSmsMessage(activityOrder.getOrderPhoneNo(), msgContent);
/*            if("100".equals(code)){
                return Constant.RESULT_STR_SUCCESS;
            }else{
                return Constant.RESULT_STR_FAILURE;
            }*/
        } catch (Exception e) {
            logger.info("selectPhoneByActivityOrderId", e);
            return Constant.RESULT_STR_FAILURE;
        }
    }

   /* private String sendSmsMessage(final String userMobileNo,final  String smsContent){
         String code = "";
        try{
*//*            Runnable runnable = new Runnable() {
                @Override
                public void run() {*//*
                    SmsSend send = new SmsSend();
*//*                    try {*//*
//            code = send.sendSmsMessage(smsConfig.getSmsUrl(),smsConfig.getuId(),smsConfig.getPwd(),userMobileNo,smsContent);
*//*                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
            };*//*
*//*            Thread thread = new Thread(runnable);
            thread.start();*//*
            return code;
        }catch (Exception e){
            logger.info("sendSms error", e);
        }
        return code;
    }*/

    public Map queryFrontOrderById(String orderId) {
        return cmsOrderMapper.queryFrontOrderById(orderId);
    }


    /**
     * 根据活动订单id 查询订单详情
     *
     * @param activityOrderId
     * @return
     */
    public CmsActivityOrder queryActivityOrderByOrderId(String activityOrderId) {
        CmsActivityOrder cmsActivityOrder = cmsOrderMapper.queryActivityOrderByOrderId(activityOrderId);
        List<CmsActivityOrderDetail> cmsActivityOrderDetails = cmsActivityOrderDetailService.queryCmsActivityOrderDetailsByOrderId(activityOrderId);
        cmsActivityOrder.setActivityOrderDetailList(cmsActivityOrderDetails);
        return cmsActivityOrder;
    }
}
