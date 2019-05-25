package com.sun3d.why.webservice.controller;
import com.sun3d.why.annotation.EmojiInspect;
import com.sun3d.why.annotation.SysBusinessLog;
import com.sun3d.why.model.CmsApplyJoinTeam;
import com.sun3d.why.model.CmsTeamUser;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.JSONResponse;
import com.sun3d.why.util.PaginationApp;
import com.sun3d.why.util.UUIDUtils;
import com.sun3d.why.webservice.service.ActivityRoomAppService;
import com.sun3d.why.webservice.service.RoomBookAppService;
import com.sun3d.why.webservice.service.TeamUserAppService;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import javax.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
/**
 * 手机app接口 活动室列表
 * Created by Administrator on 2015/7/4
 */
@RequestMapping("/appRoom")
@Controller
public class RoomAppController {
    private Logger logger = Logger.getLogger(ActivityAppController.class);
    @Autowired
    private ActivityRoomAppService activityRoomAppService;
    @Autowired
    private RoomBookAppService roomBookAppService;
    @Autowired
    private TeamUserAppService teamUserAppService;
    /**
     * app获取活动室详情
     * @param roomId 活动室id
     * @return json
     */
    @RequestMapping(value = "/roomAppDetail")
    @SysBusinessLog(remark="app获取活动室详情")
    public String roomAppDetail(HttpServletResponse response,String roomId) throws Exception {
        String json="";
        try {
            if(roomId!=null && StringUtils.isNotBlank(roomId)){
                json = activityRoomAppService.queryAppActivityRoomByRoomId(roomId);
            }else{
                json=JSONResponse.commonResultFormat(10108,"活动室id缺失!",null);
            }
        }catch (Exception e){
           e.printStackTrace();
            logger.info("query roomDetail error"+e.getMessage());
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(json);
        response.getWriter().flush();
        response.getWriter().close();
        return  null;
    }
    
    @RequestMapping(value = "/roomAllList")
    @SysBusinessLog(remark="app获取所有有效活动室列表")
    public String roomAllList(HttpServletResponse response,String []roomTag,
    		Integer roomAreaType,Integer roomCapacityType,
    		String []roomFacility,PaginationApp pageApp,
    		String pageIndex,String pageNum) throws Exception {
        String json="";
        try {
        	 pageApp.setFirstResult(Integer.valueOf(pageIndex));
             pageApp.setRows(Integer.valueOf(pageNum));
        	
             json = activityRoomAppService.queryAllAppActivityRoomListById(roomTag, roomAreaType, roomCapacityType, roomFacility, pageApp);
        }catch (Exception e){
           e.printStackTrace();
            logger.info("query roomAllList error"+e.getMessage());
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(json);
        response.getWriter().flush();
        response.getWriter().close();
        return  null;
    }

    /**
     * app预定活动室 获取返回参数
     * @param roomId 活动室id
     * @param orderRoomDate 预定日期
     * @param openPeriod 预定时间段
     * @return json
     */
    @RequestMapping(value = "/roomBook")
    public String roomBook(HttpServletResponse response,String roomId,String bookId,String userId) throws Exception {
        String json = "";
        try {
            if(StringUtils.isBlank(roomId)) {
            	json=  JSONResponse.commonResultFormat(14101, "活动室id缺失", null);
            }else if(StringUtils.isBlank(bookId))
            {
            	json=  JSONResponse.commonResultFormat(14102, "活动室预定id缺失", null);
            }else if(StringUtils.isBlank(userId))
            {
            	json=  JSONResponse.commonResultFormat(10111, "用户id缺失", null);
            }
            else{
                
                json=roomBookAppService.queryAppRoomBookByCondition(roomId,bookId, userId);
            }
        } catch (Exception e) {
            json=JSONResponse.commonResultFormat(500, "系统错误", null);
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(json);
        response.getWriter().flush();
        response.getWriter().close();
        return  null;
    }


    /**
     * app活动室确定订单成功
     * @param bookId 订单id
     * @param teamUserId 团体用户id
     * @param userId 用户id
     * @param orderName 预定人姓名
     * @param orderTel 预定电话
     * @return 15110预定场次id缺失
     * @throws Exception
     */
    @RequestMapping(value = "/roomOrderConfirm")
    @EmojiInspect
    public String roomOrderConfirm(HttpServletResponse response,
    								String bookId,
    								String tuserId,
    								String tuserName,
    								String userId,
    								String orderName,
    								String orderTel,
    								String purpose) throws Exception {
    	
       // JSONObject  jsonObject=new JSONObject();
        String json="";
      
        if(bookId != null && StringUtils.isNotBlank(bookId)){
              json=roomBookAppService.appRoomOrderByCondition(bookId, tuserId,tuserName, userId, orderName, orderTel,purpose);
         
        }else{
           json=JSONResponse.commonResultFormat(15110, "活动室预定id缺失!", null);
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }

    /**
     * 根据用户id判断用户是否是团体用户
     * @param userId 用户id
     * return
     */
    @RequestMapping(value = "/roomTeamUser")
    public String roomTeamUser(HttpServletResponse response,String userId) throws Exception {
        String json="";
        if(userId!=null &&  StringUtils.isNotBlank(userId)) {
             json=teamUserAppService.queryAppTeamUserList(userId);
        }
        else{
            json=JSONResponse.commonResultFormat(10111,"用户id为空!",null);
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }
    
    /**
     * 活动室预定中添加使用者
     * 
     * @param response
     * @param userId
     * @param roomOrderId
     * @param tuserName
     * @param userTpe
     * @param tag
     * @param year
     * @param tuserTeamRemark
     * @param tuserPicture
     * @param tuserTeamType
     * @param tuserLimit
     * @param teamUserDetailPics
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/addRoomTeamUser")
    @EmojiInspect
    public String addRoomTeamUser(HttpServletResponse response,
    		String userId,
    		String roomOrderId,
    		String tuserName,
    		Integer userType,
    		String tag,
    		Integer year,
    		String tuserTeamRemark,
    		String tuserPicture,
    		String tuserTeamType,
    		Integer tuserLimit,
    		String [] teamUserDetailPics)throws Exception {
        String json="";
        
        if(StringUtils.isBlank(tuserName))
        {
        	json=JSONResponse.commonResultFormat(10001,"使用者名称为空!",null);
        }else if(StringUtils.isBlank(userId))
        {
        	json=JSONResponse.commonResultFormat(10002,"用户为空!",null);
        }
        else
        {
        	CmsTeamUser teamUser =new CmsTeamUser();
        	
        	  //添加团体时，默认赋值
        	teamUser.setTuserId(UUIDUtils.createUUId());
        	teamUser.settUpdateUser(userId);
        	teamUser.settUpdateTime(new Date());
        	teamUser.settCreateTime(new Date());
        	teamUser.settCreateUser(userId);
        	teamUser.setTuserIsVenue(Constant.NORMAL);
        	teamUser.setTuserIsActiviey(Constant.NORMAL);
        	teamUser.setUserId(userId);
        	teamUser.setTuserUserType(userType);
        	teamUser.setTuserTag(tag);
        	teamUser.setTuserName(tuserName);
        	teamUser.setTuserYear(year);
        	teamUser.setTuserTeamRemark(tuserTeamRemark);
        	teamUser.setTuserPicture(tuserPicture);
        	teamUser.setTuserTeamType(tuserTeamType);
        	teamUser.setTuserLimit(tuserLimit);
        	
        	 json=teamUserAppService.addCmsTeamUser(teamUser, teamUserDetailPics, roomOrderId);
        	
        }
        
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }
}