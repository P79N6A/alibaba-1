package com.sun3d.why.webservice.service.impl;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.culturecloud.enumeration.common.IntegralTypeEnum;
import com.sun3d.why.dao.CmsActivityOrderDetailMapper;
import com.sun3d.why.dao.CmsActivityOrderMapper;
import com.sun3d.why.dao.CmsRoomOrderMapper;
import com.sun3d.why.model.CmsActivityEvent;
import com.sun3d.why.model.CmsActivityOrder;
import com.sun3d.why.model.CmsActivityOrderDetail;
import com.sun3d.why.model.CmsRoomOrder;
import com.sun3d.why.model.UserIntegralDetail;
import com.sun3d.why.model.extmodel.BasePath;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.service.CmsActivityEventService;
import com.sun3d.why.service.UserIntegralDetailService;
import com.sun3d.why.util.ActivitySeatTemplate;
import com.sun3d.why.util.CompareTime;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.JSONResponse;
import com.sun3d.why.util.PaginationApp;
import com.sun3d.why.util.QRCode;
import com.sun3d.why.webservice.api.util.HttpClientConnection;
import com.sun3d.why.webservice.service.ActivityAppOrderService;

@Service
@Transactional
public class ActivityAppOrderServiceImpl implements ActivityAppOrderService {
    private Logger logger = Logger.getLogger(ActivityAppOrderServiceImpl.class);
    static  int printCount=0;
    @Autowired
    private CmsActivityOrderMapper cmsActivityOrderMapper;
    @Autowired
    private StaticServer staticServer;
    @Autowired
    private BasePath basePath;
    @Autowired
    private CmsActivityOrderDetailMapper cmsActivityOrderDetailMapper;
    @Autowired
    private CmsRoomOrderMapper cmsRoomOrderMapper;
    @Autowired
    private UserIntegralDetailService userIntegralDetailService;
    @Autowired
    private CmsActivityEventService cmsActivityEventService;
    
    
    /**
     * app根据用户id获取当前我的活动订单
     * @param pageApp 分页对象
     * @param userId  用户id
     * @return
     */
    @Override
    public String queryAppCurrentOrdersByUserId(PaginationApp pageApp, String userId) throws Exception {
        List<Map<String, Object>> listMapNow = new ArrayList<Map<String, Object>>();
        SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
        String date = sf.format(new Date());
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("userId", userId);
        map.put("activityStartTime", date);
        if (pageApp != null && pageApp.getFirstResult() != null && pageApp.getRows() != null) {
            map.put("firstResult", pageApp.getFirstResult());
            map.put("rows", pageApp.getRows());
        }
        List<CmsActivityOrder> userActivityList = cmsActivityOrderMapper.queryAppCurrentOrdersByUserId(map);
        if (CollectionUtils.isNotEmpty(userActivityList)) {
            for (CmsActivityOrder activityOrder : userActivityList) {
                Map<String, Object> mapUserNowActivity = new HashMap<String, Object>();
                mapUserNowActivity.put("activityId", activityOrder.getActivityId() != null ? activityOrder.getActivityId() : "");
                mapUserNowActivity.put("orderNumber", activityOrder.getOrderNumber() != null ? activityOrder.getOrderNumber() : "");
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                if (activityOrder.getOrderCreateTime() != null) {
                    mapUserNowActivity.put("orderTime", sdf.format(activityOrder.getOrderCreateTime()));
                }
                mapUserNowActivity.put("activityName", activityOrder.getActivityName() != null ? activityOrder.getActivityName() : "");
              //  StringBuffer activityAddress=new StringBuffer();
              //  activityAddress.append(activityOrder.getCity());
              //  activityAddress.append(activityOrder.getArea());
              //  String address=activityOrder.getActivityAddress() != null ? activityOrder.getActivityAddress() : "";
              //  activityAddress.append(address);
                mapUserNowActivity.put("activityAddress",activityOrder.getActivityAddress() != null ? activityOrder.getActivityAddress() : "");
                mapUserNowActivity.put("activityEventDateTime", activityOrder.getEventDateTime() != null ? activityOrder.getEventDateTime() : "");
                mapUserNowActivity.put("orderPrice", activityOrder.getOrderPrice() != null ? activityOrder.getOrderPrice() : "");
                StringBuffer sbSeat=new StringBuffer();//封装座位号
                StringBuffer sbLine=new StringBuffer();//封装订单序列号
                String seat=""; //座位号
                String orderLine=""; //订单序列号
                int j=0;
                //座位号
                if (activityOrder.getSeatStatus()!= null && StringUtils.isNotBlank(activityOrder.getSeatStatus())) {
                    String[] activitySeatStatus = activityOrder.getSeatStatus().split(",");
                    for (int i = 0; i < activitySeatStatus.length; i++) {
                        //1.预定成功  3.已出票
                        if (Integer.valueOf(activitySeatStatus[i]) == 1 || Integer.valueOf(activitySeatStatus[i])==3) {
                            seat=activityOrder.getSeats()!=null?StringUtils.split(activityOrder.getSeats(),",")[i]:"";
                            sbSeat.append(seat+",");
                            //订单票数
                            j++;
                            //订单序列号 用于取消订单
                            orderLine=activityOrder.getOrderLine()!=null?StringUtils.split(activityOrder.getOrderLine(),",")[i]:"";
                            sbLine.append(orderLine+",");
                        }
                    }
                }
                mapUserNowActivity.put("activitySeats",sbSeat.toString());
                mapUserNowActivity.put("orderPayStatus", activityOrder.getOrderPayStatus() != null ? activityOrder.getOrderPayStatus() : "");
                //生成活动订单id 进行取消活动订单
                mapUserNowActivity.put("activityOrderId", activityOrder.getActivityOrderId() != null ? activityOrder.getActivityOrderId() : "");
                mapUserNowActivity.put("orderLine",sbLine.toString());
                mapUserNowActivity.put("orderVotes",j);
                mapUserNowActivity.put("orderValidateCode", activityOrder.getOrderValidateCode() != null ? activityOrder.getOrderValidateCode() : "");
                mapUserNowActivity.put("activitySalesOnline",activityOrder.getActivitySalesOnline()!=null?activityOrder.getActivitySalesOnline():"");
                mapUserNowActivity.put("activityIsReservation",activityOrder.getActivityIsReservation()!=null?activityOrder.getActivityIsReservation():"");
                //封装二维码路径生成二维码图片
                StringBuffer sb = new StringBuffer();
                sb.append(basePath.getBasePath());
                SimpleDateFormat sdf1 = new SimpleDateFormat("yyyyMM");
                sb.append(sdf1.format(new Date()));
                sb.append("/");
                if (activityOrder.getOrderValidateCode() != null && org.apache.commons.lang3.StringUtils.isNotBlank(activityOrder.getOrderValidateCode())) {
                    sb.append(activityOrder.getOrderValidateCode());
                    sb.append(".jpg");
                }
                QRCode.create_image(activityOrder.getOrderValidateCode(), sb.toString());
                StringBuffer stringBuffer = new StringBuffer();
                stringBuffer.append(staticServer.getStaticServerUrl());
                stringBuffer.append(sdf1.format(new Date()));
                stringBuffer.append("/");
                stringBuffer.append(activityOrder.getOrderValidateCode());
                stringBuffer.append(".jpg");
                mapUserNowActivity.put("activityQrcodeUrl", stringBuffer.toString());
                //活动代码
                String activityIconUrl = "";
                if (StringUtils.isNotBlank(activityOrder.getActivityIconUrl())) {
                    activityIconUrl = staticServer.getStaticServerUrl() + activityOrder.getActivityIconUrl();
                }
                mapUserNowActivity.put("activityIconUrl", activityIconUrl);
                listMapNow.add(mapUserNowActivity);
            }
        }
        return JSONResponse.toAppResultFormat(0, listMapNow);
    }

    /**
     * app根据用户id查询历史订单
     * @param userId  用户id
     * @param pageApp 分页对象
     * @return
     */
    @Override
    public String queryAppPastOrdersByUserId(String userId, PaginationApp pageApp) {
        List<Map<String, Object>> listMapOld = new ArrayList<Map<String, Object>>();
        SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
        String date = sf.format(new Date());
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("userId", userId);
        map.put("activityEndTime", date);
        map.put("orderIsVaLid", Constant.NORMAL);
        //分页
        if (pageApp != null && pageApp.getFirstResult() != null && pageApp.getRows() != null) {
            map.put("firstResult", pageApp.getFirstResult());
            map.put("rows", pageApp.getRows());
        }
        List<CmsActivityOrder> pastActivityList = cmsActivityOrderMapper.queryAppPastOrdersByUserId(map);
        if (CollectionUtils.isNotEmpty(pastActivityList)) {
            for (CmsActivityOrder activityOrderOld : pastActivityList) {
                Map<String, Object> mapUserOldActivity = new HashMap<String, Object>();
                mapUserOldActivity.put("orderNumber", activityOrderOld.getOrderNumber() != null ? activityOrderOld.getOrderNumber() : "");
                mapUserOldActivity.put("activityName", activityOrderOld.getActivityName() != null ? activityOrderOld.getActivityName() : "");
                StringBuffer activityAddress=new StringBuffer();
                activityAddress.append(activityOrderOld.getCity());
                activityAddress.append(activityOrderOld.getArea());
                String address=activityOrderOld.getActivityAddress() != null ? activityOrderOld.getActivityAddress() : "";
                activityAddress.append(address);
                mapUserOldActivity.put("activityAddress",activityAddress.toString());
                mapUserOldActivity.put("activityId", activityOrderOld.getActivityId() != null ? activityOrderOld.getActivityId() : "");
                mapUserOldActivity.put("activityOrderId", activityOrderOld.getActivityOrderId() != null ? activityOrderOld.getActivityOrderId() : "");
                listMapOld.add(mapUserOldActivity);
            }
        }
        return JSONResponse.toAppResultFormat(0, listMapOld);
    }

    /**
     * app删除我的历史活动订单
     * @param activityOrderId 活动订单id
     * @param userId 用户id
     * @return
     */
    @Override
    public int deleteUserActivityHistory(String activityOrderId, String userId) {
        int count = 0;
        Map<String, Object> map = new HashMap<String, Object>();
        if(activityOrderId != null && userId != null){
            map.put("activityOrderId",activityOrderId);
            map.put("userId",userId);
            count = cmsActivityOrderMapper.deleteUserActivityHistory(map);
            return  count;
        }
        return 0;
    }

    /**
     * 取票机获取订单详情(活动或活动室)
     * @param orderValidateCode 取票码
     * @return
     */
    @Override
    public String queryAppOrderDetails(String orderValidateCode) {
        String json = "";
     //   SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd");
        Date date = new Date();
        SimpleDateFormat sdf2 = new SimpleDateFormat("yyyy-MM-dd HH:mm");
      //  int flag = 0;
   //     int status = 0;
        List<Map<String, Object>> mapList = new ArrayList<Map<String, Object>>();
        Map<String,Object> orderMap = new HashMap<String, Object>();
      /*  Map<String, String> map = new HashMap<String, String>();
        map.put("jyxq", "菊园新区");
        map.put("qtsgwhg", "区图书馆文化馆");
        map.put("qbwg", "区博物馆");
        map.put("hthmsg", "韩天衡美术馆");
        map.put("lysysy", "陆俨少艺术院");
        map.put("nxz", "南翔镇");
        map.put("xhz", "徐行镇");
        map.put("wgz", "外冈镇");
        map.put("gyq", "工业区");
        map.put("zxjd", "真新街道");
        map.put("xcljd", "新成路街道");
        map.put("jdz", "嘉定镇");
        map.put("htz", "华亭镇");
        map.put("atz", "安亭镇");
        map.put("jqz", "江桥镇");
        map.put("mlz", "马陆镇");
        map.put("hd", "黄渡");
        map.put("qhltsg", "嘉定图书馆清河路分馆");
        map.put("qt", "其他");*/
        Map<String,Object> map=new HashMap<String, Object>();
        if(orderValidateCode!=null && StringUtils.isNotBlank(orderValidateCode)){
           map.put("orderValidateCode",orderValidateCode);
        }
        CmsActivityOrder cmsActivityOrder=cmsActivityOrderMapper.queryActvityOrderByValidateCode(map);
        if (cmsActivityOrder != null) {
            //  String nowDate1=sdf1.format(date);
            //   int statusDate1=CompareTime.timeCompare1(cmsActivityOrder.getActivityStartTime(),nowDate1); date.substring(0,date.lastIndexOf("-")
            String nowDate2 = sdf2.format(date);
            int statusDate2 = CompareTime.timeCompare2(cmsActivityOrder.getEventDateTime().substring(0, cmsActivityOrder.getEventDateTime().lastIndexOf("-")), nowDate2);
            if(cmsActivityOrder.getOrderPayStatus()==2 || cmsActivityOrder.getOrderPayStatus()==3 || cmsActivityOrder.getOrderPayStatus()==4){
                orderMap.put("orderPayStatus", cmsActivityOrder.getOrderPayStatus());
            }else {
                //返回 0 表示时间日期相同
                //返回 1 表示日期1>日期2
                //返回 -1 表示日期1<日期2
                if (statusDate2 == -1) {
                    orderMap.put("orderPayStatus", 5);
                }else {
                    orderMap.put("orderPayStatus", cmsActivityOrder.getOrderPayStatus());
                }
            }
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            if (cmsActivityOrder.getOrderCreateTime() != null) {
                orderMap.put("orderTime", sdf.format(cmsActivityOrder.getOrderCreateTime()));
            }
            orderMap.put("activityId",cmsActivityOrder.getActivityId()!=null?cmsActivityOrder.getActivityId():"");
            orderMap.put("orderNumber", cmsActivityOrder.getOrderNumber() != null ? cmsActivityOrder.getOrderNumber() : "");
            orderMap.put("activityName", cmsActivityOrder.getActivityName() != null ? cmsActivityOrder.getActivityName() : "");
            orderMap.put("activityAddress", cmsActivityOrder.getActivityAddress() != null ? cmsActivityOrder.getActivityAddress() : "");
            orderMap.put("activityTime", cmsActivityOrder.getEventDateTime()!=null?cmsActivityOrder.getEventDateTime():"");
            orderMap.put("activitySalesOnline",cmsActivityOrder.getActivitySalesOnline()!=null?cmsActivityOrder.getActivitySalesOnline():"");
            orderMap.put("activityIsReservation",cmsActivityOrder.getActivityIsReservation()!=null?cmsActivityOrder.getActivityIsReservation():"");
            StringBuffer seatSB = new StringBuffer();; //改变后座位号
            StringBuffer sbSeat= new StringBuffer();; //座位号
            StringBuffer sbLine=new StringBuffer();//封装订单序列号
            String seat="";       // 座位号
            String orderLine="";  //订单序列号
            int j = 0;
            if (cmsActivityOrder.getSeatStatus() != null && StringUtils.isNotBlank(cmsActivityOrder.getSeatStatus())) {
                String[] activitySeatStatus = cmsActivityOrder.getSeatStatus().split(",");
                for (int i = 0; i < activitySeatStatus.length; i++) {
                    if (Integer.valueOf(activitySeatStatus[i]) == 1) {
                        //在线选座 截取座位重新编辑成几排几座
                        seat=cmsActivityOrder.getSeats()!=null?StringUtils.split(cmsActivityOrder.getSeats(), ",")[i]:"";
                        sbSeat.append(seat + ",");

                        if (!seat.equals("") && StringUtils.isNotBlank(seat) && seat.contains("_")) {
                            String[] seats = seat.split("_");
                            seatSB.append(seats[0] + "排");
                            seatSB.append(seats[1] + "座");
                            seatSB.append(",");
                        }
                        //自由入座 编辑座位信息
                        else {
                            seatSB.append("自由入座");
                            seatSB.append(",");
                        }
                        //人数
                        j++;
                        //订单序列号 用于取消订单
                        orderLine=cmsActivityOrder.getOrderLine()!=null?StringUtils.split(cmsActivityOrder.getOrderLine(),",")[i]:"";
                        sbLine.append(orderLine+",");
                    }
                }
            }
            orderMap.put("activitySeats", sbSeat.toString());
            orderMap.put("seats", seatSB.toString());
            orderMap.put("orderVotes", Integer.valueOf(j));
            //生成活动订单id 进行取消活动订单
            orderMap.put("activityOrderId", cmsActivityOrder.getActivityOrderId() != null ? cmsActivityOrder.getActivityOrderId() : "");
            orderMap.put("orderLine",sbLine.toString());
            orderMap.put("orderValidateCode", cmsActivityOrder.getOrderValidateCode() != null ? cmsActivityOrder.getOrderValidateCode() : "");
            orderMap.put("orderPhotoNo", cmsActivityOrder.getOrderPhoneNo() != null ? cmsActivityOrder.getOrderPhoneNo() : "");
            mapList.add(orderMap);
            return JSONResponse.toAppResultFormat(0,mapList);
        } else {
            //获取活动室订单
            CmsRoomOrder cmsRoomOrder=cmsRoomOrderMapper.queryRoomOrderByValidateCode(map);
            if (cmsRoomOrder != null) {
              //拼接活动室时间段与具体时间点
                StringBuffer sbTime=new StringBuffer();
                sbTime.append(cmsRoomOrder.getCurDates()+" ");
                sbTime.append(cmsRoomOrder.getOpenPeriod());
                String nowDate2 = sdf2.format(date);
                int statusDate2 = CompareTime.timeCompare2(sbTime.toString().substring(0,sbTime.toString().lastIndexOf("-")),nowDate2);
                if(cmsRoomOrder.getBookStatus() ==2 || cmsRoomOrder.getBookStatus() ==3 || cmsRoomOrder.getBookStatus() ==4 || cmsRoomOrder.getBookStatus()==5){
                    orderMap.put("orderStatus",cmsRoomOrder.getBookStatus());
                }else {
                    //返回 0 表示时间日期相同
                    //返回 1 表示日期1>日期2
                    //返回 -1 表示日期1<日期2
                    if (statusDate2 == -1) {
                        orderMap.put("orderStatus",6);
                    }else {
                        orderMap.put("orderStatus",cmsRoomOrder.getBookStatus());
                    }
                }
                orderMap.put("tuserTeamName", cmsRoomOrder.getTuserTeamName() != null ? cmsRoomOrder.getTuserTeamName() : "");
                orderMap.put("roomOrderNo", cmsRoomOrder.getOrderNo() != null ? cmsRoomOrder.getOrderNo() : "");
                orderMap.put("roomTime",sbTime.toString());
                orderMap.put("venueName",cmsRoomOrder.getVenueName()!=null?cmsRoomOrder.getVenueName():"");
                orderMap.put("venueAddress", cmsRoomOrder.getVenueAddress() != null ? cmsRoomOrder.getVenueAddress() : "");
                orderMap.put("roomName", cmsRoomOrder.getRoomName() != null ? cmsRoomOrder.getRoomName() : "");
                orderMap.put("roomOderId", cmsRoomOrder.getRoomOrderId() != null ? cmsRoomOrder.getRoomOrderId() : "");
                orderMap.put("orderTel", cmsRoomOrder.getUserTel() != null ? cmsRoomOrder.getUserTel() : "");
                orderMap.put("validCode",cmsRoomOrder.getValidCode()!=null?cmsRoomOrder.getValidCode():"");
                orderMap.put("roomId",cmsRoomOrder.getRoomId()!=null?cmsRoomOrder.getRoomId():"");
                long orderCreateTime=cmsRoomOrder.getOrderCreateTime().getTime();
                orderMap.put("roomOrderCreateTime",orderCreateTime/1000);
                mapList.add(orderMap);
                return JSONResponse.toAppResultFormat(1,mapList);
               /* switch (cmsRoomOrder.getBookStatus()) {
                    case 2:
                        return JSONResponse.toAppResultFormat(14113, "对不起您所订的票已取消");
                    case 3:
                        return JSONResponse.toAppResultFormat(14113, "对不起您所订的票已验票");
                    case 4:
                        return JSONResponse.toAppResultFormat(14113, "对不起您所订的票不存在");
                    case 5:
                        return JSONResponse.toAppResultFormat(14113,"对不起您所订的票已打印");
                }
                if (StringUtils.isEmpty(cmsRoomOrder.getRoomId())) {
                    return JSONResponse.toAppResultFormat(14113, "对不起您所订的票对应的活动室有误，请联系管理员，添加活动室关联");
                }
                // 订票区域限定
                if (area!=null && StringUtils.isNotBlank(area)) {
                    area = map.get(area);
                    if (cmsRoomOrder.getDictName() == null
                            || !area.equals(cmsRoomOrder.getDictName().trim())) {
                        return JSONResponse.toAppResultFormat(14113, "请到本展馆的区域" + cmsRoomOrder.getDictName() + "取票");
                    }
                }
                //判断活动室时间是否有效
                if (cmsRoomOrder.getBookStatus() != 0 && cmsRoomOrder.getBookStatus() == 1) {
                    //活动室时间
                    Date date = new Date();
                    String curDate = cmsRoomOrder.getCurDates() != null ? cmsRoomOrder.getCurDates() : "";
                    StringBuffer time = new StringBuffer();
                    time.append(curDate);
                    String openPeriod = cmsRoomOrder.getOpenPeriod() != null ? cmsRoomOrder.getOpenPeriod() : "";
                    String openTime = openPeriod.toString().substring(0, openPeriod.toString().indexOf("-"));
                    time.append(" " + openTime);
                    System.out.println("time:" + time);
                    String nowDate2 = sdf2.format(date);
                    int statusDate2 = CompareTime.timeCompare2(time.toString(), nowDate2);
                    //返回 0 表示时间日期相同
                    //返回 1 表示日期1>日期2
                    //返回 -1 表示日期1<日期2
                    if (statusDate2 == -1) {
                        return JSONResponse.toAppResultFormat(14113, "对不起您的所预订的活动室已开始，不可取票");
                    } else {
                        sb.append("<div style='font-family:微软雅黑;font-size:16px;'>    [文化云]场馆预订<br>");
                        sb.append(cmsRoomOrder.getRoomName() + " </div>");
                        sb.append("<div style='font-family:微软雅黑;font-size:12px;'>");
                        sb.append("地点：" + cmsRoomOrder.getVenueAddress() + "<br>");
                        sb.append("时间：" + curDate + " " + openPeriod + "<br>");
                        sb.append("场馆：" + cmsRoomOrder.getVenueName() + "<br>");
                        sb.append("票类：网络票<br>");
                        sb.append("取票时间：" + DateUtils.parseDateToLongString(new Date())
                                + "<br>");
                        sb.append("恭候您的大驾光临！<br></div>");
                        sb.append("<div style='font-family:微软雅黑;font-size:11px;'>温馨提醒：未入场达2次或进行营利性活动将取消预订资格。<br>");
                        sb.append("----------------------------------------<br></div>");
                        sb.append("<div style='font-family:微软雅黑;font-size:10px;'>更多精彩内容请访问 http://www.wenhuayun.cn</div><br>");
                        sb.append("<br><br><br>");
                        sb.append("<div style='font-family:微软雅黑;font-size:20px;'>副券   <br></div>");
                        sb.append("<div style='font-family:微软雅黑;font-size:10px;'>账号:"
                                + cmsRoomOrder.getUserName() + " <br> 场地: "
                                + cmsRoomOrder.getVenueName() + "</div>");

                        //封装二维码路径生成二维码图片
                        sb.append("<div id='qrcodeImg' data-val="+cmsRoomOrder.getValidCode()+" style='padding-left: 55px;'");
                        sb.append("</div><br>");
                        //更新活动室取票订单状态 5.已出票
                        cmsRoomOrder.setBookStatus(Constant.BOOK_STATUS5);
                        status = cmsRoomOrderMapper.editCmsRoomOrder(cmsRoomOrder);
                        if (status > 0) {
                            json=JSONResponse.toAppResultFormat(0,sb.toString());
                        } else {
                            json=JSONResponse.toAppResultFormat(14113,"取票信息有误");
                        }
                    }
                }*/
            }else {
                 return JSONResponse.toAppResultFormat(14113,"对不起您的取票码有误,请重新输入");
            }
        }
    }

    /**
     * 验证系统验证活动订单信息
     * @param orderValidateCode 取票码
     * @return
     */
    @Override
    public String queryActvityOrderByValidateCode(String orderValidateCode) throws Exception{
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
        SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd");
        Date date = new Date();
        String json="";
        List<Map<String, Object>> listMap = new ArrayList<Map<String, Object>>();
        Map<String,Object> param=new HashMap<String, Object>();
        if(orderValidateCode!=null && StringUtils.isNotBlank(orderValidateCode)){
            param.put("orderValidateCode",orderValidateCode);
        }
        CmsActivityOrder cmsActivityOrder=cmsActivityOrderMapper.queryActvityOrderByValidateCode(param);
        if (cmsActivityOrder != null) {
            // 验证是否已验票
            if(cmsActivityOrder.getOrderPayStatus() == 4){
                return JSONResponse.toAppResultFormat(10107,"该订单已验过票，不可再验");
            }else if(cmsActivityOrder.getOrderPayStatus() == 2){
                return JSONResponse.toAppResultFormat(11117,"该订单已取消，不可验票");
            }else{
               // String eventDateTime = cmsActivityOrder.getEventDateTime();
               // int status = CompareTime.timeCompare2(StringUtils.left(eventDateTime, 10)+ " " + StringUtils.right(eventDateTime, 5), sdf.format(date));
//                if(status < 0 || cmsActivityOrder.getOrderPayStatus() == 5){
//                    return JSONResponse.toAppResultFormat(11112,"该订单已过期，不可验票");
//                }
            }

            String[] eventDateTimes = cmsActivityOrder.getEventDateTime().split(" ");
            CmsActivityEvent event=cmsActivityEventService.queryByEventId(cmsActivityOrder.getEventId());
            int statusDate1=0;
            if(event.getSingleEvent()!=null&&event.getSingleEvent()==1){
                statusDate1 = CompareTime.timeCompare1(event.getEventDate(), sdf1.format(date));
            }else{
                statusDate1 = CompareTime.timeCompare1(eventDateTimes[0].toString(), sdf1.format(date));
            }

            long hour = (sdf.parse(sdf.format(date)).getTime() - sdf.parse(cmsActivityOrder.getEventDateTime()).getTime()) % (1000 * 24 * 60 * 60) / (1000 * 60 * 60) +
                    ((sdf.parse(sdf.format(date)).getTime() - sdf.parse(cmsActivityOrder.getEventDateTime()).getTime()) / (1000 * 24 * 60 * 60)) * 24;
            if(statusDate1 <= 0){
                /*if(hour >= 1){
                    return JSONResponse.toAppResultFormat(11115, "对不起您的所预订的活动已超过一小时，不可验票");
                }*/
                Map<String,Object> map = new HashMap<String, Object>();
                map.put("orderNumber", cmsActivityOrder.getOrderNumber() != null ? cmsActivityOrder.getOrderNumber() : "");
                map.put("activityName", cmsActivityOrder.getActivityName() != null ? cmsActivityOrder.getActivityName() : "");
                map.put("activityAddress", cmsActivityOrder.getActivityAddress() != null ? cmsActivityOrder.getActivityAddress() : "");
                map.put("activityTime", cmsActivityOrder.getEventDateTime()!=null?cmsActivityOrder.getEventDateTime():"");
                String nowDate2 = sdf.format(date);
                int statusDate2 = CompareTime.timeCompare2(cmsActivityOrder.getEventDateTime().substring(0, cmsActivityOrder.getEventDateTime().lastIndexOf("-")), nowDate2);
                if(cmsActivityOrder.getOrderPayStatus()==2 || cmsActivityOrder.getOrderPayStatus()==3 || cmsActivityOrder.getOrderPayStatus()==4){
                    map.put("orderPayStatus", cmsActivityOrder.getOrderPayStatus());
                }else {
                    //返回 0 表示时间日期相同
                    //返回 1 表示日期1>日期2
                    //返回 -1 表示日期1<日期2
                    if (statusDate2 == -1) {
                        map.put("orderPayStatus", 5);
                    }else {
                        map.put("orderPayStatus", cmsActivityOrder.getOrderPayStatus());
                    }
                }
                StringBuffer sbSeat = new StringBuffer(); //座位号
                StringBuffer seatStatus=new StringBuffer();//座位状态
                String seat = "";   //进行
                int j = 0;
                if (cmsActivityOrder.getSeatStatus()!=null && StringUtils.isNotBlank(cmsActivityOrder.getSeatStatus())) {
                    String[] activityPayStatus = cmsActivityOrder.getSeatStatus().split(",");
                    for (int i = 0; i < activityPayStatus.length; i++) {
                        //座位号
                        seat = cmsActivityOrder.getSeats() != null ? StringUtils.split(cmsActivityOrder.getSeats(), ",")[i] : "";
                        sbSeat.append(seat + ",");
                        //人数
                        j++;
                        //座位票的状态
                        seatStatus.append(activityPayStatus[i]+",");
                    }
                }
                map.put("activitySeats", sbSeat.toString());
                map.put("orderVotes", Integer.valueOf(j));
                map.put("seatStatus",seatStatus.toString());
                map.put("orderValidateCode", cmsActivityOrder.getOrderValidateCode() != null ? cmsActivityOrder.getOrderValidateCode() : "");
                map.put("orderPhotoNo", cmsActivityOrder.getOrderPhoneNo() != null ? cmsActivityOrder.getOrderPhoneNo() : "");
                map.put("userId", cmsActivityOrder.getUserId() != null ? cmsActivityOrder.getUserId() : "");
                map.put("userName", cmsActivityOrder.getUserName() != null ? cmsActivityOrder.getUserName() : "");
                listMap.add(map);
                json=JSONResponse.toAppResultFormat(0,listMap);
            }else{
                return JSONResponse.toAppResultFormat(14114, "对不起活动不在有效时间段，不可验票");
            }
        } else {
            json=JSONResponse.toAppResultFormat(14113,"活动取票码错误");
        }
        return json;
    }

    /**
     * 验证系统验证座位信息
     * @param orderValidateCode 取票码
     * @param seat 座位号
     * @param userId 后台用户id
     * @param orderPayStatus 订单状态 1-未出票 2-已取消 3-已出票 4-已验票 5-已失效
     * @return
     */
    @Override
    public String queryActvityOrderSeatsByValidateCode(String orderValidateCode,String seat,String userId,String orderPayStatus)throws Exception{
        String json = "";
        int flag = 0;
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
        SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd");
        Map<String,Object> param=new HashMap<String, Object>();
        if(orderValidateCode!=null && StringUtils.isNotBlank(orderValidateCode)){
            param.put("orderValidateCode",orderValidateCode);
        }
        CmsActivityOrder cmsActivityOrder = cmsActivityOrderMapper.queryActvityOrderByValidateCode(param);
        Date date = new Date();
        //String nowDate = sdf.format(date);
        String nowDate1 = sdf1.format(date);
        //返回 0 表示时间日期相同
        //返回 1 表示日期1>日期2
        //返回 -1 表示日期1<日期2
        //int statusDate = CompareTime.timeCompare2(cmsActivityOrder.getEventDateTime().substring(0, cmsActivityOrder.getEventDateTime().lastIndexOf("-")), nowDate);
        String[] eventDateTimes = cmsActivityOrder.getEventDateTime().split(" ");
        int statusDate1 = CompareTime.timeCompare1(eventDateTimes[0].toString(), nowDate1);
        if (cmsActivityOrder != null && cmsActivityOrder.getOrderPayStatus() == 4) {
            return JSONResponse.toAppResultFormat(0, "该订单已全部验票，不可再验");
        }

        String eventDateTime = StringUtils.substring(cmsActivityOrder.getEventDateTime(), 0, 16);
        long hour = (sdf.parse(sdf.format(date)).getTime() - sdf.parse(eventDateTime).getTime()) % (1000 * 24 * 60 * 60) / (1000 * 60 * 60) +
                ((sdf.parse(sdf.format(date)).getTime() - sdf.parse(eventDateTime).getTime()) / (1000 * 24 * 60 * 60)) * 24;
        //验证活动是否已开始 只能当天可以验票，并且活动开始一小时之内可以继续验票
        if (statusDate1 <= 0) {

            /*if(hour > 1){
                return JSONResponse.toAppResultFormat(11115, "对不起您的所预订的活动已超过一小时，不可验票");
            }*/
            String[] orderCodes = cmsActivityOrder.getSeats().split(",");
            for (int j = 0; j < orderCodes.length; j++) {
                String orderCode = orderCodes[j];
                String[] seats = seat.split(",");
                for (int i = 0; i < seats.length; i++) {
                    if (seats[i].equals(orderCode)) {
                        CmsActivityOrderDetail cmsActivityOrderDetail = cmsActivityOrderDetailMapper.queryCmsActivityOrderDetailById(cmsActivityOrder.getActivityOrderId(), seats[i]);
                        cmsActivityOrderDetail.setSeatStatus(Constant.ORDER_SEAT_STATUS4);
                        cmsActivityOrderDetail.setUpdateTime(new Date());
                        cmsActivityOrderDetail.setUpdateUser(userId);
                        cmsActivityOrderDetail.setSeatVal(seats[i]);
                        flag = cmsActivityOrderDetailMapper.editCmsActivityOrderDetailByStatus(cmsActivityOrderDetail);
                    }
                }
            }
            if (flag > 0) {
                int count = cmsActivityOrderDetailMapper.queryCmsActivityOrderDetailByStatus(cmsActivityOrder.getActivityOrderId(), Integer.valueOf(orderPayStatus));
                if (count == 0) {
                    cmsActivityOrder.setOrderPayStatus(Constant.ORDER_PAY_STATUS4);
                    cmsActivityOrder.setSysUserId(userId);
                    cmsActivityOrder.setOrderCheckTime(date);
                    int status = cmsActivityOrderMapper.editActivityOrder(cmsActivityOrder);
                    if (status > 0) {
                    	
                    	// 积分数
                		int integralChange=50;

                		// 0:增加、1:扣除
                		int changeType=0;
                		
                		// 积分类型
                		int type=IntegralTypeEnum.VERIFICATION.getIndex();
                		
                		UserIntegralDetail userIntegralDetail = new UserIntegralDetail();
            			userIntegralDetail.setIntegralChange(integralChange);
            			userIntegralDetail.setChangeType(changeType);
            			userIntegralDetail.setIntegralFrom(cmsActivityOrder.getActivityOrderId());
            			userIntegralDetail.setIntegralType(type);
            			userIntegralDetail.setUserId(cmsActivityOrder.getUserId());
		        		userIntegralDetail.setUpdateType(1);
		        		
		        		HttpClientConnection.post(staticServer.getChinaServerUrl() + "chinaIntegral/updateIntegralByJson.do", (JSONObject)JSON.toJSON(userIntegralDetail));
                    	
                        json = JSONResponse.toAppResultFormat(0, "该订单已全部验票");
                    }
                } else {
                    json = JSONResponse.toAppResultFormat(101, "该座位验票成功");
                }
            }
        }else {
            return JSONResponse.toAppResultFormat(14114, "对不起活动不在当天开始，不可验票");
        }
        return json;
    }

    /**
     * app获取电子票订单信息
     * @param activityOrderId 活动订单id
     * @return
     */
    @Override
    public String queryAppELectronicTicketById(String activityOrderId) throws Exception {
        List<Map<String, Object>> listMap = new ArrayList<Map<String, Object>>();
        CmsActivityOrder cmsActivityOrder=cmsActivityOrderMapper.queryAppELectronicTicketById(activityOrderId);
        if(cmsActivityOrder!=null){
            Map<String,Object> map=new HashMap<String, Object>();
            map.put("activityId",cmsActivityOrder.getActivityId()!=null?cmsActivityOrder.getActivityId():"");
            map.put("activityName", cmsActivityOrder.getActivityName() != null ? cmsActivityOrder.getActivityName() : "");
          //  StringBuffer activityAddress=new StringBuffer();
           // activityAddress.append(cmsActivityOrder.getCity());
           // activityAddress.append(cmsActivityOrder.getArea());
           // String address=cmsActivityOrder.getActivityAddress() != null ? cmsActivityOrder.getActivityAddress() : "";
            //activityAddress.append(address);
            map.put("activityAddress",cmsActivityOrder.getActivityAddress() != null ? cmsActivityOrder.getActivityAddress() : "");
            map.put("activityEventDateTime", cmsActivityOrder.getEventDateTime() != null ? cmsActivityOrder.getEventDateTime() : "");
            map.put("activitySeats",cmsActivityOrder.getSeats()!=null?cmsActivityOrder.getSeats():"");
            map.put("orderVotes",cmsActivityOrder.getOrderVotes()!=null?cmsActivityOrder.getOrderVotes():"");
            //封装二维码路径生成二维码图片
            StringBuffer sb = new StringBuffer();
            sb.append(basePath.getBasePath());
            SimpleDateFormat sdf1 = new SimpleDateFormat("yyyyMM");
            sb.append(sdf1.format(new Date()));
            sb.append("/");
            if (cmsActivityOrder.getOrderValidateCode() != null && org.apache.commons.lang3.StringUtils.isNotBlank(cmsActivityOrder.getOrderValidateCode())) {
                sb.append(cmsActivityOrder.getOrderValidateCode());
                sb.append(".jpg");
            }
            QRCode.create_image(cmsActivityOrder.getOrderValidateCode(), sb.toString());
            StringBuffer stringBuffer = new StringBuffer();
            stringBuffer.append(staticServer.getStaticServerUrl());
            stringBuffer.append(sdf1.format(new Date()));
            stringBuffer.append("/");
            stringBuffer.append(cmsActivityOrder.getOrderValidateCode());
            stringBuffer.append(".jpg");
            map.put("activityQrcodeUrl", stringBuffer.toString());
            listMap.add(map);
        }
        return JSONResponse.toAppResultFormat(0,listMap);
    }

    /**
     * 取票机活动取票流程
     * @param orderValidateCode 取票码
     * @param seat 座位号
     * @return
     */
    @Override
    public String takeAppActivityValidateCode(String orderValidateCode,String seat) throws Exception {
        String json = "";
        int flag = 0;
        int status = 0;
        Map<String,Object> param=new HashMap<String, Object>();
        if(orderValidateCode!=null && StringUtils.isNotBlank(orderValidateCode)){
            param.put("orderValidateCode",orderValidateCode);
        }
        CmsActivityOrder cmsActivityOrder = cmsActivityOrderMapper.queryActvityOrderByValidateCode(param);
        if (cmsActivityOrder != null) {
                String[] orderCodes = cmsActivityOrder.getSeats().split(",");
                for (int j = 0; j < orderCodes.length; j++) {
                    String orderCode = orderCodes[j];
                    String[]   seats = seat.split(",");
                    for (int i = 0; i < seats.length; i++) {
                        if (seats[i].equals(orderCode)) {
                            printCount++;
                            CmsActivityOrderDetail cmsActivityOrderDetail = cmsActivityOrderDetailMapper.queryCmsActivityOrderDetailById(cmsActivityOrder.getActivityOrderId(), seats[i]);
                            cmsActivityOrderDetail.setSeatStatus(Constant.ORDER_PAY_STATUS3);
                            cmsActivityOrderDetail.setUpdateTime(new Date());
                            cmsActivityOrderDetail.setSeatVal(seats[i]);
                            flag = cmsActivityOrderDetailMapper.editCmsActivityOrderDetailByStatus(cmsActivityOrderDetail);
                        }
                    }
                }
                if (flag > 0) {
                    int count = cmsActivityOrderDetailMapper.queryCmsActivityOrderDetailByStatus(cmsActivityOrder.getActivityOrderId(),Constant.ORDER_PAY_STATUS1);
                    if (count == 0) {
                        cmsActivityOrder.setPrintTicketTimes(printCount);
                        cmsActivityOrder.setOrderPayStatus(Constant.ORDER_STATUS3);
                        status = cmsActivityOrderMapper.editActivityOrder(cmsActivityOrder);
                        if (status > 0) {
                            //多个座位信息
                            json=ActivitySeatTemplate.toActivitySeatTemplate(cmsActivityOrder,seat,staticServer,basePath);
                        }
                     } else {
                            //单个座位信息
                            json=ActivitySeatTemplate.toActivitySeatTemplate(cmsActivityOrder,seat, staticServer, basePath);
                    }

                }
           }else {
                         json= JSONResponse.toAppResultFormat(14113,"对不起您的取票码有误");
        }
                          return json;
    }
}