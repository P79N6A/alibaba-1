package com.sun3d.why.dao;

import com.sun3d.why.model.CmsRecommendRelated;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

public interface CmsRecommendRelatedMapper {


    /**
     * 删除
     * @param cmsRecommendRelated
     * @return int
     */
    int deleteById(CmsRecommendRelated cmsRecommendRelated);

    /**
     * 插入
     * @param  cmsRecommendRelated
     * @return int
     */

    int insert(CmsRecommendRelated cmsRecommendRelated);

    /**
     * 有选择插入
     * @param  cmsRecommendRelated
     * @return int
     */

    int addRecommendRelated(CmsRecommendRelated cmsRecommendRelated) ;


    /**
     * 查询列表
     * @param  map
     * @return List<CmsRecommendRelated>
     */
    List<CmsRecommendRelated> queryRecommendActivity(Map<String,Object> map);
    //查询数据总数
    int queryRecommendActivityCount(Map<String, Object> map);
}