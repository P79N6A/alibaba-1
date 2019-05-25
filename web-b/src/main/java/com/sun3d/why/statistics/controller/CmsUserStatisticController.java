package com.sun3d.why.statistics.controller;

import com.sun3d.why.model.CmsUserStatistics;
import com.sun3d.why.statistics.service.CmsUserStatisticsService;
import org.apache.commons.collections.CollectionUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by cj on 2015/7/28.
 */
@RequestMapping(value = "/userStatistic")
@Controller
public class CmsUserStatisticController {

    private Logger logger = Logger.getLogger(CmsUserStatisticController.class);

    @Autowired
    private CmsUserStatisticsService userStatisticsService;

    /**
     * 内容统计
     * @return
     */
    @RequestMapping(value ="/userStatistic")
    public ModelAndView userStatistic(){
        ModelAndView model = new ModelAndView();
        // 1.文化云平台注册会员统计
        Map<String, Object> userMap = new HashMap<String, Object>();
        userMap.put("sType", 1);
        List<CmsUserStatistics> userStatisticsList = userStatisticsService.queryUserStatistics(userMap);
        if(CollectionUtils.isNotEmpty(userStatisticsList)){
            CmsUserStatistics userStatistics = userStatisticsList.get(0);
            model.addObject("userStatistics", userStatistics);
        }

        // 2.文化云平台会员年龄统计
        Map<String, Object> userAgeMap = new HashMap<String, Object>();
        userAgeMap.put("sType", 2);
        List<CmsUserStatistics> userAgeStatisticsList = userStatisticsService.queryUserStatistics(userAgeMap);
        if(CollectionUtils.isNotEmpty(userAgeStatisticsList)){
            StringBuilder userAgeDate = new StringBuilder();
            for(CmsUserStatistics userStatistics:userAgeStatisticsList){
                if(userStatistics.getsCategory() == 2){
                    userAgeDate.append("60后-"+userStatistics.getsCount()+",");
                }else if(userStatistics.getsCategory() == 3){
                    userAgeDate.append("70后-"+userStatistics.getsCount()+",");
                }else if(userStatistics.getsCategory() == 4) {
                    userAgeDate.append("80后-"+userStatistics.getsCount()+",");
                }else if(userStatistics.getsCategory() == 5){
                    userAgeDate.append("90后-"+userStatistics.getsCount()+",");
                }else if(userStatistics.getsCategory() == 6){
                    userAgeDate.append("00后-"+userStatistics.getsCount()+",");
                }else if(userStatistics.getsCategory() == 7){
                    userAgeDate.append("其他-"+userStatistics.getsCount()+",");
                }
            }
            model.addObject("userAgeDate", userAgeDate);
        }

        // 3.文化云平台会员性别统计
        Map<String, Object> userSexMap = new HashMap<String, Object>();
        userSexMap.put("sType", 3);
        List<CmsUserStatistics> userSexStatisticsList = userStatisticsService.queryUserStatistics(userSexMap);
        if(CollectionUtils.isNotEmpty(userSexStatisticsList)){
            StringBuilder userSexDate = new StringBuilder();
            for(CmsUserStatistics userStatistics:userSexStatisticsList){
                if(userStatistics.getsCategory() == 8){
                    userSexDate.append("男-"+userStatistics.getsCount()+",");
                }else if(userStatistics.getsCategory() == 9){
                    userSexDate.append("女-"+userStatistics.getsCount()+",");
                }
            }
            model.addObject("userSexDate", userSexDate);
        }

        model.setViewName("admin/statistic/userStatistic");
        return model;
    }

}
