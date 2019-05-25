package com.sun3d.why.controller;


import com.sun3d.why.annotation.SysBusinessLog;
import com.sun3d.why.model.AppAdvertCalendar;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.service.AppAdvertCalendarService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.Pagination;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.List;

@Controller
@RequestMapping(value = "/advertCalendar")
public class AppAdvertCalendarController {
 
    @Autowired
    private HttpSession session;
    @Autowired
    private AppAdvertCalendarService appAdvertCalendarService;

    /**
     * App广告位列表
     *
     * @param
     * @return
     */
    @SysBusinessLog(remark = "App广告位列表")
    @RequestMapping(value = "/appAdvertCalendarIndex")
    public ModelAndView appAdvertCalendarIndex(AppAdvertCalendar record, Pagination page) {
        ModelAndView model = new ModelAndView();
        try {
            List<AppAdvertCalendar> pageList = new ArrayList<AppAdvertCalendar>();
            String tagIds = "";
            pageList = appAdvertCalendarService.queryAdvertByCondition(record, page);
            model.addObject("list", pageList);
            model.addObject("page", page);
            model.addObject("record", record);
            model.setViewName("admin/advert/appAdvertCalendarIndex");
        } catch (Exception e) {

        }
        return model;
    }

    /**
     * 日历广告位新增页面
     *
     * @param
     * @return
     */
    @RequestMapping(value = "/addAdvertCalendar")
    public ModelAndView addAdvertCalendar(String advertId) {
        ModelAndView model = new ModelAndView();
        try {
            model.addObject("advertId", advertId);
            model.setViewName("admin/advert/addAdvertCalendar");
        } catch (Exception e) {

        }
        return model;
    }

    /**
     * 保存添加App广告位
     *
     * @return
     */
    @RequestMapping(value = "/addAdvert")
    @ResponseBody
    public String addAdvert(AppAdvertCalendar appadvertcalender) {
        try {
            if (appadvertcalender != null) {
                String result="";
                if (StringUtils.isNotBlank(appadvertcalender.getAdvImgUrl())) {
                    SysUser sysUser = (SysUser) session.getAttribute("user");
                    if (sysUser!= null) {
                        result = appAdvertCalendarService.addAdvert(appadvertcalender, sysUser);
                    } else {
                        result ="noLogin";
                    }
                        return result;
                } else {
                    return Constant.RESULT_STR_FAILURE;
                }
            }
        } catch (Exception e) {
            return Constant.RESULT_STR_FAILURE;
        }
        return Constant.RESULT_STR_FAILURE;
    }
    /**
     * 根据id读取咨询
     *
     * @return
     */
    @RequestMapping(value = "/getAdvert")
    @ResponseBody
    public AppAdvertCalendar getAdvert(String advertId) {
        try {
            return appAdvertCalendarService.getAdvert(advertId);
        } catch (Exception e) {
        }
        return null;
    }
}
