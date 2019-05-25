package com.sun3d.why.controller;

import com.sun3d.why.dao.IndexStatisticsMapper;
import com.sun3d.why.model.CmsVenue;
import com.sun3d.why.model.IndexStatistics;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.service.CmsDeptService;
import com.sun3d.why.service.CmsUserService;
import com.sun3d.why.service.CmsVenueService;
import com.sun3d.why.statistics.service.IndexStatisticsService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
public class IndexController {
    private Logger logger = LoggerFactory.getLogger(IndexController.class);

    @Autowired
    private IndexStatisticsService indexStatisticsService;
    @Autowired
    private IndexStatisticsMapper indexStatisticsMapper;
    @Autowired
    private CmsDeptService cmsDeptService;
    @Autowired
    private CmsVenueService cmsVenueService;
    @Autowired
    private CmsUserService cmsUserService;
    @Autowired
    private HttpSession session;
    @Autowired
    private StaticServer staticServer;

    @RequestMapping(value = "/admin", method = {RequestMethod.GET})
    public String index(HttpServletRequest request) {
        return "admin/main";
    }

    @RequestMapping(value = "/top", method = {RequestMethod.GET})
    public String top(HttpServletRequest request) {
        return "admin/top";
    }

    @RequestMapping(value = "/loading", method = {RequestMethod.GET})
    public String loading(HttpServletRequest request) {
        return "admin/loading";
    }
    
    @RequestMapping(value = "/left", method = {RequestMethod.GET})
    public String left(HttpServletRequest request) {
        return "admin/left";
    }

    @RequestMapping("/right")
    public String right(HttpServletRequest request,IndexStatistics vo) {
    	SysUser user = (SysUser) session.getAttribute("user");
    	List<IndexStatistics> list = null;
    	if(user!=null){
    		SysUser sysUser = cmsUserService.querySysUserByUserId(user.getUserId());
    		//根据部门重置用户市区
    		try {
    			if(sysUser.getUserIsManger() >= 2){
    				sysUser.setUserCity(cmsDeptService.querySysDeptByDeptId(sysUser.getUserDeptPath().split("\\.")[1]).getDeptName());
    			}
				if(sysUser.getUserIsManger() >= 3){
					sysUser.setUserCounty(cmsDeptService.querySysDeptByDeptId(sysUser.getUserDeptPath().split("\\.")[2]).getDeptName());
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
    		list = indexStatisticsService.queryIndexStatistics(vo,sysUser);
    		if(sysUser.getUserIsManger() == 3){		//区级
    			List<CmsVenue> venueList = cmsVenueService.queryVenueByAreaName(sysUser.getUserCounty());
    			request.setAttribute("venueList", venueList);
    		}else if(sysUser.getUserIsManger() == 4){		//场馆级
    			CmsVenue cmsVenue = cmsVenueService.queryVenueByVenueDeptId(sysUser.getUserDeptId());
    			request.setAttribute("venue", cmsVenue);
    		}
    		//区级、场馆级计算馆均活动发布数
    		if(sysUser.getUserIsManger() == 3 || sysUser.getUserIsManger() == 4){
    			vo.setActivityCity(sysUser.getUserCity());
    			vo.setActivityArea(sysUser.getUserCounty());
    			List<IndexStatistics> areaStatisticslist = indexStatisticsMapper.queryIndexStatisticsByArea(vo);
    			request.setAttribute("averageActivityCount", areaStatisticslist.size()>0?areaStatisticslist.get(0).getAverageActivityCount():0);
    		}
    		request.setAttribute("userIsManger", sysUser.getUserIsManger());
    	}
    	request.setAttribute("list", list);
    	request.setAttribute("indexStatistics", vo);
        return "admin/right";
    }

    @RequestMapping(value = "/login", method = {RequestMethod.GET})
    public String login(HttpServletRequest request) {
    	//request.setAttribute("cityName", staticServer.getCityInfo().split(",")[1]);
        return "admin/main";
    }

    @RequestMapping(value = "/help", method = {RequestMethod.GET})
    public String help(HttpServletRequest request,String link) {
        request.setAttribute("link",link);
        return "admin/help/question";
    }

}
