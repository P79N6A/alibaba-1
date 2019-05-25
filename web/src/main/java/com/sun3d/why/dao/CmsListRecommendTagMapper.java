package com.sun3d.why.dao;

import com.sun3d.why.model.CmsListRecommendTag;
import com.sun3d.why.model.SysUser;

import java.util.List;
import java.util.Map;

public interface CmsListRecommendTagMapper {

    /**
     * 根据主键删除
     * @param listRecommendId
     * @return
     */
    int deleteCmsListRecommendTagId(String listRecommendId);



    /**
     * 添加
     * @param cmsListRecommendTag
     * @return
     */
    int addCmsListRecommendTag(CmsListRecommendTag cmsListRecommendTag);


    /**
     * 查询List
     *
     * @return
     */
    List<CmsListRecommendTag> queryCmsListRecommendTagList();

    /**
     * app查询标签id集合
     * @return
     */
    List<CmsListRecommendTag> queryAppListRecommendTagList();
}