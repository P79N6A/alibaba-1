package com.sun3d.why.dao;

import com.sun3d.why.model.CmsContentStatistic;

import java.util.List;

public interface CmsContentStatisticMapper {

    /**
     * 根据条件查询出符合条件的统计数据
     * @param cmsContentStatistic
     * @return
     */
    List<CmsContentStatistic> queryStatisticByCondition(CmsContentStatistic cmsContentStatistic);

    /**
     * 根据条件查询出符合条件的统计数据数量
     * @param cmsContentStatistic
     * @return
     */
    int queryStatisticCountByCondition(CmsContentStatistic cmsContentStatistic);

    /**
     * 新增统计数据
     * @param record
     * @return
     */
    int addCmsContentStatistic(CmsContentStatistic record);

    /**
     * 删除统计数据
     * @param contentId
     * @return
     */
    int deleteById(String contentId);

    /**
     * 编辑统计数据
     * @param record
     * @return
     */
    int editStatisticById(CmsContentStatistic record);

    /**
     * 根据平台内容统计ID查询统计数据
     * @param contentId
     * @return
     */
    CmsContentStatistic queryStatisticById(String contentId);

    /**
     * 删除统计数据
     * @param cmsContentStatistic
     */
    void deleteStatisticData(CmsContentStatistic cmsContentStatistic);
}