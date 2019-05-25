package com.sun3d.why.job;

import com.sun3d.why.model.ActivityCircleStatistics;
import com.sun3d.why.model.ActivityStatistics;
import com.sun3d.why.model.SysDict;
import com.sun3d.why.statistics.service.ActivityCircleStatisticsService;
import com.sun3d.why.statistics.service.ActivityStatisticsService;
import com.sun3d.why.service.CmsActivityService;
import com.sun3d.why.service.SysDictService;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.*;

/**
 * 活动统计数量
 * Created by yujinbing on 2015/7/28.
 */
@Component("activityContentStatisticJob")
public class ActivityContentStatisticJob {

    /**
     * 导入log4j日志管理，记录错误信息
     */
    private Logger logger = Logger.getLogger(ActivityContentStatisticJob.class);

    @Autowired
    private ActivityStatisticsService activityStatisticsService;

    @Autowired
    private ActivityCircleStatisticsService activityCircleStatisticsService;

    @Autowired
    private SysDictService sysDictService;

    @Autowired
    private CmsActivityService activityService;

    public void activityContentStatisticJob() throws Exception {


        try {
            activityStatisticsService.deleteBySid(new HashMap());
            addActivityStatisticsInfo();
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        try {
            addActivityCircleStatistics();
        } catch (Exception ex) {
            ex.printStackTrace();
        }

    }

    /**
     * 添加活动发布数量至统计表中
     */
    public void addActivityStatisticsInfo() {
          //周
          List<Map> weekList = activityService.queryActivityStatistic(new HashMap(), 1);

          //上海市总数量
          Integer allWeekCount = 0;
          Integer allMonthCount = 0;
          Integer allSeasonCount = 0;
          Integer allYearCount = 0;
          Integer allPreWeekCount = 0;
          Integer allPreMonthCount = 0;
          Integer allPreSeasonCount = 0;
          Integer allPreYearCount = 0;
          String allArea = "45,上海市";

          if (weekList != null && weekList.size() > 0) {
              for (Map map : weekList) {
                  ActivityStatistics activityStatistics = new ActivityStatistics();
                  activityStatistics.setSid(1);
                  activityStatistics.setActivityCount(Integer.valueOf(map.get("curCount") == null ? "0" : map.get("curCount").toString()));
                  activityStatistics.setPreActivityCount(Integer.valueOf(map.get("preCount") == null ? "0" : map.get("preCount").toString()));
                  activityStatistics.setArea(map.get("area") == null ? "45,上海市" :map.get("area").toString());
                  activityStatistics.setStatisticsTime(new Date());
                  activityStatistics.setStatisticsType(1);
                  allWeekCount += activityStatistics.getActivityCount();
                  allPreWeekCount += activityStatistics.getPreActivityCount();
                  if ("45,上海市".equals(activityStatistics.getArea())) {
                      continue;
                  }
                  activityStatisticsService.addActivityStatistics(activityStatistics);
              }
          }
           //月
            List<Map> monthList = activityService.queryActivityStatistic(new HashMap(), 2);
            if (monthList != null && monthList.size() > 0) {
                for (Map map : monthList) {
                    ActivityStatistics activityStatistics = new ActivityStatistics();
                    activityStatistics.setSid(2);
                    activityStatistics.setActivityCount(Integer.valueOf(map.get("curCount") == null ? "0" : map.get("curCount").toString()));
                    activityStatistics.setPreActivityCount(Integer.valueOf(map.get("preCount") == null ? "0" : map.get("preCount").toString()));
                    activityStatistics.setArea(map.get("area") == null ? "45,上海市" :map.get("area").toString());
                    activityStatistics.setStatisticsTime(new Date());
                    activityStatistics.setStatisticsType(2);
                    allMonthCount += activityStatistics.getActivityCount();
                    allPreMonthCount += activityStatistics.getPreActivityCount();
                    if ("45,上海市".equals(activityStatistics.getArea())) {
                        continue;
                    }
                    activityStatisticsService.addActivityStatistics(activityStatistics);
                }
            }
            //季
            List<Map> seasonList = activityService.queryActivityStatistic(new HashMap(), 3);
            if (seasonList != null && seasonList.size() > 0) {
                for (Map map : seasonList) {
                    ActivityStatistics activityStatistics = new ActivityStatistics();
                    activityStatistics.setSid(3);
                    activityStatistics.setActivityCount(Integer.valueOf(map.get("curCount") == null ? "0" : map.get("curCount").toString()));
                    activityStatistics.setPreActivityCount(Integer.valueOf(map.get("preCount") == null ? "0" : map.get("preCount").toString()));
                    activityStatistics.setArea(map.get("area") == null ? "45,上海市" :map.get("area").toString());
                    activityStatistics.setStatisticsTime(new Date());
                    activityStatistics.setStatisticsType(3);
                    allSeasonCount += activityStatistics.getActivityCount();
                    allPreSeasonCount += activityStatistics.getPreActivityCount();
                    if ("45,上海市".equals(activityStatistics.getArea())) {
                        continue;
                    }
                    activityStatisticsService.addActivityStatistics(activityStatistics);
                }
            }
            //年
            List<Map> yearList = activityService.queryActivityStatistic(new HashMap(), 4);
            if (yearList != null && yearList.size() > 0) {
                for (Map map : yearList) {
                    ActivityStatistics activityStatistics = new ActivityStatistics();
                    activityStatistics.setSid(4);
                    activityStatistics.setActivityCount(Integer.valueOf(map.get("curCount") == null ? "0" : map.get("curCount").toString()));
                    activityStatistics.setPreActivityCount(Integer.valueOf(map.get("preCount") == null ? "0" : map.get("preCount").toString()));
                    activityStatistics.setArea(map.get("area") == null ? "45,上海市" :map.get("area").toString());
                    activityStatistics.setStatisticsTime(new Date());
                    activityStatistics.setStatisticsType(4);
                    allYearCount += activityStatistics.getActivityCount();
                    allPreYearCount += activityStatistics.getPreActivityCount();
                    if ("45,上海市".equals(activityStatistics.getArea())) {
                        continue;
                    }
                    activityStatisticsService.addActivityStatistics(activityStatistics);
                }
            }
        //上海市整个数据
        for (int i = 1 ; i <= 4; i++) {
            ActivityStatistics activityStatistics = new ActivityStatistics();
            activityStatistics.setSid(i);
            if (i == 1) {
                activityStatistics.setActivityCount(allWeekCount);
                activityStatistics.setPreActivityCount(allPreWeekCount);
            } else if (i ==2) {
                activityStatistics.setActivityCount(allMonthCount);
                activityStatistics.setPreActivityCount(allPreMonthCount);
            } else if (i ==3) {
                activityStatistics.setActivityCount(allSeasonCount);
                activityStatistics.setPreActivityCount(allPreSeasonCount);
            } else if (i ==4) {
                activityStatistics.setActivityCount(allYearCount);
                activityStatistics.setPreActivityCount(allPreYearCount);
            }
            activityStatistics.setStatisticsType(i);
            activityStatistics.setArea(allArea);
            activityStatistics.setStatisticsTime(new Date());
            activityStatisticsService.addActivityStatistics(activityStatistics);
        }

    }

    /**
     * 添加标签数量至标签统计表中
     */
    public void addActivityCircleStatistics() {
        //删除旧数据
        activityCircleStatisticsService.deleteInfo();
        //取前六个数量最多的标签
        List<Map> listMap  = activityService.queryActivityCircleStatistic(new HashMap<String, Object>());
        double totalCount = 0;
        List<ActivityCircleStatistics> list = new ArrayList<ActivityCircleStatistics>();
        String allArea = "45,上海市";
        double allPernt = 0;
        double allCount = 0;
        double qtCount = 0;
        Map<String ,Double>  tempMap = new HashMap<String ,Double>();
        if (listMap != null) {
            int index = 1;
            for (Map map : listMap) {
                ActivityCircleStatistics circleStatistics = new ActivityCircleStatistics();
                circleStatistics.setStatisticsTime(new Date());
                String area = map.get("area") == null ? "45,上海市" :map.get("area").toString();
                String count = map.get("activityLocationCount") == null ? "0" : map.get("activityLocationCount").toString();
                String code = map.get("activityLocation") == null ? "" :  map.get("activityLocation").toString();
                circleStatistics.setArea(area);
                circleStatistics.setActivityCircle(code);
                SysDict sysDict = sysDictService.querySysDictByDictId(code);
                if (sysDict != null) {
                    circleStatistics.setCircleName(sysDict.getDictName());
                }
                circleStatistics.setPercentage(Double.valueOf(count));
                //大于6的算到其它里面去
                if (index > 6) {
                    qtCount += Integer.parseInt(count);
                    continue;
                }
                activityCircleStatisticsService.insertSelective(circleStatistics);
                index ++;
            }

            if (qtCount != 0) {
                ActivityCircleStatistics circleStatistics = new ActivityCircleStatistics();
                circleStatistics.setStatisticsTime(new Date());
                String area = "45,上海市";
                circleStatistics.setArea(area);
                circleStatistics.setActivityCircle("qt");
                circleStatistics.setCircleName("其他");
                circleStatistics.setPercentage(Double.valueOf(qtCount));
                activityCircleStatisticsService.insertSelective(circleStatistics);
            }


        }
    }


/*    *//**
     * 删除活动商圈旧数据
     *//*
    public void deleteActivityCircleStatistics() {

    }

    *//**
     * 删除活动旧数据
     *//*
    public void deleteActivityStatistics() {

    }*/
}
