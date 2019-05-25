package com.sun3d.why.util;

import com.sun3d.why.model.VenueUserStatistics;
import com.sun3d.why.statistics.service.StatisticVenueUserService;
import org.apache.log4j.Logger;

import java.util.concurrent.Callable;

/**
 *  多线程删除用户展馆统计
 */
public class venueStatisticDelCallable implements Callable{
    private Logger logger = Logger.getLogger(venueStatisticDelCallable.class);
    private String venueId;
    private Integer operateTypeCollect;
    private String userId;
    private StatisticVenueUserService statisticVenueUserService;
    public venueStatisticDelCallable(String venueId, Integer operateTypeCollect, String userId, StatisticVenueUserService statisticVenueUserService) {
         this.venueId=venueId;
         this.operateTypeCollect=operateTypeCollect;
         this.statisticVenueUserService=statisticVenueUserService;
         this.userId=userId;
    }

    @Override
    public Integer call() throws Exception {
        int count = statisticVenueUserService.venueUserCountByCondition(venueId, operateTypeCollect,null,userId,null);
        if (count < 0) {
            //代表当天重复操作了这个状态  1.浏览次数 2.被赞次数 3.收藏次数4.分享次数
            logger.debug("当天用户场馆数据不存在");
            return 2;
        }
        VenueUserStatistics venueUserStatistics=new VenueUserStatistics();
        venueUserStatistics.setUserId(userId);;
        venueUserStatistics.setVenueId(venueId);
        venueUserStatistics.setOperateType(operateTypeCollect);
        int flag=statisticVenueUserService.deleteVenueUser(venueUserStatistics);
        return flag;
    }
}
