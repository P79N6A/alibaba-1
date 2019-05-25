package com.sun3d.why.service;

import com.sun3d.why.model.*;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.PaginationApp;

import java.util.List;
import java.util.Map;

/**
 * <p>
 * 活动室管理服务层service接口
 * </p>
 * Created by cj on 2015/4/30.
 */
public interface CmsActivityRoomService {

    /**
     * 根据活动室主键id获取活动室信息
     *
     * @param roomId String 活动室主键id
     * @return CmsActivityRoom 活动室模型
     */
    CmsActivityRoom queryCmsActivityRoomById(String roomId);

    /**
     * 新增一条完整的活动室信息，模型信息固定所有属性
     *
     * @param record CmsActivityRoom 活动室模型
     * @param sysUser SysUser 用户信息
     * @param allRoomDayStr 星期以及日期组成的字符串(按格式 *号分割星期 ,号分割时间段)
     * @return int 成功返回1
     */
    int addCmsActivityRoom(final CmsActivityRoom record,final SysUser sysUser,final String allRoomDayStr);

    /**
     * 根据活动室主键id来修改活动室模型中不为空的信息，推荐使用
     *
     * @param record CmsActivityRoom 活动室信息
     * @param sysUser SysUser 用户信息
     * @param allRoomDayStr 星期以及日期组成的字符串(按格式 *号分割星期 ,号分割时间段)
     * @return int 成功返回1
     */
    int editCmsActivityRoom(final CmsActivityRoom record,final SysUser sysUser,final String allRoomDayStr,final String sysNo);

    int editCmsActivityRoom( CmsActivityRoom record);
    
    /**
     * 根据活动室主键id来修改活动室模型中不为空的信息，推荐使用
     *
     * @param record CmsActivityRoom 活动室信息
     * @param sysUser SysUser 用户信息
     * @return int 成功返回1
     */
    int deleteCmsActivityRoom(CmsActivityRoom record,SysUser sysUser);

    /**
     * 带条件请求活动室列表
     * @param record 活动室信息
     * @param cmsVenue  场馆信息
     * @param page  分页信息
     * @param sysUser 用户信息
     * @return
     */
    List<CmsActivityRoom> queryCmsActivityRoomByCondition(CmsActivityRoom record,CmsVenue cmsVenue,Pagination page,SysUser sysUser);

    /**
     * 带条件请求活动室列表个数
     * @param map
     * @return
     */
    int queryCmsActivityRoomCountByCondition(Map<String,Object> map);

    /**
     * 根据活动室查询条件查询符合条件的活动室列表
     * @param record
     * @return
     */
    List<CmsActivityRoom> queryByCmsActivityRoom(CmsActivityRoom record);

    /**
     * 根据活动室查询条件查询符合条件的活动室个数
     * @param record
     * @return
     */
    int queryCountByCmsActivityRoom(CmsActivityRoom record);


    /**
     * app根据展馆id获取活动室列表
     * @param cmsActivityRoom 活动室对象
     * @param pageApp  分页对象
     * @return
     */
    List<CmsActivityRoom> queryByAppActivityRoom(CmsActivityRoom cmsActivityRoom, PaginationApp pageApp);


    

 
    /**
     * 初始化某个特定活动室七天的预定信息
     * @param cmsActivityRoom
     * @return
     */
    int generateOneRoomBook(CmsActivityRoom cmsActivityRoom);

    /**
     * 讲某个活动室的数据生成后放入Redis中
     * @return
     */
    int setRoomBookToRedis(CmsActivityRoom cmsActivityRoom);


    /**
     * 带条件查询符合的统计数据[平台内容统计--活动室统计]
     * @param cmsActivityRoom
     * @return
     */
    List<CmsActivityRoom> queryRoomStatistic(CmsActivityRoom cmsActivityRoom);

    /**
     * 发布活动室
     * @param roomId
     * @return
     */
    int publishActivityRoom(String roomId);

    /**
     * 还原活动室
     * @param roomId
     * @return
     */
    int backActivityRoom(String roomId);
    
    /**
     * 彻底删除活动室
     * @param id
     * @return
     */
    int deleteRecycleActivityRoom(String id);


    public int editCmsActivityRoomAPI(final CmsActivityRoom record,final SysUser sysUser,final String allRoomDayStr,final String sysNo);


    /**
     * 前端页面显示关联的活动室
     * @param record 活动室查询条件
     * @param excludeFlag 是否排除自己的标记
     * @return
     */
    public List<CmsActivityRoom> queryRelatedRoom(CmsActivityRoom record,boolean excludeFlag);

    /**
     * 前端页面显示关联的活动室数量
     * @param record 活动室查询条件
     * @param excludeFlag 是否排除自己的标记
     * @return
     */
    public int queryRelatedRoomCount(CmsActivityRoom record,boolean excludeFlag);

    /**
     * qww判断场馆是否可预定
     * @param venueId
     * @return
     */
    boolean checkVenueIsReserve(String venueId);
    
    /**
     * 下架
     * @param cmsActivityRoom
     * @param sysUser
     * @return
     */
    public int pullActivityRoom(CmsActivityRoom cmsActivityRoom, SysUser sysUser);
    
   /**
    * 上架
	 * @param cmsActivityRoom
	 * @param sysUser
	 * @return
	 */
public int pushActivityRoom(CmsActivityRoom cmsActivityRoom, SysUser sysUser);
    
}
