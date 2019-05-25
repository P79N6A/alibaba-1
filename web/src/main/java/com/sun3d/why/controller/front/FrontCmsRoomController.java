package com.sun3d.why.controller.front;

import com.sun3d.why.dao.CmsSensitiveWordsMapper;
import com.sun3d.why.jms.client.ActivityRoomBookClient;
import com.sun3d.why.jms.model.JmsResult;
import com.sun3d.why.model.*;
import com.sun3d.why.model.extmodel.RoomBookConfig;
import com.sun3d.why.service.*;
import com.sun3d.why.util.CmsSensitive;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.UUIDUtils;
import com.sun3d.why.webservice.api.model.CmsApiOrder;
import com.sun3d.why.webservice.api.service.CmsApiRoomOrderService;
import com.sun3d.why.webservice.service.RoomBookAppService;

import net.sf.json.JSONObject;

import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpSession;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * <p>
 * 处理活动室前台页面请求
 * <p/>
 * Created by cj on 2015/6/16
 */
@RequestMapping("/frontRoom")
@Controller
public class FrontCmsRoomController {

    private Logger logger = Logger.getLogger(FrontCmsRoomController.class);
    //活动室逻辑控制层
    @Autowired
    private CmsActivityRoomService cmsActivityRoomService;
    //活动室预定逻辑控制层
    @Autowired
    private CmsRoomBookService cmsRoomBookService;
    //场馆逻辑控制层
    @Autowired
    private CmsVenueService cmsVenueService;
    //评论逻辑控制层
    @Autowired
    private CmsCommentService cmsCommentService;
    //团体逻辑控制层
    @Autowired
    private CmsTeamUserService cmsTeamUserService;
    //敏感词
    @Autowired
    private CmsSensitiveWordsService sensitiveWordsService;
    //缓存信息逻辑控制层
    @Autowired
    private CacheService cacheService;
    @Autowired
    private HttpSession session;
    @Autowired
    private CmsApiRoomOrderService cmsApiRoomOrderService;
    @Autowired
    private SysDictService sysDictService;
    @Autowired
    private CmsTagService cmsTagService;
    @Autowired
    private CmsRoomOrderService cmsRoomOrderService;
    @Autowired
    private RoomBookConfig roomBookConfig;
    @Autowired
    private CmsSensitiveWordsMapper cmsSensitiveWordsMapper;
    @Autowired
    private RoomBookAppService roomBookAppService;
    /**
     * 显示活动室详情
     * @param roomId
     * @return
     */
    @RequestMapping(value = "/roomDetail")
    public ModelAndView roomDetail(String roomId){
        ModelAndView model = new ModelAndView();
        //从session中获取登录用户
        CmsTerminalUser cmsTerminalUser = (CmsTerminalUser)session.getAttribute("terminalUser");
        CmsActivityRoom cmsActivityRoom = null;
        CmsVenue cmsVenue = null;
        List<CmsRoomBook> roomBookList = null;
        int commentCount = 0;
        List<CmsTeamUser> teamUserList = null;
        boolean invalidData = false;
        try {
            if(cmsTerminalUser != null){
                teamUserList = cmsTeamUserService.queryTeamUserList(cmsTerminalUser.getUserId());
            }
            if(StringUtils.isNotBlank(roomId)){
                //获取活动室信息
                cmsActivityRoom = cmsActivityRoomService.queryCmsActivityRoomById(roomId);
                //获取场馆信息
                cmsVenue = cmsVenueService.queryVenueById(cmsActivityRoom.getRoomVenueId());
                //评论数量
                CmsComment cmsComment = new CmsComment();
                cmsComment.setCommentRkId(roomId);
                cmsComment.setCommentType(Constant.TYPE_ACTIVITY_ROOM);
                commentCount = cmsCommentService.queryCommentCountByCondition(cmsComment);

                //绘制预定表格
                roomBookList = cmsRoomBookService.queryRoomBookTableByDays(roomId,5);
                //当所有显示数据第五个字段为空时，去掉页面第五行
                if(roomBookList != null && roomBookList.size()== 25){
                    CmsRoomBook roomBook = null;
                    boolean flag = true;
                    for(int i=20; i<25; i++){
                        roomBook = roomBookList.get(i);
                        if(roomBook.getBookStatus() != 3){
                            flag = false;
                        }
                    }
                    if(flag){
                        for(int i=20; i<25; i++){
                            roomBook = roomBookList.get(i);
                            roomBook.setBookStatus(4);
                        }
                    }
                }
                //对显示数据进行筛选
                roomBookList = filterRoomBookList(roomBookList);

                if(cmsVenue.getVenueIsDel() == 2 || cmsActivityRoom.getRoomIsDel() == 2){
                    invalidData = true;
                }
            }
            //活动室设施列表
            String facIds = cmsActivityRoom.getRoomFacilityDict();
            if(StringUtils.isNotBlank(cmsActivityRoom.getRoomFacilityDict())){
                model.addObject("facList",sysDictService.querySysDictListByIds(facIds.substring(0,facIds.length()-1)));
            }else{
                model.addObject("facList",new ArrayList<SysDict>());
            }
            //活动室标签
            model.addObject("tagList", cmsTagService.queryTeamTags(cmsActivityRoom.getRoomTag()));
        } catch (Exception e) {
            logger.error("加载活动室详情页时发生错误：",e);
            e.printStackTrace();
        }
        model.setViewName("index/activityRoom/roomDetail");
        model.addObject("cmsActivityRoom",cmsActivityRoom);
        model.addObject("cmsVenue",cmsVenue);
        model.addObject("commentCount",commentCount);
        model.addObject("roomBookList",roomBookList);
        model.addObject("teamUserList",teamUserList);
        model.addObject("invalidData",invalidData);
        return model;
    }

    /**
     * 活动室预定
     * @param roomId
     * @return
     */
    @RequestMapping(value = "/roomBook")
    public ModelAndView roomBook(String roomId,String bookId,String tuserId,String userTel){
        ModelAndView model = new ModelAndView();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        CmsRoomBook cmsRoomBook = null;
        List<CmsRoomBook> validList = null;
        String openPeriod = "";
        Date date = null;
        if(StringUtils.isNotBlank(bookId)){
            cmsRoomBook = cmsRoomBookService.queryCmsRoomBookById(bookId);
            date = cmsRoomBook.getCurDate();
            openPeriod = cmsRoomBook.getOpenPeriod();
        }
        if(date == null){
            date = new Date();
        }
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(date);

        CmsActivityRoom cmsActivityRoom = null;
        CmsVenue cmsVenue = null;
        List<CmsTeamUser> teamUserList = null;
        CmsTeamUser cmsTeamUser = null;
        String weekStr = "";

        int dayOfWeek = calendar.get(Calendar.DAY_OF_WEEK);
        if(dayOfWeek == 1){
            weekStr = "星期日";
        }else if(dayOfWeek == 2){
            weekStr = "星期一";
        }else if(dayOfWeek == 3){
            weekStr = "星期二";
        }else if(dayOfWeek == 4){
            weekStr = "星期三";
        }else if(dayOfWeek == 5){
            weekStr = "星期四";
        }else if(dayOfWeek == 6){
            weekStr = "星期五";
        }else if(dayOfWeek == 7){
            weekStr = "星期六";
        }
        String dateStr = sdf.format(date);
        List<CmsRoomBook> roomBookList = null;
        CmsTerminalUser cmsTerminalUser = (CmsTerminalUser)session.getAttribute("terminalUser");
        try {
            if(cmsTerminalUser != null){
                teamUserList = cmsTeamUserService.queryTeamUserList(cmsTerminalUser.getUserId());
                if(teamUserList != null && teamUserList.size() > 0){
                    cmsTeamUser = teamUserList.get(0);
                }
                //获取活动室信息
                cmsActivityRoom = cmsActivityRoomService.queryCmsActivityRoomById(roomId);
                if(cmsActivityRoom != null){
                    //获取场馆信息
                    cmsVenue = cmsVenueService.queryVenueById(cmsActivityRoom.getRoomVenueId());
                }
                //根据日期获取预定信息
                roomBookList = cmsRoomBookService.queryCmsRoomBookByDate(cmsActivityRoom.getRoomId(),sdf.parse(dateStr));

                Date now = new Date();
                //此List用来存放前台活动室订票页面，时间段select里面的下拉value
                validList = new ArrayList<CmsRoomBook>();
                //将用户选择的时间段拼成选择的完整时间和当前时间对比，如果比当前时间之前则移除这个时间段，不然前台会订到活动已经开始或结束了的票
                for (CmsRoomBook roomBook : roomBookList) {
                    if (!"OFF".equals(roomBook.getOpenPeriod())) {
                        String[] str = roomBook.getOpenPeriod().split("-");
                        String openPeriodStr = str[0];//获取 开放时间段的开始时间(HH:ss);
                        SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd");
                        openPeriodStr = sf.format(roomBook.getCurDate()) + " " + openPeriodStr;
                        SimpleDateFormat sdfHm = new SimpleDateFormat("yyyy-MM-dd HH:mm");
                        Date OpenPeriodTime = sdfHm.parse(openPeriodStr);
                        if (OpenPeriodTime.after(now)) {
                            validList.add(roomBook);
                        }
                    }
                }
            }else{
                logger.error("当前没有登录用户，请求处理终止!");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        model.setViewName("index/activityRoom/roomBook");
        model.addObject("cmsActivityRoom", cmsActivityRoom);
        model.addObject("cmsVenue",cmsVenue);
        model.addObject("teamUserList",teamUserList);
        model.addObject("cmsTerminalUser",cmsTerminalUser);
        model.addObject("dateStr",dateStr);
        model.addObject("weekStr",weekStr);
        model.addObject("roomBookList",validList);
        model.addObject("openPeriod",openPeriod);
        model.addObject("tuserId",tuserId);
        model.addObject("bookId",bookId);
        model.addObject("userTel",userTel);
        model.addObject("cmsTeamUser",cmsTeamUser);
        return model;
    }

    /**
     * 活动室预定
     * @param cmsRoomBook
     * @return
     */
    @RequestMapping(value = "/roomBookOrder")
    public ModelAndView roomBookOrder(CmsRoomBook cmsRoomBook,String curDateStr,String tuserName){
        ModelAndView model = new ModelAndView();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        List<CmsRoomBook> roomBookList = null;
        //获取场馆信息
        CmsVenue cmsVenue = null;
        //获取活动室信息
        CmsActivityRoom cmsActivityRoom = null;
        //当前登录用户ID
        CmsTerminalUser cmsTerminalUser = (CmsTerminalUser)session.getAttribute("terminalUser");
        try {
            if(cmsRoomBook != null && cmsTerminalUser != null && StringUtils.isNotBlank(curDateStr)){
                //获取活动室信息
                cmsActivityRoom = cmsActivityRoomService.queryCmsActivityRoomById(cmsRoomBook.getRoomId());
                if(cmsActivityRoom != null){
                    //获取场馆信息
                    cmsVenue = cmsVenueService.queryVenueById(cmsActivityRoom.getRoomVenueId());
                }
                //根据日期获取预定信息
                roomBookList = cmsRoomBookService.queryCmsRoomBookByDate(cmsActivityRoom.getRoomId(),sdf.parse(curDateStr));
                //设置当前
                cmsRoomBook.setCurDate(sdf.parse(curDateStr));

                CmsRoomBook tmpCmsRoomBook = null;
                for(int i=0; i<roomBookList.size(); i++){
                    tmpCmsRoomBook = roomBookList.get(i);
                    if(tmpCmsRoomBook.getCurDate().equals(cmsRoomBook.getCurDate()) &&
                            tmpCmsRoomBook.getOpenPeriod().equals(cmsRoomBook.getOpenPeriod()) &&
                            tmpCmsRoomBook.getRoomId().equals(cmsRoomBook.getRoomId())){
                        cmsRoomBook.setBookId(tmpCmsRoomBook.getBookId());
                    }
                }
                //创建订单号
                cmsRoomBook.setOrderNo(cacheService.genOrderNumber());
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        model.setViewName("index/activityRoom/roomBookOrder");
        model.addObject("cmsVenue",cmsVenue);
        model.addObject("cmsActivityRoom",cmsActivityRoom);
        model.addObject("cmsRoomBook",cmsRoomBook);
        model.addObject("tuserName",tuserName);
        return model;
    }

    /**
     * 活动室预定
     * @param cmsRoomBook
     * @return
     */
    @RequestMapping(value = "/roomOrderConfirm")
    public ModelAndView roomOrderConfirm(CmsRoomBook cmsRoomBook){
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss SSS");
        ModelAndView model = new ModelAndView();
        //获取活动室信息
        CmsActivityRoom cmsActivityRoom = null;
        CmsRoomBook tmpCmsRoomBook = null;
        //获取场馆信息
        CmsVenue cmsVenue = null;
        //当前登录用户ID
        CmsTerminalUser cmsTerminalUser = (CmsTerminalUser)session.getAttribute("terminalUser");
        if(cmsRoomBook != null){
            tmpCmsRoomBook = cmsRoomBookService.queryCmsRoomBookById(cmsRoomBook.getBookId());
            //获取活动室信息
            cmsActivityRoom = cmsActivityRoomService.queryCmsActivityRoomById(tmpCmsRoomBook.getRoomId());
            if(cmsActivityRoom != null){
                //获取场馆信息
                cmsVenue = cmsVenueService.queryVenueById(cmsActivityRoom.getRoomVenueId());
            }
            if(tmpCmsRoomBook != null){
                tmpCmsRoomBook.setTuserId(cmsRoomBook.getTuserId());
                tmpCmsRoomBook.setUserId(cmsTerminalUser.getUserId());
                tmpCmsRoomBook.setUserName(cmsRoomBook.getUserName());
                tmpCmsRoomBook.setUserTel(cmsRoomBook.getUserTel());
                tmpCmsRoomBook.setOrderNo(cmsRoomBook.getOrderNo());
                tmpCmsRoomBook.setSysId(cmsRoomBook.getSysId());
                tmpCmsRoomBook.setSysNo(cmsRoomBook.getSysNo());
                //订单成功后的一系列操作
                roomBookAppService.roomConfirm(tmpCmsRoomBook,cmsVenue,cmsActivityRoom,cmsTerminalUser,null);
            }
        }
        model.setViewName("index/activityRoom/roomBookResult");
        model.addObject("cmsActivityRoom",cmsActivityRoom);
        model.addObject("cmsRoomBook",tmpCmsRoomBook);
        model.addObject("cmsVenue",cmsVenue);
        logger.info("结束场馆预定时间!"+sdf.format(new Date()));
        return model;
    }


    //-------------------------------**********************-------------------------------
    /**
     * 检查活动室是否已经被预定
     * @return
     */
    @RequestMapping(value = "/roomOrderCheck")
    @ResponseBody
    public String roomOrderCheck(CmsRoomBook cmsRoomBook){
        JSONObject rtnJSON=new JSONObject();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss SSS");
        logger.info("开始进行场馆预定时间!"+sdf.format(new Date()));
        //当前登录用户ID
        CmsTerminalUser cmsTerminalUser = (CmsTerminalUser)session.getAttribute("terminalUser");
        if(cmsTerminalUser != null){
            int count = cmsRoomOrderService.getRoomBookCountOneDay(cmsTerminalUser.getUserId());
            if(count >= roomBookConfig.getMaxRoomBookCount()){
                rtnJSON.put("status", false);
                rtnJSON.put("msg", "当日已预订五次，请明天再试！");
                return rtnJSON.toString();
            }else{
                if(cmsRoomBook != null){
                    CmsRoomBook tmpCmsRoomBook = cmsRoomBookService.queryCmsRoomBookById(cmsRoomBook.getBookId());
                    if(tmpCmsRoomBook != null){
                        tmpCmsRoomBook.setOrderNo(cmsRoomBook.getOrderNo());
                        tmpCmsRoomBook.setTuserId(cmsRoomBook.getTuserId());
                        tmpCmsRoomBook.setUserId(UUIDUtils.createUUId());
                        tmpCmsRoomBook.setUserName(cmsRoomBook.getUserName());
                        tmpCmsRoomBook.setUserTel(cmsRoomBook.getUserTel());
                        //判断系统是否是子系统的预定，如果是子系统的预定，系统将会向子系统发送请求，判断子系统的是否成功预定
                        CmsApiOrder apiOrder=this.cmsApiRoomOrderService.addOrder(tmpCmsRoomBook,cmsTerminalUser);
                        //子系统判断成功，则执行预定
                        if(apiOrder.isStatus()){
                            tmpCmsRoomBook.setSysId(apiOrder.getContentId());
                            tmpCmsRoomBook.setSysNo(apiOrder.getSysNo());
                            rtnJSON.put("sysId", tmpCmsRoomBook.getSysId());
                            rtnJSON.put("sysNo", tmpCmsRoomBook.getSysNo());
                            //---------------*******************预定活动室
                            ActivityRoomBookClient activityRoomBookClient = new ActivityRoomBookClient();
                            JmsResult jmsResult = activityRoomBookClient.bookActivityRoom(tmpCmsRoomBook,cacheService);
                            if(jmsResult.getSuccess()){
                                rtnJSON.put("status", true);
                                rtnJSON.put("msg", "预定成功!");
                                return rtnJSON.toString();
                            }else{
                                if(jmsResult.getMessage().equals("server data error")){
                                    jmsResult.setMessage("服务器数据异常!");
                                    final String finalRoomId = tmpCmsRoomBook.getRoomId();
                                    Runnable runnable=new Runnable() {
                                        @Override
                                        public void run() {
                                            setRoomBookToRedis(finalRoomId);
                                        }
                                    };
                                    Thread thread=new Thread(runnable);
                                    thread.start();
                                    logger.info("预定失败!" + jmsResult.getMessage());
                                    rtnJSON.put("status", false);
                                    rtnJSON.put("msg", jmsResult.getMessage());
                                    return rtnJSON.toString();
                                }else if(jmsResult.getMessage().equals("occupied")){
                                    //如果当前活动室之前已被预订但是MQ或其它通信异常导致数据库段没有成功预订，再次被预定时置为成功
                                    if(tmpCmsRoomBook.getBookStatus() == 1){
                                        rtnJSON.put("status", true);
                                        rtnJSON.put("msg", "预定成功!");
                                        return rtnJSON.toString();
                                    }else{
                                        rtnJSON.put("status", false);
                                        rtnJSON.put("msg", "该活动室已被预订！");
                                        return rtnJSON.toString();
                                    }
                                }else{
                                    rtnJSON.put("status", false);
                                    rtnJSON.put("msg", "请求超时，请重试!");
                                    return rtnJSON.toString();
                                }
                            }
                            //---------------*******************预定活动室
                        } else{
                            rtnJSON.put("status", false);
                            rtnJSON.put("msg", apiOrder.getMsg()+ ","+apiOrder.getCode());
                        }
                    }else{
                        rtnJSON.put("status", false);
                        rtnJSON.put("msg", "预定信息不存在或已被预订");
                    }
                }else{
                    rtnJSON.put("status", false);
                    rtnJSON.put("msg", "预定信息不存在或已被预订");
                }
            }
        }else{
            rtnJSON.put("status", false);
            rtnJSON.put("msg", "当前用户没有登录");
        }
        return rtnJSON.toString();
    }

    /**
     * 将活动室预订信息放入Redis
     * @param finalRoomId
     */
    public void setRoomBookToRedis(String finalRoomId){
        //将未来七天的预定信息放入Redis
        List<String> roomBookList = cmsRoomBookService.queryRoomBookDataToRedis(finalRoomId, 7);
        //*********************************************************往Redis中放入活动室预定数据，活动室预定队列
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(new Date());
        //设置过期时间为当前时间之后的24小时
        calendar.add(Calendar.HOUR_OF_DAY,24);
        //将活动室预定信息放入Redis
        cacheService.setRoomBookList(finalRoomId,roomBookList,calendar.getTime());
        //将活动室队列放入内存中的一个set集合中
        cacheService.saveActivityRoomToQueues(CacheConstant.ACTIVITY_ROOM_QUEUES, finalRoomId + "_N");
        //**********************************************************往Redis中放入活动室预定数据，活动室预定队列
    }

    /**
     * 前台场馆详情显示推荐活动室
     * @param venueId
     * @param pageNum
     * @return
     */
    @RequestMapping(value = "/roomList")
    @ResponseBody
    public Map<String,Object> roomList(String venueId,String roomId,Integer pageNum) {
        CmsActivityRoom cmsActivityRoom = new CmsActivityRoom();
        cmsActivityRoom.setVenueId(venueId);
        cmsActivityRoom.setRoomId(roomId);
        //活动室显示数量每页为4个
        cmsActivityRoom.setRows(4);
        if (pageNum != null) {
            cmsActivityRoom.setPage(pageNum);
        }
        List<CmsActivityRoom> roomList = cmsActivityRoomService.queryRelatedRoom(cmsActivityRoom, true);
        int roomCount = cmsActivityRoomService.queryRelatedRoomCount(cmsActivityRoom,true);

        Map<String, Object> map = new HashMap<String, Object>();
        map.put("roomList", roomList);
        map.put("roomCount", roomCount);
        return map;
    }


    /**
     * 根据日期查询对应的活动室预定信息
     * @param curDate
     * @return
     */
    @RequestMapping(value = "/roomBookList")
    @ResponseBody
    public List<CmsRoomBook> roomBookList(String roomId,String curDate) {
        List<CmsRoomBook> roomBookList = null;
        List<CmsRoomBook> validList = null;
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        try {
            if(StringUtils.isNotBlank(roomId) && StringUtils.isNotBlank(curDate)){
                //根据日期获取预定信息
                roomBookList = cmsRoomBookService.queryCmsRoomBookByDate(roomId,sdf.parse(curDate));
                //将用户选择的时间段拼成选择的完整时间和当前时间对比，如果比当前时间之前则移除这个时间段，不然前台会订到活动已经开始或结束了的票
                Date now = new Date();
                validList = new ArrayList<CmsRoomBook>();
                for (CmsRoomBook roomBook : roomBookList) {

                    if (!"OFF".equals(roomBook.getOpenPeriod())) {
                        String[] str = roomBook.getOpenPeriod().split("-");
                        String openPeriodStr = str[0];//获取 开放时间段的开始时间(HH:ss);
                        SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd");
                        openPeriodStr = sf.format(roomBook.getCurDate()) + " " + openPeriodStr;
                        SimpleDateFormat sdfHm = new SimpleDateFormat("yyyy-MM-dd HH:mm");
                        Date OpenPeriodTime = sdfHm.parse(openPeriodStr);
                        if (OpenPeriodTime.after(now)) {
                            validList.add(roomBook);
                        }
                    }
                }

            }
        } catch (ParseException e) {
            logger.error("日期格式解析有误!",e);
        }
        return validList;
    }

    /**
     * 前台场馆详情显示推荐场馆
     * @param venueId
     * @return
     */
    @RequestMapping(value = "/relatedVenueList")
    @ResponseBody
    public List<CmsVenue> relatedVenueList(String venueId) {
        List<CmsVenue> venueList = null;
        if(StringUtils.isNotBlank(venueId)) {
            //场馆信息
            CmsVenue cmsVenue = this.cmsVenueService.queryVenueById(venueId);
            CmsVenue venueCondition = new CmsVenue();
            venueCondition.setVenueArea(cmsVenue.getVenueArea());
            Pagination page = new Pagination();
            page.setRows(3);
            venueList = cmsVenueService.queryVenueByCondition(venueCondition, page, null, null);
        }
        return venueList;
    }

    /**
     * 前端2.0 添加评论
     * @param comment
     * @param roomId
     * @return
     */
    @RequestMapping(value = "/addComment", method = {RequestMethod.POST})
    @ResponseBody
    public String addComment(CmsComment comment,String roomId) {
        try{
            if(session.getAttribute("terminalUser") != null){
                String sensitiveWords= CmsSensitive.sensitiveWords(comment, cmsSensitiveWordsMapper);
                if(StringUtils.isNotBlank(sensitiveWords) && sensitiveWords.equals("sensitiveWords")){
                    return  Constant.SensitiveWords_EXIST;
                }
                CmsTerminalUser user = (CmsTerminalUser) session.getAttribute("terminalUser");
                comment.setCommentUserId(user.getUserId());
                comment.setCommentType(Constant.TYPE_ACTIVITY_ROOM);
                comment.setCommentRkId(roomId);
                return cmsCommentService.addComment(comment);
            }
        }catch (Exception e){
            logger.info("addComment error", e);
            return Constant.RESULT_STR_FAILURE;
        }
        return Constant.RESULT_STR_FAILURE;
    }

    /**
     * 将预订时间在服务器当前时间之前的预订场次显示成不可预订状态
     * @param roomBookList
     * @return
     */
    public List<CmsRoomBook> filterRoomBookList(List<CmsRoomBook> roomBookList){
        List<CmsRoomBook> newRoomBookList = new ArrayList<CmsRoomBook>();
        Calendar newCalendar = Calendar.getInstance();
        SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd");
        SimpleDateFormat sdf2 = new SimpleDateFormat("yyyy-MM-dd HH:mm");
        try {
            for(CmsRoomBook tempRoomBook : roomBookList){
                Date curDate = tempRoomBook.getCurDate();
                String openPeriod = tempRoomBook.getOpenPeriod();
                Integer bookStatus = tempRoomBook.getBookStatus();
                String curDateStr = sdf1.format(curDate);
                if(openPeriod.contains("OFF")){
                    newRoomBookList.add(tempRoomBook);
                }else{
                    int index = openPeriod.indexOf("-");
                    String lastTime = openPeriod.substring(0,index);
                    if(newCalendar.getTime().after(sdf2.parse(curDateStr + " " +lastTime)) && bookStatus ==1){
                        tempRoomBook.setBookStatus(3);
                    }
                    newRoomBookList.add(tempRoomBook);
                }
            }
        } catch (Exception e) {
            logger.error("过滤活动室详情页预订数据时发生异常：",e);
            e.printStackTrace();
        }
        return newRoomBookList;
    }
    
	  @RequestMapping(value = "/roomOrderComplete")
	    public ModelAndView roomOrderComplete(
	    		String cmsRoomOrderId,
	    		String roomName,
	    		String orderName,
	    		String tuserName,
	    		String venueName,
	    		Integer userType,
	    		Integer tuserIsDisplay,
	    		String date,
	    		String orderTel,
	    		String openPeriod,
	    		String userId
	    		) throws UnsupportedEncodingException{
	    	
	   	 ModelAndView model = new ModelAndView();    
	   	 
	   	
	   	 
	   	model.addObject("roomName", URLDecoder.decode(roomName, "UTF-8"));
	 	model.addObject("orderName", URLDecoder.decode(orderName, "UTF-8"));
	 	model.addObject("tuserName", URLDecoder.decode(tuserName, "UTF-8"));
		model.addObject("venueName", URLDecoder.decode(venueName, "UTF-8"));
		model.addObject("date", URLDecoder.decode(date, "UTF-8"));
		model.addObject("orderTel", orderTel);
		model.addObject("openPeriod", openPeriod);
		model.addObject("userId", userId);
		model.addObject("cmsRoomOrderId", cmsRoomOrderId);

		model.setViewName("index/activityRoom/roomBookSuccess");    	 
    	 return model;
	  }
}
