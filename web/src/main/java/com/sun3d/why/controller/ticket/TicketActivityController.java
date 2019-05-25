package com.sun3d.why.controller.ticket;

import com.culturecloud.model.request.ticketmachine.TicketMachineHeartVO;
import com.sun3d.why.annotation.SysBusinessLog;
import com.sun3d.why.dao.CmsActivityEventMapper;
import com.sun3d.why.dao.CmsActivitySeatMapper;
import com.sun3d.why.jms.client.ActivityBookClient;
import com.sun3d.why.model.*;
import com.sun3d.why.model.extmodel.BasePath;
import com.sun3d.why.model.extmodel.BookActivitySeatInfo;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.service.*;
import com.sun3d.why.util.*;
import com.sun3d.why.webservice.api.model.CmsApiOrder;
import com.sun3d.why.webservice.api.service.CmsApiActivityOrderService;
import com.sun3d.why.webservice.api.util.HttpResponseText;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.BufferedInputStream;
import java.io.IOException;
import java.net.URLDecoder;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * Created by yujinbing on 2015/12/23.
 */
@RequestMapping("/ticketActivity")
@Controller
public class TicketActivityController {

    private Logger logger = LoggerFactory.getLogger(TicketActivityController.class);

    @Autowired
    private BasePath basePath;

    @Autowired
    private CmsTerminalUserService terminalUserService;

    @Autowired
    private CmsActivityService activityService;

    @Autowired
    private CacheService cacheService;

    @Autowired
    private HttpSession session;

    @Autowired
    private CmsActivityEventService cmsActivityEventService;

    @Autowired
    private CmsCommentService commentService;


    @Autowired
    private CmsApiActivityOrderService cmsApiActivityOrderService;

    @Autowired
    private CmsActivityOrderService cmsActivityOrderService;

    @Autowired
    private CmsActivitySeatMapper cmsActivitySeatMapper;

    @Autowired
    private CmsActivityEventMapper cmsActivityEventMapper;


    @Autowired
    private StaticServer staticServer;
    /**
     * 跳转至活动列表页面
     *
     * @param request
     * @return
     */
    @RequestMapping(value = "/ticketActivityList")
    public ModelAndView ticketActivityList(HttpServletRequest request,String machineCode) {
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("machineCode", machineCode);
        modelAndView.setViewName("ticket/activity/ticketActivityList");
        return modelAndView;
    }


    /**
     * 活动列表页面load页面
     *
     * @param activity
     * @param page
     * @return
     */
    @RequestMapping(value = "/ticketActivityListLoad")
    public ModelAndView ticketActivityListLoad(CmsActivity activity,String machineCode, Pagination page) {
        ModelAndView modelAndView = new ModelAndView();
        try {
            if (StringUtils.isNotBlank(activity.getActivityStartTime())) {
                activity.setActivityStartTime(activity.getActivityStartTime() + " 00:00");
            }
            if (StringUtils.isNotBlank(activity.getActivityEndTime())) {
                activity.setActivityEndTime(activity.getActivityEndTime() + " 23:59");
            }
            page.setRows(12);
            List<CmsActivity> activityList = activityService.queryActivityListTicketLoad(activity, machineCode, page);
            modelAndView.addObject("activityList", activityList);
            modelAndView.addObject("activity", activity);
            modelAndView.addObject("page", page);
        } catch (Exception ex) {
            ex.printStackTrace();
            logger.error("ticketActivityListLoad error {}", ex);
        }
        modelAndView.setViewName("ticket/activity/ticketActivityListLoad");
        return modelAndView;
    }


    /**
     * 取票机详细页
     *
     * @param request
     * @param activityId
     * @return
     */
    @SysBusinessLog(remark = "取票机详细页")
    @RequestMapping(value = "/ticketActivityDetail")
    public ModelAndView ticketActivityDetail(HttpServletRequest request, String activityId) {
        ModelAndView modelAndView = new ModelAndView();
        try {
            CmsActivity cmsActivity = this.activityService.queryCmsActivityByActivityId(activityId);
            modelAndView.addObject("cmsActivity", cmsActivity);
            //推荐活动
            Pagination page = new Pagination();
            page.setRows(3);
            List<CmsActivity> cmsActivityList = activityService.getRelateActivity(cmsActivity, page);
            modelAndView.addObject("cmsActivityList", cmsActivityList);
            //得到时间段
            List<CmsActivityEvent> activityEventList = cmsActivityEventService.queryEventTimeByActivityId(activityId);
            modelAndView.addObject("activityEventList", activityEventList);
            String createTime = new SimpleDateFormat("yyyy-MM-dd HH:mm").format(cmsActivity.getActivityCreateTime());
            modelAndView.addObject("createTime", createTime);
            // 前端2.0已审核评论数
            // CmsTerminalUser user = (CmsTerminalUser) session.getAttribute("terminalUser");
            CmsComment comment = new CmsComment();
            comment.setCommentRkId(cmsActivity.getActivityId());
            comment.setCommentType(Constant.TYPE_ACTIVITY);
            int count = commentService.queryCommentCountByCondition(comment);
            modelAndView.addObject("commentCount", count);
            //判断时间是否过期
            String endDate = "";
            if (activityEventList != null && activityEventList.size() > 0) {
                endDate = activityEventList.get(activityEventList.size() - 1).getEventTime();
            }
            if (StringUtils.isNotBlank(cmsActivity.getActivityEndTime())) {
                if (new SimpleDateFormat("yyyy-MM-dd HH:mm").parse(cmsActivity.getActivityEndTime() + " " + endDate.split("-")[0]).before(new Date())) {
                    modelAndView.addObject("isOver", "Y");
                } else {
                    modelAndView.addObject("isOver", "N");
                }
            } else {
                if (new SimpleDateFormat("yyyy-MM-dd HH:mm").parse(cmsActivity.getActivityStartTime() + " " + endDate.split("-")[0]).before(new Date())) {
                    modelAndView.addObject("isOver", "Y");
                } else {
                    modelAndView.addObject("isOver", "N");
                }
            }
            //取票机端预订限制
            String tagSubName = activityService.queryFrontActivityByActivityId(activityId).getTagName();
            if(StringUtils.isNotBlank(tagSubName)){
            	if(tagSubName.indexOf("限制")!=-1){
            		modelAndView.addObject("orderLimit", 1);
                }
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            logger.error("ticketActivityListLoad error {}", ex);
        }
        modelAndView.setViewName("ticket/activity/ticketActivityDetail");
        return modelAndView;
    }


    /**
     * 进入活动预定选坐页面
     *
     * @return
     */
    @SysBusinessLog(remark = "取票机进入预订选座页面")
    @RequestMapping(value = "/ticketActivityBook")
    public ModelAndView ticketActivityBook(String activityId) {
        ModelAndView model = new ModelAndView();
        try {
            CmsActivity cmsActivity = activityService.queryFrontActivityByActivityId(activityId);
            if (cmsActivity != null && cmsActivity.getActivityIsDel() == 1 && cmsActivity.getActivityState() == 6) {
                //在线选座情况
                //查询场次信息 时间段
                List<CmsActivityEvent> activityEventTimes = cmsActivityEventService.queryEventTimeByActivityId(activityId);
                //查询场次信息 最大 和最小的有效 日期 且有余票的
                Map map = cmsActivityEventService.queryMinMaxDateByActivityId(activityId);
                if (map != null && map.size() > 0) {
                    cmsActivity.setActivityStartTime(map.get("minEventDate").toString());
                    cmsActivity.setActivityEndTime(map.get("maxEventDate").toString());
                }
                String canNotEventStrs = cmsActivityEventService.queryCanNotBookEventTime(activityId);
                List<CmsActivityEvent> activityEventDates = cmsActivityEventService.queryEventDateByActivityId(activityId);
                model.addObject("activityEventTimes", activityEventTimes);
                model.addObject("activityEventDates", activityEventDates);
                model.addObject("activityId", activityId);
                model.addObject("cmsActivity", cmsActivity);
                model.addObject("canNotEventStrs", canNotEventStrs);
                model.setViewName("ticket/activity/ticketActivityBook");
                return model;
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            this.logger.error("ticketActivityBook error {}", ex);
            return null;
        }
        return null;
    }

    //预订时生成跳转二维码
    @RequestMapping(value = "/ticketActivityBookPic")
    public void ticketActivityBook(String needPath,  HttpServletResponse response) throws IOException {

        ServletOutputStream out=null;
        try {
            out = response.getOutputStream();
            QRCode.create_image_outStream(needPath,out);
            //写出到请求的地方
            response.setContentType("image/png");
            out.flush();
        } catch (IOException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (out!=null) {
                out.close();
            }

        }
    }

    /**
     * 验证活动预定
     *
     * @param seatId
     * @param cmsActivityOrder
     * @return
     */
    @SysBusinessLog(remark = "取票机验证活动预定")
    @RequestMapping(value = "/checkTicketActivityBook")
    @ResponseBody
    public Map checkTicketActivityBook(String[] seatId, Integer bookCount, CmsActivityOrder cmsActivityOrder) {
        Map map = new HashMap();
        try {
            CmsTerminalUser terminalUser = (CmsTerminalUser) session.getAttribute("terminalUser");
            if (terminalUser == null) {
                map.put("success", "N");
                map.put("msg", "login");
                return map;
            }
            if (seatId != null) {
                int count = seatId.length;
                cmsActivityOrder.setOrderVotes(count);
            } else {
                cmsActivityOrder.setOrderVotes(bookCount);
            }
            cmsActivityOrder.setUserId(terminalUser.getUserId());
            String checkRs = cmsActivityOrderService.checkActivitySeatStatus(cmsActivityOrder, seatId);

//            BookActivitySeatInfo activitySeatInfo = new BookActivitySeatInfo();
//            activitySeatInfo.setActivityId(cmsActivityOrder.getActivityId());
//            activitySeatInfo.setSeatIds(seatId);
//            activitySeatInfo.setBookCount(bookCount);
//            activitySeatInfo.setUserId(terminalUser.getUserId());
//            activitySeatInfo.setPrice(cmsActivityOrder.getOrderPrice());
//            activitySeatInfo.setPhone(cmsActivityOrder.getOrderPhoneNo());
//            activitySeatInfo.setsId(UUIDUtils.createUUId());
//            activitySeatInfo.setEventId(cmsActivityOrder.getEventId());
//            activitySeatInfo.setEventDateTime(cmsActivityOrder.getEventDateTime());
//            String checkRs = cacheService.checkActivitySeatStatus(activitySeatInfo, activitySeatInfo.getSeatIds(), bookCount, terminalUser.getUserId());
            if (!Constant.RESULT_STR_SUCCESS.equals(checkRs)) {
                map.put("success", "N");
                map.put("msg", checkRs);
                return map;
            } else {
                map.put("success", "Y");
                return map;
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            this.logger.error("checkTicketActivityBook error {}", ex);
            map.put("success", "N");
            map.put("msg", ex.toString());
            return map;
        }
    }


    /**
     * 确定订单页面
     *
     * @param request
     * @param cmsActivityOrder
     * @param seatId
     * @param bookCount
     * @return
     */
    @SysBusinessLog(remark = "取票机确定订单页面")
    @RequestMapping(value = "/preSaveTicketActivityOder")
    public String preSaveTicketActivityOder(HttpServletRequest request, CmsActivityOrder cmsActivityOrder, String[] seatId, Integer bookCount, String seatValues) {
        try {
        	 CmsActivity cmsActivity = activityService.queryFrontActivityByActivityId(cmsActivityOrder.getActivityId());
             cmsActivityOrder.setOrderNumber(cacheService.genOrderNumber());
             if (seatId != null) {
                 cmsActivityOrder.setOrderSummary(arrayToString(seatId));
                 request.setAttribute("seatIds", arrayToString(seatId));
                 
                 request.setAttribute("bookCount", seatId.length);
             }
             else
             	   request.setAttribute("bookCount", bookCount);
             
             cmsActivityOrder.setOrderVotes(bookCount);
             request.setAttribute("activityOrder", cmsActivityOrder);
             request.setAttribute("activity", cmsActivity);
             request.setAttribute("seatValues", seatValues);
             
             String saveSeatValues=seatValues;
             
             saveSeatValues=saveSeatValues.replaceAll("排", "_");
             saveSeatValues=saveSeatValues.replaceAll("座", "");
             
              request.setAttribute("saveSeatValues", saveSeatValues);
        } catch (Exception ex) {
            this.logger.error("preSaveTicketActivityOder error {}", ex);
        }
        return "ticket/activity/ticketActivityBookOrder";
    }

    public String arrayToString(String[] strs) {
        StringBuffer sb = new StringBuffer();
        for (String str : strs) {
            sb.append(str + ",");
        }
        return sb.toString();
    }


    /**
     * 保存预定订单
     *
     * @param request
     * @param cmsActivityOrder
     * @param seatIds
     * @param bookCount
     * @return
     */
    @SysBusinessLog(remark = "取票机下订单")
    @RequestMapping(value = "/saveTicketActivityOder")
    @ResponseBody
    public Map saveTicketActivityOder(HttpServletRequest request, CmsActivityOrder cmsActivityOrder, String seatIds, Integer bookCount, String seatValues) {
        Map map = new HashMap();
        CmsTerminalUser terminalUser = (CmsTerminalUser) session.getAttribute("terminalUser");
        if (terminalUser == null) {
            map.put("success", "N");
            map.put("msg", "请先登录");
            return map;
        }
        if (StringUtils.isBlank(seatIds) && bookCount == null) {
            map.put("success", "N");
            map.put("msg", "请选择座位");
            return map;
        }
        if (StringUtils.isNotBlank(seatValues)) {
            seatValues = seatValues.replaceAll("排", "_");
            seatValues = seatValues.replaceAll("座", "");
            String seats[] = seatValues.split(",");
            bookCount = seats.length;
        }
        BookActivitySeatInfo activitySeatInfo = new BookActivitySeatInfo();
        activitySeatInfo.setActivityId(cmsActivityOrder.getActivityId());
        if (seatIds != null && StringUtils.isNotBlank(seatIds)) {
            String[] seatId = seatIds.split(",");
            activitySeatInfo.setSeatIds(seatId);
        }
        activitySeatInfo.setUserId(terminalUser.getUserId());
        activitySeatInfo.setType(1);
        activitySeatInfo.setPrice(cmsActivityOrder.getOrderPrice());
        activitySeatInfo.setPhone(cmsActivityOrder.getOrderPhoneNo());
        activitySeatInfo.setsId(UUIDUtils.createUUId());
        activitySeatInfo.setBookCount(bookCount);
        activitySeatInfo.setOrderNumber(cmsActivityOrder.getOrderNumber());
        activitySeatInfo.setEventId(cmsActivityOrder.getEventId());
        activitySeatInfo.setEventDateTime(cmsActivityOrder.getEventDateTime());
        activitySeatInfo.setBook(true);
        //判断系统是否是子系统的预定，如果是子系统的预定，系统将会向子系统发送请求，判断子系统的是否成功预定
        CmsApiOrder apiOrder = this.cmsApiActivityOrderService.addOrder(activitySeatInfo, terminalUser, seatValues);
        //子系统判断成功，则执行预定
        if (apiOrder.isStatus()) {
            // activitySeatInfo.setType(cmsActivityOrder.getOrderType());
            ActivityBookClient activityBookClient = new ActivityBookClient();
            activitySeatInfo.setSysId(apiOrder.getContentId());
            activitySeatInfo.setSysNo(apiOrder.getSysNo());
            cmsActivityOrder.setSysId(apiOrder.getContentId());
            cmsActivityOrder.setSysNo(apiOrder.getSysNo());
            cmsActivityOrder.setOrderVotes(bookCount);
            cmsActivityOrder.setOrderSummary(seatValues);
            cmsActivityOrder.setSeats(seatIds);
            cmsActivityOrder.setUserId(terminalUser.getUserId());
            String[] seatId = new String[0];
            if (seatIds != null && StringUtils.isNotBlank(seatIds)) {
                seatId = seatIds.split(",");
            }
            synchronized (cmsActivityOrder) {
                String checkRs = cmsActivityOrderService.checkActivitySeatStatus(cmsActivityOrder, seatId);
                if (Constant.RESULT_STR_SUCCESS.equals(checkRs)) {
                    String count = cmsActivityOrderService.addActivityOrder(cmsActivityOrder);
                    if (!Constant.RESULT_STR_FAILURE.equals(count)) {
                        map.put("success", "Y");
                        map.put("msg", "预订成功");
                    } else {
                        map.put("success", "N");
                        map.put("msg", "预订失败");
                    }
                } else {
                    map.put("success", "N");
                    map.put("msg", "下单失败，请重新选择票务后重新下单！");
                }
                return map;
            }
        } else {
            map.put("success", "N");
            map.put("msg", apiOrder.getMsg() + ",错误代码:" + apiOrder.getCode());
            return map;
        }

    }


    /**
     * 订单保存成功之后  跳转至成功提示页面
     *
     * @param request
     * @return
     */
    @RequestMapping(value = "/saveTicketActivityOderOver")
    public String saveTicketActivityOderOver(HttpServletRequest request, String activityId, String activityOrderId, String orderValidateCode,String seatValues, String eventDateTime) {
        try {
            CmsActivity activity = activityService.queryCmsActivityByActivityId(activityId);
            CmsActivityOrder activityOrder = cmsActivityOrderService.queryCmsActivityOrderByOrderValidateCode(orderValidateCode);
            request.setAttribute("activity", activity);
            request.setAttribute("activityOrder", activityOrder);
            request.setAttribute("eventDateTime", eventDateTime);
            seatValues = URLDecoder.decode(seatValues, "UTF-8");
            request.setAttribute("seatValues", seatValues.replace(",", "；"));
            request.setAttribute("activityName", activity.getActivityName());
            request.setAttribute("activityId", activityId);
            request.setAttribute("activityOrderId", activityOrderId);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "ticket/activity/ticketActivityBookSuccess";
    }


    /**
     * 进入手机端页面
     *
     * @return
     */
    @RequestMapping(value = "/ticketMobile")
    public String ticketMobile() {
        return "ticket/ticketMobile";
    }

    /**
     * 根据活动id 和活动场次信息得到 该活动场次的座位信息
     *
     * @param activityId
     * @param eventDateTime
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/showTicketActivitySeatInfo")
    public Map showTicketActivitySeatInfo(String activityId, String eventDateTime) {
        Map rsMap = new HashMap();
        CmsActivity cmsActivity = activityService.queryCmsActivityByActivityId(activityId);
        Map<String, String> seatInfo = new HashMap<String, String>();
        seatInfo.put("activityId", activityId);
        seatInfo.put("activityEventimes", eventDateTime);
        List<CmsActivitySeat> list = cmsActivitySeatMapper.selectSeatList(seatInfo);
        CmsActivityEvent event = cmsActivityEventMapper.queryEventByActivityAndTime(activityId, eventDateTime);
        if (CollectionUtils.isEmpty(list) && cmsActivity.getActivitySalesOnline() == "Y") {
            list = cacheService.getSeatInfoByIdAndTime(activityId, eventDateTime);
            List<CmsActivitySeat> seats = new LinkedList<>();
            for (CmsActivitySeat seat : list) {
                seat.setActivitySeatId(UUIDUtils.createUUId());
                seat.setEventId(event.getEventId());
                seat.setSeatCreateTime(new Date());
                seat.setSeatCreateUser("1");
                seat.setSeatUpdateTime(new Date());
                seat.setSeatUpdateUser("1");
                seats.add(seat);
            }
            int result = cmsActivitySeatMapper.addActivitySeatList(seats);
        }
        Integer ticketCount = 0;
        //可以预定的票数
        if (event != null && event.getAvailableCount() > 0) {
            ticketCount = event.getAvailableCount();
        }
        if (ticketCount == 0) {
            ticketCount = cacheService.getSeatCountByActivityIdAndTime(activityId, eventDateTime);
        }
//        List<CmsActivitySeat> list = cacheService.getSeatInfoByIdAndTime(activityId, eventDateTime);
//        //可以预定的票数
//        ticketCount = cacheService.getSeatCountByActivityIdAndTime(activityId, eventDateTime);
        //得到场次id
        CmsActivityEvent cmsActivityEvent = cmsActivityEventService.queryEventByActivityAndTime(activityId, eventDateTime);
        if (cmsActivityEvent != null) {
            rsMap.put("eventId", cmsActivityEvent.getEventId());
        } else {
            rsMap.put("success", "N");
            return rsMap;
        }
        if (list != null) {
            Map<String, Object> map = getSeatInfoByList(list);
            String seatInfos = map.get("seatInfo") == null ? "" : map.get("seatInfo").toString();
            Integer maxColumn = Integer.valueOf(map.get("maxColumn").toString());
            String maintananceInfo = map.get("maintananceInfo") == null ? "" : map.get("maintananceInfo").toString();
            String vipInfo = map.get("vipInfo") == null ? "" : map.get("vipInfo").toString();
            rsMap.put("venueSeatList", list);
            rsMap.put("seatInfo", seatInfos);
            rsMap.put("maintananceInfo", maintananceInfo);
            rsMap.put("vipInfo", vipInfo);
            rsMap.put("maxColumn", maxColumn.toString());
            /*rsMap.put("eventId",eventId);*/
            rsMap.put("ticketCount", ticketCount);
            rsMap.put("success", "Y");
        }
        return rsMap;
    }


    /**
     * 根据查询出的座位列表绘制前台展示座位信息
     *
     * @param activitySeatList
     * @return
     */
    public Map<String, Object> getSeatInfoByList(List<CmsActivitySeat> activitySeatList) {
        StringBuilder seatInfoBuilder = new StringBuilder();
        StringBuilder vipInfoBuilder = new StringBuilder();
        StringBuilder maintananceBuilder = new StringBuilder();
        String normalSeat = "a";        //正常
        String deleteSeat = "D";        //删除
        String occupySeat = "U";        //占用
        String giveSeat = "G";          //赠票
        String maintenanceSeat = "m";
        String vipSeat = "v";
        //可预订的余票数量
        Integer canBookCount = 0;
        int tmpVar = 1;
        Integer maxColumn = 0;
        for (int i = 0; i < activitySeatList.size(); i++) {
            CmsActivitySeat activitySeat = activitySeatList.get(i);
            String row = activitySeat.getSeatRow().toString();
            String column = activitySeat.getSeatColumn().toString();
            if (Integer.parseInt(column) > maxColumn) {
                maxColumn = Integer.parseInt(column);
            }
            if (tmpVar != activitySeat.getSeatRow()) {
                seatInfoBuilder.append(",");
                tmpVar++;
            }
/*            //判断是否在放票时间断
            if ((activitySeat.getSeatOpenTime() != null && activitySeat.getSeatOpenTime().after(new Date()))){
                seatInfoBuilder.append(normalSeat + "[" + row + "_" + column  +"-" +activitySeat.getSeatVal() + "]");
                vipInfoBuilder.append( row + "_" + column + ",");
            } else {*/
            if (Integer.valueOf(activitySeat.getSeatStatus()) == Constant.VENUE_SEAT_STATUS_NORMAL) {
                seatInfoBuilder.append(normalSeat + "[" + row + "_" + column + "-" + activitySeat.getSeatVal().split("_")[1] + "]");
                canBookCount++;
            }
            if (Integer.valueOf(activitySeat.getSeatStatus()) == Constant.VENUE_SEAT_STATUS_NONE) {
                seatInfoBuilder.append("_");
            }
            //占用
            if (Integer.valueOf(activitySeat.getSeatStatus()) == Constant.VENUE_SEAT_STATUS_MAINTANANCE) {
                //seatInfoBuilder.append(maintenanceSeat);
                seatInfoBuilder.append(normalSeat + "[" + row + "_" + column + "-" + activitySeat.getSeatVal().split("_")[1] + "]");
                //maintananceBuilder.append(venueSeat.getSeatCode()+",");
                vipInfoBuilder.append(activitySeat.getSeatCode() + ",");
            }
/*                if(Integer.valueOf(activitySeat.getSeatStatus()) == Constant.VENUE_SEAT_STATUS_OCCUPY){
                    seatInfoBuilder.append(normalSeat + "[" + row + "_" + column  +"-" +activitySeat.getSeatVal() + "]");
                    vipInfoBuilder.append( row + "_" + column + ",");
                }*/
            if (Integer.valueOf(activitySeat.getSeatStatus()) == Constant.VENUE_SEAT_STATUS_VIP) {
                seatInfoBuilder.append(occupySeat);
                seatInfoBuilder.append(normalSeat + "[" + row + "_" + column + "-" + activitySeat.getSeatVal().split("_")[1] + "]");
                vipInfoBuilder.append(row + "_" + column + ",");
            }
        }
       /* }*/
        if (vipInfoBuilder.length() > 0)
            vipInfoBuilder.deleteCharAt(vipInfoBuilder.length() - 1);
        String seatInfo = seatInfoBuilder.toString();
        Map map = new HashMap();
        map.put("seatInfo", seatInfo);
        map.put("vipInfo", vipInfoBuilder.toString());
        map.put("maxColumn", maxColumn);
        return map;
    }

    /**
     * 查询可以预定的时间段信息
     *
     * @param activityId
     * @param eventDate
     * @return
     */
    @RequestMapping(value = "/queryTicketCanBookEventTime")
    @ResponseBody
    public List queryTicketCanBookEventTime(String activityId, String eventDate) {
        try {
            return cmsActivityEventService.queryCanBookEventTime(activityId, eventDate);
        } catch (Exception ex) {
            ex.printStackTrace();
            return null;
        }
    }

    @RequestMapping(value = "/heartBeat")
    @ResponseBody
    public void heartBeat(String machineCode) {
        try {

            TicketMachineHeartVO vo = new TicketMachineHeartVO();
            vo.setMachineCode(machineCode);
            HttpResponseText res = CallUtils.callUrlHttpPost(staticServer.getPlatformDataUrl() + "ticketMachine/heartBeat", vo);

        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }


}
