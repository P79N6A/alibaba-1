package com.sun3d.why.statistics.service.impl;

import com.sun3d.why.dao.ActivityCircleStatisticsMapper;
import com.sun3d.why.model.ActivityCircleStatistics;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.statistics.service.ActivityCircleStatisticsService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class ActivityCircleStatisticsServiceImpl implements ActivityCircleStatisticsService{

    @Autowired
    private ActivityCircleStatisticsMapper activityCircleStatisticsMapper;

    @Override
    public int insertSelective(ActivityCircleStatistics record) {
        return activityCircleStatisticsMapper.insertSelective(record);
    }
    @Override
    public int deleteInfo() {
        return activityCircleStatisticsMapper.deleteInfo();
    }

    public List<ActivityCircleStatistics> queryByMap(Map map,SysUser loginUser) {
        map.put("area",loginUser.getUserCounty());
        return activityCircleStatisticsMapper.queryByMap(map);
    }

    public Map queryAreaLabelInfo(Map map, SysUser loginUser) {
        Map rsMap = new HashMap();
        String  strInfo = "";
        try {
            if ("45,上海市".equals(loginUser.getUserCounty())) {
                List<Map> mapList = activityCircleStatisticsMapper.queryByAll(map);
                if (mapList != null && mapList.size() > 0) {
                    for (Map map1 : mapList) {
                        strInfo +=   map1.get("circleName") +  ","  + map1.get("percentage")+ ";";
                    }
                    strInfo = strInfo.substring(0,strInfo.length()  - 1);
                }
            } else {
                map.put("area",loginUser.getUserCounty());
                List<ActivityCircleStatistics> activityCircleStatisticsList = activityCircleStatisticsMapper.queryByMap(map);
                if (activityCircleStatisticsList != null && activityCircleStatisticsList.size() > 0) {
                    for (ActivityCircleStatistics bean : activityCircleStatisticsList) {
                        if (bean.getActivityCircle() != null && StringUtils.isNotBlank(bean.getActivityCircle()))
                            strInfo +=  bean.getCircleName() +  ","  + bean.getPercentage() + ";";
                    }
                    strInfo = strInfo.substring(0,strInfo.length()  - 1);
                }
            }


            rsMap.put("strInfo", strInfo);
        } catch (Exception ex) {
            ex.printStackTrace();
        }

        return rsMap;
    }
}