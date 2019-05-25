package com.sun3d.why.controller.wechat;


import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.culturecloud.model.request.micronote.CcpMicronoteReqVO;
import com.sun3d.why.annotation.EmojiInspect;
import com.sun3d.why.model.CmsActivityRoom;
import com.sun3d.why.model.CmsRoomBook;
import com.sun3d.why.model.CmsRoomOrder;
import com.sun3d.why.model.CmsTagSub;
import com.sun3d.why.model.CmsTerminalUser;
import com.sun3d.why.model.CmsVenue;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.service.CacheService;
import com.sun3d.why.service.CmsActivityRoomService;
import com.sun3d.why.service.CmsRoomBookService;
import com.sun3d.why.service.CmsRoomOrderService;
import com.sun3d.why.service.CmsTagSubService;
import com.sun3d.why.service.CmsTeamUserService;
import com.sun3d.why.service.CmsTerminalUserService;
import com.sun3d.why.service.CmsVenueService;
import com.sun3d.why.statistics.service.StatisticVenueUserService;
import com.sun3d.why.util.BindWS;
import com.sun3d.why.util.CallUtils;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.DateUtils;
import com.sun3d.why.util.JSONResponse;
import com.sun3d.why.util.PaginationApp;
import com.sun3d.why.webservice.api.util.HttpResponseText;
import com.sun3d.why.webservice.service.ActivityAppService;
import com.sun3d.why.webservice.service.ActivityRoomAppService;
import com.sun3d.why.webservice.service.CollectAppService;
import com.sun3d.why.webservice.service.RoomBookAppService;
import com.sun3d.why.webservice.service.TagAppService;
import com.sun3d.why.webservice.service.VenueAppService;


@RequestMapping("/wechatVenue")
@Controller
public class WechatVenueController {
    private Logger logger = Logger.getLogger(WechatVenueController.class);
    @Autowired
    private VenueAppService venueAppService;
    @Autowired
    private TagAppService tagAppService;
    @Autowired
    private ActivityRoomAppService activityRoomAppService;
    @Autowired
    private ActivityAppService activityAppService;
    @Autowired
    private CacheService cacheService;
    @Autowired
    private CollectAppService collectAppService;
    @Autowired
    private StatisticVenueUserService statisticVenueUserService;
    @Autowired
    private CmsRoomBookService cmsRoomBookService;
    @Autowired
    private CmsTagSubService cmsTagSubService;
    @Autowired
    private HttpSession session;

    @Autowired
    private CmsTeamUserService cmsTeamUserService;

    @Autowired
    private CmsActivityRoomService cmsActivityRoomService;

    @Autowired
    private CmsVenueService cmsVenueService;
    
    @Autowired
    private RoomBookAppService roomBookAppService;
    
    @Autowired
    private CmsRoomOrderService roomOrderService;
    
    @Autowired
    private CmsActivityRoomService activityRoomService;
    
    @Autowired
    private CmsTerminalUserService terminalUserService;
    
    @Autowired
	private StaticServer staticServer;
    
    /**场馆首页
     * @return
     */
    @RequestMapping("/venueIndex")
    public ModelAndView venueIndex(HttpServletRequest request){
    	//微信权限验证配置
    	String url = BindWS.getUrl(request);
        Map<String, String> sign = BindWS.sign(url,cacheService);
        request.setAttribute("sign", sign);
        ModelAndView model = new ModelAndView();
        model.setViewName("wechat/venue/venue");
        return model;
    }

    /**跳转到搜索页
     * @return
     */
    @RequestMapping("/venueTagPage")
    public ModelAndView venueTagPage(){
        ModelAndView model = new ModelAndView();
        model.setViewName("wechat/venue/venue_search");
        return model;
    }

    /**
     * wechat场馆首页
     * @param response
     * @param Lon
     * @param Lat
     * @param venueType
     * @param venueArea
     * @param venueIsReserve
     * @param sortType
     * @throws Exception
     */
    @RequestMapping(value = "/wcVenueList")
    public void wcVenueList(HttpServletResponse response, String pageIndex, String pageNum, PaginationApp pageApp, String Lon, String Lat, String venueType,
    			String venueArea, String venueMood, String venueIsReserve, String sortType,String tagSubId) throws Exception{
		pageApp.setFirstResult(Integer.valueOf(pageIndex));
		pageApp.setRows(Integer.valueOf(pageNum));
		String json = "";
		try {
		json = venueAppService.queryAppVenueList(pageApp, venueArea, venueMood, venueType, sortType, venueIsReserve,tagSubId, Lon, Lat);
		}catch (Exception e){
		json = JSONResponse.toAppResultFormat(10107, e.getMessage());
		logger.info("query appRecommendActivity error:"+e.getMessage());
		}
		response.setContentType("text/html;charset=UTF-8");
		response.getWriter().write(json);
		response.getWriter().flush();
		response.getWriter().close();
	}
    
    /**
     * wechat根据条件筛选场馆(搜索功能)
     * @param response
     * @param venueType
     * @param venueArea
     * @param venueName
     * @param pageIndex
     * @param pageNum
     * @param pageApp
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/wcCmsVenueList")
    public String wcCmsVenueList(HttpServletResponse response,String venueType, String venueArea, String venueName,String tagSubId, String pageIndex, String pageNum, PaginationApp pageApp) throws Exception {
        pageApp.setFirstResult(Integer.valueOf(pageIndex));
        pageApp.setRows(Integer.valueOf(pageNum));
        String json="";
        try {
            json = venueAppService.queryAppCmsVenueList(pageApp, venueType, venueArea, venueName,tagSubId);
        }catch (Exception e){
            json = JSONResponse.toAppResultFormat(10107, e.getMessage());
            logger.info("query appCmsActivityUserWantgoCount error"+e.getMessage());
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }
    
    /**
     * 微信获取展馆标签名称
     * @return json
     */
    @RequestMapping(value = "/venueTagByType")
    public String venueTagByType(HttpServletResponse response) throws Exception {
        String json="";
        try {
            json=tagAppService.queryCmsActivityTagByCondition(Constant.VENUE_TYPE,null,Constant.VENUE_CROWD);
        }catch (Exception e) {
            e.printStackTrace();
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }

    /**
     * 跳转到展馆详情页
     * @return json
     */
    @RequestMapping(value = "venueDetailIndex")
    public ModelAndView venueDetailIndex(HttpServletRequest request,String venueId,String type){
        ModelAndView model = new ModelAndView();
        //微信权限验证配置
  	    String url = BindWS.getUrl(request);
        Map<String, String> sign = BindWS.sign(url,cacheService);
        request.setAttribute("sign", sign);
        
        //从session中获取登录用户
//        CmsTerminalUser cmsTerminalUser = (CmsTerminalUser)session.getAttribute(Constant.terminalUser);
//        List<CmsTeamUser> teamUserList = null;
//
//        try{
//            if(cmsTerminalUser.getUserId() != null){
//                teamUserList = cmsTeamUserService.queryTeamUserList(cmsTerminalUser.getUserId());
//            }
//        }catch (Exception e){
//            e.printStackTrace();
//        }
//
//        request.setAttribute("teamUserList",teamUserList);
        
        request.setAttribute("type", type);
        request.setAttribute("venueId", venueId);
        request.setAttribute("cityName", staticServer.getCityInfo().split(",")[1]);
        model.setViewName("wechat/venue/venue_detail");
        return model;
    }

    /**
     * wechat查看查看展馆详情
     * @param userId    当前用户ID
     * @param venueId   展馆id
     * @return json    10108：展馆id缺失
     */
    @RequestMapping(value = "/venueDetail")
    public String venueDetail(HttpServletResponse response,String userId,String venueId) throws Exception {
    	 String json="";
         try {
             if(StringUtils.isNotBlank(venueId) && venueId!=null) {
                 json=venueAppService.queryAppCmsVenueDetailById(venueId, userId);
             }else {
                 json=JSONResponse.commonResultFormat(10108,"展馆id缺失!",null);
             }
         } catch (Exception e) {
             json=JSONResponse.commonResultFormat(10109,"系统错误!",null);
         }
         response.setContentType("text/html;charset=UTF-8");
         response.getWriter().print(json);
         return null;
    }

    /**
     * 根据展馆id获取活动室列表
     * @param venueId  展馆id
     * @param pageIndex  首页下标
     * @param pageNum    显示条数
     * @return 10108:展馆id缺失
     * @throws Exception
     */
    @RequestMapping(value = "/activityWcRoom")
    public String activityWcRoom(HttpServletResponse response,PaginationApp pageApp,String venueId,String pageIndex,String  pageNum) throws Exception {
        String json="";
        pageApp.setFirstResult(Integer.valueOf(pageIndex));
        pageApp.setRows(Integer.valueOf(pageNum));
        if(venueId!=null && StringUtils.isNotBlank(venueId)) {
            json = activityRoomAppService.queryAppActivityRoomListById(venueId,pageApp);
        }else{
            json=JSONResponse.commonResultFormat(10108,"展馆id缺失!",null);
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }

    /**
     * wechat根据展馆id查询相关活动
     * @param venueId  展馆id
     * @param pageIndex  首页下标
     * @param pageNum    显示条数
     * @return json 10108:展馆id缺失
     * @throws Exception
     */
    @RequestMapping(value = "/venueWcActivity")
    public String venueWcActivity(HttpServletResponse response,String venueId,String pageIndex,String pageNum,PaginationApp pageApp) throws Exception {
        String json="";
        if(pageIndex!=null&&pageNum!=null){
        	pageApp.setFirstResult(Integer.valueOf(pageIndex));
            pageApp.setRows(Integer.valueOf(pageNum));
        }
        if(venueId!=null && StringUtils.isNotBlank(venueId)){
            json = activityAppService.queryAppCmsActivityListById(venueId, pageApp);
        }else {
            json=JSONResponse.toAppResultFormat(10108,"展馆id缺失!");
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }
    
    /**
     * wechat根据展馆id查询相关(历史)活动
     * @param venueId  展馆id
     * @param pageIndex  首页下标
     * @param pageNum    显示条数
     * @return json 10108:展馆id缺失
     * @throws Exception
     */
    @RequestMapping(value = "/venueWcHisActivity")
    public String venueWcHisActivity(HttpServletResponse response,String venueId,String pageIndex,String pageNum,PaginationApp pageApp) throws Exception {
        String json="";
        if(pageIndex!=null&&pageNum!=null){
        	pageApp.setFirstResult(Integer.valueOf(pageIndex));
            pageApp.setRows(Integer.valueOf(pageNum));
        }
        if(venueId!=null && StringUtils.isNotBlank(venueId)){
            json = activityAppService.queryHisActivityListByVenueId(venueId, pageApp);
        }else {
            json=JSONResponse.toAppResultFormat(10108,"展馆id缺失!");
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }

    /**
     * 场馆搜索结果页
     * @param venueType
     * @param venueIsReserve
     * @param venueArea
     * @param venueName
     * @return
     */
    @RequestMapping("/preVenueList")
    public String preVenueList(HttpServletRequest request, String venueType, String venueIsReserve, String venueArea, String venueName){
    	//微信权限验证配置
    	String url = BindWS.getUrl(request);
        Map<String, String> sign = BindWS.sign(url,cacheService);
        request.setAttribute("sign", sign);
        request.setAttribute("venueType", venueType);
        request.setAttribute("venueIsReserve", venueIsReserve);
        request.setAttribute("venueArea", venueArea);
        try {
            if(StringUtils.isNotBlank(venueName)){
                venueName = URLDecoder.decode(venueName,"UTF-8");
            }
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
        request.setAttribute("venueName", venueName);
        return "wechat/venue/venueList";
    }
    
    /**
     * 类别搜索场馆页（Iframe用）
     * @param venueType
     * @return
     */
    @RequestMapping("/preVenueListIframe")
    public String preVenueListIframe(HttpServletRequest request, String venueType){
    	//微信权限验证配置
    	String url = BindWS.getUrl(request);
        Map<String, String> sign = BindWS.sign(url,cacheService);
        request.setAttribute("sign", sign);
        request.setAttribute("venueType", venueType);
        return "wechat/venue/venueListIframe";
    }
    
    /**
     * 通过标签查场馆页
     * @param request
     * @param tagSubId
     * @return
     */
    @RequestMapping("/preVenueListTagSub")
    public String tagVenueList(HttpServletRequest request,@RequestParam String tagSubId){
    	//微信权限验证配置
    	String url = BindWS.getUrl(request);
        Map<String, String> sign = BindWS.sign(url,cacheService);
        request.setAttribute("sign", sign);
        
        CmsTagSub tagSub= cmsTagSubService.queryById(tagSubId);
        if(tagSub==null)
        {
        	tagSub=new CmsTagSub();
        	 tagSub.setTagSubId(tagSubId);
        }
        request.setAttribute("tagSub", tagSub);
        return "wechat/venue/venueListTagSub";
    }

    /**
     * wechat用户收藏展馆
     * @param userId 用户id
     * @param venueId 展馆id
     * @return json 10121 用户id 或 活动id缺失 10122 展馆收藏成功 0.收藏展馆成功 1.收藏展馆失败 10123.查无此人
     * @throws Exception
     */
    @RequestMapping(value = "/wcCollectVenue")
    public String wcCollectVenue(HttpServletRequest request, HttpServletResponse response,String userId,String venueId) throws Exception {
        String json = "";
        try {
            if (StringUtils.isNotBlank(userId) && StringUtils.isNotBlank(venueId)) {
                json=collectAppService.addCollectVenue(userId, venueId, request, statisticVenueUserService);
            } else {
                json = JSONResponse.commonResultFormat(10121, "用户或展馆id缺失", null);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().print(json);
        return null;
    }
    
    /**
     * wechat用户取消收藏展馆
     * @param userId 用户id
     * @param venueId 展馆id
     * @return
     */
    @RequestMapping(value = "/wcDelCollectVenue")
    public String wcDelCollectVenue(HttpServletRequest request, HttpServletResponse response,String userId,String venueId) throws Exception {
        String json="";
        try {
            if(StringUtils.isNotBlank(userId) && StringUtils.isNotBlank(venueId)){
                json=collectAppService.delCollectVenue(userId, venueId, request, statisticVenueUserService);
            }
            else {
                json=JSONResponse.commonResultFormat(10121,"用户或展馆id缺失!",null);
            }
        }catch (Exception e){
            e.printStackTrace();
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().print(json);
        return null;
    }

    /**
     * 活动室预定
     * 
     * @param roomId
     * @param bookId
     * @return
     * @throws IOException 
     */
    @RequestMapping(value = "/roomBook")
    public String roomBook(HttpServletRequest request,HttpServletResponse response,@RequestParam String roomId,@RequestParam String bookId) throws IOException{
    	
    	String json = "";
    	
    	CmsTerminalUser terminalUser = (CmsTerminalUser)session.getAttribute(Constant.terminalUser);
    	String userId = "";
		if(terminalUser==null){
			userId = request.getParameter("userId");
		}else{
			userId = terminalUser.getUserId();
		}
    	json = roomBookAppService.queryAppRoomBookByCondition(roomId, bookId, userId);
    	
        response.setContentType("text/html;charset=UTF-8");
       
        response.getWriter().write(json);
        response.getWriter().flush();
        response.getWriter().close();
        
        return null;
    }
    
    
    @RequestMapping(value = "/roomBookOrder")
    public ModelAndView roomBookOrder(HttpServletRequest request,@RequestParam String roomId,@RequestParam String bookId ){
    	
    	 ModelAndView model = new ModelAndView();
    	 
    	 CmsTerminalUser terminalUser = (CmsTerminalUser)session.getAttribute(Constant.terminalUser);

    	 if(terminalUser!= null){
    		 model.addObject("userName", terminalUser.getUserName());
    		 model.addObject("userNickName", terminalUser.getUserNickName());
        	 model.addObject("userTelephone", terminalUser.getUserTelephone());
    	 }else{
    		 String userId = request.getParameter("userId");
    		 terminalUser  = terminalUserService.queryTerminalUserById(userId);
        	 model.addObject("userName", terminalUser.getUserName());
        	 model.addObject("userNickName", terminalUser.getUserNickName());
        	 model.addObject("userTelephone", terminalUser.getUserTelephone());
    	 }
    		 
    	 model.addObject("roomId", roomId);
    	 model.addObject("bookId", bookId);
    	 model.setViewName("wechat/venue/roomBook");
    	 return model;
    } 
    
   
    
    //提交订单
    @RequestMapping(value = "/roomOrderConfirm")
    @EmojiInspect
    public String roomOrderConfirm(HttpServletRequest request,HttpServletResponse response,@RequestParam String bookId,String orderName,String orderTel,String tuserName,String tuserId,String purpose) throws IOException{
    	
    	 String json="";
    	
         //当前登录用户ID
         CmsTerminalUser terminalUser = (CmsTerminalUser)session.getAttribute(Constant.terminalUser);
         
         String userId = "";
         if(terminalUser==null){
        	 userId = request.getParameter("userId");
         }else{
        	 userId = terminalUser.getUserId();
         }
               //  tmpCmsRoomBook.setSysId(cmsRoomBook.getSysId());
                // tmpCmsRoomBook.setSysNo(cmsRoomBook.getSysNo());
                 //订单成功后的一系列操作
         try {
			
        	  json= roomBookAppService.appRoomOrderByCondition(bookId, tuserId, tuserName, userId, orderName, orderTel, purpose);
              
              logger.info("结束场馆预订时间!"+DateUtils.formatDate(new Date()));
              
		} catch (Exception e) {
			 logger.info("场馆预订失败!"+e.getMessage());
			 
			 json= JSONResponse.toAppResultFormat(2, "系统异常，预订失败!");
		}
         
       
 /*      model.setViewName("wechat/venue/roomOrderResult");
         model.addObject("cmsActivityRoom",cmsActivityRoom);
         model.addObject("cmsRoomBook",tmpCmsRoomBook);
         model.addObject("cmsVenue",cmsVenue);*/
         
         response.setContentType("text/html;charset=UTF-8");
         
         response.getWriter().write(json);
         response.getWriter().flush();
         response.getWriter().close();
    	
         return null;
    }
    
    /**
     * 订单完成
     * 
     * @param cmsRoomOrderId
     * @param roomName
     * @param orderName
     * @param tuserName
     * @param date
     * @param venueName
     * @param userType
     * @param tuserIsDisplay
     * @param orderTel
     * @param openPeriod
     * @return
     */
    @RequestMapping(value = "/roomOrderComplete")
    public ModelAndView roomOrderComplete(
    		String cmsRoomOrderId,
    		String date,
    		Integer userType,
    		Integer tuserIsDisplay,
    		String orderTel,
    		String openPeriod
    		){
    	
   	 ModelAndView model = new ModelAndView();    
   	 
   	 CmsRoomOrder cmsRoomOrder =roomOrderService.queryCmsRoomOrderById(cmsRoomOrderId);
    	 
    	 CmsRoomBook cmsRoomBook = cmsRoomBookService.queryCmsRoomBookById(cmsRoomOrder.getBookId());
    	 
    	 model.addObject("date", this.getBookDateStr(cmsRoomBook.getCurDate(),cmsRoomBook.getDayOfWeek()));
//         
        CmsActivityRoom cmsActivityRoom  = activityRoomService.queryCmsActivityRoomById(cmsRoomOrder.getRoomId());
         
         CmsVenue cmsVenue = cmsVenueService.queryVenueById(cmsActivityRoom.getRoomVenueId());
//    	 
//    	 cmsRoomOrder.getRoomName()
//    	 
    	 model.addObject("roomOrderId", cmsRoomOrderId);
//    	 
    	 model.addObject("roomName", cmsActivityRoom.getRoomName());
//    	 
    	 model.addObject("venueName", cmsVenue.getVenueName());
    	 
    	 model.addObject("openPeriod", openPeriod);
//    	 
    	 model.addObject("tuserName", cmsRoomOrder.getTuserName());
//    	 
    	 model.addObject("orderName", cmsRoomOrder.getUserName());
//    	 
    	 model.addObject("orderTel", cmsRoomOrder.getUserTel());
//    	 
    	 model.addObject("userType", userType);
//    	 
    	 model.addObject("tuserIsDisplay", tuserIsDisplay);
    	 
    	 model.addObject("userId", cmsRoomOrder.getUserId());
    	 
    	 model.setViewName("wechat/venue/roomRoom");
    	 
    	 return model;
    } 
    
//    //活动室预定
//    @RequestMapping(value = "/roomBook")
//    public ModelAndView roomBook(String roomId,String bookId){
//        ModelAndView model = new ModelAndView();
//        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
//        CmsRoomBook cmsRoomBook = null;
//        List<CmsRoomBook> validList = null;
//        String openPeriod = "";
//        Date date = null;
//        if(StringUtils.isNotBlank(bookId)){
//            cmsRoomBook = cmsRoomBookService.queryCmsRoomBookById(bookId);
//            date = cmsRoomBook.getCurDate();
//            openPeriod = cmsRoomBook.getOpenPeriod();
//        }
//        if(date == null){
//            date = new Date();
//        }
//        Calendar calendar = Calendar.getInstance();
//        calendar.setTime(date);
//        CmsActivityRoom cmsActivityRoom = null;
//        CmsVenue cmsVenue = null;
//        List<CmsTeamUser> teamUserList = null;
//        CmsTeamUser cmsTeamUser = null;
//
//        String dateStr = sdf.format(date);
//
//        List<CmsRoomBook> roomBookList = null;
//
//        CmsTerminalUser cmsTerminalUser = (CmsTerminalUser)session.getAttribute(Constant.terminalUser);
//
//        List<String> dateList = new ArrayList<>();
//        Calendar _thisCalendar =   Calendar.getInstance();
//        _thisCalendar.setTime(new Date());
//        Date _thisDate = new Date();
//        for (int index=0;index<6;index++){
//            _thisCalendar.setTime(_thisDate);
//            _thisCalendar.add(Calendar.DATE,index);
//            dateList.add(sdf.format(_thisCalendar.getTime()));
//        }
//        model.addObject("dateList",dateList);
//        try {
//            if(cmsTerminalUser.getUserId() != null){
//                teamUserList = cmsTeamUserService.queryTeamUserList(cmsTerminalUser.getUserId());
//                if(teamUserList != null && teamUserList.size() > 0){
//                    cmsTeamUser = teamUserList.get(0);
//                    model.addObject("teamList",teamUserList);
//                }
//                //获取活动室信息
//                cmsActivityRoom = cmsActivityRoomService.queryCmsActivityRoomById(roomId);
//                if(cmsActivityRoom != null){
//                    //获取场馆信息
//                    cmsVenue = cmsVenueService.queryVenueById(cmsActivityRoom.getRoomVenueId());
//                }
//                //根据日期获取预定信息
//                roomBookList = cmsRoomBookService.queryCmsRoomBookByDate(cmsActivityRoom.getRoomId(),sdf.parse(dateStr));
//                Date now = new Date();
//                //此List用来存放前台活动室订票页面，时间段select里面的下拉value
//                validList = new ArrayList<CmsRoomBook>();
//                //将用户选择的时间段拼成选择的完整时间和当前时间对比，如果比当前时间之前则移除这个时间段，不然前台会订到活动已经开始或结束了的票
//                for (CmsRoomBook roomBook : roomBookList) {
//                    if (!"OFF".equals(roomBook.getOpenPeriod())) {
//                        String[] str = roomBook.getOpenPeriod().split("-");
//                        String openPeriodStr = str[0];//获取 开放时间段的开始时间(HH:ss);
//                        SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd");
//                        openPeriodStr = sf.format(roomBook.getCurDate()) + " " + openPeriodStr;
//                        SimpleDateFormat sdfHm = new SimpleDateFormat("yyyy-MM-dd HH:mm");
//                        Date OpenPeriodTime = sdfHm.parse(openPeriodStr);
//                        if (OpenPeriodTime.after(now)) {
//                            validList.add(roomBook);
//                        }
//                    }
//                }
//            }else{
//                logger.error("当前没有登录用户，请求处理终止!");
//            }
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//        model.setViewName("wechat/venue/roomBook");
//        model.addObject("cmsActivityRoom", cmsActivityRoom);
//        model.addObject("cmsVenue",cmsVenue);
//        model.addObject("teamUserList",teamUserList);
//        model.addObject("cmsTerminalUser",cmsTerminalUser);
//        model.addObject("dateStr",dateStr);
//        model.addObject("roomBookList",validList);
//        model.addObject("openPeriod",openPeriod);
//        model.addObject("cmsTeamUser",cmsTeamUser);
//        return model;
//    }


    //显示提交信息
//    @RequestMapping(value = "/roomBookOrder")
//    @ResponseBody
//    @Deprecated
//    public Map<String,Object> roomBookOrder(CmsRoomBook cmsRoomBook,String curDateStr,String tuserName){
//
//        Map<String,Object> result = new HashMap<>();
//
//        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
//        List<CmsRoomBook> roomBookList = null;
//        //获取场馆信息
//        CmsVenue cmsVenue = null;
//        //获取活动室信息
//        CmsActivityRoom cmsActivityRoom = null;
//        //当前登录用户ID
//        CmsTerminalUser cmsTerminalUser = (CmsTerminalUser)session.getAttribute(Constant.terminalUser);
//        try {
//            result.put("code",500);
//            if(cmsRoomBook != null && cmsTerminalUser != null && StringUtils.isNotBlank(curDateStr)){
//                //获取活动室信息
//                cmsActivityRoom = cmsActivityRoomService.queryCmsActivityRoomById(cmsRoomBook.getRoomId());
//                if(cmsActivityRoom != null){
//                    //获取场馆信息
//                    cmsVenue = cmsVenueService.queryVenueById(cmsActivityRoom.getRoomVenueId());
//                }
//                //根据日期获取预定信息
//                roomBookList = cmsRoomBookService.queryCmsRoomBookByDate(cmsActivityRoom.getRoomId(),sdf.parse(curDateStr));
//                //设置当前
//                cmsRoomBook.setCurDate(sdf.parse(curDateStr));
//                CmsRoomBook tmpCmsRoomBook = null;
//                for(int i=0; i<roomBookList.size(); i++){
//                    tmpCmsRoomBook = roomBookList.get(i);
//                    if(tmpCmsRoomBook.getCurDate().equals(cmsRoomBook.getCurDate()) &&
//                            tmpCmsRoomBook.getOpenPeriod().equals(cmsRoomBook.getOpenPeriod()) &&
//                            tmpCmsRoomBook.getRoomId().equals(cmsRoomBook.getRoomId())){
//                        cmsRoomBook.setBookId(tmpCmsRoomBook.getBookId());
//                    }
//                }
//                //创建订单号
//                cmsRoomBook.setOrderNo(cacheService.genOrderNumber());
//
//
//                result.put("data",cmsRoomBook);
//                result.put("code",200);
//            }
//        } catch (Exception e) {
//            e.printStackTrace();
//            result.put("code",500);
//        }
//
///*        model.setViewName("wechat/venue/roomBookOrder");
//        model.addObject("cmsVenue",cmsVenue);
//        model.addObject("cmsActivityRoom",cmsActivityRoom);
//        model.addObject("cmsRoomBook",cmsRoomBook);
//        model.addObject("tuserName",tuserName);*/
//        return result;
//    }

    //提交订单
//    @RequestMapping(value = "/roomOrderConfirm")
//    @ResponseBody
//    public Map<String,Object> roomOrderConfirm(CmsRoomBook cmsRoomBook){
//        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss SSS");
//        Map<String,Object> result = new HashMap<>();
//        //获取活动室信息
//        CmsActivityRoom cmsActivityRoom = null;
//        CmsRoomBook tmpCmsRoomBook = null;
//        //获取场馆信息
//        CmsVenue cmsVenue = null;
//        //当前登录用户ID
//        CmsTerminalUser cmsTerminalUser = (CmsTerminalUser)session.getAttribute(Constant.terminalUser);
//        if(cmsRoomBook != null){
//            tmpCmsRoomBook = cmsRoomBookService.queryCmsRoomBookById(cmsRoomBook.getBookId());
//            //获取活动室信息
//            cmsActivityRoom = cmsActivityRoomService.queryCmsActivityRoomById(tmpCmsRoomBook.getRoomId());
//            if(cmsActivityRoom != null){
//                //获取场馆信息
//                cmsVenue = cmsVenueService.queryVenueById(cmsActivityRoom.getRoomVenueId());
//            }
//            if(tmpCmsRoomBook != null){
//                tmpCmsRoomBook.setTuserId(cmsRoomBook.getTuserId());
//                tmpCmsRoomBook.setUserId(cmsTerminalUser.getUserId());
//                tmpCmsRoomBook.setUserName(cmsRoomBook.getUserName());
//                tmpCmsRoomBook.setUserTel(cmsRoomBook.getUserTel());
//                tmpCmsRoomBook.setOrderNo(cmsRoomBook.getOrderNo());
//                tmpCmsRoomBook.setSysId(cmsRoomBook.getSysId());
//                tmpCmsRoomBook.setSysNo(cmsRoomBook.getSysNo());
//                //订单成功后的一系列操作
//                cmsActivityRoomService.roomConfirm(tmpCmsRoomBook,cmsVenue,cmsTerminalUser,null);
//            }
//        }
///*        model.setViewName("wechat/venue/roomOrderResult");
//        model.addObject("cmsActivityRoom",cmsActivityRoom);
//        model.addObject("cmsRoomBook",tmpCmsRoomBook);
//        model.addObject("cmsVenue",cmsVenue);*/
//        result.put("venue",cmsVenue);
//        result.put("code",200);
//        logger.info("结束场馆预定时间!"+sdf.format(new Date()));
//        return result;
//    }

    @RequestMapping(value = "/roomExplain")
    public String roomExplain(){
        return "wechat/venue/roomExplain";
    }
    
    /**
     * wechat用户报名场馆接口
     * @param venueId           场馆id
     * @param userId            用户id
     * return
     */
    @RequestMapping(value = "/wcAddVenueUserWantgo")
    public String wcAddVenueUserWantgo(HttpServletResponse response,String venueId,String userId) throws Exception {
        String json="";
        try{
            json=venueAppService.addAppVenueUserWantgo(venueId, userId);
        }catch (Exception e){
            json=JSONResponse.toAppResultFormat(10108, e.getMessage());
            logger.error("add appAddVenueUserWantgo error" + e.getMessage());
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }

    /**
     * wechat用户取消报名场馆接口
     * @param venueId           场馆id
     * @param userId            用户id
     * return
     */
    @RequestMapping(value = "/wcDeleteVenueUserWantgo")
    public String wcDeleteVenueUserWantgo(HttpServletResponse response,String venueId,String userId) throws Exception {
        String json="";
        try{
            json=venueAppService.deleteAppVenueUserWantgo(venueId, userId);
        }catch (Exception e){
            json=JSONResponse.toAppResultFormat(10108, e.getMessage());
            logger.error("delete appDeleteVenueUserWantgo error" + e.getMessage());
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }

    /**
     * wechat获取场馆报名列表接口(点赞人列表)
     * @param venueId   场馆id
     * @param pageIndex 首页下标
     * @param pageNum   显示条数
     * return
     */
    @RequestMapping(value = "/wcVenueUserWantgoList")
    public String wcVenueUserWantgoList(HttpServletResponse response,String venueId,String pageIndex,String pageNum ,PaginationApp pageApp) throws Exception {
        pageApp.setFirstResult(Integer.valueOf(pageIndex));
        pageApp.setRows(Integer.valueOf(pageNum));
        String json="";
        try {
            json=venueAppService.queryAppVenueUserWantgoList(pageApp, venueId);
        }catch (Exception e){
            json=JSONResponse.toAppResultFormat(10108, e.getMessage());
            logger.info("query appVenueUserWantgoList error"+e.getMessage());
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }

    /**
     * wechat获取场馆浏览量
     * @param venueId 场馆id
     * return
     */
    @RequestMapping(value = "/wcCmsVenueBrowseCount")
    public String wcCmsVenueBrowseCount(HttpServletResponse response,String venueId) throws Exception {
        String json="";
        try {
            if(StringUtils.isNotBlank(venueId)){
                json = venueAppService.queryAppCmsVenueBrowseCount(venueId);
            }else{
                json = JSONResponse.toAppResultFormat(14101, "场馆id缺失");
            }
        }catch (Exception e){
            json = JSONResponse.toAppResultFormat(10107, e.getMessage());
            logger.info("query appCmsActivityUserWantgoCount error"+e.getMessage());
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }
    /**
     * why3.5 场馆热门
     *
     * @param
     * @return
     */
    @RequestMapping(value = "/getVenueHot")
    public String getVenueHot(HttpServletResponse response) throws IOException {
        String json = "";
        try {
            json=tagAppService.venueHot();
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }
    
    /**
     * 获取活动室中文显示日期
     * 
     * @param curDate
     * @param dayOfWeek
     * @return
     */
    private String getBookDateStr(Date curDate,Integer dayOfWeek)
    {
    	SimpleDateFormat formatter = new SimpleDateFormat("yyyy年MM月dd日");
        String strDate = formatter.format(curDate);
        String weekCn=" 周";
        
        switch (dayOfWeek) {
		case 1:
			weekCn+="一";
			break;
		case 2:
			weekCn+="二";
			break;
		case 3:
			weekCn+="三";
			break;
		case 4:
			weekCn+="四";
			break;
		case 5:
			weekCn+="五";
			break;
		case 6:
			weekCn+="六";
			break;
		case 7:
			weekCn+="日";
			break;
		}
        
        String date=strDate+weekCn;
        
        return date;
    }
    
    /**
     * why3.5.4 wechat场馆在线活动及活动室数
     * @param response
     * @param sortType
     * @throws Exception
     */
    @RequestMapping(value = "/wcVenueCountInfo")
    public void wcVenueCountInfo(HttpServletResponse response, String venueId) throws Exception{
		String json = "";
		try {
			json = venueAppService.queryVenueCountInfo(venueId);
		}catch (Exception e){
			json = JSONResponse.toAppResultFormat(10107, e.getMessage());
			e.printStackTrace();
		}
		response.setContentType("text/html;charset=UTF-8");
		response.getWriter().write(json);
		response.getWriter().flush();
		response.getWriter().close();
	}
    
    /**
     * 跳转到空间首页
     * @param request
     * @return
     */
    @RequestMapping(value = "/toSpace")
    public String toSpace(HttpServletRequest request) {
        //微信权限验证配置
        String url = BindWS.getUrl(request);
        Map<String, String> sign = BindWS.sign(url, cacheService);
        request.setAttribute("sign", sign);
        return "wechat/venue/spaceIndex";
    }
    
    /**
     * 根据场馆类型获取场馆列表信息
     * @param response
     * @param venueType
     * @throws IOException
     */
    @RequestMapping("/queryVenueByType")
    @ResponseBody
    public void queryVenueByType(HttpServletResponse response,String venueType,String venueName) throws IOException{
    	String json="";
    	try {
			json=venueAppService.queryVenueByType(venueType,venueName);
		} catch (Exception e) {
			e.printStackTrace();
		}
    	response.setContentType("text/html;charset=UTF-8");
		response.getWriter().write(json);
		response.getWriter().flush();
		response.getWriter().close();
    }
    
    /**
     * 文化地图场馆相关活动列表
     * @param response
     * @param venueId
     * @param pageIndex
     * @param pageNum
     * @param pageApp
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/venueWcMapActivity")
    public String venueWcMapActivity(HttpServletResponse response,String venueId,String pageIndex,String pageNum,PaginationApp pageApp) throws Exception {
        String json="";
        if(pageIndex!=null&&pageNum!=null){
        	pageApp.setFirstResult(Integer.valueOf(pageIndex));
            pageApp.setRows(Integer.valueOf(pageNum));
        }
        if(venueId!=null && StringUtils.isNotBlank(venueId)){
            json = activityAppService.queryCultureMapActivityListById(venueId, pageApp);
        }else {
            json=JSONResponse.toAppResultFormat(10108,"展馆id缺失!");
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }
    
}
