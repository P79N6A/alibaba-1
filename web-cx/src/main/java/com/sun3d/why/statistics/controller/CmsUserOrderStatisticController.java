package com.sun3d.why.statistics.controller;

import com.sun3d.why.model.CmsUserOrderStatistics;
import com.sun3d.why.statistics.service.CmsUserOrderStatisticsService;
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
@RequestMapping(value = "/userOrderStatistic")
@Controller
public class CmsUserOrderStatisticController {

    private Logger logger = Logger.getLogger(CmsUserOrderStatisticController.class);

    @Autowired
    private CmsUserOrderStatisticsService userOrderStatisticsService;

    /**
     * 内容统计
     * @return
     */
    @RequestMapping(value ="/userOrderStatistic")
    @ResponseBody
    public String userOrderStatistic(Integer type){
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
        StringBuilder userOrderDate = new StringBuilder();
        List<CmsUserOrderStatistics> userOrderStatisticsList = userOrderStatisticsService.queryUserOrderStatistics(map);
        if(CollectionUtils.isNotEmpty(userOrderStatisticsList)){
            for(CmsUserOrderStatistics userOrderStatistics:userOrderStatisticsList){
                if(userOrderStatistics.getsCategory() == 1){
                    userOrderDate.append("低于1次@"+userOrderStatistics.getsCount()+",");
                }else if(userOrderStatistics.getsCategory() == 2){
                    userOrderDate.append("平均1-2次@"+userOrderStatistics.getsCount()+",");
                }else if(userOrderStatistics.getsCategory() == 3){
                    userOrderDate.append("平均3次及以上@"+userOrderStatistics.getsCount()+",");
                }
            }
        }
        return userOrderDate.toString();
    }
}
