package com.sun3d.why.util;

import com.sun3d.why.model.ActivityUserStatistics;
import com.sun3d.why.statistics.service.StatisticActivityUserService;
import org.apache.log4j.Logger;

import java.util.concurrent.Callable;

/**
 * 多线程删除用户活动统计
 */
public class activityStatisticDelCallable  implements Callable{
    private Logger logger = Logger.getLogger(activityStatisticDelCallable.class);
    private String activityId;
    private Integer operateTypeCollect;
    private  String userId;
    private StatisticActivityUserService statisticActivityUserService;

    public activityStatisticDelCallable(String activityId, Integer operateTypeCollect, String userId, StatisticActivityUserService statisticActivityUserService) {
        this.activityId=activityId;
        this.operateTypeCollect=operateTypeCollect;
        this.userId=userId;
        this.statisticActivityUserService=statisticActivityUserService;
    }

    @Override
    public Integer call() throws Exception {
        int flag=0;
        int count = statisticActivityUserService.activityUserCountByCondition(activityId,operateTypeCollect,null,userId,null);
        if (count <0) {
            //代表当天重复操作了 1.浏览次数 2.被赞次数 3.收藏次数4.分享次数
            logger.error("当天用户活动状态数据不存在");
            return 2;
        }
        ActivityUserStatistics activityUserStatistics=new ActivityUserStatistics();
        //删除用户活动统计
        activityUserStatistics.setUserId(userId);;
        activityUserStatistics.setActivityId(activityId);
        activityUserStatistics.setOperateType(operateTypeCollect);
        flag =statisticActivityUserService.deleteActivityUser(activityUserStatistics);
        return flag;
    }
}
