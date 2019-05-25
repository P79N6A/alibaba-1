package com.sun3d.why.statistics.service;

import com.sun3d.why.model.CmsCollect;
import com.sun3d.why.model.CmsStatistics;
import com.sun3d.why.model.VenueUserStatistics;

import java.text.ParseException;
import java.util.List;

/**
 * Created by Administrator on 2015/5/7.
 * 场馆明细表管理
 */
public interface StatisticVenueUserService {
    /*
    根据时间进行馆藏用户关系进行统计
     */
    List<CmsStatistics> queryVenueStatisticsByType(String queryType) throws ParseException;

   

  // int countByExample(VenueUserStatisticsExample example);

   // void insertSelective(VenueUserStatistics venueUserStatistics);

  //  public List<VenueUserStatistics> selectByExample(VenueUserStatisticsExample example);

    /**
     * 删除展馆
     * @param cmsCollect
     */
    public void deleteVenue(CmsCollect cmsCollect);


  //  public int queryVenueUserCount(VenueUserStatistics record);

    /**
     *根据条件查询藏馆用户信息
     * @param venueId   场馆id
     * @param operateType  操作类型 1.浏览次数 2.被赞次数 3.收藏次数4.分享次数
     * @param remortIp  页面ip
     * @param userId  用户id
     * @param status 用户类型 1.会员 2.游客
     * @return
     */
    int venueUserCountByCondition(String venueId, Integer operateType, String remortIp, String userId, Integer status) throws ParseException;

    /**
     * 添加展馆用户信息
     * @param venueUserStatistics 展馆用户对象
     */
    int addVenueUserStatistics(VenueUserStatistics venueUserStatistics);

    /**
     * app用户收藏展馆信息
     * @param venueUserStatistics 用户展馆对象
     * @param userId 用户id
     */
    int addAppVenueUserStatistics(VenueUserStatistics venueUserStatistics, String userId);

    /**
     * app取消收藏展馆
     * @param venueUserStatistics 展馆用户对象
     */
    int deleteVenueUser(VenueUserStatistics venueUserStatistics);
}
