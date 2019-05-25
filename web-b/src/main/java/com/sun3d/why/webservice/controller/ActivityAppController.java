package com.sun3d.why.webservice.controller;

import com.sun3d.why.model.CmsActivity;
import com.sun3d.why.model.CmsComment;
import com.sun3d.why.model.SysDict;
import com.sun3d.why.service.CmsAppSettingService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.JSONResponse;
import com.sun3d.why.util.PaginationApp;
import com.sun3d.why.webservice.api.service.CmsApiActivityOrderService;
import com.sun3d.why.webservice.service.*;

import net.sf.json.JSONObject;

import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.InputStream;
import java.util.*;

/**
 * 手机app3.2接口 活动列表
 * Created by Administrator on 2015/7/1
 */
@RequestMapping("/appActivity")
@Controller
public class ActivityAppController {
    private Logger logger = Logger.getLogger(ActivityAppController.class);
    @Autowired
    private ActivityAppService activityAppService;
    @Autowired
    private AdvertService advertAppService;
    @Autowired
    private CommentAppService commentAppService;
    @Autowired
    private SysDicAppService SysDicAppService;
    @Autowired
    private CmsApiActivityOrderService cmsApiActivityOrderService;
    @Autowired
    private CmsAppSettingService cmsAppSettingService;
    @Autowired
    private AdvertAppRecommendService advertAppRecommendService;
    @Autowired
    private AdvertAppCalendarService advertAppCalendarService;

    /**
     * app首页banner轮播图
     * @param response
     * @param type 1-首页轮播图 3-近期活动广告
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/appActivityBanner")
    public String appActivityBanner(HttpServletResponse response,int type) throws Exception {
        String json="";
        try {
            json=advertAppService.queryAppAdvertBySite(type);
        }catch (Exception e){
            e.printStackTrace();
            logger.info("query activityBanner error"+e.getMessage());
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }


    /**
     * app首页栏目推荐活动列表(已废弃)
     * @param Lon       用户经度
     * @param Lat       用户纬度
     * @param pageIndex 首页下标
     * @param pageNum   显示条数
     * return json     10125系统错误
     */
    @RequestMapping(value = "/appActivityListIndex")
    public String appActivityListIndex(String Lon,String Lat,HttpServletResponse response,String pageIndex,String pageNum,PaginationApp pageApp) throws Exception {
        String  json="";
        pageApp.setFirstResult(Integer.valueOf(pageIndex));
        pageApp.setRows(Integer.valueOf(pageNum));
        try{
            json=activityAppService.queryAppActivityList(pageApp,Lon,Lat,Constant.FREE_ACTIVITY,Constant.CHILDREN_ACTIVITY,Constant.WHERE_ACTIVITY);
        }catch(Exception e){
            e.printStackTrace();
            logger.error("query activityListIndex error" + e.getMessage());
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }



    /**
     * app获取活动列表与推荐前3条
     * @param Lon       用户经度
     * @param Lat       用户纬度
     * @param pageIndex 首页下标
     * @param pageNum   显示条数
     * @param locationType  区域类型
     * @param activityIsRecommend 活动是否推荐 Y(是)  N(否)
     * return json     10125系统错误

    @RequestMapping(value = "/appActivityListIndex")
    public String appActivityListIndex(String Lon,String Lat,String locationType,HttpServletResponse response,String pageIndex,String pageNum ,PaginationApp pageApp,String activityIsRecommend) throws Exception {
        pageApp.setFirstResult(Integer.valueOf(pageIndex));
        pageApp.setRows(Integer.valueOf(pageNum));
        String  json=activityAppService.queryAppActivityList(pageApp,locationType,Lon,Lat,activityIsRecommend);
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }
     */

    /**
     * app根据不同条件筛选活动列表(近期活动，按活动名称搜索)
     * @param activity  活动对象
     * @param timeType  1.今天 2.代表 明天 3本周末
     * @param Lon        用户经度
     * @param Lat        用户纬度
     * @param pageIndex 首页下标
     * @param pageNum   显示条数
     * return json        10125系统错误
     */
     @RequestMapping(value = "/queryActivityListByCondition")
     public String queryAppActivityListByCondition(CmsActivity activity,String Lon,String Lat,HttpServletResponse response,String pageIndex,String pageNum,PaginationApp pageApp,String timeType) throws Exception {
     pageApp.setFirstResult(Integer.valueOf(pageIndex));
     pageApp.setRows(Integer.valueOf(pageNum));
     String json="";
     try {
         json=activityAppService.queryAppActivityListByCondition(activity,timeType,pageApp, Lon,Lat);
     }catch (Exception e){
         e.printStackTrace();
         logger.info("query activityListByCondition error"+e.getMessage());
     }
     response.setContentType("text/html;charset=UTF-8");
     response.getWriter().write(json);
     response.getWriter().flush();
     response.getWriter().close();
     return null;
     }




    /**
     * 根据活动类型进行筛选活动列表
     * @param Lon                      用户经度
     * @param Lat                      用户纬度
     * @param pageIndex               开始位置
     * @param pageNum                 显示条数
     * @param appType                 活动类型筛选  1.距离  2.即将开始 3.热门 4.app列表
     * @param activityTime           活动时间
     * @param activityTypeId         活动类型标签id
     * @param userId                  用户id
     * @return json
     */
    @RequestMapping(value = "/appActivityIndex")
    public String appActivityIndex(String pageIndex,String pageNum,PaginationApp pageApp,HttpServletResponse response,String appType,String Lon,String Lat,String activityTime,String activityTypeId,String userId) throws Exception {
        String json = "";
        pageApp.setFirstResult(Integer.valueOf(pageIndex));
        pageApp.setRows(Integer.valueOf(pageNum));
        try {
            switch (Integer.valueOf(appType)) {
                //热门活动
                case 3:
                    json = activityAppService.queryAppHotByActivity(pageApp, Lon, Lat, activityTypeId, appType, userId);
                    break;
                //附近活动或即将开始
                default:
                    json = activityAppService.queryActivityListPage(appType, pageApp, Lon, Lat, activityTime, activityTypeId,userId);
            }
        }catch (Exception e){
            e.printStackTrace();
            logger.info("query activityIndex error"+e.getMessage());
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }

    /**
     * app查询推荐的活动
     * @param pageIndex               开始位置
     * @param pageNum                 显示条数
     * @return json
     */
    @RequestMapping(value = "/appRecommendActivity")
    public String appRecommendActivity(String pageIndex,String pageNum,PaginationApp pageApp,HttpServletResponse response) throws Exception {
        String json = "";
        pageApp.setFirstResult(Integer.valueOf(pageIndex));
        pageApp.setRows(Integer.valueOf(pageNum));
        try {
            json = activityAppService.queryRecommendActivity(pageApp);
        }catch (Exception e){
            e.printStackTrace();
            logger.info("query appRecommendActivity error"+e.getMessage());
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }

    /**
     * why3.4 app查询推荐的活动
     * @param pageIndex               开始位置
     * @param pageNum                 显示条数
     * @return json
     */
    @RequestMapping(value = "/appRecommendCmsActivity")
    public String appRecommendCmsActivity(String pageIndex,String pageNum,PaginationApp pageApp,HttpServletResponse response) throws Exception {
        String json = "";
        pageApp.setFirstResult(Integer.valueOf(pageIndex));
        pageApp.setRows(Integer.valueOf(pageNum));
        try {
            json = activityAppService.queryRecommendCmsActivity(pageApp);
        }catch (Exception e){
            json = JSONResponse.toAppResultFormat(1, e.getMessage());
            logger.info("query appRecommendActivity error"+e.getMessage());
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }

    /**
     * app查询标签置顶的活动
     * @param pageIndex               开始位置
     * @param pageNum                 显示条数
     * @return json
     */
    @RequestMapping(value = "/appTopActivity")
    public String appTopActivity(String pageIndex,String pageNum,String tagId,PaginationApp pageApp,HttpServletResponse response) throws Exception {
        String json = "";
        pageApp.setFirstResult(Integer.valueOf(pageIndex));
        pageApp.setRows(Integer.valueOf(pageNum));
        try {
            json = activityAppService.queryTopActivity(pageApp, tagId);
        }catch (Exception e){
            e.printStackTrace();
            logger.info("query appRecommendActivity error"+e.getMessage());
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }

    /**
     * why3.4 app查询标签置顶的活动
     * @param pageIndex               开始位置
     * @param pageNum                 显示条数
     * @return json
     */
    @RequestMapping(value = "/appTopCmsActivity")
    public String appTopCmsActivity(String pageIndex,String pageNum,String tagId,PaginationApp pageApp,HttpServletResponse response) throws Exception {
        String json = "";
        pageApp.setFirstResult(Integer.valueOf(pageIndex));
        pageApp.setRows(Integer.valueOf(pageNum));
        try {
            json = activityAppService.queryTopCmsActivity(pageApp, tagId);
        }catch (Exception e){
            e.printStackTrace();
            logger.info("query appRecommendActivity error"+e.getMessage());
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }

    /**
     * app即将开始与标签下的活动数目
     * @param userId 用户id
     * @param tagId  类型标签id
     * @return json
     */
    @RequestMapping(value = "/appWillStartActivityCount")
    public void appWillStartActivityCount(HttpServletResponse response,String userId,String tagId) throws Exception {
        String json = "";
        try {
            /*if (userId!=null && StringUtils.isNotBlank(userId)) {*/
                json = activityAppService.queryAppWillStartActivityCount(userId,tagId);
            /*} else {
                json = JSONResponse.commonResultFormat(10107, "用户id缺失", null);
            }*/
        } catch (Exception e) {
            e.printStackTrace();
            logger.info("系统出错!"+e.getMessage());
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(json);
        response.getWriter().flush();
        response.getWriter().close();
    }


    /**
     * app添加即将开始时的活动
     * @return json
     */
    @RequestMapping(value = "/appAddWillStart")
    public void appAddWillStart(HttpServletResponse response, String userId, String versionNo, String tagId) throws Exception {
        String json = "";
        try {
            if (userId!=null && StringUtils.isNotBlank(userId)) {
                json = activityAppService.addAppWillStart(userId, versionNo, tagId);
            } else {
                json = JSONResponse.toAppResultFormat(1, "点击即将开始操作成功");
            }
        } catch (Exception e) {
            e.printStackTrace();
            logger.info("add willStart error"+e.getMessage());
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(json);
        response.getWriter().flush();
        response.getWriter().close();
    }

    /**
     * app查看活动详情
     * @param userId      用户id
     * @param activityId 活动id
     * @return json  10107 活动id缺失
     */
    @RequestMapping(value = "/activityAppDetail")
    public String activityAppDetail(HttpServletResponse response,String activityId,String userId) throws Exception {
        String json = "";
        try {
            if (StringUtils.isNotBlank(activityId) && activityId != null) {
                json=activityAppService.queryAppActivityById(activityId,userId);
            } else {
                json = JSONResponse.commonResultFormat(10107, "活动id缺失", null);
            }
        } catch (Exception e) {
            e.printStackTrace();
            logger.info("query activityDetail error!"+e.getMessage());
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }

    /**
     * why3.5 app查看活动详情
     * @param userId      用户id
     * @param activityId 活动id
     * @return json  10107 活动id缺失
     */
    @RequestMapping(value = "/cmsActivityAppDetail")
    public String cmsActivityAppDetail(HttpServletResponse response,String activityId,String userId) throws Exception {
        String json = "";
        try {
            if (StringUtils.isNotBlank(activityId) && activityId != null) {
                json=activityAppService.queryAppCmsActivityById(activityId, userId);
            } else {
                json = JSONResponse.commonResultFormat(10107, "活动id缺失", null);
            }
        } catch (Exception e) {
            e.printStackTrace();
            logger.info("query activityDetail error!"+e.getMessage());
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }

    /**
     * 查询某类型评论
     * @param moldId     类型id
     * @param type       评论类型 1.展馆 2.活动 3.藏品 4.专题 5.会员 6.团体 7.活动室
     * @param pageIndex  首页下标
     * @param pageNum    显示条数
     * @return json 10107 活动id缺失
     * @throws Exception
     */
    @RequestMapping(value = "/activityAppComment")
    public String activityAppComment(HttpServletResponse response, PaginationApp pageApp,String moldId,String type,String pageIndex,String pageNum) throws Exception {
        String json = "";
        pageApp.setFirstResult(Integer.valueOf(pageIndex));
        //每页显示的页数
        pageApp.setRows(Integer.valueOf(pageNum));
        try {
            if (StringUtils.isNotBlank(moldId) && moldId != null) {
                json=commentAppService.queryAppCommentByCondition(moldId,type,pageApp);
            } else {
                json = JSONResponse.commonResultFormat(10107, "评论对象id缺失", null);
            }
        } catch (Exception e) {
            e.printStackTrace();
            logger.info("query comment error" + e.getMessage());
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().print(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }

    /**
     * app添加评论
     * @param comment 评论对象
     * @return json 0:代表评论成功  1:代表评论失败
     * @throws Exception
     */
    @RequestMapping(value = "/addComment")
    public String addComment(CmsComment comment,HttpServletResponse response) throws Exception {
        String json = "";
        try {
            json=commentAppService.addComment(comment);
        } catch (Exception e) {
             e.printStackTrace();
             logger.info("add comment error!"+e.getMessage());
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().print(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }


    /**
     * app获取活动座位
     * @param activityId 活动id
     * @param userId     用户id
     * @param activityEventimes 活动具体时间
     * @return 14101 活动或用户参数缺失
     * @throws Exception
     */
    @RequestMapping(value = "/appActivityBook")
    public String appActivityBook(HttpServletResponse response, String activityId,String userId,String activityEventimes) throws Exception {
        String json="";
        if (StringUtils.isEmpty(activityId) && StringUtils.isEmpty(userId)) {
            json = JSONResponse.commonResultFormat(14101, "活动或用户id缺失", null);
        }else {
            json=activityAppService.queryAppActivitySeatsById(activityId, userId,activityEventimes);
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }

    /**
     * app进入提交订单
     * @param activityId        活动id
     * @param userId            用户id
     * @param bookCount         订购张数
     * @param orderMobileNum    预定电话
     * @param orderName			姓名
     * @param orderIdentityCard	身份证
     * @param orderPrice        票价
     * @param activityEventIds 活动场次id
     * @param activityEventimes 活动具体时间
     * @param costTotalCredit 	参与此活动消耗的总积分数
     * @return 14101 活动或用户id缺失
     * @throws Exception
     */
    @RequestMapping(value = "/appActivityOrder")
    public String appActivityOrder(HttpServletRequest request, HttpServletResponse response,String activityId,String userId,String activityEventIds,
    		String bookCount,String orderMobileNum,String orderPrice,String activityEventimes, String orderName, String orderIdentityCard, String costTotalCredit) throws Exception {
        String json="";
        String seatId = request.getParameter("seatIds");
        String seatValues = request.getParameter("seatValues");
        String[] seatIds = new String[0];
        if (seatId != null && StringUtils.isNotBlank(seatId)) {
            seatIds = seatId.split(",");
        }
        try {
            if (StringUtils.isBlank(userId) && StringUtils.isBlank(activityId)) {
                json= JSONResponse.commonResultFormat(14101, "活动或用户id缺失", null);
            }else {
                json=activityAppService.appActivityOrderByCondition(activityId,userId,activityEventIds,bookCount,orderMobileNum,orderPrice,activityEventimes,seatIds,seatValues,orderName, orderIdentityCard,costTotalCredit);
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            logger.info("activityOrder error" + ex.getMessage());
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().print(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }
    
    /**
     * app获取首页（类型）标签列表接口
     * @param userId 用户id
     * return
     */
    @RequestMapping(value = "/appActivityTagList")
    public String appActivityTagList(HttpServletResponse response,String userId) throws Exception {
        String json="";
        try {
            json=activityAppService.queryAppActivityTagList(userId);
        }catch (Exception e){
            e.printStackTrace();
            logger.info("query activityTagList error" + e.getMessage());
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }
    
    /**
     * app用户报名活动接口
     * @param activityId        活动id
     * @param userId            用户id
     * return
     */
    @RequestMapping(value = "/appAddActivityUserWantgo")
    public String appAddActivityUserWantgo(HttpServletResponse response,String activityId,String userId) throws Exception {
        String json="";
        try{
             json=activityAppService.addActivityUserWantgo(activityId, userId);
        }catch (Exception e){
            e.printStackTrace();
            logger.error("add activityUserWantgo error" + e.getMessage());
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }

    /**
     * app用户取消报名活动接口
     * @param activityId        活动id
     * @param userId            用户id
     * return
     */
    @RequestMapping(value = "/deleteActivityUserWantgo")
    public String deleteActivityUserWantgo(HttpServletResponse response,String activityId,String userId) throws Exception {
        String json="";
        try{
            json=activityAppService.deleteActivityUserWantgo(activityId, userId);
        }catch (Exception e){
            e.printStackTrace();
            logger.error("delete activityUserWantgo error" + e.getMessage());
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }

    /**
     * app获取活动报名列表接口(点赞人)
     * @param activityId 活动id
     * @param pageIndex 首页下标
     * @param pageNum   显示条数
     * return 
     */
    @RequestMapping(value = "/appActivityUserWantgoList")
    public String appActivityUserWantgoList(HttpServletResponse response,String activityId,String pageIndex,String pageNum ,PaginationApp pageApp) throws Exception {
    	pageApp.setFirstResult(Integer.valueOf(pageIndex));
        pageApp.setRows(Integer.valueOf(pageNum));
        String json="";
        try {
            json=activityAppService.queryAppActivityUserWantgoList(pageApp, activityId);
        }catch (Exception e){
          e.printStackTrace();
          logger.info("query activityUserWantgoList error"+e.getMessage());
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }

    /**
     * why3.5 app获取活动报名列表接口(点赞人列表)
     * @param activityId 活动id
     * @param pageIndex 首页下标
     * @param pageNum   显示条数
     * return
     */
    @RequestMapping(value = "/appCmsActivityUserWantgoList")
    public String appCmsActivityUserWantgoList(HttpServletResponse response,String activityId,String pageIndex,String pageNum ,PaginationApp pageApp) throws Exception {
        pageApp.setFirstResult(Integer.valueOf(pageIndex));
        pageApp.setRows(Integer.valueOf(pageNum));
        String json="";
        try {
            if(StringUtils.isNotBlank(activityId)){
                json = activityAppService.queryAppCmsActivityUserWantgoList(pageApp, activityId);
            }else{
                json = JSONResponse.toAppResultFormat(14101, "活动id缺失");
            }
        }catch (Exception e){
            json = JSONResponse.toAppResultFormat(10107, e.getMessage());
            logger.info("query activityUserWantgoList error"+e.getMessage());
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }

    /**
     * why3.5 app获取浏览量
     * @param activityId 活动id
     * return
     */
    @RequestMapping(value = "/appCmsActivityBrowseCount")
    public String appCmsActivityBrowseCount(HttpServletResponse response,String activityId) throws Exception {
        String json="";
        try {
            if(StringUtils.isNotBlank(activityId)){
                json = activityAppService.queryAppCmsActivityBrowseCount(activityId);
            }else{
                json = JSONResponse.commonResultFormat(14101, "活动id缺失", null);
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
     * app用户浏览标签随机推送活动(已废弃)
     * @param userId 用户id
     * @param activityId 活动id
     * return
     */
    @RequestMapping(value = "/addRandActivity")
    public String addRandActivity(HttpServletResponse response,String userId,String activityId) throws Exception {
        String json="";
        try {
             json=activityAppService.addRandActivity(userId, activityId);
         }catch (Exception e){
           e.printStackTrace();
           logger.info("add randActivity error"+e.getMessage());
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }

    /**
     * app新的活动天数参数
     * @param response ,type代表接口请求类型 1=代码请求活动热天数 2=代表热搜关键字
     * @return json
     */
    @RequestMapping(value = "/appSettingPara")
    public String appSettingPara(HttpServletResponse response,String type) throws Exception {
        String json="";
        Properties properties = new Properties();
        try {
            InputStream is = this.getClass().getClassLoader().getResourceAsStream("pro.properties");
            properties.load(is);
            if("1".equals(type)){
                List words = cmsAppSettingService.getList("hotDays");
                StringBuilder result=new StringBuilder();
                boolean flag=false;
                for (Object string : words) {
                    if (flag) {
                        result.append(",");
                    }else {
                        flag=true;
                    }
                    result.append(string);
                }
                json =JSONResponse.toAppResultFormat(0,result.toString());
            }else{
                List words = cmsAppSettingService.getList("activityHotKeywords");
                StringBuilder result=new StringBuilder();
                boolean flag=false;
                for (Object string : words) {
                    if (flag) {
                        result.append(",");
                    }else {
                        flag=true;
                    }
                    result.append(string);
                }
                json =JSONResponse.toAppResultFormat(0, result.toString());
            }
        }catch (Exception e){
            e.printStackTrace();
            logger.info("appHotDaysNum error"+e.getMessage());
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }

    /**
     * why3.4 app查询首页的活动的浏览量、收藏量、评论量、余票、距离
     * @return json
     */
    @RequestMapping(value = "/appIndexActivityAllCount")
    public String appIndexActivityAllCount(String activityIds, HttpServletResponse response, String Lon, String Lat) throws Exception {
        String json = "";
        try {
            if(StringUtils.isNotBlank(activityIds)){
                String[] activityId = activityIds.split(",");
                List<String> list = new ArrayList<String>();
                for(String id: activityId){
                    list.add(id);
                }
                json = activityAppService.queryAppIndexData(list, Lon, Lat);
            }else{
                json = JSONResponse.commonResultFormat(10107, "活动id缺失", null);
            }
        }catch (Exception e){
            e.printStackTrace();
            logger.info("query appRecommendActivity error"+e.getMessage());
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }

    /**
     * why3.4 app查询近期活动列表
     * @param response
     * @param pageIndex 显示下标
     * @param pageNum   显示条数
     * @param activityType 分类(活动标签id,以逗号拼接成字符串)
     * @param activityArea 市区code
     * @param activityLocation 区域商圈id
     * @param sortType 排序类别 0-智能排序 1-离我最近 2-即将开始 3-即将结束 4-最新发布 5-人气最高 6-评价最好
     * @param Lon 经度
     * @param Lat 纬度
     * @param chooseType 筛选类别 1(5天之内) 2(5-10天) 3(10-15天) 4(15天以后)
     * @param isWeekend 是否周末  1-周末 0-工作日 空表示不选
     * @param bookType 1-可预订 0-直达现场 空表示所有
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/appNearActivity")
    public String appNearActivity(String pageIndex, String pageNum, PaginationApp pageApp,
                                  HttpServletResponse response, String activityType, String activityArea,
                                  String activityLocation, String sortType, String Lon, String Lat,
                                  String chooseType, String isWeekend, String bookType) throws Exception {
        pageApp.setFirstResult(Integer.valueOf(pageIndex));
        pageApp.setRows(Integer.valueOf(pageNum));
        String json = "";
        try {
            json = activityAppService.queryNearActivityByCondition(pageApp, activityType, activityArea,
                    activityLocation, sortType, Lon, Lat, chooseType, isWeekend, bookType);
        }catch (Exception e){
            json = JSONResponse.toAppResultFormat(10107, e.getMessage());
            logger.info("query appRecommendActivity error"+e.getMessage());
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }

    //获取商圈所有数据
    @RequestMapping(value = "/getAllArea",method = RequestMethod.GET)
    @ResponseBody
    public Map<String,Object> getAllArea(){
        Map<String,Object> result = new HashMap<String,Object>();
        result.put("status", 200);
        try{
            List<SysDict> dataList =  SysDicAppService.queryAllArea();
            result.put("data",dataList);
            return  result;
        }catch (Exception e){
            e.printStackTrace();
            result.put("status",500);
            result.put("data","服务器响应失败");
        }
        return  result;
    }

    /**
     * 得到子区县中的活动 余票数量
     * @param sysIds(以字逗号拼接的活动id)
     * @param response
     * @throws Exception
     */
    @RequestMapping(value = "/getSubSystemTicketCount")
    public void getSubSystemTicketCount(String sysIds, HttpServletResponse response) throws Exception{
        String json = "";
        try {
            if(StringUtils.isNotBlank(sysIds)){
                String[] ids = sysIds.split(",");
                json = JSONObject.fromObject(cmsApiActivityOrderService.getSubSystemActivityTicketCount(ids)).toString();
            }else{
                json = JSONResponse.toAppResultFormat(0, "活动id缺失");
            }
        }catch (Exception e){
            json = JSONResponse.toAppResultFormat(10107, e.getMessage());
            logger.info("query getSubSystemTicketCount error:"+e.getMessage());
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(json);
        response.getWriter().flush();
        response.getWriter().close();
    }

    /**
     * why3.5 app日历下每天活动场数
     * @param response
     * @param startDate
     * @param endDate
     * @throws Exception
     */
    @RequestMapping(value = "/appEveryDateActivityCount")
    public void appEveryDateActivityCount(HttpServletResponse response, String startDate, String endDate) throws Exception{
        String json = "";
        try {
            if(StringUtils.isNotBlank(startDate) && StringUtils.isNotBlank(endDate)){
                json = activityAppService.queryEventDateActivityCount(startDate, endDate);
            }else{
                json = JSONResponse.toAppResultFormat(14101, "活动开始日期或活动结束日期缺失");
            }
        }catch (Exception e){
            json = JSONResponse.toAppResultFormat(10107, e.getMessage());
            logger.info("query appEveryDateActivityCount error:"+e.getMessage());
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(json);
        response.getWriter().flush();
        response.getWriter().close();
    }

    /**
     * why3.5 app日历下某一天活动列表
     * @param response
     * @param pageApp
     * @param pageIndex
     * @param pageNum
     * @param everyDate
     * @param Lon
     * @param Lat
     * @throws Exception
     */
    @RequestMapping(value = "/appEveryDateActivityList")
    public void appEveryDateActivityList(HttpServletResponse response, PaginationApp pageApp, String pageIndex, String pageNum, String everyDate, String Lon, String Lat) throws Exception{
        pageApp.setFirstResult(Integer.valueOf(pageIndex));
        pageApp.setRows(Integer.valueOf(pageNum));
        String json = "";
        try {
            if(StringUtils.isNotBlank(everyDate)){
                json = activityAppService.queryAppEveryDateActivityList(pageApp, everyDate, Lon, Lat);
            }else{
                json = JSONResponse.toAppResultFormat(0, "日期缺失");
            }
        }catch (Exception e){
            json = JSONResponse.toAppResultFormat(10107, e.getMessage());
            logger.info("query appEveryDateActivityList error:"+e.getMessage());
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(json);
        response.getWriter().flush();
        response.getWriter().close();
    }

    /**
     * why3.5 app附近活动列表
     * @param response
     * @param pageApp
     * @param pageIndex
     * @param pageNum
     * @param Lon
     * @param Lat
     * @param activityType
     * @param activityIsFree	是否收费 1-免费 2-收费
     * @param activityIsReservation		是否预定 1-不可预定 2-可预定
     * @param sortType	排序 1-智能排序 2-热门排序 3-最新上线 4-即将结束
     * @throws Exception
     */
    @RequestMapping(value = "/appNearActivityList")
    public void appNearActivityList(HttpServletResponse response, PaginationApp pageApp, String pageIndex, String pageNum, 
    			String Lon, String Lat, String activityType, String activityIsFree, String activityIsReservation, String sortType) throws Exception{
        pageApp.setFirstResult(Integer.valueOf(pageIndex));
        pageApp.setRows(Integer.valueOf(pageNum));
        String json = "";
        try {
            json = activityAppService.queryAppNearActivityList(pageApp, activityType, activityIsFree, activityIsReservation, sortType, Lon, Lat);
        }catch (Exception e){
            json = JSONResponse.toAppResultFormat(10107, e.getMessage());
            logger.info("query appNearActivityList error:"+e.getMessage());
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(json);
        response.getWriter().flush();
        response.getWriter().close();
    }

    /**
     * why3.5 个人设置-我的所有的活动评论
     * @param response
     * @param pageApp
     * @param pageIndex
     * @param pageNum
     * @param userId
     * @throws Exception
     */
    @RequestMapping(value = "/appActivityCommentList")
    public void appActivityCommentList(HttpServletResponse response, PaginationApp pageApp, String pageIndex, String pageNum, String userId) throws Exception{
        pageApp.setFirstResult(Integer.valueOf(pageIndex));
        pageApp.setRows(Integer.valueOf(pageNum));
        String json = "";
        try {
            if(StringUtils.isNotBlank(userId)){
                json = commentAppService.queryAppActivityCommentByUserId(pageApp, userId);
            }else{
                json = JSONResponse.toAppResultFormat(0, "用户id缺失");
            }
        }catch (Exception e){
            json = JSONResponse.toAppResultFormat(10107, e.getMessage());
            logger.info("query appActivityCommentList error:"+e.getMessage());
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
    @RequestMapping(value = "/appDeleteActivityComment")
    public void appDeleteActivityComment(HttpServletResponse response, String commentId) throws Exception{
        String json = "";
        try {
            if(StringUtils.isNotBlank(commentId)){
                json = commentAppService.deleteAppCommentById(commentId);
            }else{
                json = JSONResponse.toAppResultFormat(10114, "评论id缺失");
            }
        }catch (Exception e){
            json = JSONResponse.toAppResultFormat(10107, e.getMessage());
            logger.info("appDeleteActivityComment error:"+e.getMessage());
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(json);
        response.getWriter().flush();
        response.getWriter().close();
    }

    /**
     * why3.5 app根据不同条件筛选活动列表(搜索功能)
     * @param activityArea
     * @param activityType
     * @param activityName
     * @param Lon
     * @param Lat
     * @param response
     * @param pageIndex
     * @param pageNum
     * @param pageApp
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/appCmsActivityListByCondition")
    public String appCmsActivityListByCondition(String activityArea, String activityType, String activityName,String Lon,String Lat,HttpServletResponse response,String pageIndex,String pageNum,PaginationApp pageApp) throws Exception {
        pageApp.setFirstResult(Integer.valueOf(pageIndex));
        pageApp.setRows(Integer.valueOf(pageNum));
        String json="";
        try {
            json=activityAppService.queryAppCmsActivityListByCondition(activityArea, activityType, activityName, pageApp, Lon,Lat);
        }catch (Exception e){
            e.printStackTrace();
            logger.info("query appCmsActivityListByCondition error"+e.getMessage());
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }

    /**
     * why3.5 app查询推荐的活动
     * @param pageIndex               开始位置
     * @param pageNum                 显示条数
     * @return json
     */
    @RequestMapping(value = "/appRecommendActivityList")
    public String appRecommendActivityList(String pageIndex,String pageNum,PaginationApp pageApp,HttpServletResponse response) throws Exception {
        String json = "";
        pageApp.setFirstResult(Integer.valueOf(pageIndex));
        pageApp.setRows(Integer.valueOf(pageNum));
        try {
            json = activityAppService.queryRecommendActivityList(pageApp);
        }catch (Exception e){
            json = JSONResponse.toAppResultFormat(1, e.getMessage());
            logger.info("query appRecommendActivityList error"+e.getMessage());
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }
    
    /**
     * app查询推荐的活动（带筛选）
     * @param activityArea
     * @param activityLocation 区域商圈id
     * @param activityIsFree	是否收费 1-免费 2-收费
     * @param activityIsReservation		是否预定 1-不可预定 2-可预定
     * @param sortType	排序 1-智能排序 2-热门排序 3-最新上线 4-即将结束
     * @param pageIndex 开始位置
     * @param pageNum   显示条数
     * @return json
     */
    @RequestMapping(value = "/appFilterActivityList")
    public String appFilterActivityList(String pageIndex, String pageNum, PaginationApp pageApp, HttpServletResponse response,
    			String activityArea,String activityLocation,String activityIsFree,String activityIsReservation,String sortType) throws Exception {
        String json = "";
        pageApp.setFirstResult(Integer.valueOf(pageIndex));
        pageApp.setRows(Integer.valueOf(pageNum));
        try {
            json = activityAppService.queryFilterActivityList(pageApp, activityArea, activityLocation, activityIsFree, activityIsReservation, sortType);
        } catch (Exception e) {
            e.printStackTrace();
            logger.info("query appFilterActivityList error" + e.getMessage());
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }

    /**
     * why3.5 app查询标签置顶的活动
     * @param tagId
     * @param activityArea
     * @param activityLocation 区域商圈id
     * @param activityIsFree	是否收费 1-免费 2-收费
     * @param activityIsReservation		是否预定 1-不可预定 2-可预定
     * @param sortType	排序 1-智能排序 2-热门排序 3-最新上线 4-即将结束
     * @param pageIndex               开始位置
     * @param pageNum                 显示条数
     * @return json
     */
    @RequestMapping(value = "/appTopActivityList")
    public String appTopActivityList(String pageIndex,String pageNum,String tagId,PaginationApp pageApp,HttpServletResponse response,
    		String activityArea,String activityLocation,String activityIsFree,String activityIsReservation,String sortType) throws Exception {
        String json = "";
        pageApp.setFirstResult(Integer.valueOf(pageIndex));
        pageApp.setRows(Integer.valueOf(pageNum));
        try {
            json = activityAppService.queryTopActivityList(pageApp, tagId, activityArea, activityLocation, activityIsFree, activityIsReservation, sortType);
        }catch (Exception e){
            e.printStackTrace();
            logger.info("query appTopActivityList error"+e.getMessage());
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }

    /**
     * why3.5 app查询广告位列表
     * @return
     */
    @RequestMapping(value = "/appAdvertRecommendList")
    public String appAdvertRecommendList(HttpServletResponse response, String tagId)throws Exception{
        String json = "";
        try{
            json = advertAppRecommendService.queryAppAdvertRecommendList(tagId);
        }catch (Exception e){
            json = JSONResponse.toAppResultFormat(500, "服务器响应失败");
            logger.info("query appAdvertRecommendList error" + e.getMessage());
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }

    /**
     * why3.5 app日历下时间段活动场数
     * @param response
     * @param startDate
     * @param endDate
     * @throws Exception
     */
    @RequestMapping(value = "/appDatePartActivityCount")
    public void appDatePartActivityCount(HttpServletResponse response, String startDate, String endDate) throws Exception{
        String json = "";
        try {
            if(StringUtils.isNotBlank(startDate) && StringUtils.isNotBlank(endDate)){
                json = activityAppService.queryAppDatePartActivityCount(startDate, endDate);
            }else{
                json = JSONResponse.toAppResultFormat(200, "开始日期或结束日期缺失");
            }
        }catch (Exception e){
            json = JSONResponse.toAppResultFormat(300, e.getMessage());
            logger.info("query appDatePartActivityCount error:"+e.getMessage());
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(json);
        response.getWriter().flush();
        response.getWriter().close();
    }

    /**
     * why3.5 app根据不同条件查询月、周下活动列表
     * @param response
     * @param startDate
     * @param endDate
     * @param activityArea
     * @param activityLocation 区域商圈id
     * @param activityType
     * @param activityIsFree
     * @param activityIsReservation
     * @param pageIndex
     * @param userId
     * @param pageNum
     * @param pageApp
     * @param type	(默认不传值，"month"：查询月开始活动)
     * @throws Exception
     */
    @RequestMapping(value = "/appActivityCalendarList")
    public void appActivityCalendarList(HttpServletResponse response, String startDate, String endDate, String activityArea,String activityLocation, String
            activityType, String activityIsFree, String activityIsReservation, String pageIndex, String userId,
                                String pageNum, PaginationApp pageApp, String type) throws Exception{
        pageApp.setFirstResult(Integer.valueOf(pageIndex));
        pageApp.setRows(Integer.valueOf(pageNum));
        String json = "";
        try {
            if(StringUtils.isNotBlank(startDate) && StringUtils.isNotBlank(endDate)){
                json = activityAppService.queryAppActivityCalendarList(pageApp, startDate, endDate, activityArea, activityLocation, activityType, activityIsFree, activityIsReservation, userId, type);
            }else{
                json = JSONResponse.toAppResultFormat(200, "开始日期或结束日期缺失");
            }
        }catch (Exception e){
            json = JSONResponse.toAppResultFormat(300, e.getMessage());
            logger.info("query appActivityList error:"+e.getMessage());
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(json);
        response.getWriter().flush();
        response.getWriter().close();
    }

    /**
     * why3.5 app我的活动日历（历史预定活动）列表
     * @param pageIndex
     * @param userId
     * @param pageNum
     * @param pageApp
     * @throws Exception
     */
    @RequestMapping(value = "/appHistoryActivityList")
    public void appHistoryActivityList(HttpServletResponse response, String pageIndex, String userId,
                                String pageNum, PaginationApp pageApp) throws Exception{
        pageApp.setFirstResult(Integer.valueOf(pageIndex));
        pageApp.setRows(Integer.valueOf(pageNum));
        String json = "";
        try {
            if(StringUtils.isNotBlank(userId)){
                json = activityAppService.queryAppHistoryActivityList(pageApp, userId);
            }else{
                json = JSONResponse.toAppResultFormat(200, "用户id缺失");
            }
        }catch (Exception e){
            json = JSONResponse.toAppResultFormat(300, e.getMessage());
            logger.info("query appHistoryActivityList error:"+e.getMessage());
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(json);
        response.getWriter().flush();
        response.getWriter().close();
    }

    /**
     * why3.5 app我的活动日历（月份预定活动及收藏）列表
     * @param pageIndex
     * @param userId
     * @param pageNum
     * @param pageApp
     * @param startDate
     * @param endDate
     * @throws Exception
     */
    @RequestMapping(value = "/appMonthActivityList")
    public void appMonthActivityList(HttpServletResponse response, String pageIndex, String userId,
                                       String pageNum, PaginationApp pageApp, String startDate, String endDate) throws Exception{
        pageApp.setFirstResult(Integer.valueOf(pageIndex));
        pageApp.setRows(Integer.valueOf(pageNum));
        String json = "";
        try {
            if(StringUtils.isNotBlank(userId) && StringUtils.isNotBlank(startDate) && StringUtils.isNotBlank(endDate)){
                json = activityAppService.queryAppMonthActivityList(pageApp, userId, startDate, endDate);
            }else{
                json = JSONResponse.toAppResultFormat(200, "用户id或活动时间段缺失");
            }
        }catch (Exception e){
            json = JSONResponse.toAppResultFormat(300, e.getMessage());
            logger.info("query appHistoryActivityList error:"+e.getMessage());
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(json);
        response.getWriter().flush();
        response.getWriter().close();
    }

    
    /**
     * app广告位(日历)
     * @return
     */
    @RequestMapping(value = "/queryCalendarAdvert")
    public String queryCalendarAdvert(HttpServletResponse response, String date) throws Exception {
        String json = "";
        try {
            json = advertAppCalendarService.queryCalendarAdvert(date);
        } catch (Exception e) {
            json = JSONResponse.toAppResultFormat(500, "服务器响应失败");
            logger.info("query wcAdvertCalendar error" + e.getMessage());
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }
    
    /**
     * app秒杀场次列表
     * @return
     */
    @RequestMapping(value = "/appActivityEventList")
    public String appActivityEventList(HttpServletResponse response, String activityId) throws Exception {
        String json = "";
        try {
        	if(StringUtils.isNotBlank(activityId)){
        		json = activityAppService.queryActivityEventList(activityId);
        	}else{
        		json = JSONResponse.toAppResultFormat(400, "活动id缺失");
        	}
        } catch (Exception e) {
            json = JSONResponse.toAppResultFormat(500, "服务器响应失败");
            logger.info("query wcActivitySpikeList error" + e.getMessage());
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }

//    /**
//     * 抢票端口
//     * @return
//     */
//    @RequestMapping(value = "/spickOrder")
//    public String spickOrder(HttpServletResponse response,int count,String activityId, String userId, String activityEventIds, String bookCount, String orderMobileNum, String orderPrice, String activityEventimes) throws Exception {
//        String json = "";
//        try {
//            for (int i=0;i<count;i++){
//                json = activityAppService.appActivityOrderByCondition(activityId, userId, activityEventIds, bookCount, orderMobileNum, orderPrice, activityEventimes, null, null);
//            }
//        } catch (Exception e) {
//            json = JSONResponse.toAppResultFormat(500, "服务器响应失败");
//            logger.info("query wcAdvertCalendar error" + e.getMessage());
//        }
//        response.setContentType("text/html;charset=UTF-8");
//        response.getWriter().write(json);
//        response.getWriter().flush();
//        response.getWriter().close();
//        return null;
//    }

}

