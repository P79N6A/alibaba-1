package com.sun3d.why.service;

import com.sun3d.why.model.*;
import com.sun3d.why.model.extmodel.BookActivitySeatInfo;

import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

public interface CacheService {



    /**
     * 根据活动id  和场次信息得到活动座位信息
     * @return
     */
    public List<CmsActivitySeat> getSeatInfoByIdAndTime(String activityId, String eventTime);

    /**
     * 根据活动id 得到 座位信息的map
     *
     * @param activityId
     * @return
     */
  //  public Map getSeatEventMapById(String activityId);



  //  public void deleteSetComment(String key,String value);

//    /**
//     * 设置内存中座位的默认值
//     */
//    public String setSeatNum(String key,List<CmsActivitySeat> list,Date endDate);

  //  public String setActivitySeat(String key,List<CmsActivitySeat> list,Date endDate,CmsActivity cmsActivity,List<String> eventTimes);




    /**
     * 根据活动id 和 活动场次时间查询剩余可预定的余票
     *
     */
    public Integer getSeatCountByActivityIdAndTime(String activityId,String eventDateTime);

    /**
     * 设置内存中座位数量的默认值
     * eventInfo 场次信息
     */
    public String  setSeatCount(String activityId,String value,Date endDate,List<String> eventInfo) throws Exception;


    /**
     * 根据活动id和时间场次 修改剩余票数
     * @param activityId
     * @param eventDateTime
     * @param value
     * @return
     */
    public String updateSeatCountByIdAndTime(String activityId,Date endDate,String eventDateTime,String value);

    /**
     * 取消订单
     * @param activityId
     * @param seatInfos
     * @return
     */
//    public String cancelOrder(String activityId,CmsActivityOrder cmsActivityOrder,CmsActivityEvent cmsActivityEvent,String seatInfos,Integer backCount,Date endDate,String type);



  //  public String addActivityTicketCount(String activityId,Integer backCount,Date endDate,String eventDateTime);

//    public String setSeatNumByMap(String key,List<Map> list);

    public void saveActivityRoomToQueues(String key, String value);


    /**
     *
     *
     * @param key
     * @return
     */
    public String getValueByKey(String key);

/*    *//**
     * 跟key键修改 座位的状态
     *
     * @param key
     * @param value
     * @return
     *//*
    public String updateValueByKey(String key, String value);*/


    public String setResultValue(String key, String value);

    public String deleteValueByKey(String key);

    //根据活动id 减去座位的数
   // public String subtractTicketCountById(String activityId ,String eventDateTime, Integer bookCount);

    /**
     * 生成订单号
     * @return 订单号
     */
    public String genOrderNumber();


    /**
     * 生成用户名编号
     * @return 户名编号
     */
    public String genUserNumber();

    //预定活动时 判断活动id 所选在座位是否可以使用
    public String checkActivitySeatStatus(BookActivitySeatInfo seatInfo,String[] seatIds,Integer bookCount,String userId);

    //判断所选座位能否被取消预定
    public String checkSeatStatusByCancel(BookActivitySeatInfo seatInfo, String[] seatIds, Integer bookCount, String userId);

    //更新座位状态
   // public String updateSeatStatus(BookActivitySeatInfo activitySeatInfo);


    /**
     * 将活动室要预定的场次信息放入Redis内存中
     * @param key
     * @param list
     */
    //public void setRoomBookNum(String key,List<CmsRoomBook> list,Date expireDate);

    /**
     * 判断某个活动室特定的场次是否已经被预定
     * @param roomId
     * @param bookId
     * @return
     */
    //public String checkRoomBookStatus(String roomId,String bookId);

    /**
     * 更新已预定活动室场次的状态
     * @param cmsRoomBook
     * @return
     */
    //public String updateRoomBookStatus(CmsRoomBook cmsRoomBook);

    /**
     * 取消活动室预定
     * @param cmsRoomBook
     * @return
     */
   // public String cancelRoomBook(CmsRoomBook cmsRoomBook);

    //保存队列的值至 队列
    public String saveQueueName(String key, String value);


    //查询队列的值
    public Iterator queryQueueName(String key);

    //发布活动的时候保存活动座位信息到 内存中
   // public Integer addActivitySeatInfo(String activityId);


    /**
     * 预定场馆活动室--第二种处理方式
     * @param roomId
     * @param bookId
     * @return
     */
    public String bookVenueRoom(String roomId,String bookId);

    /**
     * 将活动室要预定的场次信息放入Redis内存中
     * @param key
     * @param list
     */
    public void setRoomBookList(String key,List<String> list,Date expireDate);


    public void setAdvertList(String key,List<CmsAdvert> list,Date expireDate);

    public List<CmsAdvert> getAdvert(String siteId);


    public void setTagList(String key,List<CmsTag> list,Date expireDate);

    public List<CmsTag> getTagList(String tagType);

    /**
     * 首页热点推荐
     * @return
     */
    public List<CmsActivity> queryActivityList(String activityListKey);

    /**
     * 将首页热点推荐放至内存中
     * @param
     * @param cmsActivities
     */
    public String setActivityList(String activityListKey,List<CmsActivity> cmsActivities);

    public List<CmsActivity> getLikeActivityList(String code);
    
    public void setLikeActivityList(String activityListKey,List<CmsActivity> dataList,Date expireDate);



    /**
     * 根绝Redis中的KEY值更新场馆首页列表
     * @param venueIndexKey
     * @return
     */
    public boolean updateVenueIndex(String venueIndexKey,List<CmsVenue> venueList);

    /**
     * 根据Redis中的KEY值获取场馆首页列表
     * @param venueIndexKey
     * @return
     */
    public List<CmsVenue> getVenueIndexList(String venueIndexKey);

    /**
     * 存储首页场馆总数
     * @param venueIndexTotalKey
     * @param total
     * @return
     */
    public boolean setVenueIndexTotal(String venueIndexTotalKey,Integer total);

    /**
     * 获取首页场馆总数
     * @param venueIndexTotalKey
     * @return
     */
    public Integer getVenueIndexTotal(String venueIndexTotalKey);


    /**
     * 保存订票请求是否超时
     * @param sId
     * @return
     */
    public String saveBookActivitySid(String sId);

    /**
     * 添加新的bookId至Redis或删除Redis中指定的bookId
     * @param roomId 活动室ID
     * @param bookId 预订ID
     * @param addFlag 添加标记
     * @return
     */
    public String changeBookIdInRedis(String roomId, String bookId,boolean addFlag);

    /**
     * 往内存中添加数据
     * @return
     */
    public String setValueToRedis(byte[] bytesKey, byte[] valueKey, Date endDate );



    /**
     * 往内存中添加数据
     * @return
     */
    public String setValueToRedis(String key, String value , Date endDate );



   // public List<Map<String,Object>> getSendSmsInfo (String dataKey);

    public void setLoginErr(String key, String value);

    //public boolean isExistKey(String dataKey);
    /**
     * 根据传来的id和过期时间，将List存到Redis中
     * @return
     */
    public void saveList(String Key,List dataList,Date expireDate);

    /**
     * 根据传来saveId查询List
     * @return
     */
    public List getList(String saveId);
    /**
     * 将常用资讯存到redis
     *
     * @param key
     * @param information
     * @param endDate
     * @return
     */
    public void addInfo(String key, ManagementInformation information, Date endDate);

    public ManagementInformation getInfo(String informationId);

    public boolean isExistKey(String s);
}
