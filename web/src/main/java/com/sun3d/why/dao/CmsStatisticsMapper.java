package com.sun3d.why.dao;

import com.sun3d.why.model.CmsStatistics;

import java.util.Map;

public interface CmsStatisticsMapper {
   // int countByExample(CmsStatisticsExample example);

    //int deleteByExample(CmsStatisticsExample example);

  //  int deleteByPrimaryKey(String sId);

   // int insert(CmsStatistics record);

    /**
     * 添加统计表中的数据
     * @param record
     * @return
     */
    int addCmsStatisticByCondition(CmsStatistics record);

    //List<CmsStatistics> selectByExample(CmsStatisticsExample example);

  //  CmsStatistics selectByPrimaryKey(String sId);



 //   int updateByExample(@Param("record") CmsStatistics record, @Param("example") CmsStatisticsExample example);

 //   int updateByPrimaryKeySelective(CmsStatistics record);

    /**
     * 更新统计信息表中数据
     * @param record
     * @return
     */
    int editCmsStatisticByCondition(CmsStatistics record);

    /**
     *查询统计表中是否存在数据
     * @param s
     * @return
     */
    int cmsStatisticCountById(String s);

    /**
     * 前端2.0 根据id和type查询收藏量和浏览量
     * @param map
     * @return 统计表对象
     */
    CmsStatistics queryStatistics(Map<String, Object> map);
}