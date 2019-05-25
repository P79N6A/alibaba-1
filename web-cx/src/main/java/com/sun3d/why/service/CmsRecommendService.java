package com.sun3d.why.service;

import com.sun3d.why.model.CmsRecommend;
import com.sun3d.why.model.extmodel.AreaData;
import com.sun3d.why.util.Pagination;

import java.util.List;
import java.util.Map;

/**
 * Created by cj on 2015/7/30.
 */
public interface CmsRecommendService {

    int addCmsRecommend(CmsRecommend record);

    int deleteCmsRecommendById(String recommendId);

    int editCmsRecommend(CmsRecommend record);

    CmsRecommend queryCmsRecommendById(String recommendId);

    List<CmsRecommend> queryCmsRecommendList(Map<String,Object> map);

    int queryCmsRecommendCount(Map<String,Object> map);

    List<CmsRecommend> queryCmsRecommendIndex(CmsRecommend cmsRecommend,Pagination page);

    List<AreaData> queryVenueAllArea();

    List<CmsRecommend> queryCmsRecommend(CmsRecommend record);
}
