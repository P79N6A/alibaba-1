package com.sun3d.why.statistics.controller;

import com.sun3d.why.controller.CmsVenueController;
import com.sun3d.why.model.CmsContentStatistic;
import com.sun3d.why.statistics.service.CmsContentStatisticService;
import com.sun3d.why.util.Constant;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import java.util.List;

/**
 * Created by cj on 2015/7/28.
 */
@RequestMapping(value = "/contentStatistic")
@Controller
public class CmsContentStatisticController {

    private Logger logger = Logger.getLogger(CmsVenueController.class);

    @Autowired
    private CmsContentStatisticService cmsContentStatisticService;

    /**
     * 内容统计
     * @return
     */
    @RequestMapping(value ="/showStatistic")
    public ModelAndView showStatistic(){

        ModelAndView model = new ModelAndView();

        CmsContentStatistic cmsContentStatistic = new CmsContentStatistic();

        List<CmsContentStatistic> contentStatisticList = cmsContentStatisticService.queryStatisticByCondition(cmsContentStatistic);

        StringBuilder venueCategories = new StringBuilder();
        StringBuilder venueData = new StringBuilder();
        StringBuilder roomCategories = new StringBuilder();
        StringBuilder roomData = new StringBuilder();
        StringBuilder antiqueCategories= new StringBuilder();
        StringBuilder antiqueData = new StringBuilder();

        for (int i=0; i<contentStatisticList.size(); i++){
            cmsContentStatistic = contentStatisticList.get(i);
            String area = cmsContentStatistic.getArea();
            int count = cmsContentStatistic.getContentCount();
            String areaData = area.substring(area.indexOf(",")+1,area.length());
            if(cmsContentStatistic.getContentType() == Constant.CONTENT_STATISTIC_VENUE){
                venueCategories.append(areaData+",");
                venueData.append(count+",");
            }
            if(cmsContentStatistic.getContentType() == Constant.CONTENT_STATISTIC_ROOM){
                roomCategories.append(areaData+",");
                roomData.append(count+",");
            }
            if(cmsContentStatistic.getContentType() == Constant.CONTENT_STATISTIC_ANTIQUE){
                antiqueCategories.append(areaData+",");
                antiqueData.append(count+",");
            }
        }

        if(StringUtils.isNotBlank(venueCategories.toString()) && StringUtils.isNotBlank(venueData.toString())){
            venueCategories.deleteCharAt(venueCategories.lastIndexOf(","));
            venueData.deleteCharAt(venueData.lastIndexOf(","));
        }
        if(StringUtils.isNotBlank(roomCategories.toString()) && StringUtils.isNotBlank(roomData.toString())){
            roomCategories.deleteCharAt(roomCategories.lastIndexOf(","));
            roomData.deleteCharAt(roomData.lastIndexOf(","));
        }
        if(StringUtils.isNotBlank(antiqueCategories.toString()) && StringUtils.isNotBlank(antiqueData.toString())) {
            antiqueCategories.deleteCharAt(antiqueCategories.lastIndexOf(","));
            antiqueData.deleteCharAt(antiqueData.lastIndexOf(","));
        }

        model.setViewName("admin/statistic/contentStatistic");
        model.addObject("venueCategories",venueCategories.toString());
        model.addObject("venueData",venueData.toString());
        model.addObject("roomCategories",roomCategories.toString());
        model.addObject("roomData",roomData.toString());
        model.addObject("antiqueCategories",antiqueCategories.toString());
        model.addObject("antiqueData", antiqueData.toString());
        return model;
    }

}
