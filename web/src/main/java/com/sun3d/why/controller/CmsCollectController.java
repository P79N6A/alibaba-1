package com.sun3d.why.controller;

import com.sun3d.why.model.*;
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
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;

/*
 * @auther wangkun
 * 用户收藏模块
 */
@Controller
@RequestMapping(value = "/collect")
public class CmsCollectController {
    /**
     * 导入log4j日志管理，记录错误信息
     */
    private Logger logger = Logger.getLogger(SysModuleController.class
            .getName());

    /**
     * 模块管理service层对象，注解自动注入
     */
    @Autowired
    private CollectService collectService;

    @Autowired
    private HttpSession session;

    @Autowired
    private CmsTeamUserService teamUserService;

    /**
     * 活动明细表，注解自动注入
     */
    @Autowired
    private StatisticActivityUserService statisticActivityUserService;
    /**
     * 场馆明细表，注解自动注入
     */
    @Autowired
    private StatisticVenueUserService statisticVenueUserService;
    /**
     * 藏品明细表,注解自动注入
     */
    @Autowired
    private StatisticAntiqueUserService statisticAntiqueUserService;
    /**
     * 团体游客明细表，注解自动注入
     */
    @Autowired
    private StatisticTermUserService statisticTermUserService;

    /**
     * 根据管理ID以及关联类型获取收藏条数
     */
    @RequestMapping(value = "/getHotNum")
    @ResponseBody
    public int getHotNum(String relateId, int type) {
        int hotNum = 0;
        hotNum = collectService.getHotNum(relateId, type);
        return hotNum;
    }

    /**
     * 判断用户是否已经收藏该内容
     */
    @RequestMapping(value = "/isHadCollect")
    @ResponseBody
    public int isHadCollect(String relateId, int type, String userId, CmsCollect cmsCollect) {
        int hotNum = 0;
        CmsTerminalUser user = (CmsTerminalUser) session.getAttribute("terminalUser");
        if (user != null) {
            hotNum = collectService.isHadCollect(relateId, type, user.getUserId());
        }
        return hotNum;
    }

    /**
     * 取消收藏
     * 返回值大于0 代表删除失败  1 代表成功
     */
    @RequestMapping(value = "/deleteUserCollect")
    @ResponseBody
    public int deleteUserCollect(CmsCollect cmsCollect) {
        CmsTerminalUser user = (CmsTerminalUser) session.getAttribute("terminalUser");
        cmsCollect.setUserId(user.getUserId());
        collectService.deleteCollectByCondition(cmsCollect);

        if (cmsCollect.getType() == 1) {
            //场馆
            VenueUserStatistics venueUserStatistics = new VenueUserStatistics();
            venueUserStatistics.setUserId(user.getUserId());
            ;
            venueUserStatistics.setVenueId(cmsCollect.getRelateId());
            venueUserStatistics.setOperateType(3);
            statisticVenueUserService.deleteVenueUser(venueUserStatistics);
        } else if (cmsCollect.getType() == 4) {
            //团体
            CmsTeamUserStatistics teamUserStatistics = new CmsTeamUserStatistics();
            teamUserStatistics.setUserId(user.getUserId());
            ;
            teamUserStatistics.setTuserId(cmsCollect.getRelateId());
            teamUserStatistics.setOperateType(3);
            statisticTermUserService.deleteTeamUser(teamUserStatistics);
        } else if (cmsCollect.getType() == 2) {
            //活动
            ActivityUserStatistics activityUserStatistics = new ActivityUserStatistics();
            activityUserStatistics.setUserId(user.getUserId());
            ;
            activityUserStatistics.setActivityId(cmsCollect.getRelateId());
            activityUserStatistics.setOperateType(3);
            statisticActivityUserService.deleteActivityUser(activityUserStatistics);
        } else if (cmsCollect.getType() == 3) {
            //馆藏
            AntiqueUserStatistics antiqueUserStatistics = new AntiqueUserStatistics();
            antiqueUserStatistics.setUserId(user.getUserId());
            antiqueUserStatistics.setAntiqueId(cmsCollect.getRelateId());
            antiqueUserStatistics.setOperateType(3);
            statisticAntiqueUserService.deleteAntiqueUser(antiqueUserStatistics);
        }

        return collectService.getHotNum(cmsCollect.getRelateId(), cmsCollect.getType());
    }

    /**
     * 收藏活动显示
     */
    /*@RequestMapping(value = "/activityList")
	public ModelAndView activityList(Pagination page,Integer currentPage) {
		ModelAndView model = new ModelAndView();
		HashMap map = new HashMap();
		CmsTerminalUser user = (CmsTerminalUser)session.getAttribute("terminalUser");
		page.setRows(15);
		page.setPage(currentPage);
		map.put("userId", user.getUserId());
		map.put("type", Constant.COLLECT_ACTIVITY);
		map.put("firstResult", page.getFirstResult());
		map.put("rows", page.getRows());
		int total = activityService.countCollectActivity(map);
		page.setTotal(Integer.valueOf(total));
		List<CmsActivity> activityList = activityService.queryCollectActivity(map);
		model.setViewName("collect/activity");
		model.addObject("activityList", activityList);
		model.addObject("page", page);
		return model;
	}*/

    /**
     * 收藏场馆显示
     */
    @RequestMapping(value = "/venueList")
    public ModelAndView venueList(Pagination page, Integer currentPage) {
        ModelAndView model = new ModelAndView();
        HashMap map = new HashMap();
        CmsTerminalUser user = (CmsTerminalUser) session.getAttribute("terminalUser");
        page.setRows(9);
        page.setPage(currentPage);
		/*map.put("userId", user.getUserId());
		map.put("type", Constant.COLLECT_VENUE);
		map.put("firstResult", page.getFirstResult());
		map.put("rows", page.getRows());
		int total = venueService.queryCollectVenueCount(map);
		page.setTotal(Integer.valueOf(total));
		List<CmsVenue> venueList = venueService.queryCollectVenue(map);*/

		/*model.setViewName("collect/venue");
		model.addObject("venueList", venueList);*/
        model.addObject("page", page);
        return model;
    }


    /**
     * 收藏团体显示
     */
    @RequestMapping(value = "/groupList")
    public ModelAndView groupList(Pagination page, Integer currentPage) {
        ModelAndView model = new ModelAndView();
        HashMap map = new HashMap();
        CmsTerminalUser user = (CmsTerminalUser) session.getAttribute("terminalUser");
        page.setRows(2);
        page.setPage(currentPage);
        map.put("userId", user.getUserId());
        map.put("type", Constant.COLLECT_TEAMUSER);
        map.put("firstResult", page.getFirstResult());
        map.put("rows", page.getRows());
        int total = teamUserService.queryCollectTeamUserCount(map);
        page.setTotal(Integer.valueOf(total));
		/*List<CmsTeamUser> teamUserList = teamUserService.queryCollectTeamUser(map);
		model.setViewName("collect/group");
		model.addObject("teamUserList", teamUserList);
		model.addObject("page", page);*/
        return model;
    }

    /**
     * 收藏删除
     */
    @RequestMapping(value = "/deleteCollect")
    public ModelAndView deleteCollect(Integer type, String relateId, CmsCollect cmsCollect, Integer currentPage, Pagination page) {
//		CmsCollectExample example = new CmsCollectExample();
        ModelAndView model = null;
        CmsTerminalUser user = (CmsTerminalUser) session.getAttribute("terminalUser");
//		example.createCriteria().andRelateIdEqualTo(relateId).andUserIdEqualTo(user.getUserId());
        cmsCollect.setUserId(user.getUserId());
        collectService.deleteCollectByCondition(cmsCollect);

//		CmsCollectExample cmsCollectExample = new CmsCollectExample();
//		cmsCollectExample.createCriteria().andUserIdEqualTo(user.getUserId());
        Map map = new HashMap();
        map.put("userId", user.getUserId());
        int count = collectService.queryCountByCollect(map);
        user.setCollectCount(count);
        session.setAttribute("terminalUser", user);
        if (type == 1) {
            model = venueList(page, currentPage);
        } else if (type == 2) {
            //model = activityList(page, currentPage);
        } else if (type == 4) {
            model = groupList(page, currentPage);
        }
        return model;
    }
}