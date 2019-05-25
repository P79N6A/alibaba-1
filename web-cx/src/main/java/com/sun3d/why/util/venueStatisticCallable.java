package com.sun3d.why.util;

import com.sun3d.why.model.VenueUserStatistics;
import com.sun3d.why.statistics.service.StatisticVenueUserService;
import org.apache.log4j.Logger;

import java.util.concurrent.Callable;

/**
 * 多线程中添加用户展馆统计
 */
public class venueStatisticCallable implements Callable {
    private Logger logger = Logger.getLogger(venueStatisticCallable.class);
   private String ipAddr;
    private  String venueId;
    private Integer operateTypeCollect;
    private String userId;
    private  StatisticVenueUserService statisticVenueUserService;

    public venueStatisticCallable(String ipAddr, String venueId, Integer operateTypeCollect, String userId, StatisticVenueUserService statisticVenueUserService) {
       this.ipAddr=ipAddr;
        this.venueId=venueId;
        this.operateTypeCollect=operateTypeCollect;
        this.userId=userId;
        this.statisticVenueUserService=statisticVenueUserService;
    }

    @Override
    public Integer call() throws Exception {
        int count = statisticVenueUserService.venueUserCountByCondition(venueId, operateTypeCollect,ipAddr,userId, Constant.STATIS2);
        if (count > 0) {
            //代表当天重复操作了这个状态  1.浏览次数 2.被赞次数 3.收藏次数4.分享次数
            logger.debug("当天用户场馆数据已存在不会进行重复保存数据");
            return 2;
        }
        VenueUserStatistics venueUserStatistics=new VenueUserStatistics();
        venueUserStatistics.setIp(ipAddr);
        venueUserStatistics.setVenueId(venueId);
        venueUserStatistics.setOperateType(operateTypeCollect);
        int  status=statisticVenueUserService.addAppVenueUserStatistics(venueUserStatistics, userId);
        return status;
    }
}
