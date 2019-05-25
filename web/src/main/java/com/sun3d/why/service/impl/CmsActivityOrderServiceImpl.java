package com.sun3d.why.service.impl;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.culturecloud.enumeration.common.IntegralTypeEnum;
import com.culturecloud.model.request.activity.SysUserAnalyseVO;
import com.sun3d.why.dao.*;
import com.sun3d.why.model.*;
import com.sun3d.why.model.extmodel.BookActivitySeatInfo;
import com.sun3d.why.model.extmodel.SmsConfig;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.service.*;
import com.sun3d.why.util.*;
import com.sun3d.why.webservice.api.model.CmsApiOrder;
import com.sun3d.why.webservice.api.service.CmsApiActivityOrderService;
import com.sun3d.why.webservice.api.token.TokenHelper;
import com.sun3d.why.webservice.api.util.CmsApiOtherServer;
import com.sun3d.why.webservice.api.util.HttpClientConnection;
import com.sun3d.why.webservice.api.util.HttpResponseText;
import com.sun3d.why.webservice.api.util.TerminalUserConstant;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Transactional;

import javax.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@Service
@Transactional(rollbackFor = Exception.class)
public class CmsActivityOrderServiceImpl implements CmsActivityOrderService {


    @Autowired
    private CmsActivityOrderMapper cmsActivityOrderMapper;

    @Autowired
    private CmsActivityOrderDetailService cmsActivityOrderDetailService;

    @Autowired
    private CmsActivityOrderDetailMapper cmsActivityOrderDetailMapper;

    @Autowired
    private CmsActivitySeatService cmsActivitySeatService;

    @Autowired
    private CmsActivityService cmsActivityService;

    @Autowired
    private CacheService cacheService;

    @Autowired
    private SmsConfig smsConfig;

    @Autowired
    private UserIntegralMapper userIntegralMapper;

    @Autowired
    private CmsUserMessageService userMessageService;

    @Autowired
    private CmsTerminalUserMapper cmsTerminalUserMapper;
    @Autowired
    private CmsApiOtherServer cmsApiOtherServer;

    @Autowired
    private CmsActivityEventService cmsActivityEventService;

    @Autowired
    private CmsApiActivityOrderService cmsApiActivityOrderService;//lijing add 增加取消预定可能会调用子系统的逻辑

    @Autowired
    private StaticServer staticServer;

    @Autowired
    private UserIntegralDetailMapper userIntegralDetailMapper;

    private HttpServletResponse response;
    
    @Autowired
	private SmsUtil SmsUtil;

    @Override
    public int queryCountByOrderNo(String orderNumber) {
        return cmsActivityOrderMapper.queryCountByOrderNo(orderNumber);
    }

    public Map queryFrontOrderById(String activityOrderId) {
        return cmsActivityOrderMapper.queryFrontOrderById(activityOrderId);
    }

    /**
     * 通过活动的ID取消订单
     *
     * @param activityOrderId
     * @return
     */
    @Override
    public int updateOrderByActivityOrderId(String activityOrderId, CmsActivityOrder activityOrder, CmsActivityEvent cmsActivityEvent, List<CmsActivityOrderDetail> cmsActivityOrderDetails, String orderSeat, Integer cancelCount) {
        //检查订单能否被取消
        CmsActivity cmsActivity = cmsActivityService.queryFrontActivityByActivityId(activityOrder.getActivityId());
        Map<String, Object> map = new HashMap<String, Object>();
        if (activityOrderId != null && !activityOrderId.isEmpty()) {
            map.put("activityOrderId", activityOrderId);
        }
        int count = 0;
        String seatInfo = "";
        if (StringUtils.isBlank(orderSeat)) {
            //无座位信息传过来 整个订单都取消
            count = cmsActivityOrderMapper.updateOrderByActivityOrderId(map);
            cancelCount = activityOrder.getOrderVotes();
            seatInfo = activityOrder.getOrderSummary();
        } else if (StringUtils.isNotBlank(orderSeat) && cmsActivityOrderDetails != null && cmsActivityOrderDetails.size() > 0) {
            for (CmsActivityOrderDetail cmsActivityOrderDetail : cmsActivityOrderDetails) {
                //取消选中的座位 订单状态
                cmsActivityOrderDetail.setSeatStatus((int) Constant.ACTIVITY_ORDER_PAY_STATUS_CANCELLED);
                cmsActivityOrderDetail.setUpdateTime(new Date());
                count = cmsActivityOrderDetailService.editByCmsActivityOrderDetail(cmsActivityOrderDetail);
                seatInfo += cmsActivityOrderDetail.getSeatCode() + ",";
            }
            cancelCount = cmsActivityOrderDetails.size();
            //订单取消的时候进行修改剩余票数
            activityOrder.setOrderVotes(activityOrder.getOrderVotes() - cancelCount);
            //订单全部被取消时 修改主表的状态
            if (activityOrder.getOrderVotes() == 0) {
                activityOrder.setOrderPayStatus(Constant.ACTIVITY_ORDER_PAY_STATUS_CANCELLED);
            }
            count = cmsActivityOrderMapper.editActivityOrder(activityOrder);
        }
        if (count > 0) {
            //座位被取消的时候修改内存中的座位状态
            try {
                Date endDate = new SimpleDateFormat("yyyy-MM-dd 23:59:59").parse(cmsActivity.getActivityEndTime() + " 23:59:59");
                //String rs = cacheService.cancelOrder(activityOrder.getActivityId(), activityOrder, cmsActivityEvent, seatInfo, cancelCount, endDate, cmsActivity.getActivitySalesOnline());
           //     if (Constant.RESULT_STR_SUCCESS.equals(rs)) {
                    //修改可预定的余票
                 cmsActivityEvent.setAvailableCount(cmsActivityEvent.getAvailableCount() + cancelCount);
                 return cmsActivityEventService.editByActivityEvent(cmsActivityEvent);
                    //当文化系统取消成功以后，刷新子系统的取消功能
/*                        this.cancelApiOrder(activityOrder,cmsActivity);*/
               //      1;
             //   } else {
             //       return 0;
             //   }
            } catch (ParseException e) {
                e.printStackTrace();
                throw new RuntimeException(e);
            } catch (Exception e) {
                e.printStackTrace();
                throw new RuntimeException(e);
            }
        } else {
            return count;
        }
    }


    //取消子系统订单
    public Map cancelSubSystemUserOrder(CmsActivityOrder cmsActivityOrder, CmsTerminalUser cmsTerminalUser, String orderSeat, Integer cancelCount) {
        Map map = new HashMap();
        String sysId = cmsActivityOrder.getSysId();
        CmsApiOrder apiOrder = new CmsApiOrder();
        CmsActivity cmsActivity = cmsActivityService.queryCmsActivityByActivityId(cmsActivityOrder.getActivityId());
        apiOrder.setStatus(true);
        if (StringUtils.isNotBlank(cmsActivityOrder.getSysNo()) && StringUtils.isNotBlank(sysId)) {
            cmsTerminalUser = this.cmsTerminalUserMapper.queryTerminalUserById(cmsActivityOrder.getUserId());
            String token = TokenHelper.generateToken(cmsTerminalUser.getUserName());
            String userId = cmsTerminalUser.getUserId();

            Integer sourceCode = cmsTerminalUser.getSourceCode();
            if (TerminalUserConstant.SOURCE_CODE_JIADING.equals(sourceCode)) {
                userId = cmsTerminalUser.getSysId();
            }

            JSONObject json = new JSONObject();
            json.put("sysNo", cmsActivityOrder.getSysNo());
            json.put("token", token);
            json.put("userId", userId);
            json.put("activityOrderId", sysId);
            json.put("activityId", cmsActivity.getSysId());
            json.put("cancelCount", cancelCount);
            json.put("orderLines", orderSeat);
            json.put("sourceCode", sourceCode);

            String url = cmsApiOtherServer.getCancelOrderUrl("1");
            HttpResponseText httpResponseText = HttpClientConnection.post(url, json);
            if (httpResponseText.getHttpCode() == 200) {
                String result = httpResponseText.getData();
                apiOrder = JSON.parseObject(result, CmsApiOrder.class);
                if (apiOrder.isStatus()) {
                    map.put("success", "Y");
                    //子系统订单修改完成后 修改文化云数据库订单状态
                    cmsApiActivityOrderService.updateActivityOrderState(cmsActivityOrder.getActivityOrderId(), orderSeat, "1");
                } else {
                    map.put("success", "N");
                    map.put("msg", apiOrder.getMsg());
                }
            } else {
                apiOrder.setStatus(false);
                apiOrder.setMsg("系统请求子系统发生错误:" + httpResponseText.getData());
                map.put("success", "N");
                map.put("msg", apiOrder.getMsg());
            }
            return map;
        }
        return null;
    }


    /**
     * 取消用户活动订单信息
     *
     * @param activityOderId
     * @param cmsTerminalUser
     * @param orderSeat
     * @param cancelCount
     * @return
     */
    public Map cancelUserOrder(String activityOderId, CmsTerminalUser cmsTerminalUser, String orderSeat, Integer cancelCount,String jobType) {
        Map map = new HashMap();
        int cancelResult = 0;
        CmsActivityOrder cmsActivityOrder = queryCmsActivityOrderById(activityOderId);
        if ((cmsActivityOrder.getOrderPaymentStatus() == 1&&cmsActivityOrder.getOrderPayStatus()==1)
        		||(cmsActivityOrder.getOrderPaymentStatus()==0&&cmsActivityOrder.getOrderPayStatus()==1)) {
            cmsActivityOrder.setOrderPayStatus((short) 2);
            
           Date cancelEndTime = cmsActivityOrder.getCancelEndTime();
            // 取消时间过期
            if(cancelEndTime!=null && cancelEndTime.before(new Date()) && cmsActivityOrder.getOrderPaymentStatus() == 0){
            	
            	map.put("success", "S");
                map.put("msg", "订单取消失败，超出取消截止时间");
                return map;
            }
            int cancel = editActivityOrder(cmsActivityOrder);
            if (cancel > 0) {
                CmsActivityEvent cmsActivityEvent = cmsActivityEventService.queryByEventId(cmsActivityOrder.getEventId());
                int count = cmsActivityEvent.getAvailableCount();
                count = count + cmsActivityOrder.getOrderVotes();
                cmsActivityEvent.setAvailableCount(count);
                cancelResult = cmsActivityEventService.editByActivityEvent(cmsActivityEvent);
                
                if (StringUtils.isNotBlank(cmsActivityOrder.getUserId())) {
                	//返还积分
            		if (cmsActivityOrder.getCostTotalCredit()!=null && Integer.parseInt(cmsActivityOrder.getCostTotalCredit()) > 0) {
                        UserIntegral userIntegral = userIntegralMapper.selectUserIntegralByUserId(cmsActivityOrder.getUserId());
                        userIntegral.setIntegralNow(userIntegral.getIntegralNow() + Integer.parseInt(cmsActivityOrder.getCostTotalCredit()));
                        int result = userIntegralMapper.updateByPrimaryKeySelective(userIntegral);
                        if (result > 0) {
                            UserIntegralDetail userIntegralDetail = new UserIntegralDetail();
                            userIntegralDetail.setIntegralDetailId(UUIDUtils.createUUId());
                            userIntegralDetail.setCreateTime(new Date());
                            userIntegralDetail.setIntegralId(userIntegral.getIntegralId());
                            userIntegralDetail.setIntegralChange(Integer.parseInt(cmsActivityOrder.getCostTotalCredit()));
                            userIntegralDetail.setChangeType(0);
                            userIntegralDetail.setIntegralFrom("取消订单返还活动预订所需积分，订单ID：" + cmsActivityOrder.getActivityOrderId());
                            userIntegralDetail.setIntegralType(IntegralTypeEnum.RETURN_INTEGRAL.getIndex());
                            userIntegralDetailMapper.insertSelective(userIntegralDetail);
                        }
                    }
                }
            }
        } else {
            map.put("success", "N");
            map.put("msg", "订单取消失败(已支付订单无法取消)");
            return map;
        }

        if (cmsActivityOrder != null) {
            if ("Y".equals(cmsActivityOrder.getActivitySalesOnline()) && StringUtils.isBlank(orderSeat)) {
                int count = cmsActivityOrder.getOrderVotes();
                orderSeat = "";
                for (int i = 1; i <= count; i++) {
                    orderSeat += String.valueOf(i) + ",";
                }
            }
            String seatInfo = "";
            //检查是否为子系统需要取消的订单
            Map isSubSystemOrder = cancelSubSystemUserOrder(cmsActivityOrder, cmsTerminalUser, orderSeat, cancelCount);
            if (isSubSystemOrder != null) {
                return isSubSystemOrder;
            }
            BookActivitySeatInfo activitySeatInfo = new BookActivitySeatInfo();
            activitySeatInfo.setActivityId(cmsActivityOrder.getActivityId());
            String[] seatIds = null;
            String[] seatCodesInfo = null;
            String seatCodes = "";
            if (orderSeat != null && StringUtils.isNotBlank(orderSeat)) {
                seatIds = orderSeat.split(",");
                //查询出订单的座位code
                for (String orderLine : seatIds) {
                    CmsActivityOrderDetailKey orderDetailKey = new CmsActivityOrderDetail();
                    orderDetailKey.setActivityOrderId(activityOderId);
                    orderDetailKey.setOrderLine(Integer.parseInt(orderLine));

                    CmsActivityOrderDetail activityOrderDetail = cmsActivityOrderDetailMapper.queryByDetailKey(orderDetailKey);
                    activityOrderDetail.setSeatStatus(2);
                    int result = cmsActivityOrderDetailMapper.editByCmsActivityOrderDetail(activityOrderDetail);
                    CmsActivity cmsActivity = cmsActivityService.queryFrontActivityByActivityId(cmsActivityOrder.getActivityId());
                    Map seatMap = new HashMap();
                  //  seatMap.put("activityId", cmsActivityOrder.getActivityId());
                    seatMap.put("seatCode", activityOrderDetail.getSeatCode());
                   // if (cmsActivity.getSingleEvent() == 0) {
                        seatMap.put("eventId", cmsActivityOrder.getEventId());
                 //   }
                    CmsActivitySeat cmsActivitySeat = cmsActivitySeatService.querySeatValByMap(seatMap);
                    cmsActivitySeat.setSeatIsSold(1);
                    cmsActivitySeat.setSeatStatus(1);
                    cmsActivitySeatService.editByActivitySeat(cmsActivitySeat);
                    seatCodes += activityOrderDetail.getSeatCode() + ",";
                    if ("Y".equals(cmsActivityOrder.getActivitySalesOnline())) {
                        //退订的座位
                        String seatValue = StringUtils.isBlank(activityOrderDetail.getSeatVal()) ? activityOrderDetail.getSeatCode() : activityOrderDetail.getSeatVal();
                        seatInfo += seatValue.split("_")[0] + "排" + seatValue.split("_")[1] + "座,";
                    }
                }
                seatCodesInfo = seatCodes.split(",");
            }
            activitySeatInfo.setUserId(cmsActivityOrder.getUserId());
            activitySeatInfo.setType(1);
            activitySeatInfo.setPrice(cmsActivityOrder.getOrderPrice());
            activitySeatInfo.setPhone(cmsActivityOrder.getOrderPhoneNo());
            activitySeatInfo.setsId(UUIDUtils.createUUId());
            activitySeatInfo.setBookCount(cancelCount);
            activitySeatInfo.setOrderNumber(cmsActivityOrder.getOrderNumber());
            activitySeatInfo.setEventId(cmsActivityOrder.getEventId());
            activitySeatInfo.setEventDateTime(cmsActivityOrder.getEventDateTime());
            activitySeatInfo.setSeatIds(seatCodesInfo);
            //false代表取消预定
            activitySeatInfo.setBook(false);
            activitySeatInfo.setOrderId(activityOderId);
            //简称订单信息能否被取消，已从redis移除，相同的方法还在CacheService
            String rs = checkSeatStatusByCancel(activitySeatInfo, seatCodesInfo, cancelCount, cmsActivityOrder.getUserId());
            if (cancelResult > 0) {
                rs = Constant.RESULT_STR_SUCCESS;
            }
            if (!Constant.RESULT_STR_SUCCESS.equals(rs)) {
                map.put("success", "N");
                map.put("msg", rs);
                return map;
            } else {
                map.put("success", "Y");
                map.put("phone", cmsActivityOrder.getOrderPhoneNo());
                map.put("orderValidateCode", cmsActivityOrder.getOrderValidateCode());
            }
            cmsActivityOrder.setActivityOrderId(activityOderId);
            //发送取消订单的短信
            final Map<String, Object> tempMap = new HashMap<String, Object>();
            final CmsActivityOrder activityOrder = queryCmsActivityOrderById(activityOderId);
            CmsTerminalUser terminalUser = cmsTerminalUserMapper.queryTerminalUserById(activityOrder.getUserId());
            activityOrder.setOrderPayStatus((short) 2);
            int orderResult = editAppActivityOrder(activityOrder);
            CmsActivityEvent cmsActivityEvent = cmsActivityEventService.queryByEventId(activityOrder.getEventId());
            try {
                DateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm");
                Calendar calendar = Calendar.getInstance();
                calendar.setTime(new Date());
                if (cmsActivityEvent == null) {
                    map.put("success", "N");
                    map.put("msg", "场次不存在");
                }
                if (cmsActivityEvent.getEventDateTime() != null) {
                    if (df.parse(cmsActivityEvent.getEventDateTime()).before(calendar.getTime())) {
                        //不在规定时间内 不能进行订票
                        map.put("success", "N");
                        map.put("msg", "场次已过期");
                    }
                }
            } catch (Exception ex) {
                ex.printStackTrace();
            }
            tempMap.put("userName", terminalUser.getUserName());
            //tempMap.put("orderId", activityOrder.getOrderValidateCode());
            tempMap.put("activityName", activityOrder.getActivityName());
            //为在线选座的时候 短信中需要提示那个座位被取消
            if ("Y".equals(cmsActivityOrder.getActivitySalesOnline())) {
                tempMap.put("seatInfo", seatInfo.substring(0, seatInfo.length() - 1));
            }else{
                tempMap.put("ticketCount",activityOrder.getOrderVotes().toString());
            }

            SimpleDateFormat dfparseDate = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            Date d=new Date();
            int a=(int) ((d.getTime()-activityOrder.getOrderCreateTime().getTime()) / (1000 * 60));
            
            if ("Y".equals(activityOrder.getActivitySalesOnline())) {
                //在线选坐
            	if(activityOrder.getOrderPaymentStatus()!=null&&activityOrder.getOrderPaymentStatus()==1&&jobType!=null)
            	{
            		System.out.println("自动取消==="+activityOrder.getOrderNumber());
            		System.out.println("自动取消==="+d.getTime()+"###########"+activityOrder.getOrderCreateTime().getTime());
            		final Map<String, Object> tempMap1 = new HashMap<String, Object>();
                	tempMap1.put("orderNum", activityOrder.getOrderNumber());
                    SmsUtil.cancelPayOrderSms(activityOrder.getOrderPhoneNo(), tempMap1);
            	}
            	else
            	{
            		SmsUtil.cancelActivitySeatOrderSms(activityOrder.getOrderPhoneNo(), tempMap);
            	}
                
            }
            else
            {
            	System.out.println("自动取消==="+jobType);
            	if(activityOrder.getOrderPaymentStatus()!=null&&activityOrder.getOrderPaymentStatus()==1&&jobType!=null)
            	{
            		System.out.println("自动取消==="+activityOrder.getOrderNumber());
            		System.out.println("自动取消==="+d.getTime()+"###########"+activityOrder.getOrderCreateTime().getTime());
            		final Map<String, Object> tempMap1 = new HashMap<String, Object>();
                	tempMap1.put("orderNum", activityOrder.getOrderNumber());
                    SmsUtil.cancelPayOrderSms(activityOrder.getOrderPhoneNo(), tempMap1);
            	}
            	else
            	{
            		SmsUtil.cancelActivityFreeOrderSms(activityOrder.getOrderPhoneNo(), tempMap);
            	}	
            }
            return map;
        } else {
            map.put(Constant.RESULT_STR_SUCCESS, "N");
        }
        return map;
    }

    //判断所选座位能否被取消预定

    public String checkSeatStatusByCancel(BookActivitySeatInfo seatInfo, String[] seatIds, Integer cancelCount, String userId) {
        try {
            String activityId = seatInfo.getActivityId();
            //判断活动时间已经过期 或已经结束
            CmsActivity cmsActivity = cmsActivityService.queryFrontActivityByActivityId(activityId);
            if (cmsActivity != null) {
                if (cmsActivity.getActivityState() != 6 || cmsActivity.getActivityIsDel() != 1) {
                    return "该活动未发布或已经删除，不能预定";
                }
            } else {
                return "该活动不存在";
            }

            if (seatIds != null && seatIds.length > 0) {
                String msg = "";
                Map seatMap = new LinkedHashMap();
//                seatMap = (Map) ListTranscoder.deserialize(jedis.get(activityId.getBytes()));
                if (seatMap != null && seatMap.size() > 0) {
                    if (seatMap.containsKey(seatInfo.getEventDateTime())) {
                        Map<String, CmsActivitySeat> oneEventMap = (Map<String, CmsActivitySeat>) seatMap.get(seatInfo.getEventDateTime());
                        if (oneEventMap != null && oneEventMap.size() > 0) {
                            for (String code : seatIds) {
                                CmsActivitySeat activitySeat = oneEventMap.get(code);
                                if (activitySeat != null && activitySeat.getSeatStatus() == 1) {
                                    msg += activitySeat.getSeatRow() + "排" + activitySeat.getSeatColumn() + "列,";
                                } else if (activitySeat == null) {
                                    msg += "无效座位";
                                }
                            }
                            if (!"".equals(msg)) {
                                return "对不起，您选择的座位:" + msg.substring(0, msg.length() - 1) + " 已经被取消,不能重复取消";
                            }
                        } else {
                            return "无该场次信息的座位";
                        }
                    } else {
                        return "请选择正确的场次";
                    }
                } else {
                    return "system error";
                }
                if (!"".equals(msg)) {
                    return msg;
                }
            } else {
                Integer totalCount = getSeatCount(activityId, seatInfo.getEventId());
                if (totalCount < 0) {
                    return "errorCount";
                }
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            return ex.toString();
        } finally {
        }
        return Constant.RESULT_STR_SUCCESS;
    }


    /**
     * 根据活动id  和场次 获得可以预定的数量
     *
     * @param activityId
     * @return
     */
    public Integer getSeatCount(String activityId, String eventId) {
        try {
//            String key = CacheConstant.ACTIVITY_TICKET_COUNT + activityId + "_" + eventDateTime;
//            String value = jedis.get(key);
//            if (value != null) {
//                return Integer.parseInt(value);
//            } else {
            return 0;
//            }
        } catch (Exception ex) {
            ex.printStackTrace();
            return 0;
        } finally {
        }
    }


    @Override
    public int deleteCmsActivityOrderById(String activityOrderId) {
        return cmsActivityOrderMapper.deleteCmsActivityOrderById(activityOrderId);
    }

    @Override
    public int addCmsActivityOrder(CmsActivityOrder record) {
        return cmsActivityOrderMapper.addCmsActivityOrder(record);
    }

    @Override
    public CmsActivityOrder queryCmsActivityOrderById(String activityOrderId) {
        return cmsActivityOrderMapper.queryCmsActivityOrderById(activityOrderId);
    }

    @Override
    public int editCmsActivity(CmsActivityOrder record) {
        return cmsActivityOrderMapper.editCmsActivity(record);
    }

    @Override
    public List<Map> queryUserOrderByMap(Map map, Pagination page) {
        map.put("orderIsVaLid", 1);
        page.setTotal(queryUserOrderCountByMap(map));
        if (page != null) {
            map.put("rows", page.getRows());
            map.put("firstResult", page.getFirstResult());
//            page.setTotal(queryUserActivityCount(map));
        }
        return cmsActivityOrderMapper.queryUserOrderByMap(map);
    }

    @Override
    public Integer queryUserOrderCountByMap(Map map) {
        return cmsActivityOrderMapper.queryUserOrderCountByMap(map);
    }

    /**
     * 我的活动  当前活动 james
     *
     * @param userId
     * @param page
     * @param pageApp
     * @return
     */
    @Override
    public List<CmsActivityOrder> queryUserOrderListById(String userId, Pagination page, String activityName, PaginationApp pageApp) {
        SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        String date = sf.format(new Date());
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("userId", userId);
        map.put("activityStartTime", date);
        map.put("activityState", 6);
        //网页分页
        if (page != null && page.getFirstResult() != null && page.getRows() != null) {
            map.put("firstResult", page.getFirstResult());
            map.put("rows", page.getRows());
            page.setTotal(queryUserActivityListCount(map));
        }
        //app分页
        if (pageApp != null && pageApp.getFirstResult() != null && pageApp.getRows() != null) {
            map.put("firstResult", pageApp.getFirstResult());
            map.put("rows", pageApp.getRows());
        }
        List<CmsActivityOrder> activityOrderList = cmsActivityOrderMapper.queryUserActivityList(map);
        List<CmsActivityOrder> cmsActivityOrders = new ArrayList<CmsActivityOrder>();
        if (activityOrderList != null && activityOrderList.size() > 0) {
            for (CmsActivityOrder cmsActivityOrder : activityOrderList) {
                List<CmsActivityOrderDetail> list = cmsActivityOrderDetailMapper.queryCmsActivityOrderDetailByOrderId(cmsActivityOrder.getActivityOrderId());
                if(cmsActivityOrder.getCancelEndTime() != null){              	
                	String sd = sf.format(cmsActivityOrder.getCancelEndTime());
                	Date sd2 = null;
                	try {
                		sd2 = sf.parse(sd);
                	} catch (ParseException e) {
                		e.printStackTrace();
                	}
                	if(sd2.before(new Date())){
                		cmsActivityOrder.setOrderPaymentStatus((short) 10);
                	}
                }
                cmsActivityOrder.setActivityOrderDetailList(list);
                cmsActivityOrders.add(cmsActivityOrder);
            }
        }
        return cmsActivityOrders;
    }


    @Override
    public List<CmsActivityOrder> queryUserActivityUn(String user, Pagination page, String activityName) {
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("userId", user);
        map.put("type", Constant.COLLECT_ACTIVITY);
        if (StringUtils.isNotBlank(activityName)) {
            map.put("activityName", "%" + activityName + "%");
        }
        //分页
        if (page != null && page.getFirstResult() != null && page.getRows() != null) {
            map.put("firstResult", page.getFirstResult());
            map.put("rows", page.getRows());
            page.setTotal(queryUserActivityUnCount(map));
        }
        return cmsActivityOrderMapper.queryUserActivityUnList(map);
    }

    @Override
    public int queryUserActivityUnCount(Map<String, Object> map) {
        return cmsActivityOrderMapper.queryUserActivityListUnCount(map);
    }

    @Override
    public int queryUserActivityListCount(Map<String, Object> map) {
        return cmsActivityOrderMapper.queryUserActivityListCount(map);
    }


    @Override
    public List<CmsActivityOrder> queryUserActivityHistory(String user, Pagination page, String activityName, PaginationApp pageApp) {
        SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd hh:mm");
        String date = sf.format(new Date());
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("userId", user);
        map.put("activityEndTime", date);
        map.put("orderIsVaLid", 1);
        map.put("activityState", 6);
        //分页
        if (page != null && page.getFirstResult() != null && page.getRows() != null) {
            map.put("firstResult", page.getFirstResult());
            map.put("rows", page.getRows());
            page.setTotal(queryUserActivityHistoryCount(map));
        }


        List<CmsActivityOrder> activityOrderList = cmsActivityOrderMapper.queryUserActivityHistoryList(map);
        List<CmsActivityOrder> cmsActivityOrders = new ArrayList<CmsActivityOrder>();
        if (activityOrderList != null && activityOrderList.size() > 0) {
            for (CmsActivityOrder cmsActivityOrder : activityOrderList) {
                List<CmsActivityOrderDetail> list = cmsActivityOrderDetailMapper.queryCmsActivityOrderDetailByOrderId(cmsActivityOrder.getActivityOrderId());
                cmsActivityOrder.setActivityOrderDetailList(list);
                cmsActivityOrders.add(cmsActivityOrder);
            }
        }
        return cmsActivityOrders;
    }

    @Override
    public int queryUserActivityHistoryCount(Map<String, Object> map) {
        return cmsActivityOrderMapper.queryActivityOrderHistoryCount(map);
    }

    /**
     * @param cmsActivityOrder
     * @return
     */
    @Override
    @Transactional(isolation=Isolation.REPEATABLE_READ)
    public String addActivityOrder(CmsActivityOrder cmsActivityOrder) {
        try {
            final  CmsActivity cmsActivity = cmsActivityService.queryFrontActivityByActivityId(cmsActivityOrder.getActivityId());
            if (cmsActivityOrder != null) {
                synchronized (cmsActivityOrder) {
                    CmsActivityEvent cmsActivityEvent = cmsActivityEventService.queryByEventId(cmsActivityOrder.getEventId());
                    int count = cmsActivityEvent.getAvailableCount();
                    if (count >= cmsActivityOrder.getOrderVotes()) {
                        count = count - cmsActivityOrder.getOrderVotes();
                        cmsActivityEvent.setAvailableCount(count);
                    } else {
                        return Constant.RESULT_STR_FAILURE;
                    }
                    int result = cmsActivityEventService.editByActivityEvent(cmsActivityEvent);
                    //活动主键ID
                    cmsActivityOrder.setActivityOrderId(UUIDUtils.createUUId());
                    cmsActivityOrder.setOrderNumber(cacheService.genOrderNumber());
                    cmsActivityOrder.setVenueId(cmsActivity.getVenueId());
                    cmsActivityOrder.setOrderCreateTime(Calendar.getInstance().getTime());
//                    cmsActivityOrder.setOrderUpdateTime(Calendar.getInstance().getTime());
                    cmsActivityOrder.setOrderPayStatus(Constant.ACTIVITY_ORDER_PAY_STATUS_UNBILLED);
                    cmsActivityOrder.setOrderIsValid((short) 1);
                    cmsActivityOrder.setSurplusCount(count);
                }
            }
            String orderNumber = cmsActivityOrder.getOrderNumber() + (100 + new Random().nextInt(899));
            cmsActivityOrder.setOrderValidateCode(orderNumber);
            int count = cmsActivityOrderMapper.addActivityOrder(cmsActivityOrder);
            if (count == 0) {
                return Constant.RESULT_STR_FAILURE;
            }
            if (count > 0) {
                //增加子表字段
                String seatInfo = cmsActivityOrder.getOrderSummary();
                if (StringUtils.isNotBlank(seatInfo)) {
                    synchronized (seatInfo) {
                        Map seatMap = new HashMap();
                        seatMap.put("activityId", cmsActivityOrder.getActivityId());
                        int index = 1;
                        String[] seatvals = seatInfo.split(",");
                        String[] seatCodes = null;
                        if (StringUtils.isNotBlank(cmsActivityOrder.getSeats())) {
                            seatCodes = cmsActivityOrder.getSeats().split(",");
                        }
                        for (String val : seatvals) {
                            CmsActivityOrderDetail cmsActivityOrderDetail = new CmsActivityOrderDetail();
                            cmsActivityOrderDetail.setSeatVal(val);
                            cmsActivityOrderDetail.setActivityOrderId(cmsActivityOrder.getActivityOrderId());
                            //预定成功 未出票
                            cmsActivityOrderDetail.setSeatStatus((int) Constant.ACTIVITY_ORDER_PAY_STATUS_UNBILLED);
                            cmsActivityOrderDetail.setOrderLine(index);
                            cmsActivityOrderDetail.setUpdateTime(new Date());
                            cmsActivityOrderDetail.setUpdateUser(cmsActivityOrder.getUserId());
                            seatMap.put("seatVal", val);
                            if (StringUtils.isNotBlank(seatCodes[index - 1])) {
                                seatMap.put("seatCode", seatCodes[index - 1]);
                            }
                            if (cmsActivity.getSingleEvent() == 0) {
                                seatMap.put("eventId", cmsActivityOrder.getEventId());
                            }
                            CmsActivitySeat cmsActivitySeat = cmsActivitySeatService.querySeatValByMap(seatMap);
                            
                            if(cmsActivitySeat.getSeatIsSold()!=null&&cmsActivitySeat.getSeatIsSold()==2)
                            {
                            	throw new RuntimeException("座位已被预订"); 
                            }
                            
                            cmsActivitySeat.setSeatIsSold(2);
                            cmsActivitySeat.setSeatStatus(2);
                            cmsActivitySeatService.editByActivitySeat(cmsActivitySeat);
                            if (cmsActivitySeat != null) {
                                cmsActivityOrderDetail.setSeatCode(StringUtils.isBlank(cmsActivitySeat.getSeatCode()) ? val : cmsActivitySeat.getSeatCode());
                            } else {
                                cmsActivityOrderDetail.setSeatCode(val);
                            }
                            cmsActivityOrderDetailService.addCmsActivityOrderDetail(cmsActivityOrderDetail);
                            index++;
                        }
                    }
                } else {
                    for (int i = 1; i <= cmsActivityOrder.getOrderVotes(); i++) {
                        CmsActivityOrderDetail cmsActivityOrderDetail = new CmsActivityOrderDetail();
                        cmsActivityOrderDetail.setSeatCode("" + i);
                        cmsActivityOrderDetail.setActivityOrderId(cmsActivityOrder.getActivityOrderId());
                        cmsActivityOrderDetail.setSeatStatus((int) Constant.ACTIVITY_ORDER_PAY_STATUS_UNBILLED);
                        cmsActivityOrderDetail.setOrderLine(i);
                        cmsActivityOrderDetail.setSeatVal(String.valueOf(i));
                        cmsActivityOrderDetail.setUpdateTime(new Date());
                        cmsActivityOrderDetail.setUpdateUser(cmsActivityOrder.getUserId());
                        cmsActivityOrderDetailService.addCmsActivityOrderDetail(cmsActivityOrderDetail);
                    }
                }
                final String userId=cmsActivityOrder.getUserId();
                Runnable runnable = new Runnable() {
                    @Override
                    public void run() {
                        SysUserAnalyseVO vo=new SysUserAnalyseVO();
                        vo.setUserId(userId);
                        vo.setTagId(cmsActivity.getActivityType());
                        HttpResponseText res = CallUtils.callUrlHttpPost(staticServer.getPlatformDataUrl()+"order/userAnalyse",vo);
                        if(response!=null){
                            response.setContentType("text/html;charset=UTF-8");
                            try {
                                response.getWriter().write(res.getData());
                                response.getWriter().flush();
                                response.getWriter().close();
                            } catch (IOException e) {
                                e.printStackTrace();
                            }
                        }
                    }
                };
                Thread thread = new Thread(runnable);
                thread.start();

                try {
                    CmsTerminalUser terminalUser = cmsTerminalUserMapper.queryTerminalUserById(cmsActivityOrder.getUserId());
                    if (terminalUser != null) {
                        //发送短信通知 用户预定活动成功
                        sendPhoneMsg(terminalUser, cmsActivityOrder, cmsActivity);
                    }
                } catch (Exception ex) {
                    ex.printStackTrace();
                }
            }
            return orderNumber;
        } catch (Exception ex) {
            ex.printStackTrace();
            throw new RuntimeException(ex);
        }
    }

    //判断所选座位能否被预定
    @Override
    public String checkActivitySeatStatus(CmsActivityOrder cmsActivityOrder, String[] seatIds) {
        try {
            int bookCount = cmsActivityOrder.getOrderVotes();
            String activityId = cmsActivityOrder.getActivityId();
            String userId = cmsActivityOrder.getUserId();
            String eventId = cmsActivityOrder.getEventId();
            String phoneNum = cmsActivityOrder.getOrderPhoneNo();
            CmsActivity cmsActivity = cmsActivityService.queryFrontActivityByActivityId(activityId);
            if (cmsActivity.getIdentityCard() == 1 && StringUtils.isBlank(cmsActivityOrder.getOrderIdentityCard())) {
                return "该活动需要填写身份信息，请前往安康文化云公众号预订";
            }
            if (seatIds != null) {
                if (seatIds.length > 0) {
                    for (String seat : seatIds) {
                        Map seatMap = new HashMap();
                        seatMap.put("activityId", activityId);
                        seatMap.put("seatCode", seat);
                        if (cmsActivity.getSingleEvent() == 0) {
                            seatMap.put("eventId", cmsActivityOrder.getEventId());
                        }
                        CmsActivitySeat cmsActivitySeat = cmsActivitySeatService.querySeatValByMap(seatMap);
                        if (cmsActivitySeat.getSeatIsSold() == 2) {
                            return "座位已被预订";
                        }
                    }
                } else {
                    if (cmsActivity.getActivitySalesOnline().equals("Y")) {
                        return "请选择座位";
                    }
                }

            } else {
                if (cmsActivity.getActivitySalesOnline().equals("Y")) {
                    return "请选择座位";
                }
            }

            //判断活动时间已经过期 或已经结束
            if (cmsActivity != null) {
                if (cmsActivity.getActivityState() != 6 || cmsActivity.getActivityIsDel() != 1) {
                    return "该活动未发布或已经删除，不能预定";
                }
            } else {
                return "该活动不存在";
            }
            //判断是否是子区县的活动
            if (StringUtils.isNotBlank(cmsActivity.getSysNo()) && StringUtils.isNotBlank(cmsActivity.getSysId())) {
                String str = cmsApiActivityOrderService.checkActivitySeatStatus(activityId, seatIds, bookCount, userId);
                if (Constant.RESULT_STR_SUCCESS.equals(str)) {
                    return Constant.RESULT_STR_SUCCESS;
                } else {
                    return str;
                }
            }
            Map orderMap = new HashMap();
            orderMap.put("activityId", activityId);
            if (StringUtils.isNotBlank(eventId)) {
                orderMap.put("eventId", eventId);
            }
            orderMap.put("userId", userId);
            //判断用户是否填写了手机号码
            if (StringUtils.isBlank(phoneNum)) {
                return "手机号码不能为空";
            }
            //积分判断
            if (cmsActivityOrder.getCostTotalCredit() != null) {
                if (cmsActivity.getCostCredit() != null && cmsActivityOrder.getCostTotalCredit().equals("0")) {
                    if (cmsActivity.getCostCredit() > 0) {
                        return "该活动需要消耗积分，请前往安康文化云公众号预订。";
                    }
                }
                if (StringUtils.isNotBlank(userId)) {
                    UserIntegral userIntegral = userIntegralMapper.selectUserIntegralByUserId(userId);
                    if (userIntegral != null) {
                        if (Integer.parseInt(cmsActivityOrder.getCostTotalCredit()) > userIntegral.getIntegralNow()) {
                            return "该用户的积分不够抵扣该活动";
                        }
                        if (cmsActivity.getLowestCredit() != null) {
                            if (cmsActivity.getLowestCredit() > userIntegral.getIntegralNow()) {
                                return "该用户的积分没有达到最低积分门槛";
                            }
                        }

                    } else {
                        if (Integer.parseInt(cmsActivityOrder.getCostTotalCredit()) > 0) {
                            return "该用户的积分不够抵扣该活动";
                        }
                    }
                }
            }
            if (cmsActivity.getTicketSettings().equals("N")) {
                int userTickets = queryOrderCountByUser(orderMap);
                if (userTickets > 0 && cmsActivity.getTicketNumber() != null && userTickets + 1 > cmsActivity.getTicketNumber()) {
                    return "moreLimit";
                }
                //为移动接口添加的判断
                if (cmsActivity.getTicketCount() != null && bookCount > cmsActivity.getTicketCount()) {
                    return "moreLimitCount";
                }
            } else {
                int userTicketCount = queryOrderTicketCountByUser(orderMap);
                //最大的购买票数
                int maxBookCount = 5;
                if (seatIds != null && seatIds.length > 0) {
                    if ((userTicketCount + seatIds.length) > maxBookCount) {
                        return "more";
                    }
                } else {
                    if ((userTicketCount + bookCount) > maxBookCount) {
                        return "more";
                    }
                }
            }
            CmsActivityEvent cmsActivityEvent = cmsActivityEventService.queryByEventId(eventId);
            try {
                DateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm");
                Calendar calendar = Calendar.getInstance();
                calendar.setTime(new Date());
                if (cmsActivityEvent == null) {
                    return "该场次不存在";
                }
                if (cmsActivityOrder.getOrderVotes() > cmsActivityEvent.getAvailableCount()) {
                    return "剩余票数不够!";
                }
                if (cmsActivityEvent.getEventDateTime() != null) {
                    if (df.parse(cmsActivityEvent.getEventDateTime()).before(calendar.getTime())) {
                        //不在规定时间内 不能进行订票
                        return "overtime";
                    }
                }
                if (cmsActivityEvent.getSpikeTime() != null) {
                    if (cmsActivityEvent.getSpikeTime().after(calendar.getTime())) {
                        //不在规定时间内 不能进行订票
                        return "此活动需要秒杀，请关注“安康文化云”公众号进行订票";
                    }
                }
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            return ex.toString();
        } finally {

        }
        return Constant.RESULT_STR_SUCCESS;
    }

    /**
     * 修改我的活动 -- 前端
     *
     * @param cmsActivityOrder
     * @return
     */

    @Override
    public int editActivityOrder(CmsActivityOrder cmsActivityOrder) {
        if (cmsActivityOrder != null) {
            //活动主键ID
            if (cmsActivityOrder.getActivityOrderId() == null) {
                cmsActivityOrder.setActivityOrderId(UUIDUtils.createUUId());
            }
            //订单ID
            if (cmsActivityOrder.getOrderNumber() == null) {
                cmsActivityOrder.setOrderNumber(cacheService.genOrderNumber());
            }
        }

        return cmsActivityOrderMapper.editActivityOrder(cmsActivityOrder);
    }


    public List<Map> queryActivityOrderInfoById(String activityOrderId) {

        return cmsActivityOrderMapper.queryActivityOrderInfoById(activityOrderId);
    }

    /**
     * 删除我的活动历史活动
     *
     * @param activityOrderId
     * @param userId
     * @return
     */
    @Override
    public int deleteUserActivityHistory(String activityOrderId, String userId) {
        int count = 0;
        Map<String, Object> map = new HashMap<String, Object>();
        if (activityOrderId != null && userId != null) {
            map.put("activityOrderId", activityOrderId);
            map.put("userId", userId);
            count = cmsActivityOrderMapper.deleteUserActivityHistory(map);
            return count;
        }
        return 0;
    }

    @Override
    public int queryAllReserveAndNotReserved(String userId) {
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("userId", userId);
        return cmsActivityOrderMapper.queryAllReserveAndNotReserved(map);
    }


    /**
     * 获取评论数
     *
     * @param userId
     * @return
     */
    @Override
    public int queryActivityCommentByActivityId(String userId, int commentType) {
        Map<String, Object> map = new HashMap<String, Object>();

        if (userId != null) {
            map.put("userId", userId);
        }
        map.put("commentType", commentType);

        return cmsActivityOrderMapper.queryActivityCommentByActivityId(map);
    }

    /**
     * \
     * 查询用户已经购买的总票数
     *
     * @param map
     * @return
     */
    public Integer queryOrderTicketCountByUser(Map map) {
        Integer count = cmsActivityOrderMapper.queryOrderTicketCountByUser(map);
        return count == null ? 0 : count;
    }

    @Override
    public Integer queryOrderCountByUser(Map map) {
        Integer count = cmsActivityOrderMapper.queryOrderCountByUser(map);
        return count == null ? 0 : count;
    }

    /**
     * 发送短信
     *
     * @param terminalUser
     * @param cmsActivityOrder
     */
    public void sendPhoneMsg(final CmsTerminalUser terminalUser, final CmsActivityOrder cmsActivityOrder, final CmsActivity cmsActivity) {
        try {
            final Map map = new HashMap();
            //String activityName = cmsActivityService.queryFrontActivityByActivityId(cmsActivityOrder.getActivityId()).getActivityName();
            map.put("userName", terminalUser.getUserName());
            String[] eventDateTime = cmsActivityOrder.getEventDateTime().split(" ");
            String[] data = eventDateTime[0].split("-");
            map.put("activityName", data[1] + "月" + data[2] + "日" + cmsActivity.getActivityName());
            map.put("ticketCount", cmsActivityOrder.getOrderVotes().toString());
            String ticketCode = cmsActivityOrder.getOrderValidateCode();
            map.put("time", eventDateTime[1]);
            //发送验证码
            map.put("ticketNum", "("+ ticketCode + ")");
            map.put("ticketCode",  ticketCode );
            cmsActivityOrder.setOrderValidateCode(ticketCode);
            editActivityOrder(cmsActivityOrder);
/*            final  String msg =  URLEncoder.encode(userMessageService.getSmsTemplate(Constant.ACTIVITY_ORDER_SMS , map),"utf-8");*/
            Runnable runnable = new Runnable() {
                @Override
                public void run() {
                    //sendSmsMessage(cmsActivityOrder.getOrderPhoneNo(),msg);
                    SmsUtil.sendActivityOrderSms(cmsActivityOrder.getOrderPhoneNo(), map);
                }
            };
            Thread thread = new Thread(runnable);
            thread.start();
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }


    /**
     * 根据区域统计总订票数
     *
     * @param map
     * @return
     */
    public List<Map> queryTicketCountByArea(Map map) {
        return cmsActivityOrderMapper.queryTicketCountByArea(map);
    }

    /**
     * app根据取票码改变票状态
     *
     * @param cmsActivityOrder
     * @return
     */
    @Override
    public int editAppActivityOrder(CmsActivityOrder cmsActivityOrder) {
        return cmsActivityOrderMapper.editActivityOrder(cmsActivityOrder);
    }

    private CmsApiOrder cancelApiOrder(CmsActivityOrder activityOrder, CmsActivity cmsActivity) throws Exception {
        // 子系统取消预定接口
        // 向子系统发送请求
        CmsApiOrder apiOrder = new CmsApiOrder();
        apiOrder.setStatus(true);

        CmsTerminalUser terminalUser = null;
        try {
            // 查询活动，判断活动的的外部系统的预定链接地址
            String activityId = cmsActivity.getActivityId();
            terminalUser = this.cmsTerminalUserMapper.queryTerminalUserById(activityOrder.getUserId());
            if (terminalUser != null) {
                String sysNo = cmsActivity.getSysNo();
                String sysId = activityOrder.getSysId();
                if (StringUtils.isNotBlank(sysNo) && StringUtils.isNotBlank(sysId)) {
                    String token = TokenHelper.generateToken(terminalUser.getUserName());
                    String userId = terminalUser.getUserId();

                    JSONObject json = new JSONObject();
                    json.put("sysNo", sysNo);
                    json.put("token", token);
                    json.put("userId", userId);
                    json.put("activityId", sysId);

                    String url = cmsApiOtherServer.getCancelOrderUrl(sysNo);
                    HttpResponseText httpResponseText = HttpClientConnection.post(url, json);
                    if (httpResponseText.getHttpCode() == 200) {
                        String result = httpResponseText.getData();
                        apiOrder = JSON.parseObject(result, CmsApiOrder.class);
                    } else {
                        apiOrder.setStatus(false);
                        apiOrder.setMsg("系统请求子系统发生错误:" + httpResponseText.getData());
                    }

                } else {
                    apiOrder.setStatus(true);
                    apiOrder.setMsg("sysId,sysNo不存在，无须调用子系统预定功能!");
                }
            } else {
                apiOrder.setStatus(false);
                apiOrder.setMsg("预定的用户不存在或被禁用!");
            }


        } catch (Exception e) {
            e.printStackTrace();
        }

        return apiOrder;
    }


    @Override
    public int queryCountRoomOrderOfVenue(Map<String, Object> map) {

        return cmsActivityOrderMapper.queryCountRoomOrderOfVenue(map);

    }

    /**
     * 根据活动id查询订单List
     *
     * @param activityId
     * @return List<CmsActivityOrder>
     */
    public List<CmsActivityOrder> queryCmsActivityOrderListByActivityId(String activityId) {
        try {
            if (activityId != null && activityId != "") {

                return cmsActivityOrderMapper.queryCmsActivityOrderListByActivityId(activityId);
            }
        } catch (Exception e) {
            e.printStackTrace();

        }
        return null;
    }


    /**
     * 活动撤销时批量给有效的订单用户 发送短信 通知
     *
     * @param activityId
     * @param msgSMS
     */
    public void revocationActivitySendSMS(String activityId, String msgSMS, String userId) {
        List<CmsActivityOrder> cmsActivityOrders = cmsActivityOrderMapper.queryRevocationActivityOrdersByActivityId(activityId);
        if (cmsActivityOrders != null && cmsActivityOrders.size() > 0) {
            for (CmsActivityOrder cmsActivityOrder : cmsActivityOrders) {
                Map<String,String> result = cancelUserOrder(cmsActivityOrder.getActivityOrderId(),null,null,null,null);
                Map map = new HashMap();
                map.put("content", msgSMS);
                SmsUtil.cancelActivitySms(cmsActivityOrder.getOrderPhoneNo(), map);
                if (StringUtils.isNotBlank(cmsActivityOrder.getUserId())) {
                	//返还积分
                    JSONObject json=new JSONObject();
            		json.put("userId", cmsActivityOrder.getUserId());
            		json.put("costTotalCredit", cmsActivityOrder.getCostTotalCredit());
            		json.put("activityOrderId", cmsActivityOrder.getActivityOrderId());
            		HttpClientConnection.post(staticServer.getChinaServerUrl() + "chinaIntegral/removeOrderIntegralByJson.do", json);
                }
            }
//            cmsActivityOrderMapper.revocationActivityOrderByActivityId(activityId, userId);
        }


    }

    /**
     * 单个活动票务
     *
     * @param map
     * @return
     */
    @Override
    public List<CmsActivityOrder> queryActivityOrderByActivityId(Map map, Pagination page, CmsActivityOrder activity, SysUser sysUser) {
        //活动名称
        if (activity != null && StringUtils.isNotBlank(activity.getOrderValidateCode())) {
            map.put("orderValidateCode", "%" + activity.getOrderValidateCode() + "%");
        }
        if (activity != null && StringUtils.isNotBlank(activity.getActivityName())) {
            map.put("activityName", "%" + activity.getActivityName() + "%");
        }
        //订单状态
/*        if(activity != null && activity.getOrderPayStatus() != null){
            map.put("orderPayStatus",activity.getOrderPayStatus());
        }*/
        // 场馆区域
        if (activity != null && StringUtils.isNotBlank(activity.getActivityArea())) {
            map.put("activityArea", "%" + activity.getActivityArea() + "%");
        }
        //是否免费
        if (activity != null && StringUtils.isNotBlank(activity.getActivityIsFree())) {
            map.put("activityIsFree", activity.getActivityIsFree());
        }
        if (activity != null && StringUtils.isNotBlank(activity.getUserName())) {
            map.put("userName", "%" + activity.getUserName() + "%");
        }
        if (sysUser != null) {
            map.put("venueDept", sysUser.getUserDeptPath() + "%");
        }
        //现在选坐
        if (activity != null && StringUtils.isNotBlank(activity.getActivitySalesOnline())) {
            map.put("activitySalesOnline", activity.getActivitySalesOnline());
        }
        if (page != null && page.getFirstResult() != null && page.getRows() != null) {
            map.put("firstResult", page.getFirstResult());
            map.put("rows", page.getRows());
            page.setTotal(cmsActivityOrderMapper.queryActivityOrderCountByActivityId(map));
        }
        List<CmsActivityOrder> activityOrderList = cmsActivityOrderMapper.queryActivityOrderByActivityId(map);
        List<CmsActivityOrder> cmsActivityOrders = new ArrayList<CmsActivityOrder>();
        if (activityOrderList != null && activityOrderList.size() > 0) {
            for (CmsActivityOrder cmsActivityOrder : activityOrderList) {
                List<CmsActivityOrderDetail> list = cmsActivityOrderDetailMapper.queryCmsActivityOrderDetailByOrderId(cmsActivityOrder.getActivityOrderId());
                cmsActivityOrder.setActivityOrderDetailList(list);
                cmsActivityOrders.add(cmsActivityOrder);
            }
        }
        return cmsActivityOrders;
    }


    /**
     * 自由入座取消整个订单
     */
    public int updateOrderByActivityOrderId(Map map) {
        //修改子表中的状态
        return cmsActivityOrderMapper.updateOrderByActivityOrderId(map);
    }

    /**
     * 添加子系统的活动订单
     *
     * @param cmsActivityOrder
     * @return
     */
    public int addSubSystemActivityOrder(CmsActivityOrder cmsActivityOrder, String seatValues) {
        try {
            if (cmsActivityOrder != null) {
                //活动主键ID
                //if(cmsActivityOrder.getActivityOrderId() == null){
                cmsActivityOrder.setActivityOrderId(UUIDUtils.createUUId());
                // }
                try {
                    cmsActivityOrder.setOrderCreateTime(Calendar.getInstance().getTime());
                } catch (Exception ex) {
                    ex.printStackTrace();
                }
                cmsActivityOrder.setOrderPayStatus(Constant.ACTIVITY_ORDER_PAY_STATUS_UNBILLED);
                cmsActivityOrder.setOrderIsValid((short) 1);
                int count = cmsActivityOrderMapper.addActivityOrder(cmsActivityOrder);
                if (count == 0) {
                    return count;
                }
                CmsActivity cmsActivity = cmsActivityService.queryFrontActivityByActivityId(cmsActivityOrder.getActivityId());
                cmsActivityOrder.setVenueId(cmsActivity.getVenueId());
                if (count > 0) {
                    //增加子表字段
                    String seatInfo = cmsActivityOrder.getOrderSummary();

                    if (StringUtils.isNotBlank(seatInfo)) {
                        Map seatMap = new HashMap();
                        seatMap.put("activityId", cmsActivityOrder.getActivityId());
                        int index = 1;
                        String[] seatCodes = seatInfo.split(",");
                        for (String code : seatCodes) {
                            CmsActivityOrderDetail cmsActivityOrderDetail = new CmsActivityOrderDetail();
                            cmsActivityOrderDetail.setSeatCode(code);
                            cmsActivityOrderDetail.setActivityOrderId(cmsActivityOrder.getActivityOrderId());
                            //预定成功 未出票
                            cmsActivityOrderDetail.setSeatStatus((int) Constant.ACTIVITY_ORDER_PAY_STATUS_UNBILLED);
                            cmsActivityOrderDetail.setOrderLine(index);
                            cmsActivityOrderDetail.setUpdateTime(new Date());
                            cmsActivityOrderDetail.setUpdateUser(cmsActivityOrder.getUserId());
                            seatMap.put("seatCode", code);
                            CmsActivitySeat cmsActivitySeat = cmsActivitySeatService.querySeatValByMap(seatMap);
                            if (cmsActivitySeat != null) {
                                cmsActivityOrderDetail.setSeatVal(StringUtils.isBlank(cmsActivitySeat.getSeatVal()) ? code : cmsActivitySeat.getSeatVal());
                            } else {
                                //
                                if (StringUtils.isNotBlank(seatValues)) {
                                    //判断否有中文
                                    Pattern p2 = Pattern.compile("[\u4e00-\u9fa5]");
                                    Matcher m2 = p2.matcher(seatValues);
                                    if (m2.find()) {
                                        String regEx = "[^0-9]";
                                        Pattern p = Pattern.compile(regEx);
                                        Matcher m = p.matcher(seatValues.split(",")[index - 1]);
                                        String value = m.replaceAll("_").trim();
                                        cmsActivityOrderDetail.setSeatVal(value.substring(0, value.length() - 1));
                                    } else {
                                        cmsActivityOrderDetail.setSeatVal(seatValues.split(",")[index - 1]);
                                    }
                                } else {
                                    cmsActivityOrderDetail.setSeatVal(code);
                                }

                            }
                            cmsActivityOrderDetailService.addCmsActivityOrderDetail(cmsActivityOrderDetail);
                            index++;
                        }
                    } else {
                        for (int i = 1; i <= cmsActivityOrder.getOrderVotes(); i++) {
                            CmsActivityOrderDetail cmsActivityOrderDetail = new CmsActivityOrderDetail();
                            cmsActivityOrderDetail.setSeatCode("" + i);
                            cmsActivityOrderDetail.setActivityOrderId(cmsActivityOrder.getActivityOrderId());
                            cmsActivityOrderDetail.setSeatStatus((int) Constant.ACTIVITY_ORDER_PAY_STATUS_UNBILLED);
                            cmsActivityOrderDetail.setOrderLine(i);
                            cmsActivityOrderDetail.setSeatVal(String.valueOf(i));
                            cmsActivityOrderDetail.setUpdateTime(new Date());
                            cmsActivityOrderDetail.setUpdateUser(cmsActivityOrder.getUserId());
                            cmsActivityOrderDetailService.addCmsActivityOrderDetail(cmsActivityOrderDetail);
                        }
                    }
                }
                return count;
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            throw new RuntimeException(ex);
        }
        return 0;
    }


    /**
     * 根据子系统中的订单id 查询文化云中的对应订单
     *
     * @param sysId
     * @return
     */
    public String queryActivityIdBySysId(String sysId) {
        return cmsActivityOrderMapper.queryActivityIdBySysId(sysId);
    }

    @Override
    public List<CmsActivityOrder> queryTimeOutNotVerificationOrder(int dayAgo) {

        // 获取几天前的日期
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(new Date());
        calendar.set(Calendar.DATE, calendar.get(Calendar.DATE) - dayAgo);
        Date date = calendar.getTime();

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

        String strDate = sdf.format(date);

        List<CmsActivityOrder> cmsActivityOrderList = cmsActivityOrderMapper.queryTimeOutNotVerificationOrder(strDate);

        return cmsActivityOrderList;
    }

	@Override
	public CmsActivityOrder queryCmsActivityOrderByOrderValidateCode(String orderValidateCode) {
		
		return cmsActivityOrderMapper.queryCmsActivityOrderByOrderValidateCode(orderValidateCode);
	}


}
