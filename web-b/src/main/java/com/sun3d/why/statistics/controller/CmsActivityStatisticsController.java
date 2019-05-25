package com.sun3d.why.statistics.controller;

import com.sun3d.why.model.*;
import com.sun3d.why.statistics.service.ActivityCircleStatisticsService;
import com.sun3d.why.statistics.service.ActivityStatisticsService;
import com.sun3d.why.statistics.service.IndexStatisticsService;
import com.sun3d.why.util.DateUtils;
import com.sun3d.why.util.ExportExcel;
import com.sun3d.why.util.NsExcelWriteUtils;
import com.sun3d.why.util.Pagination;
import org.apache.commons.lang3.StringUtils;
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
import java.io.File;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


@RequestMapping("/activityStatistics")
@Controller
public class CmsActivityStatisticsController {
    private Logger logger = LoggerFactory.getLogger(CmsActivityStatisticsController.class);
    @Autowired
    private ActivityStatisticsService activityStatisticsService;
    @Autowired
    private ActivityCircleStatisticsService activityCircleStatisticsService;
    @Autowired
    private IndexStatisticsService indexStatisticsService;

    @Autowired
    private HttpSession session;

    @Autowired
    private ExportExcel exportExcel;

    /**
     * 进入活动统计首页
     *
     * @param type
     * @param request
     * @return
     */
    @RequestMapping("/activityStatisticsIndex")
    public String activityStatisticsIndex(String type, HttpServletRequest request) {
        return "admin/activityStatistics/activityStatisticsIndex";
    }

    /**
     * 进入活动地区统计首页
     *
     * @param type
     * @param request
     * @return
     */
    @RequestMapping("/activityAreaStatisticsIndex")
    public String activityAreaStatisticsIndex(String type, HttpServletRequest request) {
        return "admin/activityStatistics/activityStatistics";
    }

    /**
     * 进入活动地区统计首页
     *
     * @param type
     * @param request
     * @return
     */
    @RequestMapping("/activityTagStatisticsIndex")
    public String activityTagStatisticsIndex(String type, HttpServletRequest request) {
        return "admin/activityStatistics/activityTagStatistics";
    }

    /**
     * 进入活动预约统计首页
     *
     * @param type
     * @param request
     * @return
     */
    @RequestMapping("/activityBookStatisticsIndex")
    public String activityBookStatisticsIndex(String type, HttpServletRequest request) {
        return "admin/activityStatistics/activityBookStatistics";
    }

    /**
     * 活动评论报表页
     *
     * @param activityStatistics
     * @param page
     * @return
     */
    @RequestMapping("/activityMessageStatisticsIndex")
    public ModelAndView activityMessageStatisticsIndex(ActivityStatistics activityStatistics, Pagination page) {
        ModelAndView model = new ModelAndView();
        Map map = new HashMap();
        try {
            List<ActivityStatistics> list = activityStatisticsService.queryByMessage(activityStatistics, page, null);
            model.addObject("list", list);
            model.addObject("page", page);
            model.addObject("activityStatistics", activityStatistics);
            model.setViewName("admin/activityStatistics/activityMessageStatistics");
        } catch (Exception e) {
            logger.error("activityIndex error {}", e);
        }
        return model;
    }

    /**
     * 活动评论报表 显示论详情
     *
     * @param activityStatistics
     * @param page
     * @return
     */
    @RequestMapping("/activityMessage")
    public ModelAndView activityMessage(ActivityStatistics activityStatistics, Pagination page) {
        ModelAndView model = new ModelAndView();
        try {
            List<ActivityStatistics> list = activityStatisticsService.queryCommentByActivity(activityStatistics, page, null);
            model.addObject("list", list);
            model.addObject("page", page);
            model.addObject("activityStatistics", activityStatistics);
            model.setViewName("admin/activityStatistics/activityMessage");
        } catch (Exception e) {
            logger.error("activityIndex error {}", e);
        }
        return model;
    }

    /**
     * 活动评论报表 导出excel
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/exportActivityByMessageExcel")
    public void exportActivityByMessageExcel(HttpServletRequest request, HttpServletResponse response, ActivityStatistics activityStatistics, Pagination pagination, Pagination page) {
        try {
            response.setContentType("application/vnd.ms-excel;charset=utf-8");
            response.setCharacterEncoding("UTF-8");
            response.setHeader("Content-Disposition", "attachment;filename=" + "activity.xls");
            ServletOutputStream out = response.getOutputStream();
            SysUser sysUser = (SysUser) session.getAttribute("user");
            List<ActivityStatistics> list = activityStatisticsService.queryByMessage(activityStatistics, null, null);
            exportExcel.exportActivityExcel("测试title", "EXPORT_ACTIVITY_MESSAGE_STATISTICS_EXCEL", list, out, null);
        } catch (IOException e) {
            e.printStackTrace();
        } catch (ParseException e) {
            e.printStackTrace();
        }

    }

    /**
     * 活动统计首页 柱状图
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping("/queryAllAreaInfo")
    @ResponseBody
    public String queryAllAreaInfo(HttpServletRequest request, HttpServletResponse response) {
        Map map = new HashMap();
        String type = request.getParameter("type");
        String rs = activityStatisticsService.queryAllAreaInfo(type);
        return rs;
    }


    /**
     * 活动统计首页 柱状图
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping("/queryCountInfo")
    @ResponseBody
    public Map queryCountInfo(HttpServletRequest request, HttpServletResponse response) {
        SysUser user = (SysUser) session.getAttribute("user");
        Map map = new HashMap();
        if (StringUtils.isNotBlank(user.getUserCounty())) {
            map.put("area", user.getUserCounty());
        }
        String type = request.getParameter("type");
        map.put("statisticsType", type);
        Map rsMap = activityStatisticsService.queryCountInfo(map);
        return rsMap;
    }

    /**
     * 各区县活动情况 柱状图
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping("/queryAreaCountInfo")
    @ResponseBody
    public List<ActivityStatistics> queryAreaCountInfo(ActivityStatistics activityStatistics, HttpServletRequest request, HttpServletResponse response) {
        List<ActivityStatistics> list = activityStatisticsService.queryByArea(activityStatistics);
        return list;
    }

    /**
     * 各区县活动预定情况 柱状图
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping("/queryBookCountInfo")
    @ResponseBody
    public List<ActivityStatistics> queryBookCountInfo(ActivityStatistics activityStatistics, HttpServletRequest request, HttpServletResponse response) {
        List<ActivityStatistics> list = activityStatisticsService.queryByBook(activityStatistics);
        return list;
    }

    /**
     * 各区县活动情况 导出excel
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/exportActivityByAreaExcel")
    public void exportActivityByAreaExcel(HttpServletRequest request, HttpServletResponse response, ActivityStatistics activityStatistics, Pagination pagination) {
        try {
            response.setContentType("application/vnd.ms-excel;charset=utf-8");
            response.setCharacterEncoding("UTF-8");
            response.setHeader("Content-Disposition", "attachment;filename=" + "activity.xls");
            ServletOutputStream out = response.getOutputStream();
            SysUser sysUser = (SysUser) session.getAttribute("user");
            List<ActivityStatistics> list = activityStatisticsService.queryByArea(activityStatistics);
            exportExcel.exportActivityExcel("测试title", "EXPORT_ACTIVITY_STATISTICS_EXCEL", list, out, null);
        } catch (IOException e) {
            e.printStackTrace();
        }

    }

    /**
     * 各区县活动情况 导出excel
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/exportActivityByBookExcel")
    public void exportActivityByBookExcel(HttpServletRequest request, HttpServletResponse response, ActivityStatistics activityStatistics, Pagination pagination) {
        try {
            response.setContentType("application/vnd.ms-excel;charset=utf-8");
            response.setCharacterEncoding("UTF-8");
            response.setHeader("Content-Disposition", "attachment;filename=" + "activity.xls");
            ServletOutputStream out = response.getOutputStream();
            SysUser sysUser = (SysUser) session.getAttribute("user");
            List<ActivityStatistics> list = activityStatisticsService.queryByBook(activityStatistics);
            exportExcel.exportActivityExcel("测试title", "EXPORT_ACTIVITY_BOOK_STATISTICS_EXCEL", list, out, null);
        } catch (IOException e) {
            e.printStackTrace();
        }

    }


    /**
     * 活动标签热度统计
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping("/queryTagCountInfo")
    @ResponseBody
    public List<ActivityStatistics> queryTagCountInfo(ActivityStatistics activityStatistics, HttpServletRequest request, HttpServletResponse response) {
        List<ActivityStatistics> list = activityStatisticsService.queryByTag(activityStatistics);
        return list;
    }

    /**
     * 活动标签热度统计 导出excel
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/exportActivityByTagExcel")
    public void exportActivityByTagExcel(HttpServletRequest request, HttpServletResponse response, ActivityStatistics activityStatistics, Pagination pagination) {
        try {
            response.setContentType("application/vnd.ms-excel;charset=utf-8");
            response.setCharacterEncoding("UTF-8");
            response.setHeader("Content-Disposition", "attachment;filename=" + "activity.xls");
            ServletOutputStream out = response.getOutputStream();
            SysUser sysUser = (SysUser) session.getAttribute("user");
            List<ActivityStatistics> list = activityStatisticsService.queryByTag(activityStatistics);
            exportExcel.exportActivityExcel("测试title", "EXPORT_ACTIVITY_TAG_STATISTICS_EXCEL", list, out, null);
        } catch (IOException e) {
            e.printStackTrace();
        }

    }

    /**
     * 活动统计首页 饼状图
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping("/queryAreaLabelInfo")
    @ResponseBody
    public Map queryAreaLabelInfo(HttpServletRequest request, HttpServletResponse response) {
        SysUser user = (SysUser) session.getAttribute("user");
        Map map = new HashMap();
        map = activityCircleStatisticsService.queryAreaLabelInfo(map, user);
        return map;
    }


    /**
     * 后台首页
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping("/queryRightIndex")
    @ResponseBody
    public Map queryRightIndex(HttpServletRequest request, HttpServletResponse response) {
        Map map = new HashMap();
        SysUser user = (SysUser) session.getAttribute("user");
        String area = request.getParameter("area");
        String name = "";
        String count = "";
        List<IndexStatistics> indexStatisticsList = indexStatisticsService.queryInfoByInfo(map, user, area);
        if (indexStatisticsList != null && indexStatisticsList.size() != 0) {
            for (IndexStatistics indexStatistics : indexStatisticsList) {
                if (indexStatistics.getStatisticsType() != null && indexStatistics.getStatisticsType() == 1) {
                    name += "活动数量,";
                    count += indexStatistics.getStatisticsCount() + ",";
                } else if (indexStatistics.getStatisticsType() != null && indexStatistics.getStatisticsType() == 2) {
                    name += "团体数量,";
                    count += indexStatistics.getStatisticsCount() + ",";
                } else if (indexStatistics.getStatisticsType() != null && indexStatistics.getStatisticsType() == 3) {
                    name += "场馆数量,";
                    count += indexStatistics.getStatisticsCount() + ",";
                } else if (indexStatistics.getStatisticsType() != null && indexStatistics.getStatisticsType() == 4) {
                    name += "藏品数量,";
                    count += indexStatistics.getStatisticsCount() + ",";
                } else if (indexStatistics.getStatisticsType() != null && indexStatistics.getStatisticsType() == 5) {
                    name += "活动室数量,";
                    count += indexStatistics.getStatisticsCount() + ",";
                } else if (indexStatistics.getStatisticsType() != null && indexStatistics.getStatisticsType() == 6) {
                    name += "活动售票量,";
                    count += indexStatistics.getStatisticsCount() + ",";
                } else if (indexStatistics.getStatisticsType() != null && indexStatistics.getStatisticsType() == 7) {
                    name += "活动室预定数量,";
                    count += indexStatistics.getStatisticsCount() + ",";
                }
            }
            map.put("names", name.substring(0, name.length() - 1));
            map.put("counts", count.substring(0, count.length() - 1));
        }
        return map;
    }

    /**
     * 进入活动发布统计首页
     *
     * @param type
     * @param request
     * @return
     */
    @RequestMapping("/activityPublicStatistics")
    public String activityPublicStatistics(String type, HttpServletRequest request) {
        return "admin/activityStatistics/activityPublicStatistics";
    }


    /**
     * 活动发布统计查询
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping("/selectStatDataByAdmin")
    @ResponseBody
    public List<StatData> selectStatDataByAdmin(HttpServletRequest request, HttpServletResponse response) throws ParseException {
        SysUser user = (SysUser) session.getAttribute("user");
        Map map = new HashMap();
        //        类型码：活动：activity  场馆：venue
        if (StringUtils.isNotBlank(request.getParameter("cType"))) {
            String cType = request.getParameter("cType");
            map.put("cType", cType);
        }
//        地区码，当为0时，表示搜索所有地区
        if (StringUtils.isNotBlank(request.getParameter("carea"))) {
            if(request.getParameter("carea").equals("1")){
            }else{
                map.put("carea", request.getParameter("carea"));
            }
        }
//        场馆码，当为0时，表示搜索所在地区下所有场馆
        if (StringUtils.isNotBlank(request.getParameter("vname"))) {

            if ("0".equals(request.getParameter("vname"))) {
                map.put("allVenue", 0);
            } else {
                map.put("vname", request.getParameter("vname"));
            }
        } else {
            map.put("allArea", 0);
        }
//        搜索时间，当选择为所有地区或所有场馆时，将筛选出某时间段内的数据；某日、某周、某月
        if (StringUtils.isNotBlank(request.getParameter("cdate"))) {
            map.put("cdate", request.getParameter("cdate"));
        }
//        评级等级
        if (StringUtils.isNotBlank(request.getParameter("clevel"))) {
            map.put("clevel", request.getParameter("clevel"));
        }
//        日期筛选格式，当不为空时，表示不进行时间搜索。而是按照地区单位进行搜索。
//        1：天为单位，最近十天的数据；2：周为单位，最近十周的数据；3：以月为单位，最近十月的数据
        if (StringUtils.isNotBlank(request.getParameter("dateType"))) {
            map.put("dateType", request.getParameter("dateType"));
        }
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
        if (StringUtils.isNotBlank(request.getParameter("startTime"))) {
            map.put("startTime", df.parse(request.getParameter("startTime")));

        }
        if (StringUtils.isNotBlank(request.getParameter("endTime"))) {
            map.put("endTime", df.parse(request.getParameter("endTime")));
        }
        List<StatData> statDatas = activityStatisticsService.selectStatDataByAdmin(map);
        return statDatas;
    }

    /**
     * 进入活动交互统计首页
     *
     * @param type
     * @param request
     * @return
     */
    @RequestMapping("/activityAlternatelyStatistics")
    public String activityAlternatelyStatistics(String type, HttpServletRequest request) {
        return "admin/activityStatistics/activityAlternatelyStatistics";
    }

    /**
     * 活动交互统计查询
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping("/selectStatReactByAdmin")
    @ResponseBody
    public List<StatReact> selectStatReactByAdmin(HttpServletRequest request, HttpServletResponse response) throws ParseException {
        SysUser user = (SysUser) session.getAttribute("user");
        Map map = new HashMap();
        //        类型码：活动：activity  场馆：venue
        if (StringUtils.isNotBlank(request.getParameter("cType"))) {
            String cType = request.getParameter("cType");
            map.put("cType", cType);
        }
//        地区码，当为0时，表示搜索所有地区
        if (StringUtils.isNotBlank(request.getParameter("carea"))) {
            map.put("carea", request.getParameter("carea"));
        }
//        要搜索的详细活动名称
        if (StringUtils.isNotBlank(request.getParameter("cname"))) {
            map.put("cname", request.getParameter("cname"));
        }
//        场馆码，当为0时，表示搜索所在地区下所有场馆
        if (StringUtils.isNotBlank(request.getParameter("vname"))) {

            if ("0".equals(request.getParameter("vname"))) {
                map.put("allVenue", 0);
            } else {
                map.put("vname", request.getParameter("vname"));
            }
        } else {
            map.put("allArea", 0);
        }
//        搜索时间，当选择为所有地区或所有场馆时，将筛选出某时间段内的数据；某日、某周、某月
        if (StringUtils.isNotBlank(request.getParameter("cdate"))) {
            map.put("cdate", request.getParameter("cdate"));
        }
//        评级等级
        if (StringUtils.isNotBlank(request.getParameter("clevel"))) {
            map.put("clevel", request.getParameter("clevel"));
        }
//        日期筛选格式，当不为空时，表示不进行时间搜索。而是按照地区单位进行搜索。
//        1：天为单位，最近十天的数据；2：周为单位，最近十周的数据；3：以月为单位，最近十月的数据
        if (StringUtils.isNotBlank(request.getParameter("dateType"))) {
            map.put("dateType", request.getParameter("dateType"));
        }
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
        if (StringUtils.isNotBlank(request.getParameter("startTime"))) {
            map.put("startTime", df.parse(request.getParameter("startTime")));

        }
        if (StringUtils.isNotBlank(request.getParameter("endTime"))) {
            map.put("endTime", df.parse(request.getParameter("endTime")));
        }
        List<StatReact> statReacts = activityStatisticsService.selectStatReactByAdmin(map);
        return statReacts;
    }

    /**
     * 单场活动交互统计首页
     *
     * @param type
     * @param request
     * @return
     */
    @RequestMapping("/activityIdAltStatistics")
    public String activityIdAltStatistics(String type, HttpServletRequest request) {
        return "admin/activityStatistics/activityIdAltStatistics";
    }

    /**
     * 活动常规统计
     *
     * @return
     */
    @RequestMapping("/activityRoutineStatistics")
    public String activityRoutineStatistics() {
        return "admin/activityStatistics/activityRoutineStatistics";
    }


    /**
     * 活动常规统计
     *
     * @return
     */
    @RequestMapping("/activityRoutineStatisticsData")
    @ResponseBody
    public List<ActivityRoutineStatistics> activityRoutineStatisticsData(String activityName, String venueName, String startTime, String endTime) throws Exception {
        Map map = new HashMap();
        if (StringUtils.isNotBlank(activityName)) {
            map.put("activityName", activityName);
        }
        if (StringUtils.isNotBlank(venueName)) {
            map.put("venueName", venueName);
        }
        if (StringUtils.isNotBlank(startTime)) {
            map.put("startTime", startTime);
        } else {
            if (StringUtils.isBlank(activityName)) {
                startTime = DateUtils.formatDate(DateUtils.getCurrMonthFirst());
                map.put("startTime", startTime);
            }
        }
        if (StringUtils.isNotBlank(endTime)) {
            map.put("endTime", endTime);
        }
        List<ActivityRoutineStatistics> statReacts = activityStatisticsService.activityRoutineStatisticsData(map);
        return statReacts;
    }


    /**
     * 导出活动常规统计
     * @param request
     * @param response
     */
    @RequestMapping(value = "/exportActivityRoutineStatisticsData")
    public void exportUserAnalysisList(HttpServletRequest request, HttpServletResponse response,String activityName, String venueName, String startTime, String endTime) {
        try {

            Map map = new HashMap();
            if (StringUtils.isNotBlank(activityName)) {
                map.put("activityName", activityName);
            }
            if (StringUtils.isNotBlank(venueName)) {
                map.put("venueName", venueName);
            }
            if (StringUtils.isNotBlank(startTime)) {
                map.put("startTime", startTime);
            } else {
                if (StringUtils.isBlank(activityName)) {
                    startTime = DateUtils.formatDate(DateUtils.getCurrMonthFirst());
                    map.put("startTime", startTime);
                }
            }
            if (StringUtils.isNotBlank(endTime)) {
                map.put("endTime", endTime);
            }
            List<ActivityRoutineStatistics> statReacts = activityStatisticsService.activityRoutineStatisticsData(map);

            SimpleDateFormat sdf=new SimpleDateFormat("yyyyMMddHHmmss");

            SimpleDateFormat sdf1=new SimpleDateFormat("yyyy-MM-dd HH:mm");

            String fileName=sdf.format(new Date());

            //exportExcel.exportActivityExcel("测试title", "EXPORT_ACTIVITY_STATISTICS_EXCEL", list, out, null);

            File file=File.createTempFile(fileName,".xls");

            NsExcelWriteUtils writer=new NsExcelWriteUtils(file.getPath());


            writer.createSheet("导出活动常规统计");

            String []title=new String[]{"活动名称","活动场馆名称","活动场次","有效订单数","总票数","订票数","订票率","取票数","取票率"};

            writer.createRow(0);
            for (int i = 0; i < title.length; i++) {
                writer.createCell(i, title[i]);
            }

            for (int i = 1; i <= statReacts.size(); i++) {

                writer.createRow(i);

                ActivityRoutineStatistics b=statReacts.get(i-1);

                writer.createCell(0, b.getActivityName());
                writer.createCell(1, b.getVenueName());
                writer.createCell(2, b.getEventDateTime());
                writer.createCell(3, b.getValidOrders().toString());
                //writer.createCell(4, b.getCheckOrders().toString());
                writer.createCell(4, String.valueOf(b.getTickets()));
                writer.createCell(5, String.valueOf(b.getValidTickets()));
                writer.createCell(6, b.getBookPer());
                writer.createCell(7, String.valueOf(b.getTakeTickets()));
                writer.createCell(8, b.getTakeTicketsPer());
                //writer.createCell(10, String.valueOf(b.getCheckOrders()));
                //writer.createCell(11, b.getPresentPer());
            }
            writer.createExcel();
            NsExcelWriteUtils.downLoadFileByInputStream(file, fileName+".xls", response);
        } catch (IOException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    /**
     * 各区县活动情况 柱状图
     *
     * @return
     */
    @RequestMapping("/queryAreaData")
    @ResponseBody
    public List<ActivityData> queryAreaData(ActivityData data) {
        List<ActivityData> list = activityStatisticsService.queryAreaData(data);
        return list;
    }


    /**
     * 进入活动街镇统计首页
     * @param data
     * @param request
     * @return
     */
    @RequestMapping("/activityLocationStatisticsIndex")
    public String activityLocationStatisticsIndex(ActivityData data, HttpServletRequest request) {
        request.setAttribute("data",data);
        return "admin/activityStatistics/activityLocationStatistics";
    }


    /**
     * 街镇活动情况 柱状图
     *
     * @return
     */
    @RequestMapping("/queryLocationData")
    @ResponseBody
    public List<ActivityData> queryLocationData(ActivityData data) {
        List<ActivityData> list = activityStatisticsService.queryLocationData(data);
        return list;
    }

    /**
     * 进入活动类型统计首页
     * @return
     */
    @RequestMapping("/activityTypeStatisticsIndex")
    public String activityTypeStatisticsIndex() {
        return "admin/activityStatistics/activityTypeStatistics";
    }

    /**
     * 活动类型情况 柱状图
     *
     * @return
     */
    @RequestMapping("/queryActivityTypeData")
    @ResponseBody
    public List<ActivityData> queryActivityTypeData(ActivityData data) {
        List<ActivityData> list = activityStatisticsService.queryActivityTypeData(data);
        return list;
    }

    /**
     * 进入活动场馆统计首页
     * @return
     */
    @RequestMapping("/activityVenueStatisticsIndex")
    public String activityVenueStatisticsIndex(ActivityData data, HttpServletRequest request) {
        request.setAttribute("data",data);
        return "admin/activityStatistics/activityVenueStatistics";
    }

    /**
     * 活动场馆情况 柱状图
     * @return
     */
    @RequestMapping("/queryActivityVenueData")
    @ResponseBody
    public List<ActivityData> queryActivityVenueData(ActivityData data) {
        List<ActivityData> list = activityStatisticsService.queryActivityVenueData(data);
        return list;
    }

}
