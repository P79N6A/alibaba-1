package com.sun3d.why.controller.front.league;

import com.sun3d.why.model.SysUser;
import com.sun3d.why.model.league.CmsLeague;
import com.sun3d.why.model.league.CmsLeagueBO;
import com.sun3d.why.service.league.CmsLeagueService;
import com.sun3d.why.util.JSONResponse;
import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.List;

/*
 * @auther liunima
 * 联盟
 */
@Controller
@RequestMapping(value = "/league")
public class CmsLeagueController {
    /**
     * 导入log4j日志管理，记录错误信息
     */
    private Logger logger = Logger.getLogger(this.getClass().getName());


    @Autowired
    private HttpSession session;

    @Autowired
    private CmsLeagueService leagueService;


    /**
     * 培训列表页
     * @return
     */
    @RequestMapping("/list")
    public ModelAndView list(CmsLeagueBO league) {
        ModelAndView model = new ModelAndView();
        try {
            SysUser sysUser = (SysUser) session.getAttribute("user");
            List<CmsLeagueBO> list = leagueService.queryList(league);
            model.addObject("league", league);
            model.addObject("list", list);
            model.setViewName("admin/league/league_list");
        } catch (Exception e) {
            logger.error("activityIndex error {}", e);
        }
        return model;
    }


    /**
     * 新增培训页
     *
     * @return
     */
    @RequestMapping("/toSave")
    public String toSave(CmsLeagueBO bo, HttpServletRequest request) {
        if (StringUtils.isNotBlank(bo.getId())) {
            CmsLeague league = leagueService.selectByPrimaryKey(bo.getId());
            request.setAttribute("league", league);
        }
        return "admin/league/league_add";
    }

    @RequestMapping("/save")
    @ResponseBody
    public String save(CmsLeagueBO league) {
        try {
            SysUser sysUser = (SysUser) session.getAttribute("user");
            return leagueService.save(league, sysUser);
        } catch (Exception e) {
            e.printStackTrace();
            return JSONResponse.getResult(500, "系统异常，操作失败!");
        }
    }

    /**
     * 获取培训list
     * @return
     */
    @RequestMapping("/queryLeagues")
    @ResponseBody
    public List<CmsLeagueBO> queryLeagues(CmsLeagueBO league) {
        List<CmsLeagueBO> list = new ArrayList<>();
        try {
            list = leagueService.queryList(league);
        } catch (Exception e) {
            logger.error("activityIndex error {}", e);
        }
        return list;
    }

}