package com.sun3d.why.service.impl;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.sun3d.why.dao.CmsActivityRoomMapper;
import com.sun3d.why.dao.CmsRoomBookMapper;
import com.sun3d.why.dao.CmsRoomOrderMapper;
import com.sun3d.why.dao.CmsRoomTimeMapper;
import com.sun3d.why.dao.SysUserMapper;
import com.sun3d.why.model.CmsActivityRoom;
import com.sun3d.why.model.CmsRoomBook;
import com.sun3d.why.model.CmsRoomOrder;
import com.sun3d.why.model.CmsRoomTime;
import com.sun3d.why.model.CmsVenue;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.model.extmodel.SmsConfig;
import com.sun3d.why.service.CacheConstant;
import com.sun3d.why.service.CacheService;
import com.sun3d.why.service.CmsActivityRoomService;
import com.sun3d.why.service.CmsRoomBookService;
import com.sun3d.why.service.CmsRoomOrderService;
import com.sun3d.why.service.CmsUserMessageService;
import com.sun3d.why.service.CmsVenueService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.PaginationApp;
import com.sun3d.why.util.UUIDUtils;

/**
 * <p>
 * 活动室服务层实现类
 * 事务管理层
 * 需要用到事务的功能都在此编写
 * <p/>
 * Created by cj on 2015/4/30.
 */
@Service
@Transactional(rollbackFor = Exception.class)
public class CmsActivityRoomServiceImpl implements CmsActivityRoomService {


    /**
     * 自动注入数据操作层dao实例
     */
    @Autowired
    private CmsActivityRoomMapper cmsActivityRoomMapper;

    @Autowired
    private CmsRoomTimeMapper cmsRoomTimeMapper;

    @Autowired
    private CmsRoomBookMapper cmsRoomBookMapper;

    @Autowired
    private CmsRoomOrderMapper cmsRoomOrderMapper;

    @Autowired
    private CacheService cacheService;

    @Autowired
    private CmsRoomBookService cmsRoomBookService;

    @Autowired
    private CmsUserMessageService userMessageService;

    @Autowired
    private CmsVenueService cmsVenueService;
    
    @Autowired
    private CmsRoomOrderService cmsRoomOrderService;

    @Autowired
    private SmsConfig smsConfig;

    @Autowired
    private HttpSession session;

    @Autowired
    private SysUserMapper sysUserMapper;

    //log4j日志
    private Logger logger = Logger.getLogger(CmsActivityRoomServiceImpl.class);

    /**
     * 根据活动室主键id获取活动室信息
     *
     * @param roomId String 活动室主键id
     * @return CmsActivityRoom 活动室模型
     *
     *
     */
    @Override
    @Transactional(readOnly = true)
    public CmsActivityRoom queryCmsActivityRoomById(String roomId) {

        return cmsActivityRoomMapper.queryCmsActivityRoomById(roomId);
    }

    /**
     * 新增一条完整的活动室信息，模型信息固定所有属性
     *
     * @param record CmsActivityRoom 活动室模型
     * @param sysUser SysUser 用户信息
     * @param allRoomDayStr 星期以及日期组成的字符串(按格式 *号分割星期 ,号分割时间段)
     * @return int 成功返回1
     */
    @Override
    public int addCmsActivityRoom(final CmsActivityRoom record,final SysUser sysUser,final String allRoomDayStr) {
        int result = 1;
        try {
            Runnable runnable=new Runnable() {
                @Override
                public void run() {
                    //查询用户用户信息
                  //  SysUser syncUser = sysUserMapper.querySysUserByUserAccount("chuangtu_sh");
                    int result = 0;

                    //添加活动室时，默认赋值
                    record.setRoomId(UUIDUtils.createUUId());
                    record.setRoomIsDel(Constant.NORMAL);
                    if(record.getRoomState() == null){
                        record.setRoomState(Constant.PUBLISH);
                    }
                    if(record.getRoomIsFree() == 1){
                        record.setRoomFee(null);
                    }
                    record.setRoomCreateTime(new Date());
                    record.setRoomCreateUser(sysUser.getUserId());
                    record.setRoomUpdateTime(new Date());
                    record.setRoomUpdateUser(sysUser.getUserId());
                    
                    // 一周预订情况
                    int [] week=new int [7];
                    
                    //赋予默认值
                    if (record.getRoomDayMonday() == null) {
                        record.setRoomDayMonday(2);
                        week[0]=2;
                    }
                    else
                    	week[0]=1;
                    if (record.getRoomDayTuesday() == null) {
                        record.setRoomDayTuesday(2);
                        week[1]=2;
                    }
                    else
                    	week[1]=1;
                    if (record.getRoomDayWednesday() == null) {
                        record.setRoomDayWednesday(2);
                        week[2]=2;
                    }
                    else
                    	week[2]=1;
                    if (record.getRoomDayThursday() == null) {
                        record.setRoomDayThursday(2);
                        week[3]=2;
                    }
                    else
                    	week[3]=1;
                    if (record.getRoomDayFriday() == null) {
                        record.setRoomDayFriday(2);
                        week[4]=2;
                    }
                    else
                    	week[4]=1;
                    if (record.getRoomDaySaturday() == null) {
                        record.setRoomDaySaturday(2);
                        week[5]=2;
                    }
                    else
                    	week[5]=1;
                    if (record.getRoomDaySunday() == null) {
                        record.setRoomDaySunday(2);
                        week[6]=2;
                    }
                    else
                    	week[6]=1;
                    result = cmsActivityRoomMapper.addCmsActivityRoom(record);

                    //添加活动室时间段数据
                    String[] allRoomDayArr = StringUtils.split(allRoomDayStr, "*");
                    for (int i = 0; i < allRoomDayArr.length; i++) {
                        String allTimePeriodStr = allRoomDayArr[i];
                        int dayIsOpen=week[i];
                        String[] allTimePeriodArr = StringUtils.split(allTimePeriodStr, ",");
                        for (int j = 0; j < allTimePeriodArr.length; j++) {
                            String timePeriodStr = allTimePeriodArr[j];

                            CmsRoomTime cmsRoomTime = new CmsRoomTime();
                            cmsRoomTime.setRoomTimeId(UUIDUtils.createUUId());
                            cmsRoomTime.setRoomId(record.getRoomId());
                            //前台传递的数据中 顺序为星期一开始到星期日结束
                            cmsRoomTime.setRoomDay(i + 1);
                            if (dayIsOpen==2||timePeriodStr.equals("OFF")) {
                                cmsRoomTime.setIsOpen(2);
                            } else {
                                cmsRoomTime.setIsOpen(1);
                            }
                            cmsRoomTime.setTimePeriod(timePeriodStr);
                            cmsRoomTime.setTimeSort(j + 1);
                            cmsRoomTime.setUpdateTime(new Date());
                            cmsRoomTime.setUpdateUser(sysUser.getUserId());
                            cmsRoomTimeMapper.addRoomTime(cmsRoomTime);
                        }
                    }

                    // 活动室添加成功后，判断所属场馆是否可以预定
                    boolean bool = checkVenueIsReserve(record.getRoomVenueId());
                    CmsVenue cmsVenue = cmsVenueService.queryVenueById(record.getRoomVenueId());
                    if(cmsVenue != null){
                        if(bool && cmsVenue.getVenueIsReserve() == Constant.VENUE_NOT_RESERVE){
                            CmsVenue venue = new CmsVenue();
                            venue.setVenueId(record.getRoomVenueId());
                            venue.setVenueIsReserve(Constant.VENUE_IS_RESERVE);
                            venue.setVenueUpdateTime(new Date());
                            venue.setVenueUpdateUser(sysUser.getUserId());
                            cmsVenueService.editVenueByVenueId(venue);
                            //将缓存的场馆列表置空
                            cacheService.updateVenueIndex(Constant.VENUE_INDEX_REDIS_DEFAULT,new ArrayList<CmsVenue>());
                        }
                    }

                    if (result > 0) {
                        //生成预定信息
                        generateOneRoomBook(record);
                        //讲数据放入Redis
                        setRoomBookToRedis(record);
                        //将活动室队列放入内存中的一个set集合中
                        cacheService.saveActivityRoomToQueues(CacheConstant.ACTIVITY_ROOM_QUEUES, record.getRoomId() +"_N");
                    }
                }
            };
            Thread thread=new Thread(runnable);
            thread.start();
        } catch (Exception e) {
            logger.error("添加活动室出错",e);
            result = 0;
        }
        return result;
    }

    /**
     * 根据活动室主键id来修改活动室所有信息
     *
     * @param record CmsActivityRoom 活动室信息
     * @param sysUser SysUser 用户信息
     * @param allRoomDayStr 星期以及日期组成的字符串(按格式 *号分割星期 ,号分割时间段)
     * @return int 成功返回1
     */
    @Override
    public int editCmsActivityRoom(final CmsActivityRoom record,final SysUser sysUser,final String allRoomDayStr,final String sysNo) {
        int count = 1;
        try {
            Runnable runnable=new Runnable() {
                @Override
                public void run() {
                    int count = 0;
                    //根据馆藏ID查询馆藏信息
                    CmsActivityRoom cmsActivityRoom = cmsActivityRoomMapper.queryCmsActivityRoomById(record.getRoomId());
                    if(record.getRoomIsFree() == 1){
                        record.setRoomFee(null);
                    }
                    //修改馆藏时，默认赋值
                    record.setRoomCreateTime(cmsActivityRoom.getRoomCreateTime());
                    record.setRoomCreateUser(cmsActivityRoom.getRoomCreateUser());
                    record.setRoomIsDel(cmsActivityRoom.getRoomIsDel());
                    record.setRoomUpdateUser(sysUser.getUserId());
                    record.setRoomUpdateTime(new Date());
                    // 一周预订情况
                    int [] week=new int [7];
                    
                    //赋予默认值
                    if (record.getRoomDayMonday() == null) {
                        record.setRoomDayMonday(2);
                        week[0]=2;
                    }
                    else
                    	week[0]=1;
                    if (record.getRoomDayTuesday() == null) {
                        record.setRoomDayTuesday(2);
                        week[1]=2;
                    }
                    else
                    	week[1]=1;
                    if (record.getRoomDayWednesday() == null) {
                        record.setRoomDayWednesday(2);
                        week[2]=2;
                    }
                    else
                    	week[2]=1;
                    if (record.getRoomDayThursday() == null) {
                        record.setRoomDayThursday(2);
                        week[3]=2;
                    }
                    else
                    	week[3]=1;
                    if (record.getRoomDayFriday() == null) {
                        record.setRoomDayFriday(2);
                        week[4]=2;
                    }
                    else
                    	week[4]=1;
                    if (record.getRoomDaySaturday() == null) {
                        record.setRoomDaySaturday(2);
                        week[5]=2;
                    }
                    else
                    	week[5]=1;
                    if (record.getRoomDaySunday() == null) {
                        record.setRoomDaySunday(2);
                        week[6]=2;
                    }
                    else
                    	week[6]=1;
                    count = cmsActivityRoomMapper.editCmsActivityRoom(record);

                    //添加活动室时间段数据
                    String[] allRoomDayArr = StringUtils.split(allRoomDayStr, "*");

                    for (int i = 0; i < allRoomDayArr.length; i++) {
                        String allTimePeriodStr = allRoomDayArr[i];
                        String[] allTimePeriodArr = StringUtils.split(allTimePeriodStr, ",");
                        int dayIsOpen=week[i];
                        
                        for (int j = 0; j < allTimePeriodArr.length; j++) {
                            String timePeriodStr = allTimePeriodArr[j];
                            String[] timeAndPeriod = timePeriodStr.split("_");

                            CmsRoomTime cmsRoomTime = new CmsRoomTime();
                            cmsRoomTime.setRoomTimeId(timeAndPeriod[0]);
                            if (dayIsOpen==2||timeAndPeriod[1].equals("OFF")) {
                                cmsRoomTime.setIsOpen(2);
                            } else {
                                cmsRoomTime.setIsOpen(1);
                            }
                            cmsRoomTime.setTimePeriod(timeAndPeriod[1]);
                            cmsRoomTime.setRoomId(record.getRoomId());
                            cmsRoomTime.setTimeSort(j + 1);
                            cmsRoomTime.setRoomDay(i + 1);
                            cmsRoomTime.setUpdateTime(new Date());
                            cmsRoomTime.setUpdateUser(sysUser.getUserId());
                            cmsRoomTimeMapper.editRoomTime(cmsRoomTime);
                        }
                    }

                    // 草稿活动室编缉发布成功后，判断所属场馆是否可以预定
                    boolean bool = checkVenueIsReserve(record.getRoomVenueId());
                    CmsVenue cmsVenue = cmsVenueService.queryVenueById(record.getRoomVenueId());
                    if(cmsVenue != null){
                        if(bool && cmsVenue.getVenueIsReserve() == Constant.VENUE_NOT_RESERVE){
                            CmsVenue venue = new CmsVenue();
                            venue.setVenueId(record.getRoomVenueId());
                            venue.setVenueIsReserve(Constant.VENUE_IS_RESERVE);
                            venue.setVenueUpdateTime(new Date());
                            venue.setVenueUpdateUser(sysUser.getUserId());
                            cmsVenueService.editVenueByVenueId(venue);
                            //将缓存的场馆列表置空
                            cacheService.updateVenueIndex(Constant.VENUE_INDEX_REDIS_DEFAULT,new ArrayList<CmsVenue>());
                        }
                    }
                }
            };
            Thread thread=new Thread(runnable);
            thread.start();
        } catch (Exception e) {
            logger.error("更新活动室信息时出错");
        }
        return count;
    }

    /**
     * 根据活动室主键id来修改活动室模型中不为空的信息，推荐使用
     *
     * @param record CmsActivityRoom 活动室信息
     * @param sysUser SysUser 用户信息
     * @return int 成功返回1
     */
    public int deleteCmsActivityRoom(CmsActivityRoom record,SysUser sysUser){
        int editCount = 0;
        try {
            //修改馆藏时，默认赋值
            record.setRoomIsDel(Constant.DELETE);
            record.setRoomState(Constant.TRASH);
            record.setRoomUpdateTime(new Date());
            record.setRoomUpdateUser(sysUser.getUserId());

            editCount = cmsActivityRoomMapper.editCmsActivityRoom(record);

            // 活动室删除成功后，判断所属场馆是否可以预定
            boolean bool = checkVenueIsReserve(record.getRoomVenueId());
            CmsVenue cmsVenue = cmsVenueService.queryVenueById(record.getRoomVenueId());
            if(cmsVenue != null){
                if(!bool && cmsVenue.getVenueIsReserve() == Constant.VENUE_IS_RESERVE){
                    CmsVenue venue = new CmsVenue();
                    venue.setVenueId(record.getRoomVenueId());
                    venue.setVenueIsReserve(Constant.VENUE_NOT_RESERVE);
                    venue.setVenueUpdateTime(new Date());
                    venue.setVenueUpdateUser(sysUser.getUserId());
                    cmsVenueService.editVenueByVenueId(venue);
                    //将缓存的场馆列表置空
                    cacheService.updateVenueIndex(Constant.VENUE_INDEX_REDIS_DEFAULT,new ArrayList<CmsVenue>());
                }
            }
        } catch (Exception e) {
            logger.error("逻辑删除活动室信息时出错",e);
        }
        return editCount;
    }

    /**
     * 带条件请求活动室列表
     * @param record 活动室信息
     * @param cmsVenue  场馆信息
     * @param page  分页信息
     * @param sysUser 用户信息
     * @return
     */
    @Override
    public List<CmsActivityRoom> queryCmsActivityRoomByCondition(CmsActivityRoom record,CmsVenue cmsVenue,Pagination page,SysUser sysUser){
        Map<String,Object> map = new HashMap<String, Object>();
        List<CmsActivityRoom> list = null;
        try {
            if(record.getRoomIsDel() != null){
                map.put("roomIsDel",record.getRoomIsDel());
            }
//            }else{
//                record.setRoomIsDel(Constant.NORMAL);
//                map.put("roomIsDel",Constant.NORMAL);
//            }
            if(record.getRoomState() != null){
                map.put("roomState",record.getRoomState());
            }else{
                record.setRoomState(Constant.PUBLISH);
                map.put("roomState",Constant.PUBLISH);
            }
            if (StringUtils.isNotBlank(record.getRoomName())){
                map.put("roomName","%"+record.getRoomName()+"%");
            }
            if(StringUtils.isNotBlank(record.getSearchKey())){
                map.put("searchKey", record.getSearchKey());
            }
            if(cmsVenue != null){
                if (StringUtils.isNotBlank(cmsVenue.getVenueArea())){
                    map.put("venueArea","%"+cmsVenue.getVenueArea()+"%");
                }
                if (StringUtils.isNotBlank(cmsVenue.getVenueType())){
                    map.put("venueType",cmsVenue.getVenueType());
                }
                if (StringUtils.isNotBlank(cmsVenue.getVenueId())){
                    map.put("venueId",cmsVenue.getVenueId());
                }
            }

            String userDeptPath = sysUser.getUserDeptPath();
            if(userDeptPath != null){
                map.put("venueDept", "%"+userDeptPath+"%");
            }
            int total = cmsActivityRoomMapper.queryCmsActivityRoomCountByCondition(map);
            //设置分页的总条数来获取总页数
            page.setTotal(total);
            page.setRows(page.getRows());
            map.put("firstResult",page.getFirstResult());
            map.put("rows",page.getRows());
            list = cmsActivityRoomMapper.queryCmsActivityRoomByCondition(map);
        } catch (Exception e) {
            logger.error("执行带条件分页查询活动室信息时出错",e);
        }
        return list;
    }

    /**
     * 带条件请求活动室列表个数
     * @param map
     * @return
     */
    @Override
    public int queryCmsActivityRoomCountByCondition(Map<String, Object> map){

        return cmsActivityRoomMapper.queryCmsActivityRoomCountByCondition(map);
    }

    /**
     * 根据活动室查询条件查询符合条件的活动室列表
     * @param record
     * @return
     */
    public List<CmsActivityRoom> queryByCmsActivityRoom(CmsActivityRoom record){

        Map<String,Object> map = new HashMap<String, Object>();
        List<CmsActivityRoom> list = null;
        try {
            if (record.getRoomIsDel() != null) {
                map.put("roomIsDel", record.getRoomIsDel());
            } else {
                record.setRoomIsDel(Constant.NORMAL);
                map.put("roomIsDel", Constant.NORMAL);
            }
            if(record.getRoomState() != null){
                map.put("roomState",record.getRoomState());
            }else{
                record.setRoomState(Constant.PUBLISH);
                map.put("roomState",Constant.PUBLISH);
            }
            if (StringUtils.isNotBlank(record.getRoomName())) {
                map.put("roomName", "%" + record.getRoomName() + "%");
            }
            if (StringUtils.isNotBlank(record.getRoomVenueId())){
                map.put("venueId",record.getRoomVenueId());
            }
            if (record.getVenueIsDel() != null){
                map.put("venueIsDel",record.getVenueIsDel());
            }
            int total = cmsActivityRoomMapper.queryCmsActivityRoomCountByCondition(map);
            record.setTotal(total);
            map.put("firstResult", record.getFirstResult());
            map.put("rows", record.getRows());
            list = cmsActivityRoomMapper.queryCmsActivityRoomByCondition(map);
        }catch (Exception e){
            logger.error("根据活动室查询条件查询符合条件的活动室列表时出错!",e);
        }
        return list;
    }

    /**
     * 根据活动室查询条件查询符合条件的活动室个数
     * @param record
     * @return
     */
    public int queryCountByCmsActivityRoom(CmsActivityRoom record){
        int count = 0;
        Map<String,Object> map = new HashMap<String, Object>();
        try {
            if (record.getRoomIsDel() != null) {
                map.put("roomIsDel", record.getRoomIsDel());
            } else {
                record.setRoomIsDel(Constant.NORMAL);
                map.put("roomIsDel", Constant.NORMAL);
            }
            if(record.getRoomState() != null){
                map.put("roomState",record.getRoomState());
            }else{
                record.setRoomState(Constant.PUBLISH);
                map.put("roomState",Constant.PUBLISH);
            }
            if (StringUtils.isNotBlank(record.getRoomName())) {
                map.put("roomName", "%" + record.getRoomName() + "%");
            }
            if (StringUtils.isNotBlank(record.getRoomVenueId())){
                map.put("venueId",record.getRoomVenueId());
            }
            count = cmsActivityRoomMapper.queryCmsActivityRoomCountByCondition(map);
        }catch (Exception e){
            logger.error("根据活动室查询条件查询符合条件的活动室列表时出错!",e);
        }
        return count;
    }


    /**
     * 根据展馆id查询活动室列表
     * @param record
     * @param pageApp  分页对象
     * @return
     */
    @Override
    public List<CmsActivityRoom> queryByAppActivityRoom(CmsActivityRoom record, PaginationApp pageApp) {
        Map<String,Object> map = new HashMap<String, Object>();
        List<CmsActivityRoom> list = null;
        try {
            if (record.getRoomIsDel() != null) {
                map.put("roomIsDel", record.getRoomIsDel());
            } else {
                record.setRoomIsDel(Constant.NORMAL);
                map.put("roomIsDel", Constant.NORMAL);
            }
            if(record.getRoomState() != null){
                map.put("roomState",record.getRoomState());
            }else{
                record.setRoomState(Constant.PUBLISH);
                map.put("roomState",Constant.PUBLISH);
            }
            if (StringUtils.isNotBlank(record.getRoomName())) {
                map.put("roomName", "%" + record.getRoomName() + "%");
            }
            if (StringUtils.isNotBlank(record.getRoomVenueId())){
                map.put("venueId",record.getRoomVenueId());
            }
            //app分页
            if (pageApp != null && pageApp.getFirstResult() != null && pageApp.getRows() != null) {
                map.put("firstResult", pageApp.getFirstResult());
                map.put("rows", pageApp.getRows());
                //  pageApp.setTotal(commentMapper.queryCommentCountByCondition(map));
            }
            list = cmsActivityRoomMapper.queryCmsActivityRoomByCondition(map);
        }catch (Exception e){
            logger.error("app根据展馆id的活动室列表时出错!",e);
        }
        return list;
    }

   

    /**
     * 初始化某个特定活动室七天的预定信息
     * @param cmsActivityRoom
     * @return
     */
    public int generateOneRoomBook(CmsActivityRoom cmsActivityRoom){
        List<CmsActivityRoom> roomList = new ArrayList<CmsActivityRoom>();
        roomList.add(cmsActivityRoom);
        int result = cmsRoomBookService.initRoomBookInfo(roomList);
        return result;
    }

    /**
     * 将某个活动室的数据生成后放入Redis中
     * @return
     */
    public int setRoomBookToRedis(CmsActivityRoom cmsActivityRoom){
        int result = 1;
        try {
            //将活动室预定数据放入Redis中，修改后只放活动室预定ID列表
            List<String> roomBookList = cmsRoomBookService.queryRoomBookDataToRedis(cmsActivityRoom.getRoomId(),7);
            Calendar calendar = Calendar.getInstance();
            calendar.setTime(new Date());
            //设置过期时间为当前时间之后的24小时
            calendar.add(Calendar.HOUR_OF_DAY,24);
            //将活动室预定信息放入Redis
            cacheService.setRoomBookList(cmsActivityRoom.getRoomId(), roomBookList, calendar.getTime());
        } catch (Exception e) {
            logger.error("将预定信息放入Redis中失败!",e);
            result = 0;
        }
        return result;
    }

    /**
     * 带条件查询符合的统计数据[平台内容统计--活动室统计]
     * @param cmsActivityRoom
     * @return
     */
    @Override
    public List<CmsActivityRoom> queryRoomStatistic(CmsActivityRoom cmsActivityRoom) {

        return cmsActivityRoomMapper.queryRoomStatistic(cmsActivityRoom);
    }

    /**
     * 发布活动室
     * @param roomId
     * @return
     */
    @Override
    public int publishActivityRoom(String roomId) {
        CmsActivityRoom cmsActivityRoom = cmsActivityRoomMapper.queryCmsActivityRoomById(roomId);
        cmsActivityRoom.setRoomState(Constant.PUBLISH);
        cmsActivityRoom.setRoomUpdateTime(new Date());
        int editCount = cmsActivityRoomMapper.editCmsActivityRoom(cmsActivityRoom);

        // 活动室发布成功后，判断所属场馆是否可以预定
        boolean bool = checkVenueIsReserve(cmsActivityRoom.getRoomVenueId());
        CmsVenue cmsVenue = cmsVenueService.queryVenueById(cmsActivityRoom.getRoomVenueId());
        if(cmsVenue != null){
            if(bool && cmsVenue.getVenueIsReserve() == Constant.VENUE_NOT_RESERVE){
                CmsVenue venue = new CmsVenue();
                venue.setVenueId(cmsActivityRoom.getRoomVenueId());
                venue.setVenueIsReserve(Constant.VENUE_IS_RESERVE);
                venue.setVenueUpdateTime(new Date());
                SysUser sysUser = (SysUser) session.getAttribute("user");
                venue.setVenueUpdateUser(sysUser.getUserId());
                cmsVenueService.editVenueByVenueId(venue);
                //将缓存的场馆列表置空
                cacheService.updateVenueIndex(Constant.VENUE_INDEX_REDIS_DEFAULT,new ArrayList<CmsVenue>());
            }
        }

        return editCount;
    }

    /**
     * 还原活动室
     * @param roomId
     * @return
     */
    @Override
    public int backActivityRoom(String roomId) {

        CmsActivityRoom cmsActivityRoom = cmsActivityRoomMapper.queryCmsActivityRoomById(roomId);
        cmsActivityRoom.setRoomState(Constant.DRAFT);
        cmsActivityRoom.setRoomIsDel(Constant.NORMAL);
        cmsActivityRoom.setRoomUpdateTime(new Date());
        return cmsActivityRoomMapper.editCmsActivityRoom(cmsActivityRoom);
    }

    /**
     * 彻底删除活动室
     * @param id
     * @return
     */
    @Override
    public int deleteRecycleActivityRoom(String id) {
        return cmsActivityRoomMapper.deleteRecycleActivityRoom(id);
    }


    /**
     * 根据活动室主键id来修改活动室所有信息
     *
     * @param record CmsActivityRoom 活动室信息
     * @param sysUser SysUser 用户信息
     * @param allRoomDayStr 星期以及日期组成的字符串(按格式 *号分割星期 ,号分割时间段)
     * @return int 成功返回1
     */
    @Override
    public int editCmsActivityRoomAPI(final CmsActivityRoom record,final SysUser sysUser,final String allRoomDayStr,final String sysNo) {
        int count = 1;
        try {
            Runnable runnable=new Runnable() {
                @Override
                public void run() {
                    int count = 0;
                    //根据馆藏ID查询馆藏信息
                    CmsActivityRoom cmsActivityRoom = cmsActivityRoomMapper.queryCmsActivityRoomById(record.getRoomId());
                    if(record.getRoomIsFree() == 1){
                        record.setRoomFee(null);
                    }
                    //修改馆藏时，默认赋值
                    record.setRoomCreateTime(cmsActivityRoom.getRoomCreateTime());
                    record.setRoomCreateUser(cmsActivityRoom.getRoomCreateUser());
                    record.setRoomIsDel(1); //设置活动室为非删除
                    record.setRoomUpdateUser(sysUser.getUserId());
                    record.setRoomUpdateTime(new Date());
                    //赋予默认值
                    if (record.getRoomDayMonday() == null) {
                        record.setRoomDayMonday(2);
                    }
                    if (record.getRoomDayTuesday() == null) {
                        record.setRoomDayTuesday(2);
                    }
                    if (record.getRoomDayWednesday() == null) {
                        record.setRoomDayWednesday(2);
                    }
                    if (record.getRoomDayThursday() == null) {
                        record.setRoomDayThursday(2);
                    }
                    if (record.getRoomDayFriday() == null) {
                        record.setRoomDayFriday(2);
                    }
                    if (record.getRoomDaySaturday() == null) {
                        record.setRoomDaySaturday(2);
                    }
                    if (record.getRoomDaySunday() == null) {
                        record.setRoomDaySunday(2);
                    }
                    count = cmsActivityRoomMapper.editCmsActivityRoom(record);


                    //添加活动室时间段数据
                    String[] allRoomDayArr = StringUtils.split(allRoomDayStr, "*");
                    // sysNo 0代表文化云 1代表嘉定  不用执行先删除再插入的操作
                    if(!"1".equals(sysNo) && !"0".equals(sysNo)){
                        //关于时间段处理方案 先删除，再添加
                        cmsRoomTimeMapper.deleteByRoomId(record.getRoomId());

                        for (int i = 0; i < allRoomDayArr.length; i++) {
                            String allTimePeriodStr = allRoomDayArr[i];
                            String[] allTimePeriodArr = StringUtils.split(allTimePeriodStr, ",");
                            for (int j = 0; j < allTimePeriodArr.length; j++) {
                                String timePeriodStr = allTimePeriodArr[j];

                                CmsRoomTime cmsRoomTime = new CmsRoomTime();
                                cmsRoomTime.setRoomTimeId(UUIDUtils.createUUId());
                                cmsRoomTime.setRoomId(record.getRoomId());
                                //前台传递的数据中 顺序为星期一开始到星期日结束
                                cmsRoomTime.setRoomDay(i + 1);
                                if (timePeriodStr.equals("OFF")) {
                                    cmsRoomTime.setIsOpen(2);
                                } else {
                                    cmsRoomTime.setIsOpen(1);
                                }
                                cmsRoomTime.setTimePeriod(timePeriodStr);
                                cmsRoomTime.setTimeSort(j + 1);
                                cmsRoomTime.setUpdateTime(new Date());
                                cmsRoomTime.setUpdateUser(sysUser.getUserId());
                                cmsRoomTimeMapper.addRoomTime(cmsRoomTime);
                            }
                        }

                    }else{
                        for (int i = 0; i < allRoomDayArr.length; i++) {
                            String allTimePeriodStr = allRoomDayArr[i];
                            String[] allTimePeriodArr = StringUtils.split(allTimePeriodStr, ",");
                            for (int j = 0; j < allTimePeriodArr.length; j++) {
                                String timePeriodStr = allTimePeriodArr[j];
                                String[] timeAndPeriod = timePeriodStr.split("_");

                                CmsRoomTime cmsRoomTime = new CmsRoomTime();
                                cmsRoomTime.setRoomTimeId(timeAndPeriod[0]);
                                if (timeAndPeriod[1].equals("OFF")) {
                                    cmsRoomTime.setIsOpen(2);
                                } else {
                                    cmsRoomTime.setIsOpen(1);
                                }
                                cmsRoomTime.setTimePeriod(timeAndPeriod[1]);
                                cmsRoomTime.setRoomId(record.getRoomId());
                                cmsRoomTime.setTimeSort(j + 1);
                                cmsRoomTime.setRoomDay(i + 1);
                                cmsRoomTime.setUpdateTime(new Date());
                                cmsRoomTime.setUpdateUser(sysUser.getUserId());
                                cmsRoomTimeMapper.editRoomTime(cmsRoomTime);
                            }
                        }
                    }
                }
            };
            Thread thread=new Thread(runnable);
            thread.start();
        } catch (Exception e) {
            logger.error("更新活动室信息时出错");
        }
        return count;
    }

    /**
     * 前端页面显示关联的活动室
     * @param record 活动室查询条件
     * @param excludeFlag 是否排除自己的标记
     * @return
     */
    @Override
    public List<CmsActivityRoom> queryRelatedRoom(CmsActivityRoom record, boolean excludeFlag) {
        Map<String,Object> map = new HashMap<String, Object>();
        List<CmsActivityRoom> list = null;
        try {
            map.put("roomIsDel", Constant.NORMAL);
            map.put("roomState",Constant.PUBLISH);
            if(StringUtils.isNotBlank(record.getVenueId())){
                map.put("venueId", record.getVenueId());
            }
            if(StringUtils.isNotBlank(record.getRoomId())){
                if(excludeFlag){
                    map.put("roomIdExclude", record.getRoomId());
                }else {
                    map.put("roomId", record.getRoomId());
                }
            }
            int total = cmsActivityRoomMapper.queryRelatedRoomCount(map);
            record.setTotal(total);
            map.put("firstResult", record.getFirstResult());
            map.put("rows", record.getRows());
            list = cmsActivityRoomMapper.queryRelatedRoom(map);
        }catch (Exception e){
            logger.error("查询推荐活动室信息出错!",e);
        }
        return list;
    }

    /**
     * 前端页面显示关联的活动室数量
     * @param record 活动室查询条件
     * @param excludeFlag 是否排除自己的标记
     * @return
     */
    @Override
    public int queryRelatedRoomCount(CmsActivityRoom record, boolean excludeFlag) {
        Map<String,Object> map = new HashMap<String, Object>();
        int total = 0;
        try {
            map.put("roomIsDel", Constant.NORMAL);
            map.put("roomState",Constant.PUBLISH);
            if(StringUtils.isNotBlank(record.getVenueId())){
                map.put("venueId", record.getVenueId());
            }
            if(StringUtils.isNotBlank(record.getRoomId())){
                if(excludeFlag){
                    map.put("roomIdExclude", record.getRoomId());
                }else {
                    map.put("roomId", record.getRoomId());
                }
            }
            total = cmsActivityRoomMapper.queryRelatedRoomCount(map);
        }catch (Exception e){
            logger.error("查询推荐活动室信息出错!",e);
        }
        return total;
    }

    /**
     * qww判断场馆是否可预定
     * @param venueId
     * @return
     */
    @Override
    public boolean checkVenueIsReserve(String venueId){
        boolean flag = false;
        List<CmsActivityRoom> activityRoomList = cmsActivityRoomMapper.queryActivityRoomCount(venueId);
        if(CollectionUtils.isNotEmpty(activityRoomList)){
            for(CmsActivityRoom activityRoom:activityRoomList){
                if(activityRoom.getRoomCount() != null && activityRoom.getRoomCount() > 0){
                    flag = true;
                    break;
                }
            }
        }
        return flag;
    }

	@Override
	public int editCmsActivityRoom(CmsActivityRoom record) {
		
		return  cmsActivityRoomMapper.editCmsActivityRoom(record);
	}

	@Override
	public int pullActivityRoom(CmsActivityRoom cmsActivityRoom, SysUser sysUser) {
	
		cmsActivityRoom.setRoomIsDel(Constant.PULL);
    	
    	cmsActivityRoom.setRoomUpdateUser(sysUser.getUserId());
    	cmsActivityRoom.setRoomUpdateTime(new Date());
       
    	int count=cmsActivityRoomMapper.editCmsActivityRoom(cmsActivityRoom);
    	
    	if(count>0){
    		
    		List<CmsRoomOrder> orderList=cmsRoomOrderMapper.queryRoomOrderListByRoomId(cmsActivityRoom.getRoomId());
			
    		List bookStatusArray=Arrays.asList(new int []{0,1,5});
    		
			for (CmsRoomOrder cmsRoomOrder : orderList) {
				
				Integer bookStatus=cmsRoomOrder.getBookStatus();
				
				if(bookStatus==null||bookStatusArray.contains(bookStatus.intValue()))
				{
					cmsRoomOrderService.cancelRoomOrder(cmsRoomOrder.getRoomOrderId(), sysUser.getUserNickName());
				}
			}	    
			
    	
    		// 活动室删除成功后，判断所属场馆是否可以预定
            boolean bool = checkVenueIsReserve(cmsActivityRoom.getRoomVenueId());
            CmsVenue cmsVenue = cmsVenueService.queryVenueById(cmsActivityRoom.getRoomVenueId());
            if(cmsVenue != null){
                if(!bool && cmsVenue.getVenueIsReserve() == Constant.VENUE_IS_RESERVE){
                    CmsVenue venue = new CmsVenue();
                    venue.setVenueId(cmsActivityRoom.getRoomVenueId());
                    venue.setVenueIsReserve(Constant.VENUE_NOT_RESERVE);
                    venue.setVenueUpdateTime(new Date());
                    venue.setVenueUpdateUser(sysUser.getUserId());
                    cmsVenueService.editVenueByVenueId(venue);
                }
            }
    
    	}
		
		return count;
	}

	@Override
	public int pushActivityRoom(CmsActivityRoom cmsActivityRoom, SysUser sysUser) {
		
		cmsActivityRoom.setRoomIsDel(Constant.NORMAL);
    	
    	cmsActivityRoom.setRoomUpdateUser(sysUser.getUserId());
    	cmsActivityRoom.setRoomUpdateTime(new Date());
    	
    	int count=cmsActivityRoomMapper.editCmsActivityRoom(cmsActivityRoom);
    	
    	if(count>0){
    	 // 活动室添加成功后，判断所属场馆是否可以预定
        boolean bool = checkVenueIsReserve(cmsActivityRoom.getRoomVenueId());
        CmsVenue cmsVenue = cmsVenueService.queryVenueById(cmsActivityRoom.getRoomVenueId());
        if(cmsVenue != null){
            if(bool && cmsVenue.getVenueIsReserve() == Constant.VENUE_NOT_RESERVE){
                CmsVenue venue = new CmsVenue();
                venue.setVenueId(cmsActivityRoom.getRoomVenueId());
                venue.setVenueIsReserve(Constant.VENUE_IS_RESERVE);
                venue.setVenueUpdateTime(new Date());
                venue.setVenueUpdateUser(sysUser.getUserId());
                cmsVenueService.editVenueByVenueId(venue);
            }
        }
    	}
		return count;
	}
}
