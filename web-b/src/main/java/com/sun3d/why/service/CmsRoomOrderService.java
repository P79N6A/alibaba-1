package com.sun3d.why.service;

import java.util.List;
import java.util.Map;

import com.sun3d.why.model.CmsRoomOrder;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.PaginationApp;

/**
 * Created by lt on 2015/7/3.
 */
public interface CmsRoomOrderService {
    /**
     * 查询前端我的场馆列表service
     * @param userId  RoomOrder
     * @param pagination
     * @param pageApp
     * @return
     */
    List<CmsRoomOrder> queryRoomOrderListService(String userId, Pagination pagination, PaginationApp pageApp);

    /**
     * 查询前端我的场馆总数service
     * @param map
     * @return
     */
    int queryRoomOrderListCountService(Map<String,Object> map);

    /**
     * 查询前端我的历史场馆列表service
     * @param userId
     * @param pagination
     * @param pageApp
     * @return
     */
    List<CmsRoomOrder> queryRoomOrderListHistoryService(String userId, Pagination pagination, PaginationApp pageApp);

    /**
     * 查询前端我的历史场馆总数service
     * @param map
     * @return
     */
    int queryRoomOrderListCountHistoryService(Map<String,Object> map);

    /**
     * 物理删除活动室预定订单
     * @param roomOrderId
     * @return
     */
    int deleteRoomOrder(String roomOrderId);

    /**
     * 添加 我的活动室订单信息
     * @param collection
     * @return
     */
    int addRoomOrder(CmsRoomOrder collection);

    /**
     * 编辑活动室订单信息
     * @param cmsCollection
     * @return
     */
    int editCmsRoomOrder(CmsRoomOrder cmsCollection);

    /**
     *   通过指定的活动室ID查询该活动室的信息
     * @param roomId
     * @return
     */
    List<CmsRoomOrder> queryAllRoomOrderList(String roomId,Pagination page,CmsRoomOrder cmsRoomOrder);

    /**
     * 带条件查询活动室总个数
     * @param map
     * @return
     */
    int queryAllRoomOrderCount(Map<String,Object> map);


    /**
     * app根据展馆id获取获取活动室信息
     * @param venueId
     * @param pageApp
     * @return
     */
    List<CmsRoomOrder> queryVenueRooms(String venueId, PaginationApp pageApp);


    /**
     * 根据活动室订单ID查询活动室订单信息
     * @param roomOrderId
     * @return
     */
    CmsRoomOrder queryCmsRoomOrderById(String roomOrderId);

    /**
     * 取消单个活动室订单
     * @param roomOrderId
     * @return
     */
    boolean cancelRoomOrder(String roomOrderId,String userName);

    /**
     * app当前展馆下预定的活动室数量
     * @param roomId
     * @return
     */
    int queryRoomOrderCount(String roomId);

    /**
     * app订单号查询活动室订单
     * @param validCode
     * @param bookStatus 活动室预定状态 1 success，2 取消,3 进场
     * @return
     */
    CmsRoomOrder queryValidateCode(String validCode, Integer bookStatus);

    /**
     * 统计各个区县活动室预定总数
     * @param map
     * @return
     */
    public List<Map> queryBookCountByArea(Map map);

    /**
     * 得到给定用户当天的预订数量
     * @param userId
     * @return
     */
    public int getRoomBookCountOneDay(String userId);

    /**
     * 根据预订ID获取已预订状态订单
     * @param bookId
     * @return
     */
    List<CmsRoomOrder> queryRoomOrderListByBookId(String bookId);
    
    /**
     * 发送短消息接口
     * @param roomOrderId
     * @return
     */
    String selectPhoneByRoomOrderId(String roomOrderId);
    
    /**
     * 3.5.3 查询待审核订单
     * 
     * @param userType
     * @param tuserIsDisplay
     * @param curDateStart
     * @param curDateEnd
     * @param orderCreateTimeStart
     * @param orderCreateTimeEnd
     * @param roomName
     * @return
     */
    List<CmsRoomOrder> queryRoomOrderCheck(SysUser user,Integer userType,Integer tuserIsDisplay,
    		String curDateStart,String curDateEnd,
    		String orderCreateTimeStart,String orderCreateTimeEnd,
    		String roomName,
    		Pagination page);
    
    /**
     * 3.5.3 查询当前订单
     * 
     * @param userType
     * @param tuserIsDisplay
     * @param curDateStart
     * @param curDateEnd
     * @param orderCreateTimeStart
     * @param orderCreateTimeEnd
     * @param roomName
     * @return
     */
    List<CmsRoomOrder> queryRoomOrder(SysUser user,Integer userType,Integer tuserIsDisplay,
    		String curDateStart,String curDateEnd,
    		String orderCreateTimeStart,String orderCreateTimeEnd,
    		String roomName,
    		Pagination page);
    
    /**
     * 3.5.3 查询当前订单
     * 
     * @param userType
     * @param tuserIsDisplay
     * @param curDateStart
     * @param curDateEnd
     * @param orderCreateTimeStart
     * @param orderCreateTimeEnd
     * @param roomName
     * @return
     */
    List<CmsRoomOrder> queryRoomOrderHistory(SysUser user,Integer bookStatus,Integer userType,Integer tuserIsDisplay,
    		String curDateStart,String curDateEnd,
    		String orderCreateTimeStart,String orderCreateTimeEnd,
    		String roomName,
    		Pagination page);
    
    
    
    /**
     * 订单审核通过 
     * @param roomOrderId
     * @return
     */
    int checkPass(String roomOrderId,SysUser sysUser);
}
