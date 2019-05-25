package com.sun3d.why.webservice.controller;
import com.sun3d.why.model.CmsVenue;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.JSONResponse;
import com.sun3d.why.util.PaginationApp;
import com.sun3d.why.webservice.service.ActivityAppService;
import com.sun3d.why.webservice.service.ActivityRoomAppService;
import com.sun3d.why.webservice.service.CommentAppService;
import com.sun3d.why.webservice.service.VenueAppService;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import javax.servlet.http.HttpServletResponse;
/**
 * 手机app接口 展馆列表
 * Created by Administrator on 2015/7/4
 *
 */
@RequestMapping("/appVenue")
@Controller
public class VenueAppController {
    private Logger logger = Logger.getLogger(VenueAppController.class);
    @Autowired
    private VenueAppService venueAppService;
    @Autowired
    private ActivityRoomAppService activityRoomAppService;
    @Autowired
    private ActivityAppService activityAppService;
    @Autowired
    private CommentAppService commentAppService;

    /**
     * app获取展馆推荐前3条或展馆列表(已废弃)
     * return json
     */
    @RequestMapping(value = "/venueAppIndex")
    public String venueAppIndex(HttpServletResponse response,PaginationApp pageApp,String pageIndex,String pageNum,String Lat,String Lon,String venueIsRecommend) throws Exception {
        String json = "";
        pageApp.setFirstResult(Integer.valueOf(pageIndex));
        pageApp.setRows(Integer.valueOf(pageNum));
        try {
            json=venueAppService.queryAppVenueAppByNum(pageApp,Lat,Lon,venueIsRecommend);
        }catch (Exception e){
            e.printStackTrace();
            logger.info("query venueAppIndex error"+e.getMessage());
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }


    /**
     * app根据不同条件筛选展馆
     * @param appType 标签中活动类型筛选  1.距离  3.热门
     * @param pageIndex 首页下标
     * @param pageNum 显示条数
     * @param Lon 展馆经度
     * @param Lat 展馆纬度
     * @param venueIsReserve 展馆是否可预订 1-否 2 -是
     * return json 10126系统错误
     */
    @RequestMapping(value = "/appVenueListIndex")
    public String appVenueListIndexByCondition(HttpServletResponse response,PaginationApp pageApp,String appType,String pageIndex,String pageNum,CmsVenue cmsVenue,String Lon,String Lat,String venueIsReserve) throws Exception {
        String json="";
        pageApp.setFirstResult(Integer.valueOf(pageIndex));
        //每页显示的条数
        pageApp.setRows(Integer.valueOf(pageNum));
        try {
            switch (Integer.valueOf(appType)){
                //最热门展馆
                case 3:json=venueAppService.queryAppHotByCondition(cmsVenue, pageApp, Integer.valueOf(appType), Lon,Lat, venueIsReserve);
                        break;
                //附近展馆
                default:  json=venueAppService.queryAppVenueListByCondition(cmsVenue, pageApp,Lon, Lat,venueIsReserve);

            }
        } catch (Exception e) {
            e.printStackTrace();
            logger.info("query venueListIndexByCondition error"+e.getMessage());
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }

    /**
     * app查看展馆详情
     * @param userId    当前用户ID
     * @param venueId   展馆id
     * @return json    10108：展馆id缺失
     */
    @RequestMapping(value = "/venueAppDetail")
    public String venueAppDetail(HttpServletResponse response,String userId,String venueId) throws Exception {
        String json="";
        try {
            if(StringUtils.isNotBlank(venueId) && venueId!=null) {
               json=venueAppService.queryAppVenueDetailById(venueId, userId);
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
     * 根据展馆id查询相关活动
     * @param venueId  展馆id
     * @param pageIndex  首页下标
     * @param pageNum    显示条数
     * @return json 10108:展馆id缺失
     * @throws Exception
     */
    @RequestMapping(value = "/venueAppActivity")
    public String venueAppActivity(HttpServletResponse response,String venueId,String pageIndex,String pageNum,PaginationApp pageApp) throws Exception {
    	String json="";
        pageApp.setFirstResult(Integer.valueOf(pageIndex));
        pageApp.setRows(Integer.valueOf(pageNum));
        if(venueId!=null && StringUtils.isNotBlank(venueId)){
            json = activityAppService.queryAppActivityListById(venueId, pageApp);
        }else {
            json=JSONResponse.toAppResultFormat(10108, "展馆id缺失!");
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }

    /**
     * 根据展馆id获取活动室列表
     * @param venueId     展馆id
     * @param pageIndex  首页下标
     * @param pageNum    显示条数
     * @return 10108:展馆id缺失
     * @throws Exception
     */
    @RequestMapping(value = "/activityAppRoom")
    public String activityAppRoom(HttpServletResponse response,PaginationApp pageApp,String venueId,String pageIndex,String  pageNum) throws Exception {
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
     * why3.5 个人设置-我的所有的场馆评论
     * @param response
     * @param pageApp
     * @param pageIndex
     * @param pageNum
     * @param userId
     * @throws Exception
     */
    @RequestMapping(value = "/appVenueCommentList")
    public void appVenueCommentList(HttpServletResponse response, PaginationApp pageApp, String pageIndex, String pageNum, String userId) throws Exception{
        pageApp.setFirstResult(Integer.valueOf(pageIndex));
        pageApp.setRows(Integer.valueOf(pageNum));
        String json = "";
        try {
            if(StringUtils.isNotBlank(userId)){
                json = commentAppService.queryAppVenueCommentByUserId(pageApp, userId);
            }else{
                json = JSONResponse.toAppResultFormat(0, "用户id缺失");
            }
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
     * why3.5 个人设置-删除评论
     * @param response
     * @param commentId
     * @throws Exception
     */
    @RequestMapping(value = "/appDeleteVenueComment")
    public void appDeleteVenueComment(HttpServletResponse response, String commentId) throws Exception{
        String json = "";
        try {
            if(StringUtils.isNotBlank(commentId)){
                json = commentAppService.deleteAppCommentById(commentId);
            }else{
                json = JSONResponse.toAppResultFormat(10114, "评论id缺失");
            }
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
     * why3.5 app根据条件筛选场馆
     * @param response
     * @param Lon
     * @param Lat
     * @param venueType
     * @param venueArea
     * @param venueIsReserve
     * @param sortType
     * @throws Exception
     */
    @RequestMapping(value = "/appVenueList")
    public void appVenueList(HttpServletResponse response, String pageIndex, String pageNum, PaginationApp pageApp, String Lon, String Lat, String venueType,
                             String venueArea, String venueMood, String venueIsReserve, String sortType) throws Exception{
        pageApp.setFirstResult(Integer.valueOf(pageIndex));
        pageApp.setRows(Integer.valueOf(pageNum));
        String json = "";
        try {
            json = venueAppService.queryAppVenueList(pageApp, venueArea, venueMood, venueType, sortType, venueIsReserve, Lon, Lat);
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
     * why3.5 app查看展馆详情
     * @param userId    当前用户ID
     * @param venueId   展馆id
     * @return json    10108：展馆id缺失
     */
    @RequestMapping(value = "/cmsVenueAppDetail")
    public String cmsVenueAppDetail(HttpServletResponse response,String userId,String venueId) throws Exception {
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
     * why3.5 根据展馆id查询相关活动
     * @param venueId  展馆id
     * @param pageIndex  首页下标
     * @param pageNum    显示条数
     * @return json 10108:展馆id缺失
     * @throws Exception
     */
    @RequestMapping(value = "/venueAppCmsActivity")
    public String venueAppCmsActivity(HttpServletResponse response,String venueId,String pageIndex,String pageNum,PaginationApp pageApp) throws Exception {
        String json="";
        pageApp.setFirstResult(Integer.valueOf(pageIndex));
        pageApp.setRows(Integer.valueOf(pageNum));
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
     * why3.5 app用户报名场馆接口
     * @param venueId           场馆id
     * @param userId            用户id
     * return
     */
    @RequestMapping(value = "/appAddVenueUserWantgo")
    public String appAddVenueUserWantgo(HttpServletResponse response,String venueId,String userId) throws Exception {
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
     * why3.5 app用户取消报名场馆接口
     * @param venueId           场馆id
     * @param userId            用户id
     * return
     */
    @RequestMapping(value = "/appDeleteVenueUserWantgo")
    public String appDeleteVenueUserWantgo(HttpServletResponse response,String venueId,String userId) throws Exception {
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
     * why3.5 app获取场馆报名列表接口(点赞人列表)
     * @param venueId   场馆id
     * @param pageIndex 首页下标
     * @param pageNum   显示条数
     * return
     */
    @RequestMapping(value = "/appVenueUserWantgoList")
    public String appVenueUserWantgoList(HttpServletResponse response,String venueId,String pageIndex,String pageNum ,PaginationApp pageApp) throws Exception {
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
     * why3.5 app获取场馆浏览量
     * @param venueId 场馆id
     * return
     */
    @RequestMapping(value = "/appCmsVenueBrowseCount")
    public String appCmsVenueBrowseCount(HttpServletResponse response,String venueId) throws Exception {
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
     * why3.5 app根据条件筛选场馆(搜索功能)
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
    @RequestMapping(value = "/appCmsVenueList")
    public String appCmsVenueList(HttpServletResponse response,String venueType, String venueArea, String venueName, String pageIndex, String pageNum, PaginationApp pageApp) throws Exception {
        pageApp.setFirstResult(Integer.valueOf(pageIndex));
        pageApp.setRows(Integer.valueOf(pageNum));
        String json="";
        try {
            json = venueAppService.queryAppCmsVenueList(pageApp, venueType, venueArea, venueName);
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
}



