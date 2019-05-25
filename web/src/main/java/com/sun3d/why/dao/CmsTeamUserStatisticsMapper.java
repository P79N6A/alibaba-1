package com.sun3d.why.dao;

import com.sun3d.why.model.CmsCultureUserStatistcs;
import com.sun3d.why.model.CmsTeamUserStatistics;

import java.util.Date;
import java.util.List;
import java.util.Map;

public interface CmsTeamUserStatisticsMapper {
  //  int countByExample(CmsTeamUserStatisticsExample example);

   // int deleteByExample(CmsTeamUserStatisticsExample example);

   // int deleteByPrimaryKey(String id);

   // int insert(CmsTeamUserStatistics record);

   // int insertSelective(CmsTeamUserStatistics record);

 //   List<CmsTeamUserStatistics> selectByExample(CmsTeamUserStatisticsExample example);

  //  CmsTeamUserStatistics selectByPrimaryKey(String id);

  //  int updateByExampleSelective(@Param("record") CmsTeamUserStatistics record, @Param("example") CmsTeamUserStatisticsExample example);

  //  int updateByExample(@Param("record") CmsTeamUserStatistics record, @Param("example") CmsTeamUserStatisticsExample example);

 //   int updateByPrimaryKeySelective(CmsTeamUserStatistics record);

  //  int updateByPrimaryKey(CmsTeamUserStatistics record);

    /**
     * 根据周查询团体用户数据
     * @param startDate 开始时间
     * @param endDate    结束时间
     * @return
     */
   List<CmsTeamUserStatistics> queryTeamUserStatisticsByWeekDate(Date startDate, Date endDate);
    /**
     * 查询团队用户数据
     * @param map
     * @return
     */
    int queryTermUserCountByCondition(Map<String, Object> map);

    /**
     * 添加团队用户数据
     * @param cmsTeamUserStatistics
     */
    int addTermUserStatistics(CmsTeamUserStatistics cmsTeamUserStatistics);

    /**
     *根据月份查询团体用户数据
     * @param startDate 开始时间
     * @param endDate    结束时间
     * @return
     */
    List<CmsTeamUserStatistics> queryTeamUserStatisticsByMonthDate(Date startDate, Date endDate);
    /**
     *根据季度,年份查询团体用户数据
     * @param startDate 开始时间
     * @param endDate    结束时间
     * @return
     */
    List<CmsTeamUserStatistics> queryTeamUserStatisticsByQuarterDate(Date startDate, Date endDate);

 /**
  * app取消收藏团体
  * @param teamUserStatistics
  * @return
  */
 int deleteTeamUser(CmsTeamUserStatistics teamUserStatistics);

 /**
  * app添加非遗用户数据
  * @param cultureUserStatistcs
  * @return
  */
 int addCultureUserStatistics(CmsCultureUserStatistcs cultureUserStatistcs);
}