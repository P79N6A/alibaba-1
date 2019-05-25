package com.sun3d.why.controller.wechat;

import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.sun3d.why.annotation.EmojiInspect;
import com.sun3d.why.model.CmsRoomOrder;
import com.sun3d.why.model.CmsTeamUser;
import com.sun3d.why.model.CmsTeamUserDetailPic;
import com.sun3d.why.model.CmsTerminalUser;
import com.sun3d.why.service.CacheService;
import com.sun3d.why.service.CmsRoomOrderService;
import com.sun3d.why.service.CmsTeamUserDetailPicService;
import com.sun3d.why.service.CmsTeamUserService;
import com.sun3d.why.util.BindWS;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.JSONResponse;
import com.sun3d.why.util.UUIDUtils;
import com.sun3d.why.webservice.service.ActivityRoomAppService;
import com.sun3d.why.webservice.service.TeamUserAppService;

@RequestMapping("/wechatRoom")
@Controller
public class WechatRoomController {
	private Logger logger = LoggerFactory.getLogger(WechatRoomController.class);
	
	@Autowired
    private ActivityRoomAppService activityRoomAppService;

    @Autowired
    private HttpSession session ;

    @Autowired
    private CmsTeamUserService cmsTeamUserService;
    
    @Autowired
    private CacheService cacheService;
    
    @Autowired
    private TeamUserAppService teamUserAppService;
    
    @Autowired
    private CmsRoomOrderService roomOrderService;
    
    @Autowired
    private CmsTeamUserService teamUserService;
    
    @Autowired
    private CmsTeamUserDetailPicService teamUserDetailPicService;
	
    /**
     * 活动室列表页
     * @param venueId
     * @return
     */
    @RequestMapping("/preRoomList")
    public String preRoomList(HttpServletRequest request, String venueId){

        //从session中获取登录用户
        CmsTerminalUser cmsTerminalUser = (CmsTerminalUser)session.getAttribute("terminalUser");
        List<CmsTeamUser> teamUserList = null;
        if(cmsTerminalUser != null&& cmsTerminalUser.getUserId()!=null){
            teamUserList = cmsTeamUserService.queryTeamUserList(cmsTerminalUser.getUserId());
        }
        request.setAttribute("teamUserList",teamUserList);
    	 request.setAttribute("venueId", venueId);
         return "wechat/room/roomList";
    }
    
    /**
     * 活动室详情页
     * @param roomId
     * @return
     */
    @RequestMapping("/preRoomDetail")
    public String preRoomDetail(HttpServletRequest request, String roomId){
    	//微信权限验证配置
   	    String url = BindWS.getUrl(request);
        Map<String, String> sign = BindWS.sign(url,cacheService);
        request.setAttribute("sign", sign);

        //从session中获取登录用户
        CmsTerminalUser cmsTerminalUser = (CmsTerminalUser)session.getAttribute("terminalUser");
//        List<CmsTeamUser> teamUserList = null;
//        if(cmsTerminalUser.getUserId() != null){
//            teamUserList = cmsTeamUserService.queryTeamUserList(cmsTerminalUser.getUserId());
//        }
        //request.setAttribute("teamUserList",teamUserList);
    	 request.setAttribute("roomId", roomId);
         return "wechat/room/roomDetail";
    }
    
    /**
     * 跳转活动室订单详情
     * @return
     * @authours
     * @date 2016/2/22
     * @content add
     */
    @RequestMapping(value = "/roomOrderDetail")
    public String roomOrderDetail(HttpServletRequest request,@RequestParam String roomOrderId){
    	
   
    	CmsRoomOrder roomOrder=roomOrderService.queryCmsRoomOrderById(roomOrderId);
    	
    	request.setAttribute("roomOrderId",roomOrderId);
    	
    	request.setAttribute("userId", roomOrder.getUserId());

        return "wechat/room/roomOrderDetail";
    }
    
    
    /**
     * weChat获取活动室详情
     * @param roomId 活动室id
     * @return json
     */
    @RequestMapping(value = "/roomWcDetail")
    public String roomWcDetail(HttpServletResponse response,String roomId) throws Exception {
        String json="";
        if(roomId!=null && StringUtils.isNotBlank(roomId)){
            json = activityRoomAppService.queryAppActivityRoomByRoomId(roomId);
        }else{
            json=JSONResponse.commonResultFormat(10108,"活动室id缺失!",null);
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(json);
        response.getWriter().flush();
        response.getWriter().close();
        return  null;
    }

    //认证使用者页面
    @RequestMapping(value = "/authTeamUser")
    public ModelAndView authTeamUser(HttpServletRequest request,String userId,
    		String roomOrderId ,String tuserName,String type,String tuserId){
    	
    	 ModelAndView model = new ModelAndView();
    	
    	 if(StringUtils.isNotBlank(roomOrderId)){
    		 CmsRoomOrder roomOrder= roomOrderService.queryCmsRoomOrderById(roomOrderId);
    		 tuserName=roomOrder.getTuserName();
    		 if(StringUtils.isNotBlank(roomOrder.getTuserId())){
    			 tuserId = roomOrder.getTuserId();
    		 }
    	 }
    	 
    	 if(StringUtils.isNotBlank(userId)){
    		 model.addObject("userId", userId);
     	}else{
     		CmsTerminalUser cmsTerminalUser = (CmsTerminalUser)session.getAttribute(Constant.terminalUser);
     		 model.addObject("userId", cmsTerminalUser.getUserId());
     	}
    	 
    	 
    	 //微信权限验证配置
         String url = BindWS.getUrl(request);
         Map<String, String> sign = BindWS.sign(url,cacheService);
         request.setAttribute("sign", sign);
         request.setAttribute("type", type);
         
    	 model.addObject("roomOrderId", roomOrderId);
    	 model.addObject("tuserName", tuserName);
    	 
    	 if(StringUtils.isNotBlank(tuserId)){
    		 CmsTeamUser teamUser=teamUserService.queryTeamUserById(tuserId);
    		 List<CmsTeamUserDetailPic>teamUserDetailPics=teamUserDetailPicService.queryCmsTeamUserDetailByTuserId(tuserId);
    		 model.addObject("teamUser", teamUser);
    		 model.addObject("teamUserDetailPics", teamUserDetailPics);
    		 model.setViewName("wechat/venue/authTeamUserEdit");
    	 }else{
    		 model.setViewName("wechat/venue/authTeamUser");
    	 }
    	 
    	 return model;
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
    		String tuserId,
    		String userId,
    		String roomOrderId,
    		String tuserName,
    		String tuserTag,
    		Integer tuserYear,
    		String tuserTeamRemark,
    		String tuserPicture,
    		String tuserTeamType,
    		Integer tuserUserType,
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
        else if(StringUtils.isBlank(tuserId))
        {
        	CmsTeamUser teamUser =new CmsTeamUser();
        	
        	  //添加团体时，默认赋值
        	teamUser.setTuserId(UUIDUtils.createUUId());
        	teamUser.setUserId(userId);
        	teamUser.settUpdateUser(userId);
        	teamUser.settUpdateTime(new Date());
        	teamUser.settCreateTime(new Date());
        	teamUser.settCreateUser(userId);
        	teamUser.setTuserIsVenue(Constant.NORMAL);
        	teamUser.setTuserIsActiviey(Constant.NORMAL);
        	teamUser.setTuserIsDisplay(0);
        	teamUser.setTuserUserType(tuserUserType);
        	teamUser.setTuserTag(tuserTag);
        	teamUser.setTuserName(tuserName);
        	teamUser.setTuserYear(tuserYear);
        	teamUser.setTuserTeamRemark(tuserTeamRemark);
        	teamUser.setTuserTeamType(tuserTeamType);
        	teamUser.setTuserLimit(tuserLimit);
        	
        	if(StringUtils.isNotBlank(tuserPicture)){
              	
                int index=tuserPicture.indexOf("front");
                tuserPicture = tuserPicture.substring(index,tuserPicture.length());
                teamUser.setTuserPicture(tuserPicture);
            }  
        	
        	 json=teamUserAppService.addCmsTeamUser(teamUser, teamUserDetailPics, roomOrderId);
        	
        }
        else{
        	
        	CmsTeamUser teamUser=teamUserService.queryTeamUserById(tuserId);
        	
        	teamUser.settUpdateUser(userId);
        	teamUser.settUpdateTime(new Date());
        	teamUser.setTuserUserType(tuserUserType);
        	teamUser.setTuserTag(tuserTag);
        	teamUser.setTuserName(tuserName);
        	teamUser.setTuserYear(tuserYear);
        	teamUser.setTuserTeamRemark(tuserTeamRemark);
        	teamUser.setTuserTeamType(tuserTeamType);
        	teamUser.setTuserLimit(tuserLimit);
        	
        	if(StringUtils.isNotBlank(tuserPicture)){
              	
                int index=tuserPicture.indexOf("front");
                tuserPicture = tuserPicture.substring(index,tuserPicture.length());
                teamUser.setTuserPicture(tuserPicture);
            }  
        	else
        	{
        		 teamUser.setTuserPicture("");
        	}
        	
        	json=teamUserAppService.editCmsTeamUser(teamUser, teamUserDetailPics, roomOrderId);
        }
        	
        
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }
}
