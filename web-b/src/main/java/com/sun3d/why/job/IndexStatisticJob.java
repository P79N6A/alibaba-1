package com.sun3d.why.job;

import com.sun3d.why.model.CmsContentStatistic;
import com.sun3d.why.model.IndexStatistics;
import com.sun3d.why.service.*;
import com.sun3d.why.statistics.service.CmsContentStatisticService;
import com.sun3d.why.statistics.service.IndexStatisticsService;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by yujinbing on 2015/7/29.
 */
@Component("indexStatisticJob")
public class IndexStatisticJob {

    /**
     * 导入log4j日志管理，记录错误信息
     */
    private Logger logger = Logger.getLogger(IndexStatisticJob.class);

    @Autowired
    private CmsActivityService cmsActivityService;

    @Autowired
    private CmsTeamUserService cmsTeamUserService;

    @Autowired
    private CmsVenueService cmsVenueService;

    @Autowired
    private CmsActivityRoomService cmsActivityRoomService;

    @Autowired
    private CmsAntiqueService cmsAntiqueService;

    @Autowired
    private CmsActivityOrderService cmsActivityOrderService;

    @Autowired
    private CmsRoomOrderService cmsRoomOrderService;

    @Autowired
    private IndexStatisticsService indexStatisticsService;

    @Autowired
    private CmsContentStatisticService cmsContentStatisticService;



    public void indexStatisticJob() throws Exception {
        try {
            String allArea = "45,上海市";
            Integer allActivityCount = 0;
            Integer allTeamCount = 0;
            Integer allVenueCount = 0;
            Integer allCpCount = 0;
            Integer allRoomCount = 0;
            Integer allActivityTicketCount = 0;
            Integer allRoomBookCount = 0;
            //删除旧数据
            indexStatisticsService.deleteInfo();
            //添加活动新数据
            List<Map> activityList = cmsActivityService.queryActivityGroupByArea(new HashMap<String, Object>());
           if (activityList != null && activityList.size() > 0) {
                for (Map map : activityList) {
                    IndexStatistics indexStatistics = new IndexStatistics();
                    indexStatistics.setStatisticsTime(new Date());
                    indexStatistics.setArea(map.get("area").toString());
                    indexStatistics.setStatisticsType(1);
                    indexStatistics.setStatisticsCount(Integer.parseInt(map.get("statisticsCount").toString()));
                    if(indexStatistics.getArea() != null && !indexStatistics.getArea().contains("上海市")) {
                        indexStatisticsService.addIndexStatistics(indexStatistics);
                    }
                    allActivityCount += indexStatistics.getStatisticsCount();
                }
            }
            //将各个区域团体数量插入至统计表中
            List<Map> cmsTeamList = cmsTeamUserService.queryTeamCountByArea(new HashMap());
            if (cmsTeamList != null && cmsTeamList.size() > 0) {
                for (Map map : cmsTeamList) {
                    IndexStatistics indexStatistics = new IndexStatistics();
                    indexStatistics.setStatisticsTime(new Date());
                    indexStatistics.setArea(map.get("area").toString());
                    indexStatistics.setStatisticsType(2);
                    indexStatistics.setStatisticsCount(Integer.parseInt(map.get("statisticsCount").toString()));
                    indexStatisticsService.addIndexStatistics(indexStatistics);
                    allTeamCount += indexStatistics.getStatisticsCount();
                }
            }

            //查询  场馆  藏品  活动室数量 并插入统计表中
            CmsContentStatistic cmsContentStatistic = new CmsContentStatistic();
            List<CmsContentStatistic> contentStatisticList = cmsContentStatisticService.queryStatisticByCondition(cmsContentStatistic);
            if (contentStatisticList != null && contentStatisticList.size() > 0) {
                for (CmsContentStatistic contentStatistic : contentStatisticList) {
                    IndexStatistics indexStatistics = new IndexStatistics();
                    indexStatistics.setStatisticsTime(new Date());
                    indexStatistics.setArea(contentStatistic.getArea());
                    indexStatistics.setStatisticsCount(contentStatistic.getContentCount());
                    //contentType  1:场馆   2:活动室  3:藏品
                    if (contentStatistic.getContentType() == 1) {
                        indexStatistics.setStatisticsType(3);
                        allVenueCount += indexStatistics.getStatisticsCount();
                    } else if (contentStatistic.getContentType() == 2) {
                        indexStatistics.setStatisticsType(5);
                        allRoomCount += indexStatistics.getStatisticsCount();
                    } else if (contentStatistic.getContentType() == 3) {
                        indexStatistics.setStatisticsType(4);
                        allCpCount += indexStatistics.getStatisticsCount();
                    }
                    indexStatisticsService.addIndexStatistics(indexStatistics);
                }
            }

            //添加活动订票总数 至统计表中
            List<Map> activityOrderList = cmsActivityOrderService.queryTicketCountByArea(new HashMap());
            if (activityOrderList != null && activityOrderList.size() > 0) {
                for (Map map : activityOrderList) {
                    IndexStatistics indexStatistics = new IndexStatistics();
                    indexStatistics.setStatisticsTime(new Date());
                    indexStatistics.setArea(map.get("area") == null ? "45,上海市" : map.get("area").toString());
                    indexStatistics.setStatisticsType(6);
                    indexStatistics.setStatisticsCount(Integer.parseInt(map.get("statisticsCount").toString()));
                    allActivityTicketCount += indexStatistics.getStatisticsCount();
                    if(indexStatistics.getArea() != null && !indexStatistics.getArea().contains("上海市")) {
                        indexStatisticsService.addIndexStatistics(indexStatistics);
                    }
                }
            }

            //将预定活动室次数他添加至统计表中
            List<Map> roomOrderList = cmsRoomOrderService.queryBookCountByArea(new HashMap());
            if (roomOrderList != null && roomOrderList.size() > 0) {
                for (Map map : roomOrderList) {
                    IndexStatistics indexStatistics = new IndexStatistics();
                    indexStatistics.setStatisticsTime(new Date());
                    indexStatistics.setArea(map.get("area") == null ? "45,上海市" : map.get("area").toString());
                    indexStatistics.setStatisticsType(7);
                    indexStatistics.setStatisticsCount(Integer.parseInt(map.get("statisticsCount").toString()));
                    allRoomBookCount += indexStatistics.getStatisticsCount();
                    if(indexStatistics.getArea() != null && !indexStatistics.getArea().contains("上海市")) {
                        indexStatisticsService.addIndexStatistics(indexStatistics);
                    }
                }
            }

            //添加整个上海市的数据
            for (int i = 1; i <= 7; i++) {
                IndexStatistics indexStatistics = new IndexStatistics();
                indexStatistics.setStatisticsTime(new Date());
                indexStatistics.setArea(allArea);
                indexStatistics.setStatisticsType(i);
                if (i == 1) {
                    indexStatistics.setStatisticsCount(allActivityCount);
                } else if (i ==2) {
                    indexStatistics.setStatisticsCount(allTeamCount);
                } else if (i ==3) {
                    indexStatistics.setStatisticsCount(allVenueCount);
                } else if (i ==4) {
                    indexStatistics.setStatisticsCount(allCpCount);
                } else if (i ==5) {
                    indexStatistics.setStatisticsCount(allRoomCount);
                } else if (i ==6) {
                    indexStatistics.setStatisticsCount(allActivityTicketCount);
                } else if (i ==7) {
                    indexStatistics.setStatisticsCount(allRoomBookCount);
                }
                indexStatisticsService.addIndexStatistics(indexStatistics);
            }




        } catch (Exception ex) {
           ex.printStackTrace();
        }

    }

}
