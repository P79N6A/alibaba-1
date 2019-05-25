package com.sun3d.why.controller;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.alibaba.fastjson.JSONObject;
import com.sun3d.why.model.CmsActivityRoom;
import com.sun3d.why.model.CmsRoomTime;
import com.sun3d.why.model.CmsTagSubRelate;
import com.sun3d.why.model.CmsVenue;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.service.CacheConstant;
import com.sun3d.why.service.CacheService;
import com.sun3d.why.service.CmsActivityRoomService;
import com.sun3d.why.service.CmsRoomBookService;
import com.sun3d.why.service.CmsRoomOrderService;
import com.sun3d.why.service.CmsRoomTimeService;
import com.sun3d.why.service.CmsTagSubRelateService;
import com.sun3d.why.service.CmsVenueService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.Pagination;



/**
 * 活动室模块控制层，负责跟页面数据的交互以及对下层的数据方法的调用
 * <p/>
 * Created by cj on 2015/4/21.
 */
@Controller
@RequestMapping(value = "/activityRoom")
public class CmsActivityRoomController {

    /**
     * 添加log4j日志
     */
    private Logger logger = Logger.getLogger(CmsActivityRoomController.class);
    /**
     * 自动注入业务操作层service实例
     */
    @Autowired
    private CmsActivityRoomService cmsActivityRoomService;
    //活动室预定逻辑控制层
    @Autowired
    private CmsRoomBookService cmsRoomBookService;
    //活动室预定场次逻辑控制层
    @Autowired
    private CmsRoomTimeService cmsRoomTimeService;
    //场馆逻辑控制层
    @Autowired
    private CmsVenueService cmsVenueService;
    //缓存信息逻辑控制层
    @Autowired
    private CacheService cacheService;
    @Autowired
    private HttpSession session;
    //活动室订单逻辑控制层
    @Autowired
    private CmsRoomOrderService cmsRoomOrderService;
    @Autowired
    private CmsTagSubRelateService cmsTagRelateService;
    
    @Autowired
	private StaticServer staticServer;
    /**
     * 跳转到活动室管理的首页面
     *
     * @param record CmsActivityRoom 活动室信息模型
     * @param page Pagination 分页功能类
     * @param cmsVenue CmsVenue 场馆查询信息
     * @author cj
     * @date 2015-04-28
     * @return ModelAndView 页面及参数
     */
    @RequestMapping(value = "/activityRoomIndex")
    public ModelAndView activityRoomIndex(CmsActivityRoom record, String searchKey, Pagination page,CmsVenue cmsVenue) {
        ModelAndView model = new ModelAndView();
        List<CmsActivityRoom> list = null;
        if(StringUtils.isNotBlank(cmsVenue.getVenueId())) {
            cmsVenue = cmsVenueService.queryVenueById(cmsVenue.getVenueId());
            model.setViewName("admin/activityRoom/activityRoomVenueIndex");
        }
        else
        	  model.setViewName("admin/activityRoom/activityRoomIndex");
        
        if(StringUtils.isNotBlank(searchKey)){
        	record.setSearchKey(searchKey);
        }
        try {
            SysUser sysUser = (SysUser) session.getAttribute("user");
            if(sysUser != null){
            	record.setRoomState(Constant.PUBLISH);
                list = cmsActivityRoomService.queryCmsActivityRoomByCondition(record, cmsVenue, page, sysUser);
            }else{
                logger.error("当前登录用户不存在或没有登录，活动室列表请求操作终止!");
            }
        } catch (Exception e) {
            logger.error("加载活动室列表页面时出错!",e);
        }
      
        model.addObject("list", list);
        model.addObject("page", page);
        model.addObject("record", record);
        model.addObject("searchKey", searchKey);
        model.addObject("cmsVenue",cmsVenue);
        return model;
    }

    /**
     * 跳转到活动室草稿管理的页面
     *
     * @param record CmsActivityRoom 活动室信息模型
     * @param page Pagination 分页功能类
     * @param cmsVenue CmsVenue 场馆查询信息
     * @author cj
     * @date 2015-04-28
     * @return ModelAndView 页面及参数
     */
    @RequestMapping(value = "/roomDraftList")
    public ModelAndView roomDraftList(CmsActivityRoom record, String searchKey, Pagination page, CmsVenue cmsVenue) {
        ModelAndView model = new ModelAndView();
        List<CmsActivityRoom> list = null;
        if(cmsVenue != null){
            cmsVenue = cmsVenueService.queryVenueById(cmsVenue.getVenueId());
        }
        if(StringUtils.isNotBlank(searchKey)){
        	record.setSearchKey(searchKey);
        }
        try {
            SysUser sysUser = (SysUser) session.getAttribute("user");
            if(sysUser != null){
                record.setRoomState(Constant.DRAFT);
                list = cmsActivityRoomService.queryCmsActivityRoomByCondition(record, cmsVenue, page, sysUser);
            }else{
                logger.error("当前登录用户不存在或没有登录，活动室列表请求操作终止!");
            }
        } catch (Exception e) {
            logger.error("加载活动室列表页面时出错!",e);
        }
        model.setViewName("admin/activityRoom/activityRoomDraftList");
        model.addObject("list", list);
        model.addObject("page", page);
        model.addObject("record", record);
        model.addObject("searchKey", searchKey);
        model.addObject("cmsVenue",cmsVenue);
        return model;
    }

    /**
     * 跳转到活动室回收站管理的页面
     *
     * @param record CmsActivityRoom 活动室信息模型
     * @param page Pagination 分页功能类
     * @param cmsVenue CmsVenue 场馆查询信息
     * @author cj
     * @date 2015-04-28
     * @return ModelAndView 页面及参数
     */
    @RequestMapping(value = "/roomRecycleList")
    public ModelAndView roomRecycleList(CmsActivityRoom record, String searchKey, Pagination page, CmsVenue cmsVenue) {
        ModelAndView model = new ModelAndView();
        List<CmsActivityRoom> list = null;
        if(cmsVenue != null){
            cmsVenue = cmsVenueService.queryVenueById(cmsVenue.getVenueId());
        }
        if(StringUtils.isNotBlank(searchKey)){
        	record.setSearchKey(searchKey);
        }
        try {
            SysUser sysUser = (SysUser) session.getAttribute("user");
            if(sysUser != null){
                record.setRoomIsDel(Constant.DELETE);
                record.setRoomState(Constant.TRASH);
                list = cmsActivityRoomService.queryCmsActivityRoomByCondition(record, cmsVenue, page, sysUser);
            }else{
                logger.error("当前登录用户不存在或没有登录，活动室列表请求操作终止!");
            }
        } catch (Exception e) {
            logger.error("加载活动室列表页面时出错!",e);
        }
        model.setViewName("admin/activityRoom/activityRoomRecycleList");
        model.addObject("list", list);
        model.addObject("page", page);
        model.addObject("record", record);
        model.addObject("searchKey", searchKey);
        model.addObject("cmsVenue",cmsVenue);
        return model;
    }


    /**
     * 跳转到添加活动室的页面
     *
     * @author cj
     * @date 2015-04-29
     * @return ModelAndView 页面及参数
     */
    @RequestMapping(value = "/preAddActivityRoom")
    public ModelAndView preAddActivityRoom(String venueId) {
        ModelAndView model = new ModelAndView();
        CmsVenue cmsVenue = null;
        if(StringUtils.isNotBlank(venueId)){
            cmsVenue = cmsVenueService.queryVenueById(venueId);
        }
        model.addObject("cmsVenue",cmsVenue);
        model.addObject("venueId", venueId);
        model.setViewName("admin/activityRoom/addActivityRoom");
        return model;
    }

    /**
     * 根绝前台传过来的属性添加活动室信息
     * 返回添加操作的返回值，后续跳转交由前台控制
     *
     * @param record CmsActivityRoom 团体会员
     * @author cj
     * @date 2015-04-28
     * @return String  操作成功为'success'、操作失败为'failure'
     */
    @RequestMapping(value = "/addActivityRoom")
    @ResponseBody
    public String addActivityRoom(CmsActivityRoom record,String allRoomDayStr,String []commonTag,String []childTag) {
        //默认为0，如果后续流程执行出错，则操作失败
        int count = 0;
        try {
            //从Session中获取当前登录的用户信息
            SysUser sysUser = (SysUser) session.getAttribute("user");
            if(sysUser != null){
                //执行馆藏信息入库操作
                count = cmsActivityRoomService.addCmsActivityRoom(record,sysUser,allRoomDayStr);
            }else{
                logger.error("当前登录用户不存在或没有登录，添加操作终止!");
            }
        } catch (Exception e) {
            logger.error("添加活动室信息时出错!", e);
        }
        if(count>0){
        	
        	String roomId=record.getRoomId();
        	
        	Integer type= Constant.TYPE_ACTIVITY_ROOM;
        	
        	cmsTagRelateService.insertTagRelateList(roomId, type, commonTag);
        	
        	cmsTagRelateService.insertTagRelateList(roomId, type, childTag);
        	
            return Constant.RESULT_STR_SUCCESS;
        }else {
            return Constant.RESULT_STR_FAILURE;
        }
    }

    /**
     * 跳转到修改活动室信息的页面
     *
     * @param roomId String 活动室ID
     * @author cj
     * @date 2015-04-29
     * @return ModelAndView 页面及参数
     */
    @RequestMapping(value = "/preEditActivityRoom")
    public ModelAndView preEditActivityRoom(String roomId,String venueId) {
        //准备返回显示视图与数据
        ModelAndView model = new ModelAndView();
        CmsActivityRoom cmsActivityRoom = null;
        CmsVenue cmsVenue = null;
        List<CmsRoomTime> roomTimeList = null;
        try {
            if(StringUtils.isNotBlank(roomId)){
                //根据馆藏ID查询馆藏信息
                cmsActivityRoom = cmsActivityRoomService.queryCmsActivityRoomById(roomId);
                //根据活动室场馆关联ID查询当前活动室所关联的场馆信息
                cmsVenue = cmsVenueService.queryVenueById(cmsActivityRoom.getRoomVenueId());

                CmsRoomTime cmsRoomTime = new CmsRoomTime();
                cmsRoomTime.setRoomId(roomId);
                roomTimeList = cmsRoomTimeService.queryRoomTimeByCondition(cmsRoomTime);
                
                List<CmsTagSubRelate> tagRelateList= cmsTagRelateService.queryTagRelateByEntityId(roomId);
                
                String [] roomTags=new String[tagRelateList.size()];
                
                for (int i = 0; i < tagRelateList.size(); i++) {
             	   
             	   CmsTagSubRelate relate= tagRelateList.get(i);
             	   String tagId=relate.getTagSubId();
             	  roomTags[i]=tagId;
                }
                
                model.addObject("roomTags",StringUtils.join(roomTags, ",")); 
            }else{
                logger.error("活动室ID为空，加载活动室信息处理终止!");
            }
        } catch (Exception e) {
            logger.error("加载活动室修改页面时出错!", e);
        }
        model.setViewName("admin/activityRoom/editActivityRoom");
        model.addObject("cmsActivityRoom", cmsActivityRoom);
        model.addObject("cmsVenue",cmsVenue);
        model.addObject("roomTimeList",roomTimeList);
        model.addObject("venueId", venueId);
        return model;
    }

    /**
     * 根绝前台传过来的属性修改活动室信息
     * 返回修改操作的返回值，后续跳转交由前台控制
     *
     * @param record CmsActivityRoom 活动室模型
     * @return String  操作成功为success、操作失败为failure
     */
    @RequestMapping(value = "/editActivityRoom", method = RequestMethod.POST)
    @ResponseBody
    public String editActivityRoom(CmsActivityRoom record,String allRoomDayStr,String []commonTag,String []childTag) {
        //默认为0，如果后续流程执行出错，则操作失败
        int count = 0;
        try {
            SysUser sysUser = (SysUser) session.getAttribute("user");
            if(sysUser != null){
                if(record != null && StringUtils.isNotBlank(record.getRoomId())){
                    //执行馆藏信息表数据更新操作
                    count= cmsActivityRoomService.editCmsActivityRoom(record,sysUser,allRoomDayStr,"0");
                }else{
                    logger.error("活动室信息或活动室ID为空，更新处理终止!");
                }
            }else{
                logger.error("当前登录用户不存在或没有登录，更新处理终止!");
            }
        } catch (Exception e) {
            logger.error("修改活动室信息时出错!", e);
        }
        if(count>0){
        	
        	   Set<String>tagSet=new HashSet<String>();
               tagSet.addAll(Arrays.asList(commonTag));
               tagSet.addAll(Arrays.asList(childTag));
               
               String roomId=record.getRoomId();
           	
           	Integer type= Constant.TYPE_VENUE;
           	
           	cmsTagRelateService.updateEntityTagRelateList(roomId, type, tagSet);
        	
            return Constant.RESULT_STR_SUCCESS;
        }else {
            return Constant.RESULT_STR_FAILURE;
        }
    }

    /**
     * 根据前台传入活动室ID进行逻辑删除操作
     * 返回删除操作的返回值，后续跳转交由前台控制
     *
     * @param roomId String 活动室ID
     * @author cj
     * @date 2015-04-29
     * @return String  操作成功为success、操作失败为failure
     */
    @RequestMapping(value = "/deleteActivityRoom")
    @ResponseBody
    public String deleteActivityRoom(String roomId) {
        //默认为0，如果后续流程执行出错，则操作失败
        int count = 0;
        try {
            SysUser sysUser = (SysUser) session.getAttribute("user");
            if(sysUser != null){
                if(StringUtils.isNotBlank(roomId)){
                    //根据馆藏ID查询馆藏信息
                    CmsActivityRoom cmsActivityRoom = cmsActivityRoomService.queryCmsActivityRoomById(roomId);
                    //执行馆藏信息表数据更新操作
                    count = cmsActivityRoomService.deleteCmsActivityRoom(cmsActivityRoom, sysUser);
                }else{
                    logger.error("活动室ID为空，更新处理终止!");
                }
            }else{
                logger.error("当前登录用户不存在或没有登录，更新处理终止!");
            }
        } catch (Exception e) {
            logger.error("逻辑删除活动室信息时出错!", e);
        }
        if(count>0){
            return Constant.RESULT_STR_SUCCESS;
        }else {
            return Constant.RESULT_STR_FAILURE;
        }
    }

    /**
     * 发布活动室
     *
     * @param roomId String 活动室ID
     * @author cj
     * @date 2015-04-28
     * @return String  操作成功为success、操作失败为failure
     */
    @RequestMapping(value = "/publishActivityRoom")
    @ResponseBody
    public String publishActivityRoom(String roomId) {
        //默认为0，如果后续流程执行出错，则操作失败
        int count = 0;
        try {
            //从Session中获取当前登录的用户信息
            SysUser sysUser = (SysUser) session.getAttribute("user");
            if(sysUser != null){
                count = cmsActivityRoomService.publishActivityRoom(roomId);
            }else{
                logger.error("当前登录用户不存在或没有登录，发布操作终止!");
            }
        } catch (Exception e) {
            logger.error("发布活动室信息时出错!", e);
        }
        if(count>0){
            return Constant.RESULT_STR_SUCCESS;
        }else {
            return Constant.RESULT_STR_FAILURE;
        }
    }

    /**
     * 还原活动室
     *
     * @param roomId String 活动室ID
     * @author cj
     * @date 2015-04-28
     * @return String  操作成功为success、操作失败为failure
     */
    @RequestMapping(value = "/backActivityRoom")
    @ResponseBody
    public String backActivityRoom(String roomId) {
        //默认为0，如果后续流程执行出错，则操作失败
        int count = 0;
        try {
            //从Session中获取当前登录的用户信息
            SysUser sysUser = (SysUser) session.getAttribute("user");
            if(sysUser != null){
                count = cmsActivityRoomService.backActivityRoom(roomId);
            }else{
                logger.error("当前登录用户不存在或没有登录，还原操作终止!");
            }
        } catch (Exception e) {
            logger.error("还原活动室信息时出错!", e);
        }
        if(count>0){
            return Constant.RESULT_STR_SUCCESS;
        }else {
            return Constant.RESULT_STR_FAILURE;
        }
    }

    /**
     * 根绝前台传过来的活动室ID进行单条查询
     * 返回活动室信息数据至团体信息查看页面
     *
     * @param roomId String 活动室ID
     * @author cj
     * @date 2015-04-29
     * @return ModelAndView 页面及参数
     */
    @RequestMapping(value = "/viewActivityRoom")
    public ModelAndView viewActivityRoom(String roomId) {
        //准备返回显示视图与数据
        ModelAndView model = new ModelAndView();
        CmsActivityRoom cmsActivityRoom = null;
        CmsVenue cmsVenue = null;
        try {
            if(StringUtils.isNotBlank(roomId)){
                //根据馆藏ID查询馆藏信息
                cmsActivityRoom = cmsActivityRoomService.queryCmsActivityRoomById(roomId);
                cmsVenue = cmsVenueService.queryVenueById(cmsActivityRoom.getRoomVenueId());
            }else{
                logger.error("活动室ID为空，查看处理终止!");
            }
        } catch (Exception e) {
            logger.error("加载活动室查看页面时出错!", e);
        }
        model.setViewName("admin/activityRoom/viewActivityRoom");
        model.addObject("record", cmsActivityRoom);
        model.addObject("cmsVenue",cmsVenue);
        return model;
    }


    //-------------------------------**********************-------------------------------
    /**
     * 将未来七天需要预定的票放入Redis中
     * @return
     */
    @RequestMapping(value = "/setRoomBookToRedis")
    @ResponseBody
    public int setRoomBookToRedis(){
        int result = 1;
        CmsActivityRoom cmsActivityRoom = new CmsActivityRoom();
        try {
            cmsActivityRoom.setRoomIsDel(Constant.NORMAL);
            cmsActivityRoom.setRoomState(Constant.PUBLISH);
            cmsActivityRoom.setRows(cmsActivityRoomService.queryCountByCmsActivityRoom(cmsActivityRoom));
            List<CmsActivityRoom> roomList = cmsActivityRoomService.queryByCmsActivityRoom(cmsActivityRoom);

            if(roomList != null && roomList.size() > 0){
                for (int i=0; i<roomList.size(); i++){
                    cmsActivityRoom = roomList.get(i);
                    //将未来七天的预定信息放入Redis
                    List<String> roomBookList = cmsRoomBookService.queryRoomBookDataToRedis(cmsActivityRoom.getRoomId(), 7);
                    //**********************************************************往Redis中放入活动室预定数据，活动室预定队列
                    Calendar calendar = Calendar.getInstance();
                    calendar.setTime(new Date());
                    //设置过期时间为当前时间之后的24小时
                    calendar.add(Calendar.HOUR_OF_DAY,24);
                    //将活动室预定信息放入Redis
                    cacheService.setRoomBookList(cmsActivityRoom.getRoomId(),roomBookList,calendar.getTime());

                    //将活动室队列放入内存中的一个set集合中
                    cacheService.saveActivityRoomToQueues(CacheConstant.ACTIVITY_ROOM_QUEUES, cmsActivityRoom.getRoomId() + "_N");
                    //**********************************************************往Redis中放入活动室预定数据，活动室预定队列
                }
            }
        } catch (Exception e) {
            logger.error("将预定信息放入Redis中失败!",e);
            result = 0;
        }
        return result;
    }

    /**
     * 系统初始化时，默认生成活动室未来七天的预定信息
     * @return
     */
    @RequestMapping(value = "/generateRoomBookInfo")
    @ResponseBody
    public int generateRoomBookInfo(){
        CmsActivityRoom cmsActivityRoom = new CmsActivityRoom();
        cmsActivityRoom.setRoomIsDel(Constant.NORMAL);
        cmsActivityRoom.setRoomState(Constant.PUBLISH);
        cmsActivityRoom.setRows(cmsActivityRoomService.queryCountByCmsActivityRoom(cmsActivityRoom));
        List<CmsActivityRoom> roomList = cmsActivityRoomService.queryByCmsActivityRoom(cmsActivityRoom);
        int result = cmsRoomBookService.initRoomBookInfo(roomList);
        return result;
    }

    /**
     * 生成七天后新一天的活动室预定信息
     * @return
     */
    @RequestMapping(value = "/generateRoomBookInfoOne")
    @ResponseBody
    public int generateRoomBookInfoOne(){
        CmsActivityRoom cmsActivityRoom = new CmsActivityRoom();
        cmsActivityRoom.setRoomIsDel(Constant.NORMAL);
        cmsActivityRoom.setRoomState(Constant.PUBLISH);
        cmsActivityRoom.setRows(cmsActivityRoomService.queryCountByCmsActivityRoom(cmsActivityRoom));
        List<CmsActivityRoom> roomList = cmsActivityRoomService.queryByCmsActivityRoom(cmsActivityRoom);
        int result = cmsRoomBookService.generateOneDayBookInfo(roomList);
        return result;
    }
    
    /**
     * 
     * @Description: 删除活动室（若该活动室被预定，则不能删除，否则删除至回收站）
     * @author yanghui 
     * @Created 2015-10-19
     * @param roomId
     * @return
     */
    @RequestMapping(value = "/preDeleteActivityRoom")
    @ResponseBody
    public Object preDeleteActivityRoom(String roomId) {
    	JSONObject json = new JSONObject();
        //默认为0，如果后续流程执行出错，则操作失败
        int count = 0;
        try {
            SysUser sysUser = (SysUser) session.getAttribute("user");
            if(sysUser != null){
                if(StringUtils.isNotBlank(roomId)){
                    CmsActivityRoom cmsActivityRoom = cmsActivityRoomService.queryCmsActivityRoomById(roomId);
                    if(cmsActivityRoom!=null){
                    	count = cmsRoomOrderService.queryRoomOrderCount(roomId);
                    	if(count<=0){ //说明该活动室没有被预订，直接删除到回收站
                    		 count = cmsActivityRoomService.deleteCmsActivityRoom(cmsActivityRoom, sysUser);
                    		 json.put("status", "2");
                    		 json.put("msg","数据已删除至回收站！");
                    	}else{
                    		json.put("status", "3");
                        	json.put("msg","该活动室已被预定，不能删除！");
                    	}
                    }else{
                    	json.put("status", "1");
                    	json.put("msg","该活动室不存在，请重新进入列表");
                    }
                }else{
                    logger.error("活动室ID为空，更新处理终止!");
                }
            }else{
            	json.put("status", "1");
            	json.put("msg","当前登录用户不存在或没有登录");
                logger.error("当前登录用户不存在或没有登录，更新处理终止!");
            }
        } catch (Exception e) {
            logger.error("逻辑删除活动室信息时出错!", e);
        }
     return json;
    }
    
    /**
     * 
     * @Description: 回收站删除活动室
     * @param roomId
     * @return
     */
    @RequestMapping(value = "/deleteRecycleActivityRoom")
    @ResponseBody
    public String deleteRecycleActivityRoom(String roomId) {
    	//默认为0，如果后续流程执行出错，则操作失败
        int count = 0;
        try {
            SysUser sysUser = (SysUser) session.getAttribute("user");
            if(sysUser != null){
                if(StringUtils.isNotBlank(roomId)){
                    count = cmsActivityRoomService.deleteRecycleActivityRoom(roomId);
                }else{
                    logger.error("活动室ID为空，更新处理终止!");
                }
            }else{
                logger.error("当前登录用户不存在或没有登录，更新处理终止!");
            }
        } catch (Exception e) {
            logger.error("删除活动室信息时出错!", e);
        }
        if(count>0){
            return Constant.RESULT_STR_SUCCESS;
        }else {
            return Constant.RESULT_STR_FAILURE;
        }
    }
    
    @RequestMapping(value = "/moveActivityRoom")
    @ResponseBody
    public String moveActivityRoom(String roomId) {
        int count = 0;
        String result = Constant.RESULT_STR_FAILURE;
        try{
            //从session中获取用户信息
            SysUser sysUser = (SysUser) session.getAttribute("user");
            if(sysUser != null){
                if(StringUtils.isNotBlank(roomId)) {
                
                	CmsActivityRoom cmsActivityRoom = cmsActivityRoomService.queryCmsActivityRoomById(roomId);
                    
                	if(cmsActivityRoom.getRoomIsDel()==Constant.NORMAL)
                	{
                		count=cmsActivityRoomService.pullActivityRoom(cmsActivityRoom,sysUser);
                	}
                	else if(cmsActivityRoom.getRoomIsDel()==Constant.PULL)
                	{
                	
                    	count=cmsActivityRoomService.pushActivityRoom(cmsActivityRoom,sysUser);
                	}
                	
                    
                    if (count > 0) {
                        result = Constant.RESULT_STR_SUCCESS;
                    }
                }
            }else{
                logger.error("用户没有登录，操作终止!");
                result="login";
            }
        }catch (Exception e){
            logger.info("场馆上/下架时出错!", e);
            result=Constant.RESULT_STR_FAILURE;
        }
        return result;
    }
    
    @RequestMapping(value = "/previewActivityRoom")
    @ResponseBody
    public ModelAndView preview(String roomName,
    		String roomPicUrl,
    		String roomTagName,
    		String roomIsFree,
    		String roomConsultTel,
    		String roomFee,
    		String roomArea,
    		Integer roomCapacity,
    		String roomFacilityInfo,
    		String roomRemark){
    	
        ModelAndView model = new ModelAndView();
        
        CmsActivityRoom cmsActivityRoom=new CmsActivityRoom();
        
        cmsActivityRoom.setRoomArea(roomArea);
        cmsActivityRoom.setRoomName(roomName);
        
        
        if(StringUtils.isNotBlank(roomPicUrl)){
        	cmsActivityRoom.setRoomPicUrl(staticServer.getStaticServerUrl()+roomPicUrl);
		}
        cmsActivityRoom.setRoomTagName(roomTagName);
        cmsActivityRoom.setRoomConsultTel(roomConsultTel);
        cmsActivityRoom.setRoomFee(roomFee);
        cmsActivityRoom.setRoomFacilityInfo(roomFacilityInfo);
        cmsActivityRoom.setRoomCapacity(roomCapacity);
        cmsActivityRoom.setRoomRemark(roomRemark);
         
        
        if(StringUtils.isNotBlank(roomIsFree))
         if(roomIsFree.equals( "yes")){
             //2为收费
        	 cmsActivityRoom.setRoomIsFree(2);
         }else{
             //1为免费
        	 cmsActivityRoom.setRoomIsFree(1);
         }
        
      
        model.addObject("activityRoom", cmsActivityRoom);
        model.setViewName("admin/activityRoom/roomDetail");
       
    	return model;
    }
}
