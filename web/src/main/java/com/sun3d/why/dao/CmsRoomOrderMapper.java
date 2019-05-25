package com.sun3d.why.dao;

import com.sun3d.why.model.CmsRoomOrder;

import java.util.List;
import java.util.Map;

/**
 * 前端我的收藏mapper
 */
public interface CmsRoomOrderMapper {

    int deleteByPrimaryKey(String orderCollectionId);

    /**
     * 生成我的场馆
     * @param record
     * @return
     */
    int insert(CmsRoomOrder record);

    int insertSelective(CmsRoomOrder record);

    CmsRoomOrder selectByPrimaryKey(String orderCollectionId);

    int updateByPrimaryKeySelective(CmsRoomOrder record);
    
    /**
     * 根据预订ID获取所有活动室已预订状态订单
     * @param bookId
     * @return
     */
    List<CmsRoomOrder> queryRoomOrderListByRoomId(String roomId);

    /**
     * 编辑活动室订单信息
     * @param record
     * @return
     */
    int editCmsRoomOrder(CmsRoomOrder record);

    /**
     * 查询我的场馆列表
     * @param map
     * @return
     */
    List<CmsRoomOrder> queryRoomOrderList(Map<String , Object> map);

    /**
     * 查询我我的场馆总数
     * @param map
     * @return
     */
    int queryRoomOrderListCount(Map<String , Object> map);

    /**
     * 查询我的场馆列表
     * @param map
     * @return
     */
    List<CmsRoomOrder> queryRoomOrderHistoryList(Map<String , Object> map);

    /**
     * 查询我我的场馆总数
     * @param map
     * @return
     */
    int queryRoomOrderListHistoryCount(Map<String , Object> map);

    /**
     * 物理删除活动室预定订单
     * @param roomOrderId
     * @return
     */
    int deleteRoomOrder (String roomOrderId);

    /**
     *
     * @param cmsCollection
     * @return
     */
    int addRoomOrder(CmsRoomOrder cmsCollection);

    /**
     * 带条件分页查询活动室列表
     * @param map
     * @return
     */
    List<CmsRoomOrder> queryAllRoomOrderList(Map<String , Object> map);

    /**
     * 带条件查询活动室总个数
     * @param map
     * @return
     */
    int queryAllRoomOrderCount(Map<String,Object> map);


    /**
     * app根据展馆id获取活动室信息
     * @param map
     * @return
     */
    List<CmsRoomOrder> queryVenueRooms(Map<String, Object> map);


    /**
     * 根据活动室订单ID查询活动室订单信息
     * @param roomOrderId
     * @return
     */
    CmsRoomOrder queryCmsRoomOrderById(String roomOrderId);

    /**
     * app当前预定的活动室数量
     * @param roomId
     * @return
     */
    int queryRoomOrderCount(String roomId);

    /**
     * 根据订单ID查询短信发送内容
     * @param roomOrderId
     * @return
     */
    CmsRoomOrder querySendMsg(String roomOrderId);

    /**
     * app根据订单号查询活动室订单信息
     * @param map
     * @return
     */
    CmsRoomOrder queryValidateCode(Map<String, Object> map);


    /**
     * 统计各个区县活动室预定总数
     * @param map
     * @return
     */
    public List<Map> queryBookCountByArea(Map map);

    /**
     * app根据用户id获取我的当前活动室订单
     * @param map
     * @return
     */
    public  List<CmsRoomOrder> queryCurrentRoomOrderListById(Map<String, Object> map);

    /**
     * app根据用户id获取我的过去活动室订单
     * @param map
     * @return
     */
    List<CmsRoomOrder> queryPastRoomOrderListById(Map<String, Object> map);

    /**
     * app删除以往活动室订单
     * @param roomOrderId 活动室订单id
     * @param userId 用户id
     * @return
     */
   public int deleteRoomOrderById(String roomOrderId, String userId);

    /**
     * 得到给定用户当天的预订数量
     * @param userId
     * @return
     */
    public int getRoomBookCountOneDay(String userId);

    /**
     * app取票机活动室取票
     * @param orderValidateCode 取票码
     * @return
     */
   public CmsRoomOrder queryRoomValidateCode(String orderValidateCode);

    /**
     * 根据预订ID获取所有活动室已预订状态订单
     * @param bookId
     * @return
     */
    List<CmsRoomOrder> queryRoomOrderListByBookId(String bookId);

    /**
     * 验证系统验证活动室订单信息
     * @param map
     * @return
     */
   public CmsRoomOrder queryRoomOrderByValidateCode(Map<String, Object> map);

    /**
     * app获取用户活动室订单信息（当前与历史）
     * @param map
     * @return
     */
    public List<CmsRoomOrder> queryRoomOrderListById(Map<String, Object> map);
    
    /**
     * why3.5 app显示或搜索用户活动室订单信息（当前未过期订单）
     * @param map
     * @return
     */
    List<CmsRoomOrder> queryAppRoomOrderByUserId(Map<String, Object> map);
    
    int queryAppRoomOrderByUserIdCount(Map<String, Object> map);

    /**
     * why3.5 app显示或搜索用户活动室历史订单信息（过期订单，即历史订单）
     * @param map
     * @return
     */
    List<CmsRoomOrder> queryAppRoomHistoryOrderByUserId(Map<String, Object> map);
    
    int queryAppRoomHistoryOrderByUserIdCount(Map<String, Object> map);
    
    /**
     *  why3.5.2 app显示或搜索用户活动室待审核din
     * 
     * @param map
     * @return
     */
    List<CmsRoomOrder> queryAppUserCheckOrderByUserId(Map<String, Object> map);
    
    int queryAppUserCheckOrderByUserIdCount(Map<String, Object> map);
    
    /**
     * why 3.5.2查询用户是否有某活动室的预定订单
     * 
     * @param map
     */
    List<CmsRoomOrder> queryRoomBookOrder(Map<String, Object> map);
    
  
}