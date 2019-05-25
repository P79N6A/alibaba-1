package com.sun3d.why.controller;

import com.sun3d.why.model.SysUser;
import com.sun3d.why.service.StatisticsFlowWapService;
import com.sun3d.why.util.DateUtils;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping(value = "/Statistic")
public class SysDataStatisticController {
	
	private Logger logger = LoggerFactory.getLogger(SysDataStatisticController.class);
	@Autowired
	private HttpSession session;
	@Autowired
	private StatisticsFlowWapService statisticsFlowWapService;
	@Autowired
	private com.sun3d.why.service.StatisticsFlowWebService StatisticsFlowWebService;
	
	/**
	 * 进入注册统计页面
	 * @param request
	 * @return
	 */
	@RequestMapping(value="/registerStatistic")
	public ModelAndView registerStatistic(HttpServletRequest request){
		ModelAndView model = new ModelAndView();
		try{
			SysUser sysUser = (SysUser) session.getAttribute("user");
			if(StringUtils.isNotBlank(sysUser.getUserId())){
				model.addObject("user", sysUser);
				model.setViewName("admin/statistic/registerStatistic");
			}else{
				return new ModelAndView("redirect:/login.do");
			}
		}catch(Exception e){
			e.printStackTrace();
		}
		return model;
	}
	

    /**
     * 进入发布统计页
     * @param request
     * @return
     */
    @RequestMapping("/publishStatistic")
    public ModelAndView publishStatistic(HttpServletRequest request){
    	ModelAndView model=new ModelAndView();
    	try{
			SysUser sysUser = (SysUser) session.getAttribute("user");
			if(StringUtils.isNotBlank(sysUser.getUserId())){
				model.addObject("user", sysUser);
				model.setViewName("admin/statistic/publishStatistic");
			}else{
				return new ModelAndView("redirect:/login.do");
			}
		}catch(Exception e){
			e.printStackTrace();
		}
		return model;
    }
    
    /**
     * 进入移动端流量统计页
     * @param request
     * @return
     */
    @RequestMapping("/flowStatistic")
    public ModelAndView flowStatistic(HttpServletRequest request){
    	ModelAndView model=new ModelAndView();
    	try{
			SysUser sysUser = (SysUser) session.getAttribute("user");
			if(StringUtils.isNotBlank(sysUser.getUserId())){
				model.addObject("user", sysUser);
				model.setViewName("admin/statistic/flowWapStatistic");
			}else{
				return new ModelAndView("redirect:/login.do");
			}
		}catch(Exception e){
			e.printStackTrace();
		}
		return model;
    }
    
    /**
     * 进入web端流量统计页
     * @param request
     * @return
     */
    @RequestMapping("/flowWebStatistic")
    public ModelAndView flowWebStatistic(HttpServletRequest request){
    	ModelAndView model=new ModelAndView();
    	try{
			SysUser sysUser = (SysUser) session.getAttribute("user");
			if(StringUtils.isNotBlank(sysUser.getUserId())){
				model.addObject("user", sysUser);
				model.setViewName("admin/statistic/flowWebStatistic");
			}else{
				return new ModelAndView("redirect:/login.do");
			}
		}catch(Exception e){
			e.printStackTrace();
		}
		return model;
    }
    
    
    /**
     * 移动端流量统计(按日)
     * @param time
     * @return
     */
    @RequestMapping("/flowStatisticIndex")
    @ResponseBody
	public String flowStatisticIndex(String time){
        Map<String,String> map = new HashMap<String,String>();
        map.put("date", time);
        map.put("nowdate", DateUtils.formatDate(new Date()));
        String rs=statisticsFlowWapService.flowWapStatisticQuery(map);
        return rs;
    }
    
    /**
     * 移动端流量统计(按月)
     * @param year
     * @return
     */
    @RequestMapping("/flowStatisticyearIndex")
    @ResponseBody
	public String flowStatisticyearIndex(String year){
        Map<String,String> map = new HashMap<String,String>();
        map.put("date", year);
        map.put("nowdate", DateUtils.formatDate(new Date()));
        String rs=statisticsFlowWapService.flowWapStatisticYear(map);
        return rs;
	}
    
    /**
     * WEB端流量统计(按日)
     * @param time
     * @return
     */
    @RequestMapping("/flowWebStatisticIndex")
    @ResponseBody
	public String flowWebStatisticIndex(String time){
        Map<String,String> map = new HashMap<String,String>();
        map.put("date", time);
        map.put("nowdate", DateUtils.formatDate(new Date()));
        String rs=StatisticsFlowWebService.flowWebStatisticQuery(map);
        return rs;
    }
    
    /**
     * WEB端流量统计(按月)
     * @param year
     * @return
     */
    @RequestMapping("/flowWebStatisticyearIndex")
    @ResponseBody
	public String flowWebStatisticyearIndex(String year){
        Map<String,String> map = new HashMap<String,String>();
        map.put("date", year);
        map.put("nowdate", DateUtils.formatDate(new Date()));
        String rs=StatisticsFlowWebService.flowWebStatisticYear(map);
        return rs;
	}

}
