package com.sun3d.why.job;

import com.sun3d.why.model.CmsActivityRoom;
import com.sun3d.why.model.CmsAntique;
import com.sun3d.why.model.CmsContentStatistic;
import com.sun3d.why.model.CmsVenue;
import com.sun3d.why.service.CmsActivityRoomService;
import com.sun3d.why.service.CmsAntiqueService;
import com.sun3d.why.statistics.service.CmsContentStatisticService;
import com.sun3d.why.service.CmsVenueService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.UUIDUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.Date;
import java.util.List;

/**
 * Created by cj on 2015/7/27.
 * 平台内容统计定时任务
 */
@Component("contentStatisticJob")
public class ContentStatisticJob {

    private Logger logger = Logger.getLogger(ContentStatisticJob.class);
    @Autowired
    private CmsContentStatisticService cmsContentStatisticService;
    @Autowired
    private CmsVenueService cmsVenueService;
    @Autowired
    private CmsActivityRoomService cmsActivityRoomService;
    @Autowired
    private CmsAntiqueService cmsAntiqueService;

    /**
     * 生成内容平台统计
     */
    public void generateContentStatistic(){
        //清除统计数据
        deleteStatisticData();

        //生成场馆统计数据
        generateVenueStatistic();
        //生成活动室统计数据
        generateRoomStatistic();
        //生成馆藏统计数据
        generateAntiqueStatistic();
    }

    /**
     * 生成场馆统计数据
     */
    public void generateVenueStatistic(){

        CmsVenue cmsVenue = new CmsVenue();
        //获取场馆统计数据
        List<CmsVenue> cmsVenueList = cmsVenueService.queryVenueStatistic(cmsVenue);

        CmsContentStatistic cmsContentStatistic = null;
        for (int i=0; i<cmsVenueList.size(); i++){
            cmsVenue = cmsVenueList.get(i);

            cmsContentStatistic = new CmsContentStatistic();
            cmsContentStatistic.setContentId(UUIDUtils.createUUId());
            cmsContentStatistic.setArea(cmsVenue.getVenueArea());
            //顺序暂时没有特别要求，统一置为1
            cmsContentStatistic.setAreaSort(1);
            //统计类型[1为场馆]
            cmsContentStatistic.setContentType(Constant.CONTENT_STATISTIC_VENUE);
            cmsContentStatistic.setContentCount(cmsVenue.getStatisticCount());
            cmsContentStatistic.setCreateTime(new Date());
            cmsContentStatisticService.addCmsContentStatistic(cmsContentStatistic);
        }

        logger.info("统计数量："+cmsVenueList.size());
    }

    /**
     * 生成活动室统计数据
     */
    public void generateRoomStatistic(){

        CmsActivityRoom cmsActivityRoom = new CmsActivityRoom();
        //获取活动室统计数据
        List<CmsActivityRoom> cmsActivityRoomList = cmsActivityRoomService.queryRoomStatistic(cmsActivityRoom);

        CmsContentStatistic cmsContentStatistic = null;
        for (int i=0; i<cmsActivityRoomList.size(); i++){
            cmsActivityRoom = cmsActivityRoomList.get(i);

            cmsContentStatistic = new CmsContentStatistic();
            cmsContentStatistic.setContentId(UUIDUtils.createUUId());
            cmsContentStatistic.setArea(cmsActivityRoom.getVenueArea());
            //顺序暂时没有特别要求，统一置为1
            cmsContentStatistic.setAreaSort(1);
            //统计类型[2为活动室]
            cmsContentStatistic.setContentType(Constant.CONTENT_STATISTIC_ROOM);
            cmsContentStatistic.setContentCount(cmsActivityRoom.getStatisticCount());
            cmsContentStatistic.setCreateTime(new Date());
            cmsContentStatisticService.addCmsContentStatistic(cmsContentStatistic);
        }
    }

    /**
     * 生成馆藏统计数据
     */
    public void generateAntiqueStatistic(){

        CmsAntique cmsAntique = new CmsAntique();
        //获取藏品统计数据
        List<CmsAntique> cmsAntiqueList = cmsAntiqueService.queryAntiqueStatistic(cmsAntique);

        CmsContentStatistic cmsContentStatistic = null;
        for (int i=0; i<cmsAntiqueList.size(); i++){
            cmsAntique = cmsAntiqueList.get(i);

            cmsContentStatistic = new CmsContentStatistic();
            cmsContentStatistic.setContentId(UUIDUtils.createUUId());
            cmsContentStatistic.setArea(cmsAntique.getVenueArea());
            //顺序暂时没有特别要求，统一置为1
            cmsContentStatistic.setAreaSort(1);
            //统计类型[3为藏品]
            cmsContentStatistic.setContentType(Constant.CONTENT_STATISTIC_ANTIQUE);
            cmsContentStatistic.setContentCount(cmsAntique.getStatisticCount());
            cmsContentStatistic.setCreateTime(new Date());
            cmsContentStatisticService.addCmsContentStatistic(cmsContentStatistic);
        }
    }

    /**
     * 删除统计数据
     */
    public void deleteStatisticData(){
        CmsContentStatistic cmsContentStatistic = new CmsContentStatistic();
        cmsContentStatisticService.deleteStatisticData(cmsContentStatistic);
    }
}
