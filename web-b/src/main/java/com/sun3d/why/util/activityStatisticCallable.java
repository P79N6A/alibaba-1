package com.sun3d.why.util;

import com.sun3d.why.model.ActivityUserStatistics;
import com.sun3d.why.statistics.service.StatisticActivityUserService;
import org.apache.log4j.Logger;
import java.util.concurrent.Callable;

/**
 * 用户活动统计管理
 */
public  class activityStatisticCallable implements Callable {


    private Logger logger = Logger.getLogger(activityStatisticCallable.class);
    private String ipAddr;
    private String activityId;
    private Integer collectActivity;
    private String userId;

    private StatisticActivityUserService statisticActivityUserService;
    public activityStatisticCallable(String ipAddr, String activityId, Integer collectActivity,String userId,StatisticActivityUserService statisticActivityUserService) {
         this.ipAddr=ipAddr;
         this.activityId=activityId;
         this.collectActivity=collectActivity;
         this.userId=userId;
         this.statisticActivityUserService=statisticActivityUserService;
  }

    @Override
    public Integer call() throws Exception {
        int count = statisticActivityUserService.activityUserCountByCondition(activityId,collectActivity,ipAddr,userId,Constant.STATIS2);
        if (count > 0) {
            //代表当天重复操作了 1.浏览次数 2.被赞次数 3.收藏次数4.分享次数
            logger.error("当天用户活动状态数据已存在不会重复保存数据");
            return 2;
        }
        ActivityUserStatistics activityUserStatistics=new ActivityUserStatistics();
        //添加活动收藏
        activityUserStatistics.setIp(ipAddr);
        activityUserStatistics.setActivityId(activityId);
        activityUserStatistics.setOperateType(collectActivity);
        int status =statisticActivityUserService.addAppActivityUserStatistics(activityUserStatistics,userId);
        return status;
    }
}
