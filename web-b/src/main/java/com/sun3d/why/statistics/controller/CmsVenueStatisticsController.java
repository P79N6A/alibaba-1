package com.sun3d.why.statistics.controller;

import com.sun3d.why.model.SysUser;
import com.sun3d.why.model.VenueStatistics;
import com.sun3d.why.statistics.service.IndexStatisticsService;
import com.sun3d.why.statistics.service.VenueStatisticsService;
import com.sun3d.why.util.ExportExcel;
import com.sun3d.why.util.Pagination;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;


@RequestMapping("/venueStatistics")
@Controller
public class CmsVenueStatisticsController {
    private Logger logger = LoggerFactory.getLogger(CmsVenueStatisticsController.class);
    @Autowired
    private VenueStatisticsService venueStatisticsService;

    @Autowired
    private IndexStatisticsService indexStatisticsService;

    @Autowired
    private HttpSession session;

    @Autowired
    private ExportExcel exportExcel;
    /**
     * 进入场馆地区统计首页
     * @param type
     * @param request
     * @return
     */
    @RequestMapping("/VenueAreaStatisticsIndex")
    public String VenueAreaStatisticsIndex(String type,HttpServletRequest request) {
        return "admin/venueStatistics/venueAreaStatistics";
    }

    /**
     * 进入活动室地区统计首页
     * @param type
     * @param request
     * @return
     */
    @RequestMapping("/RoomAreaStatisticsIndex")
    public String RoomAreaStatisticsIndex(String type,HttpServletRequest request) {
        return "admin/venueStatistics/roomAreaStatistics";
    }

    /**
     * 进入场馆标签统计首页
     * @param type
     * @param request
     * @return
     */
    @RequestMapping("/VenueTagStatisticsIndex")
    public String VenueTagStatisticsIndex(String type,HttpServletRequest request) {
        return "admin/venueStatistics/venueTagStatistics";
    }

    /**
     * 进入活动室标签统计首页
     * @param type
     * @param request
     * @return
     */
    @RequestMapping("/RoomTagStatisticsIndex")
    public String RoomTagStatisticsIndex(String type,HttpServletRequest request) {
        return "admin/venueStatistics/roomTagStatistics";
    }

    /**
     * 场馆评论数量表
     *
     * @param venueStatistics
     * @param page
     * @return
     */
    @RequestMapping("/VenueMessageStatisticsIndex")
    public ModelAndView VenueMessageStatisticsIndex(VenueStatistics venueStatistics, Pagination page) {
        ModelAndView model = new ModelAndView();
        try {
            List<VenueStatistics> list = venueStatisticsService.queryByMessage(venueStatistics, page);
            model.addObject("list", list);
            model.addObject("page", page);
            model.addObject("activityStatistics", venueStatistics);
            model.setViewName("admin/venueStatistics/venueCommentStatistics");
        } catch (Exception e) {
            logger.error("activityIndex error {}", e);
        }
        return model;
    }
    /**
     * 场馆评论数量表 导出excel
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/exportVenueByMessageExcel")
    public void exportVenueByMessageExcel(HttpServletRequest request, HttpServletResponse response,VenueStatistics venueStatistics) {
        try {
            response.setContentType("application/vnd.ms-excel;charset=utf-8");
            response.setCharacterEncoding("UTF-8");
            response.setHeader("Content-Disposition", "attachment;filename=" + "venue.xls");
            ServletOutputStream out = response.getOutputStream();
            SysUser sysUser = (SysUser) session.getAttribute("user");
            List<VenueStatistics> list = venueStatisticsService.queryByMessage(venueStatistics, null);
            exportExcel.exportActivityExcel("测试title", "EXPORT_VENUE_MESSAGE_STATISTICS_EXCEL", list, out, null);
        } catch (IOException e) {
            e.printStackTrace();
        }

    }
    /**
     * 各区县场馆情况
     * @param request
     * @param response
     * @return
     */
    @RequestMapping("/queryAreaCountInfo")
    @ResponseBody
    public List<VenueStatistics> queryAreaCountInfo(HttpServletRequest request,HttpServletResponse response) {
        List<VenueStatistics> list = venueStatisticsService.queryByArea();
        return list;
    }
    /**
     * 各区县活动情况 导出excel
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/exportVenueByAreaExcel")
    public void exportVenueByAreaExcel(HttpServletRequest request, HttpServletResponse response,VenueStatistics venueStatistics) {
        try {
            response.setContentType("application/vnd.ms-excel;charset=utf-8");
            response.setCharacterEncoding("UTF-8");
            response.setHeader("Content-Disposition", "attachment;filename=" + "venue.xls");
            ServletOutputStream out = response.getOutputStream();
            SysUser sysUser = (SysUser) session.getAttribute("user");
            List<VenueStatistics> list = venueStatisticsService.queryByArea();
            exportExcel.exportActivityExcel("测试title", "EXPORT_VENUE_STATISTICS_EXCEL", list, out, null);
        } catch (IOException e) {
            e.printStackTrace();
        }

    }




    /**
     * 活动室预约情况 柱状图
     * @param request
     * @param response
     * @return
     */
    @RequestMapping("/queryAreaRoomCountInfo")
    @ResponseBody
    public List<VenueStatistics> queryAreaRoomCountInfo(VenueStatistics venueStatistics,HttpServletRequest request,HttpServletResponse response) {
        List<VenueStatistics> list = venueStatisticsService.queryByAreaRoom(venueStatistics);
        return list;
    }

    /**
     * 活动室预约情况 导出excel
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/exportRoomByAreaExcel")
    public void exportRoomByAreaExcel(HttpServletRequest request, HttpServletResponse response,VenueStatistics venueStatistics) {
        try {
            response.setContentType("application/vnd.ms-excel;charset=utf-8");
            response.setCharacterEncoding("UTF-8");
            response.setHeader("Content-Disposition", "attachment;filename=" + "venue.xls");
            ServletOutputStream out = response.getOutputStream();
            SysUser sysUser = (SysUser) session.getAttribute("user");
            List<VenueStatistics> list = venueStatisticsService.queryByAreaRoom(venueStatistics);
            exportExcel.exportActivityExcel("测试title", "EXPORT_ROOM_STATISTICS_EXCEL", list, out, null);
        } catch (IOException e) {
            e.printStackTrace();
        }

    }


    /**
     * 场馆标签统计 柱状图
     * @param request
     * @param response
     * @return
     */
    @RequestMapping("/queryTagCountInfo")
    @ResponseBody
    public List<VenueStatistics> queryTagCountInfo(VenueStatistics venueStatistics,HttpServletRequest request,HttpServletResponse response) {
        List<VenueStatistics> list = venueStatisticsService.queryByTag(venueStatistics);
        return list;
    }
    /**
     * 场馆标签统计 导出excel
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/exportVenueByTagExcel")
    public void exportVenueByTagExcel(HttpServletRequest request, HttpServletResponse response,VenueStatistics venueStatistics) {
        try {
            response.setContentType("application/vnd.ms-excel;charset=utf-8");
            response.setCharacterEncoding("UTF-8");
            response.setHeader("Content-Disposition", "attachment;filename=" + "venue.xls");
            ServletOutputStream out = response.getOutputStream();
            SysUser sysUser = (SysUser) session.getAttribute("user");
            List<VenueStatistics> list = venueStatisticsService.queryByTag(venueStatistics);
            exportExcel.exportActivityExcel("测试title", "EXPORT_VENUE_TAG_STATISTICS_EXCEL", list, out, null);
        } catch (IOException e) {
            e.printStackTrace();
        }

    }

    /**
     * 活动室标签统计 柱状图
     * @param request
     * @param response
     * @return
     */
    @RequestMapping("/queryTagRoomCountInfo")
    @ResponseBody
    public List<VenueStatistics> queryTagRoomCountInfo(VenueStatistics venueStatistics,HttpServletRequest request,HttpServletResponse response) {
        List<VenueStatistics> list = venueStatisticsService.queryByTagRoom(venueStatistics);
        return list;
    }
    /**
     * 活动室标签统计 导出excel
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/exportRoomByTagExcel")
    public void exportRoomByTagExcel(HttpServletRequest request, HttpServletResponse response,VenueStatistics venueStatistics) {
        try {
            response.setContentType("application/vnd.ms-excel;charset=utf-8");
            response.setCharacterEncoding("UTF-8");
            response.setHeader("Content-Disposition", "attachment;filename=" + "venue.xls");
            ServletOutputStream out = response.getOutputStream();
            SysUser sysUser = (SysUser) session.getAttribute("user");
            List<VenueStatistics> list = venueStatisticsService.queryByTagRoom(venueStatistics);
            exportExcel.exportActivityExcel("测试title", "EXPORT_ROOM_TAG_STATISTICS_EXCEL", list, out, null);
        } catch (IOException e) {
            e.printStackTrace();
        }

    }
    /**
     * 活动留言内容
     * @param
     * @param
     * @return
     */
    @RequestMapping("/queryMessageCountInfo")
    @ResponseBody
    public List<VenueStatistics> queryMessageCountInfo(VenueStatistics venueId, Pagination page) {
        List<VenueStatistics> list = venueStatisticsService.queryCommentByVenue(venueId, page, null);

        return list;
    }
    /**
     * 进入发布统计首页
     *
     * @param type
     * @param request
     * @return
     */
    @RequestMapping("/venuePublicStatistics")
    public String activityPublicStatistics(String type, HttpServletRequest request) {
        return "admin/venueStatistics/venuePublicStatistics";
    }
    /**
     * 进入交互统计首页
     *
     * @param type
     * @param request
     * @return
     */
    @RequestMapping("/venueAlternatelyStatistics")
    public String activityAlternatelyStatistics(String type, HttpServletRequest request) {
        return "admin/venueStatistics/venueAlternatelyStatistics";
    }
}
