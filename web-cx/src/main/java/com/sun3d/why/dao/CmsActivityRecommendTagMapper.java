package com.sun3d.why.dao;
import com.sun3d.why.model.CmsActivityRecommendTag;
import com.sun3d.why.model.CmsListRecommendTag;

import java.util.List;

public interface CmsActivityRecommendTagMapper {
    /**
     * app用户浏览标签随机推送活动
     * @param cmsActivityRecommendTag
     * @return
     */
    int addRandActivity(CmsActivityRecommendTag cmsActivityRecommendTag);

    /**
     * app查询标签集合
     * @return
     */
    List<CmsListRecommendTag> queryRecommendTagList();
}