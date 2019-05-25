package com.sun3d.why.service.impl;

import com.sun3d.why.dao.CmsRoomBookMapper;
import com.sun3d.why.dao.CmsRoomTimeMapper;
import com.sun3d.why.model.CmsActivityRoom;
import com.sun3d.why.model.CmsRoomBook;
import com.sun3d.why.model.CmsRoomTime;
import com.sun3d.why.service.CmsRoomBookService;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.UUIDUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Transactional;

import java.util.Calendar;
import java.util.Date;
import java.util.List;

/**
 * Created by cj on 2015/6/25.
 */
@Service
@Transactional
public class CmsRoomBookServiceImpl implements CmsRoomBookService{

    @Autowired
    private CmsRoomBookMapper cmsRoomBookMapper;

    @Autowired
    private CmsRoomTimeMapper cmsRoomTimeMapper;

    private Logger logger = Logger.getLogger(CmsRoomBookServiceImpl.class);

    /**
     * 添加活动室预定信息
     * @param record 活动室预定信息
     * @return
     */
    @Override
    public int addCmsRoomBook(CmsRoomBook record) {

        return cmsRoomBookMapper.addCmsRoomBook(record);
    }

    /**
     * 根据活动室预定信息查询满足条件的所有活动室预定信息
     * 排序方式：活动室ID,开放时间，开放时间(周一~周日),开放时间段(场次),更新时间
     * @param cmsRoomBook 活动室预定信息
     * @return
     */
    @Override
    public List<CmsRoomBook> queryCmsRoomBookByCondition(CmsRoomBook cmsRoomBook) {

        return cmsRoomBookMapper.queryCmsRoomBookByCondition(cmsRoomBook);
    }


    /**
     * 将查询出的活动室预定数据放入Redis中
     * @param cmsRoomBook 活动室预定信息
     * @return
     */
    @Override
    public List<String> queryRoomBookDataToRedis(CmsRoomBook cmsRoomBook){

        return cmsRoomBookMapper.queryRoomBookDataToRedis(cmsRoomBook);
    }

    /**
     * 根据活动室预定信息绘制活动室详情页面Table
     * 排序方式：活动室ID,开放时间段(场次),开放日期,更新时间
     * @param cmsRoomBook
     * @return
     */
    @Override
    public List<CmsRoomBook> queryRoomBookTableByCondition(CmsRoomBook cmsRoomBook){

        return cmsRoomBookMapper.queryRoomBookTableByCondition(cmsRoomBook);
    }

    /**
     * 根据活动室预定信息查询出满足条件的活动室预定信息总记录数
     * @param cmsRoomBook 活动室预定信息
     * @return
     */
    @Override
    public int queryCmsRoomBookCountByCondition(CmsRoomBook cmsRoomBook) {

        return cmsRoomBookMapper.queryCmsRoomBookCountByCondition(cmsRoomBook);
    }

    /**
     * 根据活动室预定信息ID查询出满足条件的一条活动室预定信息
     * @param bookId 活动室预定信息ID
     * @return
     */
    @Override
    public CmsRoomBook queryCmsRoomBookById(String bookId) {

        return cmsRoomBookMapper.queryCmsRoomBookById(bookId);
    }

    /**
     * 带条件编辑活动室预定信息
     * @param record 活动室预定信息
     * @return
     */
    @Override
    public int editCmsRoomBook(CmsRoomBook record) {

        return cmsRoomBookMapper.editCmsRoomBook(record);
    }

    /**
     * 根据活动室预定信息ID删除活动室预定信息记录
     * @param bookId 活动室预定信息ID
     * @return
     */
    @Override
    public int deleteCmsRoomBookById(String bookId) {

        return cmsRoomBookMapper.deleteCmsRoomBookById(bookId);
    }

    /**
     * 根据活动室ID以及距今天的天数查询满足条件的活动室预定记录
     * @param roomId 活动室ID
     * @param days 查询的天数
     * @return
     */
    public List<CmsRoomBook> queryCmsRoomBookByDays(String roomId,int days){

        CmsRoomBook cmsRoomBook = new CmsRoomBook();
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(new Date());
        cmsRoomBook.setCurDateBegin(calendar.getTime());
        calendar.add(Calendar.HOUR_OF_DAY,24*days);
        cmsRoomBook.setRoomId(roomId);
        cmsRoomBook.setCurDate(calendar.getTime());
        cmsRoomBook.setCurDateOperator(2);
        cmsRoomBook.setRows(queryCmsRoomBookCountByCondition(cmsRoomBook));
        List<CmsRoomBook> roomBookList = queryCmsRoomBookByCondition(cmsRoomBook);
        return roomBookList;
    }

    /**
     * 根据预订信息以及距今天的天数查询满足条件的活动室预订记录
     * 只为活动室预订数据列表服务[活动室预订Controller——列表查询]
     * @param record 活动室预订信息
     * @param days 查询的天数
     * @return
     */
    @Override
    public List<CmsRoomBook> queryCmsRoomBookListByDays(CmsRoomBook record,int days,Pagination page){

        CmsRoomBook cmsRoomBook = new CmsRoomBook();
        if(record.getCurDate() != null){
            cmsRoomBook.setRoomId(record.getRoomId());
            cmsRoomBook.setCurDate(record.getCurDate());
        }else{
            Calendar calendar = Calendar.getInstance();
            calendar.setTime(new Date());
            calendar.add(Calendar.HOUR_OF_DAY,24*5);
            cmsRoomBook.setCurDateBegin(calendar.getTime());
            calendar.add(Calendar.HOUR_OF_DAY,24*days);            
            cmsRoomBook.setRoomId(record.getRoomId());
            cmsRoomBook.setCurDate(calendar.getTime());
            cmsRoomBook.setCurDateOperator(2);
        }

        cmsRoomBook.setPage(page.getPage());
        cmsRoomBook.setRows(page.getRows());
        int total = queryCmsRoomBookCountByCondition(cmsRoomBook);
        cmsRoomBook.setTotal(total);
        page.setTotal(total);
        List<CmsRoomBook> roomBookList = queryCmsRoomBookByCondition(cmsRoomBook);
        return roomBookList;
    }

    /**
     * 根据活动室ID以及距今天的天数查询满足条件的活动室预定记录
     * @param roomId 活动室ID
     * @param days 查询的天数
     * @return
     */
    public List<String> queryRoomBookDataToRedis(String roomId,int days){

        CmsRoomBook cmsRoomBook = new CmsRoomBook();
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(new Date());
        cmsRoomBook.setCurDateBegin(calendar.getTime());
        calendar.add(Calendar.HOUR_OF_DAY,24*days);
        cmsRoomBook.setRoomId(roomId);
        cmsRoomBook.setCurDate(calendar.getTime());
        cmsRoomBook.setCurDateOperator(2);
        cmsRoomBook.setRows(queryCmsRoomBookCountByCondition(cmsRoomBook));
        List<String> roomBookList = queryRoomBookDataToRedis(cmsRoomBook);
        return roomBookList;
    }

    /**
     * 根据活动室ID以及距今天的天数查询满足条件的活动室预定记录
     * 此方法只为画出活动室详情页面Table
     * @param roomId
     * @param days
     * @return
     */
    public List<CmsRoomBook> queryRoomBookTableByDays(String roomId,int days){
        CmsRoomBook cmsRoomBook = new CmsRoomBook();
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(new Date());
        cmsRoomBook.setCurDateBegin(calendar.getTime());
        calendar.add(Calendar.HOUR_OF_DAY,24*days);
        cmsRoomBook.setRoomId(roomId);
        cmsRoomBook.setCurDate(calendar.getTime());
        cmsRoomBook.setCurDateOperator(2);
        cmsRoomBook.setRows(queryCmsRoomBookCountByCondition(cmsRoomBook));
        List<CmsRoomBook> roomBookList = cmsRoomBookMapper.queryRoomBookTableByCondition(cmsRoomBook);
        return roomBookList;
    }

    /**
     * 根据活动室ID以及要查询的日期，查询出某一天的活动室预定信息
     * @param roomId 活动室ID
     * @param curDate 查询的日期
     * @return
     */
    public List<CmsRoomBook> queryCmsRoomBookByDate(String roomId,Date curDate){

        CmsRoomBook cmsRoomBook = new CmsRoomBook();
        cmsRoomBook.setRoomId(roomId);
        cmsRoomBook.setCurDate(curDate);
        cmsRoomBook.setBookStatus(1);
        cmsRoomBook.setRows(queryCmsRoomBookCountByCondition(cmsRoomBook));
        List<CmsRoomBook> roomBookList = queryCmsRoomBookByCondition(cmsRoomBook);
        return roomBookList;
    }


    /**
     * 系统初始化时，默认生成活动室未来<strong>七天</strong>的预定信息
     * @param roomList 要生成活动室预定信息的活动室列表
     * @return
     */
    @Override
    public int initRoomBookInfo(List<CmsActivityRoom> roomList) {
        int result = 1;
        try {
            CmsActivityRoom cmsActivityRoom = null;
            if(roomList != null && roomList.size() > 0){
                Date baseDate = new Date();
                Calendar calendar = Calendar.getInstance();
                calendar.setTime(baseDate);
                calendar.add(Calendar.HOUR_OF_DAY,24*3);
                for (int i=0; i<roomList.size(); i++){
                    cmsActivityRoom = roomList.get(i);
                    //生成未来七天的活动室预定信息
                    generateRoomBookByDays(cmsActivityRoom, calendar.getTime(), 7);
                }
            }
        } catch (Exception e) {
            result = 0;
        }
        return result;
    }

    /**
     * 生成基于当前日期 七天之后新一天的活动室预定信息
     * @param roomList 要生成活动室预定信息的活动室列表
     * @return
     */
    @Override
    public int generateOneDayBookInfo(List<CmsActivityRoom> roomList) {
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

    @Override
    public List<CmsRoomBook> queryAppRoomBookTableByDays(String roomId, int days) {
        CmsRoomBook cmsRoomBook = new CmsRoomBook();
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(new Date());
        calendar.add(Calendar.HOUR_OF_DAY,24*days);
        cmsRoomBook.setCurDateBegin(calendar.getTime());
       
        cmsRoomBook.setRoomId(roomId);
        cmsRoomBook.setCurDate(calendar.getTime());
        cmsRoomBook.setCurDateOperator(2);
        List<CmsRoomBook> roomBookList = cmsRoomBookMapper.queryAppRoomBookTableByCondition(cmsRoomBook);
        return roomBookList;
    }

    /**
     * 生成基于给定日期之后给定天数的活动室
     * @param cmsActivityRoom 活动室信息
     * @param baseDate 基于的日期
     * @param days 生成的天数
     */
    @Override
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
        try {
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
            List<CmsRoomTime> roomTimeList = cmsRoomTimeMapper.queryRoomTimeByCondition(cmsRoomTime);

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
                        addCmsRoomBook(cmsRoomBook);
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
                        addCmsRoomBook(cmsRoomBook);
                    }
                }
            }
        } catch (Exception e) {
            logger.error("生成预定数据出错!",e);
        }
    }
}
