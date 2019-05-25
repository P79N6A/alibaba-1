package com.sun3d.why.controller;

import com.sun3d.why.service.CmsAppSettingService;
import com.sun3d.why.util.Constant;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import java.io.*;
import java.net.URLDecoder;
import java.util.List;
import java.util.Properties;

/**
 * 设置热门
 *
 */
@Controller
@RequestMapping("/appSetting")
public class AppSettingController {
    @Autowired
    private CmsAppSettingService cmsAppSettingService;
    
    

    private Logger logger = Logger.getLogger(AppSettingController.class);

    /**
     * 设置列表，目前三类固定 1.热的时间（单位小时）：hotDays
     *                    2.活动热门词汇：activityHotKeywords
     *                    3.场馆热门词汇：venueHotKeywords
     *
     * @param
     * @return
     */
    @RequestMapping(value = "/appSettingIndex")
    public ModelAndView appSettingIndex() {
        ModelAndView model = new ModelAndView();
        try {
            String hotDays = "hotDays";
            String activityHotKeywords = "activityHotKeywords";
            String activityTagKeywords = "activityTagKeywordsName";
            String activityAreaKeywords = "activityAreaKeywords";
            String venueHotKeywords = "venueHotKeywords";
            String venueTagKeywordsName = "venueTagKeywordsName";
            String venueAreaKeywords = "venueAreaKeywords";


            List hotDaysList = cmsAppSettingService.getList(hotDays);
            List activityHotKeywordsList = cmsAppSettingService.getList(activityHotKeywords);
            List venueHotKeywordsList = cmsAppSettingService.getList(venueHotKeywords);
            List activityTagKeywordsList = cmsAppSettingService.getList(activityTagKeywords);
            List activityAreaKeywordsList = cmsAppSettingService.getList(activityAreaKeywords);
            List venueTagKeywordsNameList = cmsAppSettingService.getList(venueTagKeywordsName);
            List venueAreaKeywordsList = cmsAppSettingService.getList(venueAreaKeywords);


            model.addObject("hotDays", hotDaysList);
            model.addObject("activityHotKeywords", activityHotKeywordsList);
            model.addObject("venueHotKeywords", venueHotKeywordsList);
            model.addObject("activityTagKeywords", activityTagKeywordsList);
            model.addObject("activityAreaKeywords", activityAreaKeywordsList);
            model.addObject("venueTagKeywordsName", venueTagKeywordsNameList);
            model.addObject("venueAreaKeywords", venueAreaKeywordsList);
            model.setViewName("admin/appSetting/appSettingIndex");
        } catch (Exception e) {
            logger.error("reading Redis file error {}", e);
        }
        return model;
    }

    /**
     * @param saveId:保存到redis里的key
     * @param hotWords：对应的数据，会在后面转换为List
     *
     * @param
     * @return
     */
    @RequestMapping(value = "/saveSetting")
    @ResponseBody
    public String saveSetting(String hotWords, String saveId) {
        try {
            if (StringUtils.isNotBlank(saveId)) {
                String result = cmsAppSettingService.saveList(hotWords, saveId);
                if (Constant.RESULT_STR_SUCCESS.equals(result)) {
                    return Constant.RESULT_STR_SUCCESS;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            return e.toString();
        }
        return Constant.RESULT_STR_FAILURE;
    }

    /**
     * 根据saveId从Redis中去List
     *
     * @param
     * @return
     */
    @RequestMapping(value = "/getSetting")
    @ResponseBody
    public List getSetting(String saveId) {
        try {
            List words = cmsAppSettingService.getList(saveId);
            return words;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * 进入编辑页面
     *
     * @param
     * @return
     */
    @RequestMapping(value = "/editAppSetting")
    public ModelAndView editAppSetting(String saveId) {
        ModelAndView model = new ModelAndView();
        List words = cmsAppSettingService.getList(saveId);
        model.addObject("saveId", saveId);
        model.addObject("hotWords", words);
        model.setViewName("admin/appSetting/editAppSetting");
        return model;
    }
    /**
     * 进入编辑页面
     *
     * @param
     * @return
     */
    @RequestMapping(value = "/editAppSelectSetting")
    public ModelAndView editAppSelectSetting(String saveId) {
        ModelAndView model = new ModelAndView();
        List words = cmsAppSettingService.getList(saveId);
        model.addObject("saveName", saveId);
        model.addObject("hotWords", words);
        model.setViewName("admin/appSetting/editAppTagSetting");
        return model;
    }
    /**
     * 进入编辑页面
     *
     * @param
     * @return
     */
    @RequestMapping(value = "/editActivityAreaSetting")
    public ModelAndView editActivityAreaSetting(String saveId) {
        ModelAndView model = new ModelAndView();
        List words = cmsAppSettingService.getList(saveId);
        model.addObject("saveName", saveId);
        model.addObject("hotWords", words);
        model.setViewName("admin/appSetting/appActivityAreaSetting");
        return model;
    }
    /**
     * 进入编辑页面
     *
     * @param
     * @return
     */
    @RequestMapping(value = "/venueTagKeywordsName")
    public ModelAndView venueTagKeywordsName(String saveId) {
        ModelAndView model = new ModelAndView();
        List words = cmsAppSettingService.getList(saveId);
        model.addObject("saveName", saveId);
        model.addObject("hotWords", words);
        model.setViewName("admin/appSetting/editVenueTagSetting");
        return model;
    }
}
