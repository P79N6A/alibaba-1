package com.sun3d.why.service;

import com.sun3d.why.model.CmsActivity;
import com.sun3d.why.model.CmsRecommendRelated;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.util.Pagination;

import java.util.List;
import java.util.Map;

public interface RecommendRelatedService {


    /**
     * 删除
     * @param recommendId
     * @return int
     */
    String deleteById(String recommendId);

    /**
     * 插入
     * @return int
     */

    String insert(CmsRecommendRelated cmsRecommendRelated,SysUser user) ;

    /**
     * 有选择插入
     * @param  cmsRecommendRelated
     * @return int
     */

    int addRecommendRelated(CmsRecommendRelated cmsRecommendRelated);
    /**
     * 插入
     * @return int
     */

    String insertWeekend(CmsRecommendRelated cmsRecommendRelated,SysUser user) ;

    /**
     * 查询列表
     * @param  cmsRecommendRelated
     * @return List<CmsRecommendRelated>
     */
    List<CmsRecommendRelated> selectByCmsRecommendRelated(CmsRecommendRelated cmsRecommendRelated);

    List<CmsRecommendRelated> queryRecommendActivity(CmsActivity activity, Pagination page);


}