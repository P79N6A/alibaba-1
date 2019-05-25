package com.sun3d.why.webservice.service.impl;
import com.sun3d.why.dao.CmsRoomOrderMapper;
import com.sun3d.why.dao.CmsUserOperatorLogMapper;
import com.sun3d.why.enumeration.UserOperationEnum;
import com.sun3d.why.model.CmsRoomOrder;
import com.sun3d.why.model.CmsUserOperatorLog;
import com.sun3d.why.model.extmodel.BasePath;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.service.UserIntegralDetailService;
import com.sun3d.why.util.*;
import com.sun3d.why.webservice.service.RoomAppOrderService;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.text.SimpleDateFormat;
import java.util.*;

/**
 * 我的活动室订单管理
 */
@Service
@Transactional
public class RoomAppOrderServiceImpl implements RoomAppOrderService {
    @Autowired
    private CmsRoomOrderMapper cmsRoomOrderMapper;
    @Autowired
    private StaticServer staticServer;
    @Autowired
    private BasePath basePath;
    
    @Autowired
    private UserIntegralDetailService userIntegralDetailService;
    
    @Autowired
    private CmsUserOperatorLogMapper cmsUserOperatorLogMapper;
    
    /**
     * app根据用户id获取当前我预定的活动室
     * @param userId 用户id
     * @param pageApp 分页对象
     * @return
     */
    @Override
    public String queryCurrentRoomOrderListById(String userId, PaginationApp pageApp) throws Exception {
        List<Map<String, Object>> listMapNow = new ArrayList<Map<String, Object>>();
        Map<String, Object> map = new HashMap<String, Object>();
        SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
        String date = sf.format(new Date());
        map.put("roomTime", date);
        map.put("userId",userId);
        //app分页
        if (pageApp != null && pageApp.getFirstResult() != null && pageApp.getRows() != null) {
            map.put("firstResult", pageApp.getFirstResult());
            map.put("rows", pageApp.getRows());
        }
        List<CmsRoomOrder> currentVenueList =cmsRoomOrderMapper.queryCurrentRoomOrderListById(map);
        if(CollectionUtils.isNotEmpty(currentVenueList)){
            for(CmsRoomOrder nowRooms:currentVenueList){
                Map<String, Object> mapUserNowVenue = new HashMap<String, Object>();
                mapUserNowVenue.put("roomName",nowRooms.getRoomName()!=null?nowRooms.getRoomName():"");
                mapUserNowVenue.put("tuserTeamName",nowRooms.getTuserTeamName()!=null?nowRooms.getTuserTeamName():"");
                mapUserNowVenue.put("roomOrderNo",nowRooms.getOrderNo()!=null?nowRooms.getOrderNo():"");
                long orderCreateTime=nowRooms.getOrderCreateTime().getTime();
                mapUserNowVenue.put("roomOrderCreateTime",orderCreateTime/1000);
                mapUserNowVenue.put("venueName",nowRooms.getVenueName()!=null?nowRooms.getVenueName():"");
                StringBuffer venueAddress=new StringBuffer();
                venueAddress.append(nowRooms.getCity());
                venueAddress.append(nowRooms.getArea());
                String address=nowRooms.getVenueAddress()!=null?nowRooms.getVenueAddress():"";
                venueAddress.append(address);
                mapUserNowVenue.put("venueAddress",venueAddress.toString());
                //预定场次  还有预定人数 费用
                long curDate = nowRooms.getCurDate().getTime();
                mapUserNowVenue.put("curDate",curDate/1000);
                // mapUserNowVenue.put("curDate",nowRooms.getCurDate()!=null?nowRooms.getCurDate():"");
                mapUserNowVenue.put("openPeriod",nowRooms.getOpenPeriod()!=null?nowRooms.getOpenPeriod():"");
                //当前展馆下的活动室预定人数
                int count=cmsRoomOrderMapper.queryRoomOrderCount(nowRooms.getRoomId());
                mapUserNowVenue.put("roomsCount",count);
                mapUserNowVenue.put("roomFee",nowRooms.getRoomFee()!=null?nowRooms.getRoomFee():0);
                mapUserNowVenue.put("validCode",nowRooms.getValidCode()!=null?nowRooms.getValidCode():"");
                String roomRicUrl="";
                if(StringUtils.isNotBlank(nowRooms.getRoomPicUrl())){
                    roomRicUrl=staticServer.getStaticServerUrl()+nowRooms.getRoomPicUrl();
                }
                mapUserNowVenue.put("roomRicUrl",roomRicUrl);
                //封装二维码路径生成二维码图片
                StringBuffer sb = new StringBuffer();
                sb.append(basePath.getBasePath());
                SimpleDateFormat sdf1 = new SimpleDateFormat("yyyyMM");
                sb.append(sdf1.format(new Date()));
                sb.append("/");
                if (nowRooms.getValidCode()!= null && StringUtils.isNotBlank(nowRooms.getValidCode())) {
                    sb.append(nowRooms.getValidCode());
                    sb.append(".jpg");
                }
                QRCode.create_image(nowRooms.getValidCode(), sb.toString());
                StringBuffer stringBuffer = new StringBuffer();
                stringBuffer.append(staticServer.getStaticServerUrl());
                stringBuffer.append(sdf1.format(new Date()));
                stringBuffer.append("/");
                stringBuffer.append(nowRooms.getValidCode());
                stringBuffer.append(".jpg");
                mapUserNowVenue.put("roomQrcodeUrl", stringBuffer.toString());
                //获取活动室订单id 用户取消订单
                mapUserNowVenue.put("roomOrderId",nowRooms.getRoomOrderId()!=null?nowRooms.getRoomOrderId():"");
                mapUserNowVenue.put("roomId",nowRooms.getRoomId() != null ? nowRooms.getRoomId() : "");
                mapUserNowVenue.put("commentCount",nowRooms.getCommentNums()!=null ?nowRooms.getCommentNums():0);
               /* String venueId=nowRooms.getVenueId()!=null?nowRooms.getVenueId():"";
                if (StringUtils.isNotBlank(venueId) && !venueId.equals("")) {
                    int commentCount = 0;
                    CmsComment cmsComment = new CmsComment();
                    cmsComment.setCommentRkId(venueId);
                    cmsComment.setCommentType(Constant.TYPE_VENUE);
                    commentCount = commentService.queryCommentCountByCondition(cmsComment);
                    mapUserNowVenue.put("commentCount", commentCount);
                }*/
                listMapNow.add(mapUserNowVenue);
            }
        }
        return JSONResponse.toAppResultFormat(0,listMapNow);
    }

    /**
     * 获取过去我的活动室订单
     * @param userId 用户id
     * @param pageApp 分页对象
     * @return
     */
    @Override
    public String queryPastRoomOrderListById(String userId, PaginationApp pageApp) {
        SimpleDateFormat sdf2=new SimpleDateFormat("yyyy-MM-dd HH:mm");
        List<Map<String, Object>> listMapOld = new ArrayList<Map<String, Object>>();
        Map<String, Object> map = new HashMap<String, Object>();
        SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
        String date = sf.format(new Date());
        map.put("roomTime", date);
        map.put("userId",userId);
        if (pageApp != null && pageApp.getFirstResult() != null && pageApp.getRows() != null) {
            map.put("firstResult", pageApp.getFirstResult());
            map.put("rows", pageApp.getRows());
        }
        List<CmsRoomOrder> pastVenueList=cmsRoomOrderMapper.queryPastRoomOrderListById(map);
        if (pastVenueList!=null && pastVenueList.size() > 0) {
            for (CmsRoomOrder oldRooms : pastVenueList) {
                Map<String, Object> mapUserOldVenue = new HashMap<String, Object>();
                mapUserOldVenue.put("roomOrderNo", oldRooms.getOrderNo() != null ? oldRooms.getOrderNo() : "");
                mapUserOldVenue.put("roomId", oldRooms.getRoomId() != null ? oldRooms.getRoomId() : "");
                mapUserOldVenue.put("venueName", oldRooms.getVenueName() != null ? oldRooms.getVenueName() : "");
                StringBuffer venueAddress=new StringBuffer();
                venueAddress.append(oldRooms.getCity());
                venueAddress.append(oldRooms.getArea());
                String address=oldRooms.getVenueAddress()!=null?oldRooms.getVenueAddress():"";
                venueAddress.append(address);
                mapUserOldVenue.put("venueAddress",venueAddress.toString());
                //活动室订单id 用户删除以往活动室订单
                mapUserOldVenue.put("roomOrderId",oldRooms.getRoomOrderId()!=null?oldRooms.getRoomOrderId():"");
                mapUserOldVenue.put("roomOrderCreateTime",sdf2.format(oldRooms.getOrderCreateTime()));
                listMapOld.add(mapUserOldVenue);
            }
        }
        return  JSONResponse.toAppResultFormat(0,listMapOld);
    }

    /**
     * app删除以往活动室订单
     * @param roomOrderId 活动室订单id
     * @param userId 用户id
     * @return
     */
    @Override
    public int deleteRoomOrderById(String roomOrderId, String userId) {
        int count = cmsRoomOrderMapper.deleteRoomOrderById(roomOrderId,userId);
        if(count>0){
            return  count;
        }else{
            return  0;
        }
    }

    /**
     * 验证系统验证活动室订单信息
     * @param orderValidateCode 取票码
     * @return
     */
    @Override
    public String queryRoomOrderByValidateCode(String orderValidateCode) {
        String json="";
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
        List<Map<String, Object>> listMap = new ArrayList<Map<String, Object>>();
        Map<String,Object> param =new HashMap<String, Object>();
        if(orderValidateCode!=null && StringUtils.isNotBlank(orderValidateCode)){
            param.put("orderValidateCode",orderValidateCode);
        }
        CmsRoomOrder cmsRoomOrder=cmsRoomOrderMapper.queryRoomOrderByValidateCode(param);
        if (cmsRoomOrder != null) {
            Map<String,Object> map = new HashMap<String, Object>();
             //拼接活动室时间段与具体时间点
            StringBuffer sbTime=new StringBuffer();
            sbTime.append(cmsRoomOrder.getCurDates()+" ");
            sbTime.append(cmsRoomOrder.getOpenPeriod());
            map.put("roomTime",sbTime.toString());
            String nowDate2 = sdf.format(new Date());
            int statusDate2 = CompareTime.timeCompare2(sbTime.toString().substring(0,sbTime.toString().lastIndexOf("-")),nowDate2);
            if(cmsRoomOrder.getBookStatus() ==2 || cmsRoomOrder.getBookStatus() ==3 || cmsRoomOrder.getBookStatus()==5){
                   map.put("orderStatus",cmsRoomOrder.getBookStatus());
            }else {
                //返回 0 表示时间日期相同
                //返回 1 表示日期1>日期2
                //返回 -1 表示日期1<日期2
                if (statusDate2 == -1) {
                    map.put("orderStatus",6);
                }else {
                    map.put("orderStatus",cmsRoomOrder.getBookStatus());
                }
            }
                   map.put("tuserTeamName", cmsRoomOrder.getTuserTeamName() != null ? cmsRoomOrder.getTuserTeamName() : "");
                   map.put("roomOrderNo", cmsRoomOrder.getOrderNo() != null ? cmsRoomOrder.getOrderNo() : "");
                   map.put("venueName", cmsRoomOrder.getVenueName() != null ? cmsRoomOrder.getVenueName() : "");
                   map.put("venueAddress", cmsRoomOrder.getVenueAddress() != null ? cmsRoomOrder.getVenueAddress() : "");
                   map.put("roomName", cmsRoomOrder.getRoomName() != null ? cmsRoomOrder.getRoomName() : "");
                   map.put("roomOderId", cmsRoomOrder.getRoomOrderId() != null ? cmsRoomOrder.getRoomOrderId() : "");
                   map.put("validCode", cmsRoomOrder.getValidCode() != null ? cmsRoomOrder.getValidCode() : "");
                   map.put("orderTel", cmsRoomOrder.getUserTel() != null ? cmsRoomOrder.getUserTel() : "");
                   listMap.add(map);
                   json=JSONResponse.toAppResultFormat(0,"2",listMap);
        } else {
            json = JSONResponse.toAppResultFormat(14113, "活动室订单取票码有误");
        }
             return json;
    }

    /**
     * 验证系统验证活动室订单
     * @param roomOderId 活动室订单id
     * @param userId 后台用户id
     * @param roomTime 活动室时间
     * @return
     */
    @Override
    public String checkCmsRoomOrderByRoomOrderId(String roomOderId,String userId,String  roomTime) {
        String json="";
        int status=0;
        SimpleDateFormat sdf= new SimpleDateFormat("yyyy-MM-dd HH:mm");
        SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd");
        Date date = new Date();
        String nowDate = sdf.format(date);
        String nowDate1 = sdf1.format(date);
        int statusDate = CompareTime.timeCompare2(roomTime.substring(0,roomTime.lastIndexOf("-")), nowDate);
        String[] dateTimes = roomTime.split(" ");
        int statusDate1 = CompareTime.timeCompare1(dateTimes[0].toString(), nowDate1);
        if(statusDate==1 && statusDate1==0) {
            CmsRoomOrder cmsRoomOrder = cmsRoomOrderMapper.queryCmsRoomOrderById(roomOderId);
            if(cmsRoomOrder!=null && cmsRoomOrder.getBookStatus()==3){
                return JSONResponse.toAppResultFormat(14115, "该订单已验票，不可再验");
            }
            cmsRoomOrder.setBookStatus(Constant.BOOK_STATUS3);
            cmsRoomOrder.setSysUserId(userId);
            status = cmsRoomOrderMapper.editCmsRoomOrder(cmsRoomOrder);
            if (status > 0) {
            	
            	userIntegralDetailService.successVerificationAddIntegral(userId,roomOderId);
            	
            	CmsUserOperatorLog record=CmsUserOperatorLog.createInstance(null, roomOderId, null,userId,CmsUserOperatorLog.USER_TYPE_ADMIN, UserOperationEnum.CHECK_TICKET);
            	
            	cmsUserOperatorLogMapper.insert(record);
            	
                json = JSONResponse.toAppResultFormat(0, "该时间段活动室验票成功");
            } else {
                json = JSONResponse.toAppResultFormat(14114, "该时间段活动室验票失败");
            }
        }else {
            return JSONResponse.toAppResultFormat(14115, "对不起您的所预订的活动室已开始或该活动室不在当天开始，不可验票");
        }
            return json;
    }

    /**
     * 活动室取票流程
     * @param validateCode 取票码
     * @return
     */
    @Override
    public String takeAppRoomValidateCode(String validateCode) throws Exception {
        String json="";
        int status=0;
        Map<String,Object> param =new HashMap<String, Object>();
        if(validateCode!=null && StringUtils.isNotBlank(validateCode)){
            param.put("orderValidateCode",validateCode);
        }
        CmsRoomOrder cmsRoomOrder=cmsRoomOrderMapper.queryRoomOrderByValidateCode(param);
        if(cmsRoomOrder!=null){
            cmsRoomOrder.setBookStatus(Constant.BOOK_STATUS5);
            status = cmsRoomOrderMapper.editCmsRoomOrder(cmsRoomOrder);
            if (status > 0) {
            	
            	CmsUserOperatorLog record=CmsUserOperatorLog.createInstance(null, cmsRoomOrder.getRoomOrderId(), null,null,CmsUserOperatorLog.USER_TYPE_NORMAL, UserOperationEnum.TAKE_TICKET);
            	
            	cmsUserOperatorLogMapper.insert(record);
            	
                json=RoomSeatTemplate.toRoomSeatTemplate(cmsRoomOrder,staticServer,basePath);
            } else {
                json = JSONResponse.toAppResultFormat(14114, "该时间段活动室验票失败");
            }
        }
        return json;
    }
}
