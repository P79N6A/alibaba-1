package com.sun3d.why.statistics.controller;

import com.sun3d.why.model.CmsUserLoginStatistics;
import com.sun3d.why.statistics.service.CmsUserLoginStatisticsService;
import org.apache.commons.collections.CollectionUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by qww on 2015/7/28.
 */
@RequestMapping(value = "/userLoginStatistic")
@Controller
public class CmsUserLoginStatisticController {

    private Logger logger = Logger.getLogger(CmsUserLoginStatisticController.class);

    @Autowired
    private CmsUserLoginStatisticsService userLoginStatisticsService;

    /**
     * 内容统计
     * @return
     */
    @RequestMapping(value ="/userLoginStatistic")
    @ResponseBody
    public String userLoginStatistic(Integer type){
        Map<String, Object> map = new HashMap<String, Object>();
        if(type == 1){
            map.put("sType", 1);
        }else if(type == 2){
            map.put("sType", 2);
        }else if(type == 3){
            map.put("sType", 3);
        }else if(type == 4){
            map.put("sType", 4);
        }
        StringBuilder userLoginDate = new StringBuilder();
        List<CmsUserLoginStatistics> userLoginStatisticsList = userLoginStatisticsService.queryUserLoginStatistics(map);
        if(CollectionUtils.isNotEmpty(userLoginStatisticsList)){
            for(CmsUserLoginStatistics userLoginStatistics:userLoginStatisticsList){
                if(userLoginStatistics.getsCategory() == 1){
                    userLoginDate.append("APP-"+userLoginStatistics.getsCount()+",");
                }else if(userLoginStatistics.getsCategory() == 2){
                    userLoginDate.append("网页-"+userLoginStatistics.getsCount()+",");
                }
            }
        }
        return userLoginDate.toString();
    }
}
