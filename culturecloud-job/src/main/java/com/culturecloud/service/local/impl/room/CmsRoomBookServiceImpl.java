package com.culturecloud.service.local.impl.room;

import java.util.Calendar;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Transactional;

import com.culturecloud.coreutils.UUIDUtils;
import com.culturecloud.dao.dto.room.CmsActivityRoomDto;
import com.culturecloud.dao.dto.room.CmsRoomTimeDto;
import com.culturecloud.dao.room.CmsRoomBookMapper;
import com.culturecloud.dao.room.CmsRoomTimeMapper;
import com.culturecloud.model.bean.room.CmsActivityRoom;
import com.culturecloud.model.bean.room.CmsRoomBook;
import com.culturecloud.model.bean.room.CmsRoomTime;
import com.culturecloud.service.local.room.CmsRoomBookService;

@Transactional
@Service
public class CmsRoomBookServiceImpl implements CmsRoomBookService{
	
	@Autowired
	private CmsRoomBookMapper cmsRoomBookMapper;
	
	@Autowired
	private CmsRoomTimeMapper cmsRoomTimeMapper;

	  /**
     * 生成基于当前日期 七天之后新一天的活动室预定信息
     * @param roomList 要生成活动室预定信息的活动室列表
     * @return
     */
    @Override
    public int generateOneDayBookInfo(List<CmsActivityRoomDto> roomList) {
        int result = 1;
        try {
            CmsActivityRoom cmsActivityRoom = null;
            if(roomList != null && roomList.size() > 0){
                for (int i=0; i<roomList.size(); i++){
                    cmsActivityRoom = roomList.get(i);

                    Calendar calendar = Calendar.getInstance();
                    calendar.setTime(new Date());
                    calendar.add(Calendar.HOUR_OF_DAY,10*24);
                    //生成未来七天的活动室预定信息
                    generateRoomBookByDays(cmsActivityRoom, calendar.getTime(), 1);
                }
            }
        } catch (Exception e) {
            result = 0;
        }
        return result;
    }
    
    /**
     * 生成基于给定日期之后给定天数的活动室
     * @param cmsActivityRoom 活动室信息
     * @param baseDate 基于的日期
     * @param days 生成的天数
     */
    public void generateRoomBookByDays(CmsActivityRoom cmsActivityRoom, Date baseDate, int days) {
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(baseDate);
        for (int i=0; i<days; i++){
            if(i != 0){
                calendar.add(Calendar.HOUR_OF_DAY,24);
            }
            int dayOfWeek = calendar.get(Calendar.DAY_OF_WEEK);
            generate(dayOfWeek,cmsActivityRoom,calendar.getTime());
        }
    }

    /**
     * 生成单条活动室预定记录
     * @param dayOfWeek 星期几
     * @param cmsActivityRoom 活动室信息
     * @param curDate 当前日期
     */
    @Transactional(readOnly = false, isolation = Isolation.READ_COMMITTED)
    public void generate(int dayOfWeek,CmsActivityRoom cmsActivityRoom,Date curDate){
    	
            CmsRoomBook cmsRoomBook = new CmsRoomBook();
            CmsRoomBook condition = null;
            cmsRoomBook.setCurDate(curDate);
            cmsRoomBook.setCreateTime(new Date());
            cmsRoomBook.setUpdateTime(new Date());
            cmsRoomBook.setRoomId(cmsActivityRoom.getRoomId());

            Integer result = 0;
            if(dayOfWeek == 1){
                result = cmsActivityRoom.getRoomDaySunday();
                cmsRoomBook.setDayOfWeek(7);
            }else if(dayOfWeek == 2){
                result = cmsActivityRoom.getRoomDayMonday();
                cmsRoomBook.setDayOfWeek(1);
            }else if(dayOfWeek == 3){
                result = cmsActivityRoom.getRoomDayTuesday();
                cmsRoomBook.setDayOfWeek(2);
            }else if(dayOfWeek == 4){
                result = cmsActivityRoom.getRoomDayWednesday();
                cmsRoomBook.setDayOfWeek(3);
            }else if(dayOfWeek == 5){
                result = cmsActivityRoom.getRoomDayThursday();
                cmsRoomBook.setDayOfWeek(4);
            }else if(dayOfWeek == 6){
                result = cmsActivityRoom.getRoomDayFriday();
                cmsRoomBook.setDayOfWeek(5);
            }else if(dayOfWeek == 7){
                result = cmsActivityRoom.getRoomDaySaturday();
                cmsRoomBook.setDayOfWeek(6);
            }

            //获取场次信息
            CmsRoomTime cmsRoomTime = new CmsRoomTime();
            cmsRoomTime.setRoomId(cmsActivityRoom.getRoomId());
            cmsRoomTime.setRoomDay(cmsRoomBook.getDayOfWeek());
            List<CmsRoomTimeDto> roomTimeList = cmsRoomTimeMapper.queryRoomTimeByCondition(cmsRoomTime);

            //1代表选中即开放
            if(result == 1){
                for (int i=0; i<roomTimeList.size(); i++){
                    cmsRoomTime = roomTimeList.get(i);
                    cmsRoomBook.setBookId(UUIDUtils.createUUId());
                    cmsRoomBook.setOpenPeriod(cmsRoomTime.getTimePeriod());
                    cmsRoomBook.setTimeSort(cmsRoomTime.getTimeSort());
                    if(cmsRoomTime.getIsOpen() == null || cmsRoomTime.getIsOpen() !=1){
                        //不可预定 状态为3
                        cmsRoomBook.setBookStatus(3);
                    }else {
                        //可预定 状态为1
                        cmsRoomBook.setBookStatus(1);
                    }
                    //确保不插入重复数据，下面四个条件必须同时满足
                    condition = new CmsRoomBook();
                    condition.setRoomId(cmsRoomBook.getRoomId());
                    condition.setCurDate(cmsRoomBook.getCurDate());
                    condition.setOpenPeriod(cmsRoomBook.getOpenPeriod());
                    condition.setTimeSort(cmsRoomBook.getTimeSort());
                    int existCount = cmsRoomBookMapper.queryCmsRoomBookCount(condition);
                    if(existCount == 0) {
                        //添加活动室预定信息
                    	cmsRoomBookMapper.addCmsRoomBook(cmsRoomBook);
                    }
                }
            }else{
                for(int i=0; i<roomTimeList.size(); i++){
                    cmsRoomTime = roomTimeList.get(i);
                    cmsRoomBook.setBookId(UUIDUtils.createUUId());
                    cmsRoomBook.setOpenPeriod(cmsRoomTime.getTimePeriod());
                    cmsRoomBook.setTimeSort(cmsRoomTime.getTimeSort());
                    //不可预定 状态为3
                    cmsRoomBook.setBookStatus(3);
                    //确保不插入重复数据，下面四个条件必须同时满足
                    condition = new CmsRoomBook();
                    condition.setRoomId(cmsRoomBook.getRoomId());
                    condition.setCurDate(cmsRoomBook.getCurDate());
                    condition.setOpenPeriod(cmsRoomBook.getOpenPeriod());
                    condition.setTimeSort(cmsRoomBook.getTimeSort());
                    int existCount = cmsRoomBookMapper.queryCmsRoomBookCount(condition);
                    if(existCount == 0){
                        //添加活动室预定信息
                    	cmsRoomBookMapper.addCmsRoomBook(cmsRoomBook);
                    }
                }
            }
    }

}
