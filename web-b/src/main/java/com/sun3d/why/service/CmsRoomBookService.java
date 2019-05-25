package com.sun3d.why.service;

import com.sun3d.why.model.CmsActivityRoom;
import com.sun3d.why.model.CmsRoomBook;
import com.sun3d.why.util.Pagination;

import java.util.Date;
import java.util.List;

public interface CmsRoomBookService {

    /**
     * 添加活动室预定信息
     * @param record 活动室预定信息
     * @return
     */
    int addCmsRoomBook(CmsRoomBook record);

    /**
     * 根据活动室预定信息查询满足条件的所有活动室预定信息
     * 排序方式：活动室ID,开放时间，开放时间(周一~周日),开放时间段(场次),更新时间
     * @param cmsRoomBook 活动室预定信息
     * @return
     */
    List<CmsRoomBook> queryCmsRoomBookByCondition(CmsRoomBook cmsRoomBook);


    /**
     * 将查询出的活动室预定数据放入Redis中
     * @param cmsRoomBook
     * @return
     */
    List<String> queryRoomBookDataToRedis(CmsRoomBook cmsRoomBook);

    /**
     * 根据活动室预定信息绘制活动室详情页面Table
     * 排序方式：活动室ID,开放时间段(场次),开放日期,更新时间
     * @param cmsRoomBook
     * @return
     */
    List<CmsRoomBook> queryRoomBookTableByCondition(CmsRoomBook cmsRoomBook);

    /**
     * 根据活动室预定信息查询出满足条件的活动室预定信息总记录数
     * @param cmsRoomBook 活动室预定信息
     * @return
     */
    int queryCmsRoomBookCountByCondition(CmsRoomBook cmsRoomBook);

    /**
     * 根据活动室预定信息ID查询出满足条件的一条活动室预定信息
     * @param bookId 活动室预定信息ID
     * @return
     */
    CmsRoomBook queryCmsRoomBookById(String bookId);

    /**
     * 带条件编辑活动室预定信息
     * @param record 活动室预定信息
     * @return
     */
    int editCmsRoomBook(CmsRoomBook record);

    /**
     * 根据活动室预定信息ID删除活动室预定信息记录
     * @param bookId 活动室预定信息ID
     * @return
     */
    int deleteCmsRoomBookById(String bookId);

    /**
     * 根据活动室ID以及距今天的天数查询满足条件的活动室预定记录
     * @param roomId 活动室ID
     * @param days 查询的天数
     * @return
     */
    List<CmsRoomBook> queryCmsRoomBookByDays(String roomId,int days);

    /**
     * 根据预订信息以及距今天的天数查询满足条件的活动室预订记录
     * @param record 活动室预订信息
     * @param days 查询的天数
     * @return
     */
    List<CmsRoomBook> queryCmsRoomBookListByDays(CmsRoomBook record,int days,Pagination page);

    /**
     * 根据活动室ID以及距今天的天数查询满足条件的活动室预定记录
     * @param roomId 活动室ID
     * @param days 查询的天数
     * @return
     */
    public List<String> queryRoomBookDataToRedis(String roomId,int days);

    /**
     * 此方法只为画出活动室详情页面Table
     * @param roomId
     * @param days
     * @return
     */
    List<CmsRoomBook> queryRoomBookTableByDays(String roomId,int days);

    /**
     *
     * @param roomId
     * @param curDate
     * @return
     */
    List<CmsRoomBook> queryCmsRoomBookByDate(String roomId,Date curDate);

    /**
     * 生成基于给定日期之后给定天数的活动室
     * @param cmsActivityRoom
     * @param baseDate
     * @param days
     */
    void generateRoomBookByDays(CmsActivityRoom cmsActivityRoom,Date baseDate,int days);

    /**
     * 系统初始化时，默认生成活动室未来七天的预定信息
     * @return
     */
    int initRoomBookInfo(List<CmsActivityRoom> roomList);

    /**
     * 生成七天后新一天的活动室预定信息
     * @return
     */
    int generateOneDayBookInfo(List<CmsActivityRoom> roomList);

    /**
     * app获取活动室开放时间
     * @param roomId
     * @param day
     * @return
     */
    List<CmsRoomBook> queryAppRoomBookTableByDays(String roomId, int day);
}