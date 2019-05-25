package com.sun3d.why.webservice.controller;
import com.sun3d.why.statistics.service.StatisticActivityUserService;
import com.sun3d.why.statistics.service.StatisticVenueUserService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.JSONResponse;
import com.sun3d.why.util.PaginationApp;
import com.sun3d.why.webservice.service.ActivityAppService;
import com.sun3d.why.webservice.service.CollectAppService;
import com.sun3d.why.webservice.service.UserCollectAppService;
import com.sun3d.why.webservice.service.VenueAppService;

import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
/**
 * 手机app接口 用户收藏列表
 * Created by Administrator on 2015/7/8
 *
 */
@RequestMapping("/appUserCollect")
@Controller
public class UserCollectAppController {
    private Logger logger = Logger.getLogger(UserCollectAppController.class);
    @Autowired
    private StatisticActivityUserService statisticActivityUserService;
    @Autowired
    private StatisticVenueUserService statisticVenueUserService;
    @Autowired
    private ActivityAppService activityAppService;
    @Autowired
    private VenueAppService venueAppService;
    @Autowired
    private CollectAppService collectAppService;
    @Autowired
    private UserCollectAppService userCollectAppService;

    /**
     * app显示用户收藏活动与展馆列表
     * @param userId        用户id
     * @param activityName 活动名称
     * @param venueName    展馆名称
     * @param pageIndex   首页下标
     * @param pageNum     显示条数
     * @return json 10111:用户id不存在
     */
    @RequestMapping(value = "/queryAppUserCollect")
    public String queryAppUserCollect(PaginationApp pageApp,HttpServletResponse response,String userId,String pageIndex,String pageNum,String activityName,String venueName) throws Exception {
        String json = "";
        pageApp.setFirstResult(Integer.valueOf(pageIndex));
        pageApp.setRows(Integer.valueOf(pageNum));
        try {
            if (StringUtils.isNotBlank(userId) && userId!=null) {
                json=userCollectAppService.queryAppUserCollectByCondition(userId, pageApp, 1, 2, activityName, venueName);
            } else {
                json=JSONResponse.commonResultFormat(10111,"用户id不存在",null);
            }
        } catch (Exception e) {
            e.printStackTrace();
            logger.info("query userCollect error!"+e.getMessage());
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }

    /**
     * why3.5 app显示用户收藏展馆列表
     * @param userId    用户id
     * @param pageIndex 首页下标
     * @param pageNum   显示条数
     * @return json 10111:用户id不存在
     */
    @RequestMapping(value = "/userAppCollectVen")
    public String userAppCollectVen(PaginationApp pageApp,HttpServletResponse response,String userId,String pageIndex,String pageNum) throws Exception {
        String json = "";
        try {
            if (StringUtils.isNotBlank(userId) && userId!=null) {
                pageApp.setFirstResult(Integer.valueOf(pageIndex));
                pageApp.setRows(Integer.valueOf(pageNum));
                json=venueAppService.queryCollectVenue(userId,pageApp);
            } else {
                json=JSONResponse.commonResultFormat(10111,"用户id不存在",null);
            }
        } catch (Exception e) {
            e.printStackTrace();
            logger.info("query userCollectVen error!" + e.getMessage());
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }

    /**
     * why3.5 app显示用户收藏活动列表
     * @param userId    用户id
     * @param pageIndex 首页下标
     * @param pageNum   显示条数
     * @return json 10111:用户id不存在
     */
    @RequestMapping(value = "/userAppCollectAct")
    public String userAppCollectAct(PaginationApp pageApp,HttpServletResponse response,String userId,String pageIndex,String pageNum) throws Exception {
        String json = "";
        try {
            if (StringUtils.isNotBlank(userId) && userId!=null) {
                pageApp.setFirstResult(Integer.valueOf(pageIndex));
                pageApp.setRows(Integer.valueOf(pageNum));
                json=activityAppService.queryUserAppCollectAct(userId,pageApp);
            } else {
                json=JSONResponse.commonResultFormat(10111,"用户id不存在",null);
            }
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
     * app用户收藏活动
     * @param userId 用户id
     * @param activityId 活动id
     * @return json 10121 用户id 或 活动id缺失 10122 用户已收藏成功  0.收藏成功 1收藏失败 10123.查无此人
     * @throws Exception
     */
    @RequestMapping(value = "/appCollectActivity")
    public String appCollectActivity(HttpServletRequest request, HttpServletResponse response,String userId,String activityId) throws Exception {
        String json="";
        try {
            if(StringUtils.isNotBlank(userId) && StringUtils.isNotBlank(activityId)){
              json=collectAppService.addCollectActivity(userId, activityId, request, statisticActivityUserService);
            }
        }catch (Exception e){
            e.printStackTrace();
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().print(json);
        return null;
    }
    /**
     *app取消活动收藏
     * @param userId 用户id
     * @param activityId 活动id
     * @return json 10121 用户id 或 活动id缺失 0 用户取消收藏成功 1取消收藏失败
     */
    @RequestMapping(value = "/appDelCollectActivity")
    public String appDelCollectActivity(HttpServletRequest request, HttpServletResponse response,String userId,String activityId) throws Exception {
        String json="";
        try {
            if(StringUtils.isNotBlank(userId) && StringUtils.isNotBlank(activityId)){
                json=collectAppService.delCollectActivity(userId, activityId, request, statisticActivityUserService);
            }
            else {
                json=JSONResponse.commonResultFormat(10121,"用户或活动id缺失",null);
            }
        }catch (Exception e){
            e.printStackTrace();
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().print(json);
        return null;
    }
    /**
     * app用户收藏展馆
     * @param userId 用户id
     * @param venueId 展馆id
     * @return json 10121 用户id 或 活动id缺失 10122 展馆收藏成功 0.收藏展馆成功 1.收藏展馆失败 10123.查无此人
     * @throws Exception
     */
    @RequestMapping(value = "/appCollectVenue")
    public String appCollectVenue(HttpServletRequest request, HttpServletResponse response,String userId,String venueId) throws Exception {
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
     * app用户取消收藏展馆
     * @param userId 用户id
     * @param venueId 展馆id
     * @return
     */
    @RequestMapping(value = "/appDelCollectVenue")
    public String appDelCollectVenue(HttpServletRequest request, HttpServletResponse response,String userId,String venueId) throws Exception {
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
     * why3.5 app显示用户收藏展馆列表
     * @param userId    用户id
     * @param pageIndex 首页下标
     * @param pageNum   显示条数
     * @return json 10111:用户id不存在
     */
    @RequestMapping(value = "/userAppCollectByUser")
    public String userAppCollectByUser(PaginationApp pageApp,HttpServletResponse response,String collectType,String userId,String pageIndex,String pageNum) throws Exception {
        String json = "";
        try {
            if (StringUtils.isNotBlank(userId) && userId!=null) {
                pageApp.setFirstResult(Integer.valueOf(pageIndex));
                pageApp.setRows(Integer.valueOf(pageNum));
                if("2".equals(collectType)){
                	json=activityAppService.queryUserAppCollectAct(userId,pageApp);
                }else{
                	json=venueAppService.queryCollectVenue(userId,pageApp);
                }
            } else {
                json=JSONResponse.commonResultFormat(500,"用户id不存在",null);
            }
        } catch (Exception e) {
            e.printStackTrace();
            json=JSONResponse.toAppResultFormat(500, e.getMessage());
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }
    
    
    /**
     *app取消收藏
     * @param userId 用户id
     * @param activityId 活动id
     * @return json 10121 用户id 或 活动id缺失 0 用户取消收藏成功 1取消收藏失败
     */
    @RequestMapping(value = "/appDelCollectByType")
    public String appDelCollectActivity(HttpServletRequest request, HttpServletResponse response,String collectType, String userId,String retaleatId) throws Exception {
        String json="";
        try {
            if(StringUtils.isNotBlank(userId) && StringUtils.isNotBlank(retaleatId)){
            	if("2".equals(collectType)){
            		 json=collectAppService.delCollectActivity(userId, retaleatId, request, statisticActivityUserService);
            	}else{
            		json=collectAppService.delCollectVenue(userId, retaleatId, request, statisticVenueUserService);
            	}
            }
            else {
                json=JSONResponse.commonResultFormat(500,"取消收藏失败",null);
            }
        }catch (Exception e){
            e.printStackTrace();
            json=JSONResponse.commonResultFormat(500,"取消收藏失败",null);
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().print(json);
        return null;
    }
}