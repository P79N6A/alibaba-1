package com.sun3d.why.dao;

import com.sun3d.why.model.VenueUserStatistics;

import java.util.Date;
import java.util.List;
import java.util.Map;

public interface VenueUserStatisticsMapper {
    //int countByExample(VenueUserStatisticsExample example);

  //  int deleteByExample(VenueUserStatisticsExample example);

  //  int deleteByPrimaryKey(String id);

  //  int insert(VenueUserStatistics record);

  //  void insertSelective(VenueUserStatistics record);

  //  List<VenueUserStatistics> selectByExample(VenueUserStatisticsExample example);

  //  VenueUserStatistics selectByPrimaryKey(String id);

 //   int updateByExampleSelective(@Param("record") VenueUserStatistics record, @Param("example") VenueUserStatisticsExample example);

  //  int updateByExample(@Param("record") VenueUserStatistics record, @Param("example") VenueUserStatisticsExample example);

   // int updateByPrimaryKeySelective(VenueUserStatistics record);

  //  int updateByPrimaryKey(VenueUserStatistics record);




   // public int queryVenueUserCount(VenueUserStatistics record);
      /*
        根据周进行馆藏进行统计
         param startDate  开始时间
              endDate     结束时间
         */
    List<VenueUserStatistics> queryVenueUserStatisticsByWeekDate(Date startDate, Date endDate);

    /**
     *根据map查询场馆用户数据
     * @param map
     * @return
     */
    int queryVenueUserCountByCondition(Map<String, Object> map);
  /*
  添加馆藏用户信息
   */
    int addVenueUserStatistics(VenueUserStatistics venueUserStatistics);
    /*
     * 根据月份进行场馆进行统计
     */
    List<VenueUserStatistics> queryVenueUserStatisticsByMonthDate();

    /**
     * 根据季度与年份进行统计
     * @param startDate
     * @param endDate
     * @return
     */
    List<VenueUserStatistics> queryVenueUserStatisticsByQuarterDate(Date startDate, Date endDate);

    /**
     * app用户取消收藏展馆
     * @param venueUserStatistics
     * @return
     */
    int deleteVenueUser(VenueUserStatistics venueUserStatistics);
}