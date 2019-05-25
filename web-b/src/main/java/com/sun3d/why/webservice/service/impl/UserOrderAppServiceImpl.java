package com.sun3d.why.webservice.service.impl;

import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.sun3d.why.dao.CmsActivityMapper;
import com.sun3d.why.dao.CmsActivityOrderMapper;
import com.sun3d.why.dao.CmsActivityRoomMapper;
import com.sun3d.why.dao.CmsRoomBookMapper;
import com.sun3d.why.dao.CmsRoomOrderMapper;
import com.sun3d.why.dao.CmsTeamUserMapper;
import com.sun3d.why.dao.CmsTerminalUserMapper;
import com.sun3d.why.dao.CmsVenueMapper;
import com.sun3d.why.model.CmsActivity;
import com.sun3d.why.model.CmsActivityOrder;
import com.sun3d.why.model.CmsActivityRoom;
import com.sun3d.why.model.CmsRoomBook;
import com.sun3d.why.model.CmsRoomOrder;
import com.sun3d.why.model.CmsTeamUser;
import com.sun3d.why.model.CmsTerminalUser;
import com.sun3d.why.model.CmsVenue;
import com.sun3d.why.model.extmodel.BasePath;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.util.CompareTime;
import com.sun3d.why.util.DateUtils;
import com.sun3d.why.util.JSONResponse;
import com.sun3d.why.util.PaginationApp;
import com.sun3d.why.util.QRCode;
import com.sun3d.why.webservice.service.UserOrderAppService;

/**
 * Created by wangkun on 2016/2/17.
 */
@Transactional
@Service
public class UserOrderAppServiceImpl implements UserOrderAppService {
    @Autowired
    private CmsActivityOrderMapper cmsActivityOrderMapper;
    @Autowired
    private StaticServer staticServer;
    @Autowired
    private BasePath basePath;
    @Autowired
    private CmsRoomOrderMapper cmsRoomOrderMapper;
    @Autowired
    private CmsVenueMapper cmsVenueMapper;
    @Autowired
    private CmsActivityRoomMapper activityRoomMapper;
    @Autowired
    private CmsRoomBookMapper cmsRoomBookMapper;
    @Autowired
    private CmsTeamUserMapper teamUserMapper;
    @Autowired
    private CmsActivityMapper activityMapper;
    @Autowired
    private CmsTerminalUserMapper userMapper;
    
    /**
     * app显示或搜索用户活动与活动室订单（当前与历史）
     * @param pageApp 分页对象
     * @param userId  用户id
     * @param orderValidateCode 取票码
     * @param venueName 展馆名称
     * @param activityName 活动名称
     * @param orderNumber   订单编号
     * @return
     */
    @Override
    public String queryAppOrdersById(PaginationApp pageApp, String userId,String orderValidateCode,String venueName,String activityName,String orderNumber) throws Exception {
        SimpleDateFormat sdf2 = new SimpleDateFormat("yyyy-MM-dd HH:mm");
        List<Map<String, Object>> MapActivityList = new ArrayList<Map<String, Object>>();
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("userId", userId);
        if(orderValidateCode!=null && StringUtils.isNotBlank(orderValidateCode)){
            map.put("orderValidateCode","%" +orderValidateCode+ "%");
        }
        if(orderNumber!=null && StringUtils.isNotBlank(orderNumber)){
            map.put("orderNumber", "%" +orderNumber+ "%");
        }
        if(activityName!=null && StringUtils.isNotBlank(activityName)){
            map.put("activityName", "%/" +activityName+ "%");
        }
        if(venueName!=null && StringUtils.isNotBlank(venueName)){
            map.put("venueName", "%/" +venueName+ "%");
        }
        if (pageApp != null && pageApp.getFirstResult() != null && pageApp.getRows() != null) {
            map.put("firstResult", pageApp.getFirstResult());
            map.put("rows", pageApp.getRows());
        }

        //获取我的活动订单信息（当前与历史）
        List<CmsActivityOrder> userActivityList = cmsActivityOrderMapper.queryAppActivityOrdersById(map);
        if (CollectionUtils.isNotEmpty(userActivityList)) {
            for (CmsActivityOrder activityOrder : userActivityList) {
                Map<String, Object> mapUserActivity = new HashMap<String, Object>();
                mapUserActivity.put("activityId", activityOrder.getActivityId() != null ? activityOrder.getActivityId() : "");
                mapUserActivity.put("orderNumber", activityOrder.getOrderNumber() != null ? activityOrder.getOrderNumber() : "");
                mapUserActivity.put("orderTime", activityOrder.getOrderCreateTime().getTime()/ 1000);
                mapUserActivity.put("activityName", activityOrder.getActivityName() != null ? activityOrder.getActivityName() : "");
                mapUserActivity.put("activityAddress",activityOrder.getActivityAddress() != null ? activityOrder.getActivityAddress() : "");
                mapUserActivity.put("activityEventDateTime", activityOrder.getEventDateTime() != null ? activityOrder.getEventDateTime() : "");
                StringBuffer sbSeat=new StringBuffer();//封装座位号
                StringBuffer sbLine=new StringBuffer();//封装订单序列号
                String seat=""; //座位号
                String orderLine=""; //订单序列号
                int j=0;

                //座位号
                if (StringUtils.isNotBlank(activityOrder.getSeatStatus())) {
                    String[] activitySeatStatus = activityOrder.getSeatStatus().split(",");
                    for (int i = 0; i < activitySeatStatus.length; i++) {
                        //1.预定成功  3.已出票
                        if (Integer.valueOf(activitySeatStatus[i]) == 1 || Integer.valueOf(activitySeatStatus[i])==3) {
                            seat=activityOrder.getSeats() != null ? StringUtils.split(activityOrder.getSeats(),",")[i] : "";
                            sbSeat.append(seat+",");
                            //订单票数
                            j++;
                            //订单序列号 用于取消订单
                            orderLine=activityOrder.getOrderLine()!=null?StringUtils.split(activityOrder.getOrderLine(),",")[i]:"";
                            sbLine.append(orderLine+",");
                        }
                    }
                }
                mapUserActivity.put("activitySeats",sbSeat.toString());
                String nowDate2 = sdf2.format(new Date());

                int statusDate2 = -1;
                if(StringUtils.isNotBlank(activityOrder.getEventDateTime())){
                    statusDate2 = CompareTime.timeCompare2(activityOrder.getEventDateTime().substring(0, activityOrder.getEventDateTime().lastIndexOf("-")), nowDate2);
                }

                if(activityOrder.getOrderPayStatus()==2 || activityOrder.getOrderPayStatus()==3 || activityOrder.getOrderPayStatus()==4){
                    mapUserActivity.put("orderPayStatus", activityOrder.getOrderPayStatus());
                }else {
                    //返回 0 表示时间日期相同
                    //返回 1 表示日期1>日期2
                    //返回 -1 表示日期1<日期2
                    if (statusDate2 == -1) {
                        mapUserActivity.put("orderPayStatus", 5);
                    }else {
                        mapUserActivity.put("orderPayStatus", activityOrder.getOrderPayStatus());
                    }
                }
                //生成活动订单id 进行取消活动订单
                mapUserActivity.put("activityOrderId", activityOrder.getActivityOrderId() != null ? activityOrder.getActivityOrderId() : "");
                mapUserActivity.put("orderLine",sbLine.toString());
                mapUserActivity.put("orderVotes",j);
                mapUserActivity.put("orderValidateCode", activityOrder.getOrderValidateCode() != null ? activityOrder.getOrderValidateCode() : "");
                mapUserActivity.put("activitySalesOnline",activityOrder.getActivitySalesOnline()!=null?activityOrder.getActivitySalesOnline():"");
                mapUserActivity.put("activityIsReservation",activityOrder.getActivityIsReservation()!=null?activityOrder.getActivityIsReservation():"");
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
                mapUserActivity.put("activityQrcodeUrl", stringBuffer.toString());
                MapActivityList.add(mapUserActivity);
            }
        }
        //获取我的活动室订单信息（当前与历史）
        List<CmsRoomOrder> userRoomOrderList = cmsRoomOrderMapper.queryRoomOrderListById(map);
        
        List<Map<String,Object>> MapRoomList=this.toMapRoomList(userRoomOrderList,true);
   
        if(CollectionUtils.isEmpty(userActivityList) && CollectionUtils.isEmpty(userRoomOrderList)){
            return JSONResponse.toAppResultFormat(14151,"查无此订单信息");
        }
        return JSONResponse.toAppResultObject(0, MapActivityList, MapRoomList);
    }

    /**
     * why3.5 app显示或搜索用户活动与活动室订单信息（当前未过期订单）
     * @param pageApp 分页对象
     * @param userId  用户id
     * @return
     */
    @Override
    public String queryAppUserOrderByUserId(PaginationApp pageApp, String userId) throws Exception {
        List<Map<String, Object>> MapActivityList = new ArrayList<Map<String, Object>>();
        List<Map<String, Object>> MapRoomList = new ArrayList<Map<String, Object>>();
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("userId", userId);
        if (pageApp != null && pageApp.getFirstResult() != null && pageApp.getRows() != null) {
            map.put("firstResult", pageApp.getFirstResult());
            map.put("rows", pageApp.getRows());
        }

        //获取我的活动订单信息
		try {
			List<CmsActivityOrder> userActivityList = cmsActivityOrderMapper.queryAppActivityOrderByUserId(map);
			if (CollectionUtils.isNotEmpty(userActivityList)) {
			    for (CmsActivityOrder activityOrder : userActivityList) {
			        Map<String, Object> mapUserActivity = new HashMap<String, Object>();
			        mapUserActivity.put("activityId", activityOrder.getActivityId() != null ? activityOrder.getActivityId() : "");
			        mapUserActivity.put("orderNumber", activityOrder.getOrderNumber() != null ? activityOrder.getOrderNumber() : "");
			        mapUserActivity.put("orderTime", activityOrder.getOrderCreateTime().getTime()/ 1000);
			        mapUserActivity.put("activityName", activityOrder.getActivityName() != null ? activityOrder.getActivityName() : "");
			        mapUserActivity.put("activityAddress",activityOrder.getActivityAddress() != null ? activityOrder.getActivityAddress() : "");
			        activityOrder.setEventEndDate(activityOrder.getEventEndDate()!=null?activityOrder.getEventEndDate():activityOrder.getEventDate());;
			        if(activityOrder.getEventDate().equals(activityOrder.getEventEndDate())){
			    		Date date=DateUtils.getStringToDate(activityOrder.getEventDate()+" "+"00:00:00");
			        	Calendar cal = Calendar.getInstance();
			            cal.setTime(date);
			            int dayOfWeek= cal.get(Calendar.DAY_OF_WEEK)-1 ;
			            String[] weekDays = {"周日","周一", "周二", "周三", "周四", "周五", "周六"};
			            String weekCn=weekDays[dayOfWeek];
			            mapUserActivity.put("activityEventDateTime",activityOrder.getEventDate().replaceAll("-", ".")+" "+weekCn+" "+activityOrder.getEventTime());
			        }else{
			        	mapUserActivity.put("activityEventDateTime",activityOrder.getEventDate().replaceAll("-", ".")+"至"+activityOrder.getEventEndDate().replaceAll("-", ".")+" "+activityOrder.getEventTime());
			        }
			      
			        if(activityOrder.getActivityIsFree().equals("1")||activityOrder.getOrderPrice()==null){
			        	mapUserActivity.put("orderPrice", "免费");
			        }
			        else
			        	mapUserActivity.put("orderPrice", activityOrder.getOrderPrice().doubleValue());
			        
			        StringBuffer sbSeat=new StringBuffer();//封装座位号
			        StringBuffer sbLine=new StringBuffer();//封装订单序列号
			        String seat=""; //座位号
			        String orderLine=""; //订单序列号

			        int j=0;
			        //座位号
			        if (StringUtils.isNotBlank(activityOrder.getSeatStatus())) {
			            String[] activitySeatStatus = activityOrder.getSeatStatus().split(",");
			            for (int i = 0; i < activitySeatStatus.length; i++) {
			                //1.预定成功  3.已出票
			                if (Integer.valueOf(activitySeatStatus[i]) == 1 || Integer.valueOf(activitySeatStatus[i])==3) {
			                    seat=activityOrder.getSeats() != null ? StringUtils.split(activityOrder.getSeats(),",")[i] : "";
			                    sbSeat.append(seat+",");
			                    //订单票数
			                    j++;
			                    //订单序列号 用于取消订单
			                    orderLine=activityOrder.getOrderLine()!=null?StringUtils.split(activityOrder.getOrderLine(),",")[i]:"";
			                    sbLine.append(orderLine+",");
			                }
			            }
			        }
			        mapUserActivity.put("activitySeats",sbSeat.toString());
			        mapUserActivity.put("orderPayStatus", activityOrder.getOrderPayStatus() != null ? activityOrder.getOrderPayStatus() : 2);

			        //生成活动订单id 进行取消活动订单
			        mapUserActivity.put("activityOrderId", activityOrder.getActivityOrderId() != null ? activityOrder.getActivityOrderId() : "");
			        mapUserActivity.put("orderLine",sbLine.toString());
			        mapUserActivity.put("orderVotes",j);
			        mapUserActivity.put("orderValidateCode", activityOrder.getOrderValidateCode() != null ? activityOrder.getOrderValidateCode() : "");
			        mapUserActivity.put("activitySalesOnline",activityOrder.getActivitySalesOnline()!=null?activityOrder.getActivitySalesOnline():"");
			        mapUserActivity.put("activityIsReservation",activityOrder.getActivityIsReservation()!=null?activityOrder.getActivityIsReservation():"");
			        
			        String activityIconUrl = "";
		            if (StringUtils.isNotBlank(activityOrder.getActivityIconUrl())) {
		                activityIconUrl = staticServer.getStaticServerUrl() + activityOrder.getActivityIconUrl();
		            }
		            mapUserActivity.put("activityIconUrl", activityIconUrl);
			        
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
			        mapUserActivity.put("activityQrcodeUrl", stringBuffer.toString());
			        MapActivityList.add(mapUserActivity);
			    }
			}
			//获取我的活动室订单信息
			List<CmsRoomOrder> userRoomOrderList = cmsRoomOrderMapper.queryAppRoomOrderByUserId(map);
   
			MapRoomList = this.toMapRoomList(userRoomOrderList,false);
		} catch (Exception e) {
			e.printStackTrace();
		}
        
//        if(CollectionUtils.isEmpty(userActivityList) && CollectionUtils.isEmpty(userVenueList)){
//            return JSONResponse.toAppResultObject(1, MapActivityList, MapRoomList);
//        }
        return JSONResponse.toAppResultObject(1, MapActivityList, MapRoomList);
    }
    
    /* (non-Javadoc)
	 * @see com.sun3d.why.webservice.service.UserOrderAppService#queryAppUserOrderCountByUserId(java.lang.String)
	 */
	@Override
	public long queryAppUserOrderCountByUserId(String userId) {
		
		Map<String, Object> map = new HashMap<String, Object>();
	    map.put("userId", userId);

	    long count=0;
	    
	    List<CmsActivityOrder> userActivityList = cmsActivityOrderMapper.queryAppActivityOrderByUserId(map);
		
	    count+=userActivityList.size();
	    
	    userActivityList=null;
	    
	    List<CmsRoomOrder> userRoomOrderList = cmsRoomOrderMapper.queryAppRoomOrderByUserId(map);
	    
	    count+=userRoomOrderList.size();
	    
	    userRoomOrderList=null;
	    
		return count;
	}
    
    /**
     * why3.5 app用户活动订单详情
     * @param userId 用户id
     * @param activityOrderId 订单ID
     * @return json 10111:用户id不存在
     */
    @Override
	public String queryAppUserActivityOrderDetail(String userId,String activityOrderId) throws Exception {
    	Map<String, Object> map = new HashMap<String, Object>();
        map.put("userId", userId);
        map.put("activityOrderId", activityOrderId);
        Map<String, Object> mapUserActivity;
		try {
			CmsActivityOrder activityOrder = cmsActivityOrderMapper.queryAppUserActivityOrderDetail(map);
			map = new HashMap<String, Object>();
			map.put("relatedId", activityOrder.getActivityId());
			CmsActivity cmsActivity = activityMapper.queryAppCmsActivityById(map);
			mapUserActivity = new HashMap<String, Object>();
			mapUserActivity.put("activityId", activityOrder.getActivityId() != null ? activityOrder.getActivityId() : "");
			mapUserActivity.put("venueName", activityOrder.getVenueName() != null ? activityOrder.getVenueName() : "");
			mapUserActivity.put("venueAddress", activityOrder.getVenueAddress() != null ? activityOrder.getVenueAddress() : "");
			mapUserActivity.put("orderPayTime", activityOrder.getOrderPayTime() != null ? activityOrder.getOrderPayTime().getTime()/ 1000: "");
			mapUserActivity.put("orderPhoneNo", activityOrder.getOrderPhoneNo() != null ? activityOrder.getOrderPhoneNo() : "");
			mapUserActivity.put("orderName", activityOrder.getOrderName() != null ? activityOrder.getOrderName() : "");
			mapUserActivity.put("orderNumber", activityOrder.getOrderNumber() != null ? activityOrder.getOrderNumber() : "");
			mapUserActivity.put("orderTime", activityOrder.getOrderCreateTime().getTime()/ 1000);
			mapUserActivity.put("activityName", activityOrder.getActivityName() != null ? activityOrder.getActivityName() : "");
			mapUserActivity.put("activityAddress",activityOrder.getActivityAddress() != null ? activityOrder.getActivityAddress() : "");
			mapUserActivity.put("activitySite", cmsActivity.getActivitySite() != null ? cmsActivity.getActivitySite() : "");
			mapUserActivity.put("costTotalCredit", cmsActivity.getCostCredit() != null ? cmsActivity.getCostCredit()*activityOrder.getOrderVotes() : 0);
			String activityIconUrl = "";
            if (StringUtils.isNotBlank(cmsActivity.getActivityIconUrl())) {
                activityIconUrl = staticServer.getStaticServerUrl() + cmsActivity.getActivityIconUrl();
            }
            mapUserActivity.put("activityIconUrl", activityIconUrl);
			//获取活动经纬度
            double activityLon = 0d;
            if (cmsActivity.getActivityLon() != null) {
                activityLon = cmsActivity.getActivityLon();
            }
            double activityLat = 0d;
            if (cmsActivity.getActivityLat() != null) {
                activityLat = cmsActivity.getActivityLat();
            }
			mapUserActivity.put("activityLon", activityLon);
			mapUserActivity.put("activityLat", activityLat);
			mapUserActivity.put("activityEventDateTime", activityOrder.getEventDateTime() != null ? activityOrder.getEventDateTime() : "");
			mapUserActivity.put("eventDate", activityOrder.getEventDate()!=null?activityOrder.getEventDate():"");
			mapUserActivity.put("eventEndDate", activityOrder.getEventEndDate()!=null?activityOrder.getEventEndDate():activityOrder.getEventDate());
			mapUserActivity.put("eventTime", activityOrder.getEventTime()!=null?activityOrder.getEventTime():"");
			StringBuffer sbSeat=new StringBuffer();//封装座位号
			StringBuffer sbLine=new StringBuffer();//封装订单序列号
			String seat=""; //座位号
			String orderLine=""; //订单序列号

			//座位号
			if (StringUtils.isNotBlank(activityOrder.getSeatStatus())) {
			    String[] activitySeatStatus = activityOrder.getSeatStatus().split(",");
			    for (int i = 0; i < activitySeatStatus.length; i++) {
			        //1.预定成功  3.已出票
			        if (Integer.valueOf(activitySeatStatus[i]) == 1 || Integer.valueOf(activitySeatStatus[i])==3) {
			            seat=activityOrder.getSeats() != null ? StringUtils.split(activityOrder.getSeats(),",")[i] : "";
			            sbSeat.append(seat+",");
			            //订单票数
			            //订单序列号 用于取消订单
			            orderLine=activityOrder.getOrderLine()!=null?StringUtils.split(activityOrder.getOrderLine(),",")[i]:"";
			            sbLine.append(orderLine+",");
			        }
			    }
			}
			mapUserActivity.put("activitySeats",sbSeat.toString());
			
			String nowDate = new SimpleDateFormat("yyyy-MM-dd HH:mm").format(new Date());
            int statusDate = -1;
            if(StringUtils.isNotBlank(activityOrder.getEventDateTime())){
                String[] eventDateTime = activityOrder.getEventDateTime().split(" ");
                statusDate = CompareTime.timeCompare2(eventDateTime[0]+" "+StringUtils.right(eventDateTime[1], 5), nowDate);
            }
            Short orderPayStatus = activityOrder.getOrderPayStatus();
            if(orderPayStatus != null){
                if(orderPayStatus == 1 || orderPayStatus == 3){
                    if(statusDate < 0){ // 过期
                        orderPayStatus = 5;
                    }
                }
            }
            mapUserActivity.put("orderPayStatus", orderPayStatus != null ? orderPayStatus : 2);

			//生成活动订单id 进行取消活动订单
			mapUserActivity.put("activityOrderId", activityOrder.getActivityOrderId() != null ? activityOrder.getActivityOrderId() : "");
			mapUserActivity.put("orderLine",sbLine.toString());
			mapUserActivity.put("orderVotes",activityOrder.getOrderVotes()!= null ? activityOrder.getOrderVotes() : "");
			mapUserActivity.put("orderValidateCode", activityOrder.getOrderValidateCode() != null ? activityOrder.getOrderValidateCode() : "");
			mapUserActivity.put("activitySalesOnline",activityOrder.getActivitySalesOnline()!=null?activityOrder.getActivitySalesOnline():"");
			mapUserActivity.put("activityIsReservation",activityOrder.getActivityIsReservation()!=null?activityOrder.getActivityIsReservation():"");
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
			mapUserActivity.put("activityQrcodeUrl", stringBuffer.toString());
		} catch (Exception e) {
			e.printStackTrace();
			return JSONResponse.toAppResultFormat(500, e.getMessage());
		}
		return JSONResponse.toAppResultFormat(200, mapUserActivity);
	}

    /**
     * why3.5 app显示或搜索用户活动与活动室历史订单信息（过期订单，即历史订单）
     * @param pageApp 分页对象
     * @param userId  用户id
     * @return
     */
    @Override
    public String queryAppUserHistoryOrderByUserId(PaginationApp pageApp, String userId) throws Exception {
        SimpleDateFormat sdf2 = new SimpleDateFormat("yyyy-MM-dd HH:mm");
        List<Map<String, Object>> MapActivityList = new ArrayList<Map<String, Object>>();
       
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("userId", userId);
        if (pageApp != null && pageApp.getFirstResult() != null && pageApp.getRows() != null) {
            map.put("firstResult", pageApp.getFirstResult());
            map.put("rows", pageApp.getRows());
        }

        //获取我的活动订单信息
        List<CmsActivityOrder> userActivityList = cmsActivityOrderMapper.queryAppHistoryActivityOrderByUserId(map);
        if (CollectionUtils.isNotEmpty(userActivityList)) {
            for (CmsActivityOrder activityOrder : userActivityList) {
                Map<String, Object> mapUserActivity = new HashMap<String, Object>();
                mapUserActivity.put("activityId", activityOrder.getActivityId() != null ? activityOrder.getActivityId() : "");
                mapUserActivity.put("orderNumber", activityOrder.getOrderNumber() != null ? activityOrder.getOrderNumber() : "");
                mapUserActivity.put("orderTime", activityOrder.getOrderCreateTime().getTime()/ 1000);
                mapUserActivity.put("activityName", activityOrder.getActivityName() != null ? activityOrder.getActivityName() : "");
                mapUserActivity.put("activityAddress",activityOrder.getActivityAddress() != null ? activityOrder.getActivityAddress() : "");
                activityOrder.setEventEndDate(activityOrder.getEventEndDate()!=null?activityOrder.getEventEndDate():activityOrder.getEventDate());;
                if(activityOrder.getEventDate().equals(activityOrder.getEventEndDate())){
            		Date date=DateUtils.getStringToDate(activityOrder.getEventDate()+" "+"00:00:00");
                	Calendar cal = Calendar.getInstance();
                    cal.setTime(date);
                    int dayOfWeek= cal.get(Calendar.DAY_OF_WEEK)-1 ;
                    String[] weekDays = {"周日","周一", "周二", "周三", "周四", "周五", "周六"};
                    String weekCn=weekDays[dayOfWeek];
                    mapUserActivity.put("activityEventDateTime",activityOrder.getEventDate().replaceAll("-", ".")+" "+weekCn+" "+activityOrder.getEventTime());
                }else{
                	mapUserActivity.put("activityEventDateTime",activityOrder.getEventDate().replaceAll("-", ".")+"至"+activityOrder.getEventEndDate().replaceAll("-", ".")+" "+activityOrder.getEventTime());
                }
                
                if(activityOrder.getActivityIsFree().equals("1")||activityOrder.getOrderPrice()==null){
                    
                	mapUserActivity.put("orderPrice", "免费");
                }
                else
                	mapUserActivity.put("orderPrice", activityOrder.getOrderPrice().doubleValue());
                
                
                StringBuffer sbSeat=new StringBuffer();//封装座位号
                StringBuffer sbLine=new StringBuffer();//封装订单序列号
                String seat=""; //座位号
                String orderLine=""; //订单序列号
                int j=0;

                //座位号
                if (StringUtils.isNotBlank(activityOrder.getSeatStatus())) {
                    String[] activitySeatStatus = activityOrder.getSeatStatus().split(",");
                    for (int i = 0; i < activitySeatStatus.length; i++) {
                        //1.预定成功  3.已出票
                        if (Integer.valueOf(activitySeatStatus[i]) == 1 || Integer.valueOf(activitySeatStatus[i])==3) {
                            seat=activityOrder.getSeats() != null ? StringUtils.split(activityOrder.getSeats(),",")[i] : "";
                            sbSeat.append(seat+",");
                            //订单票数
                            j++;
                            //订单序列号 用于取消订单
                            orderLine=activityOrder.getOrderLine()!=null?StringUtils.split(activityOrder.getOrderLine(),",")[i]:"";
                            sbLine.append(orderLine+",");
                        }
                    }
                }
                mapUserActivity.put("activitySeats",sbSeat.toString());
                String nowDate2 = sdf2.format(new Date());
                int statusDate2 = -1;
                if(StringUtils.isNotBlank(activityOrder.getEventDateTime())){
                    String[] eventDateTime = activityOrder.getEventDateTime().split(" ");
                    statusDate2 = CompareTime.timeCompare2(eventDateTime[0]+" "+StringUtils.right(eventDateTime[1], 5), nowDate2);
                }
                Short orderPayStatus = activityOrder.getOrderPayStatus();
                if(orderPayStatus != null){
                    if(orderPayStatus == 1 || orderPayStatus == 3){
                        if(statusDate2 < 0){ // 过期
                            orderPayStatus = 5;
                        }
                    }
                }
                mapUserActivity.put("orderPayStatus", orderPayStatus != null ? orderPayStatus : 2);
                //生成活动订单id 进行取消活动订单
                mapUserActivity.put("activityOrderId", activityOrder.getActivityOrderId() != null ? activityOrder.getActivityOrderId() : "");
                mapUserActivity.put("orderLine",sbLine.toString());
                mapUserActivity.put("orderVotes",j);
                mapUserActivity.put("orderValidateCode", activityOrder.getOrderValidateCode() != null ? activityOrder.getOrderValidateCode() : "");
                mapUserActivity.put("activitySalesOnline",activityOrder.getActivitySalesOnline()!=null?activityOrder.getActivitySalesOnline():"");
                mapUserActivity.put("activityIsReservation",activityOrder.getActivityIsReservation()!=null?activityOrder.getActivityIsReservation():"");
                
                String activityIconUrl = "";
                if (StringUtils.isNotBlank(activityOrder.getActivityIconUrl())) {
                    activityIconUrl = staticServer.getStaticServerUrl() + activityOrder.getActivityIconUrl();
                }
                mapUserActivity.put("activityIconUrl", activityIconUrl);
                
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
                mapUserActivity.put("activityQrcodeUrl", stringBuffer.toString());
                MapActivityList.add(mapUserActivity);
            }
        }
        //获取我的活动室订单信息
        List<CmsRoomOrder> userRoomOrderList = cmsRoomOrderMapper.queryAppRoomHistoryOrderByUserId(map);
        
        List<Map<String,Object>> MapRoomList=this.toMapRoomList(userRoomOrderList,true);
     
//        if(CollectionUtils.isEmpty(userActivityList) && CollectionUtils.isEmpty(userVenueList)){
//            return JSONResponse.toAppResultObject(1, MapActivityList, MapRoomList);
//        }
        return JSONResponse.toAppResultObject(1, MapActivityList, MapRoomList);
    }
    

	/**
	 * @param pageApp
	 * @param userId
	 * @return
	 * @throws Exception
	 */
	/* (non-Javadoc)
	 * @see com.sun3d.why.webservice.service.UserOrderAppService#queryAppUserCheckOrderByUserId(com.sun3d.why.util.PaginationApp, java.lang.String)
	 */
	@Override
	public String queryAppUserCheckOrderByUserId(PaginationApp pageApp, String userId) throws Exception {

		 Map<String, Object> map = new HashMap<String, Object>();
		 map.put("userId", userId);
		 if (pageApp != null && pageApp.getFirstResult() != null && pageApp.getRows() != null) {
	            map.put("firstResult", pageApp.getFirstResult());
	            map.put("rows", pageApp.getRows());
	        }      
		
		 //获取我的活动室订单信息
	    List<CmsRoomOrder> userRoomOrderList = cmsRoomOrderMapper.queryAppUserCheckOrderByUserId(map);
		
	    List<Map<String,Object>> MapRoomList=this.toMapRoomList(userRoomOrderList,true);
	    
        return JSONResponse.toAppResultFormat(1, MapRoomList);
	    
	}
    
    /**
     * 转换活动室订单 为前台显示格式
     * 
     * @param userVenueList
     * @param expired 是否是过期订单
     * @return
     * @throws Exception 
     */
    private  List<Map<String,Object>>  toMapRoomList( List<CmsRoomOrder> userRoomOrderList,boolean expired ) throws Exception
    {
    	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
    	 
    	String nowDate = sdf.format(new Date());
    	
    	List<Map<String,Object>>  mapRoomList=new ArrayList<Map<String, Object>>();
    	  
   	   	if (CollectionUtils.isNotEmpty(userRoomOrderList)) {
              for (CmsRoomOrder roomOrder : userRoomOrderList) {
                  Map<String, Object> mapUserVenue = new HashMap<String, Object>();
                  mapUserVenue.put("roomName", roomOrder.getRoomName() != null ? roomOrder.getRoomName() : "");
                  mapUserVenue.put("tuserId", roomOrder.getTuserId() != null ? roomOrder.getTuserId() : "");
                  mapUserVenue.put("tuserTeamName", roomOrder.getTuserTeamName() != null ? roomOrder.getTuserTeamName() : "");
                  mapUserVenue.put("tuserIsDisplay", roomOrder.getTuserIsDisplay() != null ? roomOrder.getTuserIsDisplay().toString() : "");
                  mapUserVenue.put("roomOrderNo", roomOrder.getOrderNo() != null ? roomOrder.getOrderNo() : "");
                  long orderCreateTime = roomOrder.getOrderCreateTime().getTime();
                  mapUserVenue.put("orderTime", orderCreateTime / 1000);
                  mapUserVenue.put("venueName", roomOrder.getVenueName() != null ? roomOrder.getVenueName() : "");
                  mapUserVenue.put("venueAddress", roomOrder.getVenueAddress() != null ? roomOrder.getVenueAddress() : "");
                
                  Integer bookStatus = roomOrder.getBookStatus();
                  if(bookStatus != null && expired){
                	  
                      if(bookStatus == 0 || bookStatus == 1){
                    	  
                    	  //拼接活动室时间段与具体时间点
                          StringBuffer sbTime = new StringBuffer();
                          sbTime.append(roomOrder.getCurDates() + " ");
                          sbTime.append(roomOrder.getOpenPeriod());
                       
                          int statusDate2 = CompareTime.timeCompare2(sbTime.toString().substring(0, sbTime.toString().lastIndexOf("-")), nowDate);
                    	  
                          //返回 0 表示时间日期相同
                          //返回 1 表示日期1>日期2
                          //返回 -1 表示日期1<日期2
                          if (statusDate2 == -1) {
                              bookStatus = 6;
                              
                              roomOrder.setBookStatus(6);
                              
                              cmsRoomOrderMapper.editCmsRoomOrder(roomOrder);
                          }
                      }
                  }
                  
                  mapUserVenue.put("orderStatus", bookStatus);
                  
                  int dayOfWeek=roomOrder.getDayOfWeek();
                  
                  String[] weekDays = {"周一", "周二", "周三", "周四", "周五", "周六", "周日"};
                  
                  String weekCn=weekDays[dayOfWeek-1];
                  
                  String hour="";
                  
                  String hourArray[]=roomOrder.getOpenPeriod().split("-");
                  
                  if(hourArray.length>0)
                  {
                	  Date time1=DateUtils.getStringToDate( roomOrder.getCurDates()+" "+hourArray[0]+":00");
                	  Date time2=DateUtils.getStringToDate( roomOrder.getCurDates()+" "+hourArray[1]+":00");
                	  
                	  double between=(time2.getTime()-time1.getTime())/1000;//除以1000是为了转换成秒
                	  
                	  double hour1=between%(24*3600)/3600;
                	  
                	  DecimalFormat df = new DecimalFormat("#.#");
                	  
                	  hour=df.format(hour1)+"小时";
                  }
      	    	
                  mapUserVenue.put("roomTime", roomOrder.getCurDates().replaceAll("-",".")+" "+ weekCn+ " " + roomOrder.getOpenPeriod()+" "+hour);
                  mapUserVenue.put("validCode", roomOrder.getValidCode() != null ? roomOrder.getValidCode() : "");
                  String roomRicUrl = "";
                  if (StringUtils.isNotBlank(roomOrder.getRoomPicUrl())) {
                      roomRicUrl = staticServer.getStaticServerUrl() + roomOrder.getRoomPicUrl();
                  }
                  mapUserVenue.put("roomPicUrl", roomRicUrl);
                  
                  String price="";
      	    	
	      	    	if(roomOrder.getRoomIsFree()==1)
	      	    	{
	      	    		price="免费";
	      	    	}
	      	    	else
	      	    		price=roomOrder.getRoomFee();
	      	    	
	      	      mapUserVenue.put("price",price);
                  
                  //封装二维码路径生成二维码图片
                  StringBuffer sb = new StringBuffer();
                  sb.append(basePath.getBasePath());
                  SimpleDateFormat sdf1 = new SimpleDateFormat("yyyyMM");
                  sb.append(sdf1.format(new Date()));
                  sb.append("/");
                  if (roomOrder.getValidCode() != null && StringUtils.isNotBlank(roomOrder.getValidCode())) {
                      sb.append(roomOrder.getValidCode());
                      sb.append(".jpg");
                  }
                  QRCode.create_image(roomOrder.getValidCode(), sb.toString());
                  StringBuffer stringBuffer = new StringBuffer();
                  stringBuffer.append(staticServer.getStaticServerUrl());
                  stringBuffer.append(sdf1.format(new Date()));
                  stringBuffer.append("/");
                  stringBuffer.append(roomOrder.getValidCode());
                  stringBuffer.append(".jpg");
                  mapUserVenue.put("roomQrcodeUrl", stringBuffer.toString());
                  //获取活动室订单id 用户取消订单
                  mapUserVenue.put("roomOrderId", roomOrder.getRoomOrderId() != null ? roomOrder.getRoomOrderId() : "");
                  mapUserVenue.put("roomId", roomOrder.getRoomId() != null ? roomOrder.getRoomId() : "");
                  mapUserVenue.put("checkStatus", roomOrder.getCheckStatus());
                  mapRoomList.add(mapUserVenue);
              }
          }
   	  
   	  return mapRoomList;
    	
    }

	/* (non-Javadoc)
	 * @see com.sun3d.why.webservice.service.UserOrderAppService#queryAppUserRoomOrderDetail(java.lang.String, java.lang.String)
	 */
	@Override
	public String queryAppUserRoomOrderDetail(String userId, String roomOrderId) throws Exception {
		
		Map<String, Object> map = new HashMap<String, Object>();
        map.put("userId", userId);
        map.put("roomOrderId", roomOrderId);
        Map<String, Object> roomOrderMap;
		try {
			
			CmsTerminalUser user=userMapper.queryTerminalUserById(userId);
			
			CmsRoomOrder cmsRoomOrder = cmsRoomOrderMapper.queryCmsRoomOrderById(roomOrderId);
			
			// 活动室预定
	    	CmsRoomBook cmsRoomBook = cmsRoomBookMapper.queryCmsRoomBookById(cmsRoomOrder.getBookId());
	    	
			 //获取场馆信息
	    	CmsVenue cmsVenue = cmsVenueMapper.queryVenueById(cmsRoomOrder.getVenueId());
	    	
	    	//获取活动室信息
	    	CmsActivityRoom cmsActivityRoom = activityRoomMapper.queryCmsActivityRoomById(cmsRoomOrder.getRoomId());
			
			roomOrderMap = new HashMap<String, Object>();
			
			roomOrderMap.put("userType", user.getUserType());
			
			roomOrderMap.put("roomId", cmsRoomOrder.getRoomId());
			roomOrderMap.put("roomName", cmsActivityRoom.getRoomName());
			roomOrderMap.put("roomOrderId", cmsRoomOrder.getRoomOrderId() != null ? cmsRoomOrder.getRoomOrderId() : "");
			
			roomOrderMap.put("venueId", cmsRoomOrder.getVenueId());
			roomOrderMap.put("venueName", cmsVenue.getVenueName() != null ? cmsVenue.getVenueName() : "");
			roomOrderMap.put("venueAddress", cmsVenue.getVenueAddress() != null ? cmsVenue.getVenueAddress() : "");
			
			Integer dayOfWeek =cmsRoomBook.getDayOfWeek();
	    	
	    	Date curDate=cmsRoomBook.getCurDate();
	    	
	    	String date=getBookDateStr(curDate,dayOfWeek);
	    	
	    	roomOrderMap.put("date", date);
	    	
	    	// 场馆坐标经度
	    	roomOrderMap.put("venueLon", cmsVenue.getVenueLon());
			// 场馆坐标纬度
	    	roomOrderMap.put("venueLat", cmsVenue.getVenueLat());
			
			String roomPicUrl = "";
			if(StringUtils.isNotBlank(cmsActivityRoom.getRoomPicUrl())){
				roomPicUrl=staticServer.getStaticServerUrl()+cmsActivityRoom.getRoomPicUrl();
			}
			roomOrderMap.put("roomPicUrl",roomPicUrl);
	    	
	    	String price="";
	    	
	    	if(cmsActivityRoom.getRoomIsFree()==1)
	    	{
	    		price="免费";
	    	}
	    	else
	    		price=cmsActivityRoom.getRoomFee();
	    	
	    	roomOrderMap.put("price",price);
	    	
	    	roomOrderMap.put("openPeriod",cmsRoomBook.getOpenPeriod());
	    	
	    	
	    	String tuserId=cmsRoomOrder.getTuserId();
	    	
	    	String tuserIsDisplay="";
	    	
	    	if(StringUtils.isNotBlank(tuserId))
	    	{
	    		CmsTeamUser teamUser=teamUserMapper.queryCmsTeamUserById(tuserId);
	    		
	    		if(teamUser!=null)
	    			tuserIsDisplay=String.valueOf(teamUser.getTuserIsDisplay());
	    		
	    		roomOrderMap.put("tuserId", tuserId);
	    		
	    	}
	    	else
	    	{
	    		roomOrderMap.put("tuserId", "");
	    	}
	    	
	    	roomOrderMap.put("tuserIsDisplay", tuserIsDisplay);
	    	 
	    
	    	
	    	roomOrderMap.put("tuserName",cmsRoomOrder.getTuserName());
	    	
	    	roomOrderMap.put("checkStatus", cmsRoomOrder.getCheckStatus());
	    	
	    	
	    	roomOrderMap.put("orderName", cmsRoomOrder.getUserName()!= null ? cmsRoomOrder.getUserName() : "");
	    	roomOrderMap.put("orderTel", cmsRoomOrder.getUserTel()!= null ? cmsRoomOrder.getUserTel() : "");
	    	roomOrderMap.put("orderNumber", cmsRoomOrder.getOrderNo()!= null ? cmsRoomOrder.getOrderNo() : "");
	    	
	        long orderCreateTime = cmsRoomOrder.getOrderCreateTime().getTime();
	        roomOrderMap.put("orderTime", orderCreateTime / 1000);
	        
	        roomOrderMap.put("bookStatus", cmsRoomOrder.getBookStatus());
			
			//封装二维码路径生成二维码图片
			StringBuffer sb = new StringBuffer();
			sb.append(basePath.getBasePath());
			SimpleDateFormat sdf1 = new SimpleDateFormat("yyyyMM");
			sb.append(sdf1.format(new Date()));
			sb.append("/");
			if ( StringUtils.isNotBlank(cmsRoomOrder.getValidCode())) {
			    sb.append(cmsRoomOrder.getValidCode());
			    sb.append(".jpg");
			}
			QRCode.create_image(cmsRoomOrder.getValidCode(), sb.toString());
			StringBuffer stringBuffer = new StringBuffer();
			stringBuffer.append(staticServer.getStaticServerUrl());
			stringBuffer.append(sdf1.format(new Date()));
			stringBuffer.append("/");
			stringBuffer.append(cmsRoomOrder.getValidCode());
			stringBuffer.append(".jpg");
			
			roomOrderMap.put("roomQrcodeUrl", stringBuffer.toString());
			
			roomOrderMap.put("orderValidateCode", cmsRoomOrder.getValidCode());
			
			
		} catch (Exception e) {
			e.printStackTrace();
			return JSONResponse.toAppResultFormat(500, e.getMessage());
		}
		return JSONResponse.toAppResultFormat(200, roomOrderMap);
	}

	/**
     * 获取活动室中文显示日期
     * 
     * @param curDate
     * @param dayOfWeek
     * @return
     */
    private String getBookDateStr(Date curDate,Integer dayOfWeek)
    {
    	SimpleDateFormat formatter = new SimpleDateFormat("yyyy年MM月dd日");
        String strDate = formatter.format(curDate);
        
        String[] weekDays = {"周一", "周二", "周三", "周四", "周五", "周六", "周日"};
        
        String date=""+strDate+" "+weekDays[dayOfWeek-1];
        
        return date;
    }


}
