package com.sun3d.why.statistics.service.impl;

import com.sun3d.why.dao.CmsContentStatisticMapper;
import com.sun3d.why.model.CmsContentStatistic;
import com.sun3d.why.statistics.service.CmsContentStatisticService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * Created by cj on 2015/7/27.
 */
@Service
@Transactional
public class CmsContentStatisticServiceImpl implements CmsContentStatisticService{

    @Autowired
    private CmsContentStatisticMapper cmsContentStatisticMapper;

    /**
     * 根据条件查询出符合条件的统计数据
     * @param cmsContentStatistic
     * @return
     */
    @Override
    public List<CmsContentStatistic> queryStatisticByCondition(CmsContentStatistic cmsContentStatistic) {

        return cmsContentStatisticMapper.queryStatisticByCondition(cmsContentStatistic);
    }

    /**
     * 根据条件查询出符合条件的统计数据数量
     * @param cmsContentStatistic
     * @return
     */
    @Override
    public int queryStatisticCountByCondition(CmsContentStatistic cmsContentStatistic) {

        return cmsContentStatisticMapper.queryStatisticCountByCondition(cmsContentStatistic);
    }

    /**
     * 新增统计数据
     * @param record
     * @return
     */
    @Override
    public int addCmsContentStatistic(CmsContentStatistic record) {

        return cmsContentStatisticMapper.addCmsContentStatistic(record);
    }

    /**
     * 删除统计数据
     * @param contentId
     * @return
     */
    @Override
    public int deleteById(String contentId) {

        return cmsContentStatisticMapper.deleteById(contentId);
    }

    /**
     * 编辑统计数据
     * @param record
     * @return
     */
    @Override
    public int editStatisticById(CmsContentStatistic record) {

        return cmsContentStatisticMapper.editStatisticById(record);
    }

    /**
     * 根据平台内容统计ID查询统计数据
     * @param contentId
     * @return
     */
    @Override
    public CmsContentStatistic queryStatisticById(String contentId) {

        return cmsContentStatisticMapper.queryStatisticById(contentId);
    }

    /**
     * 删除统计数据
     * @param cmsContentStatistic
     */
    @Override
    public void deleteStatisticData(CmsContentStatistic cmsContentStatistic) {

        cmsContentStatisticMapper.deleteStatisticData(cmsContentStatistic);
    }
}
