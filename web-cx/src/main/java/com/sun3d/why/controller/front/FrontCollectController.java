package com.sun3d.why.controller.front;

import com.sun3d.why.model.*;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.service.*;
import com.sun3d.why.statistics.service.StatisticActivityUserService;
import com.sun3d.why.statistics.service.StatisticAntiqueUserService;
import com.sun3d.why.statistics.service.StatisticTermUserService;
import com.sun3d.why.statistics.service.StatisticVenueUserService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.Pagination;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 团队会员前台请求处理控制层
 * 负责跟页面数据的交互以及对下层的数据方法的调用
 * <p/>
 * Created by cj on 2015/4/24.
 */
@Controller
@RequestMapping(value = "/frontCollect")
public class FrontCollectController {

    /**
     * 导入log4j日志管理，记录错误信息
     */
    private Logger logger = Logger.getLogger(FrontCollectController.class);

    @Autowired
    private CmsActivityService activityService;

    @Autowired
    private CmsVenueService venueService;

    @Autowired
    private CmsTeamUserService teamUserService;

    @Autowired
    private CollectService collectService;

    @Autowired
    private HttpSession session;

    @Autowired
    private StatisticActivityUserService statisticActivityUserService;

    @Autowired
    private StatisticVenueUserService statisticVenueUserService;

    @Autowired
    private StatisticTermUserService statisticTermUserService;

    @Autowired
    private StatisticAntiqueUserService statisticAntiqueUserService;
    
    @Autowired
    private StaticServer staticServer;

    /**
     * 前端2.0收藏活动
     * @return
     */
    @RequestMapping(value = "/collectActivity")
    public String collectActivity() {
        return "index/userCenter/collectActivity";
    }

    /**
     * 前端2.0收藏活动列表
     * @return
     */
    @RequestMapping(value = "/collectActivityLoad")
    public String collectActivityLoad(String activityName,Pagination page,HttpServletRequest request) {
        try{
            if(session.getAttribute("terminalUser") != null){
                page.setRows(9);
                CmsTerminalUser user = (CmsTerminalUser)session.getAttribute("terminalUser");
                List<CmsActivity> activityList = activityService.queryCollectActivity(user, page,activityName,null);
                request.setAttribute("activityList", activityList);
                request.setAttribute("page", page);
            }
        }catch (Exception e){
            logger.info("collectActivityLoad error", e);
        }
        return "index/userCenter/collectActivityLoad";
    }

    /**
     * 前端2.0删除收藏
     * @return
     */
    @RequestMapping(value = "/deleteCollect")
    @ResponseBody
    public String deleteCollect(CmsCollect collect) {
       try{
           if(session.getAttribute("terminalUser") != null){
               CmsTerminalUser user = (CmsTerminalUser)session.getAttribute("terminalUser");
               collect.setUserId(user.getUserId());
               int bool = collectService.deleteCollectByCondition(collect);
               if(bool > 0){
                   if (collect.getType() == 1) {
                       //场馆
                       VenueUserStatistics venueUserStatistics = new VenueUserStatistics();
                       venueUserStatistics.setUserId(user.getUserId());;
                       venueUserStatistics.setVenueId(collect.getRelateId());
                       venueUserStatistics.setOperateType(3);
                       statisticVenueUserService.deleteVenueUser(venueUserStatistics);
                   } else if (collect.getType() == 4) {
                       //团体
                       CmsTeamUserStatistics teamUserStatistics = new CmsTeamUserStatistics();
                       teamUserStatistics.setUserId(user.getUserId());;
                       teamUserStatistics.setTuserId(collect.getRelateId());
                       teamUserStatistics.setOperateType(3);
                       statisticTermUserService.deleteTeamUser(teamUserStatistics);
                   } else if (collect.getType() == 2) {
                       //活动
                       ActivityUserStatistics activityUserStatistics = new ActivityUserStatistics();
                       activityUserStatistics.setUserId(user.getUserId());;
                       activityUserStatistics.setActivityId(collect.getRelateId());
                       activityUserStatistics.setOperateType(3);
                       statisticActivityUserService.deleteActivityUser(activityUserStatistics);
                   } else if (collect.getType() == 3) {
                       //馆藏
                       AntiqueUserStatistics antiqueUserStatistics = new AntiqueUserStatistics();
                       antiqueUserStatistics.setUserId(user.getUserId());
                       antiqueUserStatistics.setAntiqueId(collect.getRelateId());
                       antiqueUserStatistics.setOperateType(3);
                       statisticAntiqueUserService.deleteAntiqueUser(antiqueUserStatistics);
                   }
                   return Constant.RESULT_STR_SUCCESS;
               }
           }
       }catch (Exception e){
           logger.info("deleteCollect error",e);
           return Constant.RESULT_STR_FAILURE;
       }
        return Constant.RESULT_STR_FAILURE;
    }

    /**
     * 前端2.0收藏场馆首页
     * @return
     */
    @RequestMapping(value = "/collectVenue")
    public String collectVenue() {
        return "index/userCenter/collectVenue";
    }

    /**
     * 前端2.0收藏场馆列表
     * @return
     */
    @RequestMapping(value = "/collectVenueLoad")
    public String collectVenueLoad(String venueName,Pagination page,HttpServletRequest request) {
        try{
            if(session.getAttribute("terminalUser") != null){
                CmsTerminalUser user = (CmsTerminalUser)session.getAttribute("terminalUser");
                List<CmsVenue> venueList = venueService.queryCollectVenue(user, page, venueName);
                request.setAttribute("venueList", venueList);
                request.setAttribute("page", page);
            }
        }catch (Exception e){
            logger.info("collectVenueLoad error", e);
        }
        return "index/userCenter/collectVenueLoad";
    }

    /**
     * 前端2.0收藏团体首页
     * @return
     */
    @RequestMapping(value = "/collectGroup")
    public String collectGroup() {
        return "index/userCenter/collectGroup";
    }

    /**
     * 前端2.0收藏团体列表
     * @return
     */
    @RequestMapping(value = "/collectGroupLoad")
    public String collectGroupLoad(String tuserName,Pagination page,HttpServletRequest request) {
        try{
            if(session.getAttribute("terminalUser") != null){
                page.setRows(9);
                CmsTerminalUser user = (CmsTerminalUser)session.getAttribute("terminalUser");
                List<CmsTeamUser> teamUserList = teamUserService.queryCollectTeamUser(user,page,tuserName,null );
                request.setAttribute("teamUserList", teamUserList);
                request.setAttribute("page", page);
            }
        }catch (Exception e){
            logger.info("collectGroupLoad error", e);
        }
        return "index/userCenter/collectGroupLoad";
    }
    
    /**
     * 前端2.0收藏活动列表
     * @return
     */
    @RequestMapping(value = "/collectActivityLoadJson")
    @ResponseBody
    public Map<Object,Object> collectActivityLoadJson(String activityName,String userId,Pagination page,HttpServletRequest request) {
    	Map<Object,Object>  mapdata = null ;
    	try{
    			mapdata = new HashMap<Object, Object>();
                CmsTerminalUser user = new CmsTerminalUser();
                user.setUserId(userId);
                List<CmsActivity> activityList = activityService.queryCollectActivity(user, page,activityName,null);
/*                request.setAttribute("activityList", activityList);
                request.setAttribute("page", page);*/
                List<CmsCollectVo>  cmsCollectVoList = new ArrayList<CmsCollectVo>();
                for (CmsActivity cmsActivity : activityList) {
                	CmsCollectVo cmsCollectVo = new CmsCollectVo();
                	int l = cmsActivity.getActivityIconUrl().lastIndexOf(".");
                	String venueIconUrl = cmsActivity.getActivityIconUrl().substring(0, l)+"_300_300"+cmsActivity.getActivityIconUrl().substring(l) ;
                	cmsActivity.setActivityIconUrl(staticServer.getStaticServerUrl()+venueIconUrl);
                	//cmsVenue.setVenueIconUrl(staticServer.getStaticServerUrl() +venueIconUrl);
                	cmsCollectVo.setIconUrl(staticServer.getStaticServerUrl() +venueIconUrl);
                	cmsCollectVo.setUserId(userId);
                	cmsCollectVo.setType(Constant.COLLECT_ACTIVITY);
                	cmsCollectVo.setRelateId(cmsActivity.getActivityId());
                	cmsCollectVo.setName(cmsActivity.getActivityName());
                	cmsCollectVo.setAddress(cmsActivity.getActivityAddress());
                	cmsCollectVo.setStartTime(cmsActivity.getActivityStartTime());
                	cmsCollectVo.setBeginTime(cmsActivity.getActivityEndTime());
                	cmsCollectVoList.add(cmsCollectVo);
				}
                mapdata.put("cmsCollectVoList", cmsCollectVoList);
                mapdata.put("page", page);
        }catch (Exception e){
            logger.info("collectActivityLoad error", e);
        }
    	return mapdata;
    }

    /**
     * 前端2.0收藏场馆列表
     * @return
     */
    @RequestMapping(value = "/collectVenueLoadJson")
    @ResponseBody
    public Map<Object,Object>  collectVenueLoadJson(String venueName,String userId,Pagination page,HttpServletRequest request) {
    	Map<Object,Object>  mapdata = null ;
    	try{
    			mapdata = new HashMap<Object, Object>();
	            CmsTerminalUser user = new CmsTerminalUser();
	            user.setUserId(userId);
                List<CmsVenue> venueList = venueService.queryCollectVenue(user, page, venueName);
              /*  request.setAttribute("venueList", venueList);
                request.setAttribute("page", page);*/
                List<CmsCollectVo>  cmsCollectVoList = new ArrayList<CmsCollectVo>();
                for (CmsVenue cmsVenue : venueList) {
                	CmsCollectVo cmsCollectVo = new CmsCollectVo();
                	int l = cmsVenue.getVenueIconUrl().lastIndexOf(".");
                	String venueIconUrl = cmsVenue.getVenueIconUrl().substring(0, l)+"_300_300"+cmsVenue.getVenueIconUrl().substring(l) ;
                	//cmsVenue.setVenueIconUrl(staticServer.getStaticServerUrl() +venueIconUrl);
                	cmsCollectVo.setUserId(userId);
                	cmsCollectVo.setType(Constant.COLLECT_VENUE);
                	cmsCollectVo.setIconUrl(staticServer.getStaticServerUrl() +venueIconUrl);
                	cmsCollectVo.setRelateId(cmsVenue.getVenueId());
                	cmsCollectVo.setName(cmsVenue.getVenueName());
                	cmsCollectVo.setBeginTime("");
                	cmsCollectVo.setStartTime("");
                	cmsCollectVo.setAddress(cmsVenue.getVenueAddress());
                	cmsCollectVoList.add(cmsCollectVo);
				}
                mapdata.put("cmsCollectVoList", cmsCollectVoList);
                mapdata.put("page", page);
        }catch (Exception e){
            logger.info("collectVenueLoad error", e);
        }
        return mapdata;
    }
}