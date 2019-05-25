package com.sun3d.why.service.impl;

import com.sun3d.why.dao.CmsActivitySeatMapper;
import com.sun3d.why.model.*;
import com.sun3d.why.service.CacheService;
import com.sun3d.why.service.CmsActivitySeatService;
import com.sun3d.why.util.UUIDUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;

@Service
@Transactional
public class CmsActivitySeatServiceImpl implements CmsActivitySeatService{

    @Autowired
    private CmsActivitySeatMapper cmsActivitySeatMapper;

    @Autowired
    private CacheService cacheService;

    @Override
    public int addActivitySeat(CmsActivitySeat record){
        return cmsActivitySeatMapper.addActivitySeat(record);
    }

    @Override
    public int editByActivitySeat(CmsActivitySeat record) {
        return cmsActivitySeatMapper.editByActivitySeat(record);
    }

    @Override
    public int deleteByActivityId(String activityId) {
        return cmsActivitySeatMapper.deleteByActivityId(activityId);
    }

    @Override
    public int deleteByEventId(String eventId) {
        return cmsActivitySeatMapper.deleteByEventId(eventId);
    }
    @Override
    public List<CmsActivitySeat> queryCmsActivitySeatCondition(Map map) {
        return cmsActivitySeatMapper.queryCmsActivitySeatCondition(map);
    }
    @Override
    public  Map<String,CmsActivitySeat> getCmsActivitySeatInfo(String activityId,String [] seatIds) {
        Map map = new HashMap();
        List seatRowList = new ArrayList();
        List seatColumnList = new ArrayList();
        for (String seatId : seatIds) {
           String [] seatInfo =  seatId.split("_");
            seatRowList.add(seatInfo[0]);
            seatColumnList.add(seatInfo[1]);
        }
        map.put("activityId",activityId);
        map.put("seatRow",seatRowList);
        map.put("seatColumn", seatColumnList);
//        List<CmsActivitySeat> list = cmsActivitySeatMapper.queryCmsActivitySeatCondition(map);
        Map rsMap = new HashMap();
//        for (CmsActivitySeat activitySeat : list) {
//            rsMap.put(activitySeat.getActivitySeatId(), activitySeat);
//        }
        return rsMap;
    }

    public int addActivityTicketCount(String activityId,Integer totalTicket,Date endDate,String eventDateTime) throws Exception {
        Map<String,String> map = new HashMap();
        cacheService.updateSeatCountByIdAndTime(activityId, endDate, eventDateTime, totalTicket.toString());
        return 1;
    }

    /**
     * 后台发布活动保存座位信息
     * @param activityId
     * @param seatIds
     * @param totalTicket
     * @param loginUser
     * @param endTime
     * @param cmsActivity
     * @param eventInfo
     * @return
     * @throws Exception
     */
    public int addActivitySeatInfo(String activityId,String seatIds,Integer totalTicket,SysUser loginUser,Date endTime,CmsActivity cmsActivity,List<String> eventInfo) throws Exception {
        if (seatIds != null &&  StringUtils.isNotBlank(seatIds)) {
            Map<String,Integer> map = new HashMap();
            //得到场馆座位信息表
            String[] info = seatIds.split(",");
            List<CmsActivitySeat> list = new ArrayList<CmsActivitySeat>();
            for(String seat :info) {
                String [] seats = seat.split("-");
                Integer seatStatus = 3;

                if ("A".equals(seats[0])) {
                    seatStatus = 1;
                } else if ("U".equals(seats[0])) {
                    seatStatus = 2;
                } else if ("D".equals(seats[0])) {
                    seatStatus = 3;
                }
                String[] row_column = seats[1].split("_");
                Integer seatRow = Integer.valueOf(row_column[0]);
                Integer seatColumn = Integer.valueOf(row_column[1]);
                String seatVal = seatRow + "_" + seats[2];
                CmsActivitySeat cmsActivitySeat = new CmsActivitySeat();
                cmsActivitySeat.setActivitySeatId(UUIDUtils.createUUId());
                cmsActivitySeat.setActivityId(activityId);
                cmsActivitySeat.setTotalTicket(totalTicket);
                cmsActivitySeat.setSeatArea("ALL");
                cmsActivitySeat.setSeatCreateTime(new Date());
                cmsActivitySeat.setSeatUpdateTime(new Date());
                cmsActivitySeat.setSeatCreateUser(loginUser.getUserId());
                cmsActivitySeat.setSeatUpdateUser(loginUser.getUserId());
                cmsActivitySeat.setSeatRow(seatRow);
                cmsActivitySeat.setSeatCode(seatRow.toString() + "_" + seatColumn.toString());
                cmsActivitySeat.setSeatColumn(seatColumn);
                cmsActivitySeat.setSeatStatus(seatStatus);
                cmsActivitySeat.setSeatIsSold(1);
                cmsActivitySeat.setSeatVal(seatVal);
                if(cmsActivitySeat.getSeatStatus() != 1) {
                    cmsActivitySeat.setSeatIsSold(2);
                }
                addActivitySeat(cmsActivitySeat);
                list.add(cmsActivitySeat);
            }
            //将座位信息保存至内存中
            cacheService.setActivitySeat(activityId, list,endTime,cmsActivity,eventInfo);
            cacheService.setSeatCount(activityId,totalTicket.toString(),endTime,eventInfo);
        } else {
            //将座位信息保存至内存中
            //自由入座情况 只将座位数量保存到内存中
            cacheService.setSeatCount(activityId,totalTicket.toString(),endTime,eventInfo);
        }
        // value的值为 activityId + "_" + 状态值  Y 代表已经被监听  N代表未被监听
        cacheService.saveQueueName("activityQueues",activityId + "_" + "N");
        return 1;
    }
    /**
     * 后台发布活动保存座位信息
     * @param event
     * @param
     * @return
     * @throws Exception
     */
    public int addEventSeatInfo( CmsActivityEvent event,SysUser loginUser) throws Exception {
            String[] setaIds=event.getSeatIds().split(",");
        List<CmsActivitySeat> seatList=new ArrayList<>();
            for(String seat :setaIds) {
                String [] seats = seat.split("-");
                Integer seatStatus = 3;

                if ("A".equals(seats[0])) {
                    seatStatus = 1;
                } else if ("U".equals(seats[0])) {
                    seatStatus = 2;
                } else if ("D".equals(seats[0])) {
                    seatStatus = 3;
                }
                String[] row_column = seats[1].split("_");
                Integer seatRow = Integer.valueOf(row_column[0]);
                Integer seatColumn = Integer.valueOf(row_column[1]);
                String seatVal = seatRow + "_" + seats[2];
                CmsActivitySeat cmsActivitySeat = new CmsActivitySeat();
                cmsActivitySeat.setActivitySeatId(UUIDUtils.createUUId());
                cmsActivitySeat.setActivityId(event.getActivityId());
                cmsActivitySeat.setEventId(event.getEventId());
//                cmsActivitySeat.setTotalTicket(event.);
                cmsActivitySeat.setSeatArea("ALL");
                cmsActivitySeat.setSeatCreateTime(new Date());
                cmsActivitySeat.setSeatUpdateTime(new Date());
                cmsActivitySeat.setSeatCreateUser(loginUser.getUserId());
                cmsActivitySeat.setSeatUpdateUser(loginUser.getUserId());
                cmsActivitySeat.setSeatRow(seatRow);
                cmsActivitySeat.setSeatCode(seatRow.toString() + "_" + seatColumn.toString());
                cmsActivitySeat.setSeatColumn(seatColumn);
                cmsActivitySeat.setSeatStatus(seatStatus);
                cmsActivitySeat.setSeatIsSold(1);
                cmsActivitySeat.setSeatVal(seatVal);
                if(cmsActivitySeat.getSeatStatus() != 1) {
                    cmsActivitySeat.setSeatIsSold(2);
                }
                seatList.add(cmsActivitySeat);
            }
        int result=cmsActivitySeatMapper.addActivitySeatList(seatList);
        return  result;
    }

    /**
     * 前台用户发布可预定活动
     * @param activityId
     * @param totalTicket
     * @param endTime
     * @param cmsActivity
     * @param eventInfo
     * @return
     * @throws Exception
     */
    public int addActivitySeatInfoByFrontUser(String activityId, Integer totalTicket,Date endTime,CmsActivity cmsActivity,List<String> eventInfo) throws Exception {
        //自由入座情况 只将座位数量保存到内存中
        cacheService.setSeatCount(activityId,totalTicket.toString(),endTime,eventInfo);
        // value的值为 activityId + "_" + 状态值  Y 代表已经被监听  N代表未被监听
        cacheService.saveQueueName("activityQueues",activityId + "_" + "N");
        return 1;
    }

    public int queryCountByActivityId(String activityId) {
        return cmsActivitySeatMapper.queryCountByActivityId(activityId);
    }

    /**
     * 根据活动id  和 seatCode  查询seatVal;
     * @param map
     * @return
     */
    public CmsActivitySeat querySeatValByMap(Map map) {
        return cmsActivitySeatMapper.querySeatValByMap(map);
    }
}