package com.sun3d.why.dao;

import com.sun3d.why.model.CmsRecommend;

import java.util.List;
import java.util.Map;

public interface CmsRecommendMapper {

    int addCmsRecommend(CmsRecommend record);

    int deleteCmsRecommendById(String recommendId);

    int editCmsRecommend(CmsRecommend record);

    CmsRecommend queryCmsRecommendById(String recommendId);

    List<CmsRecommend> queryCmsRecommendList(Map<String,Object> map);

    int queryCmsRecommendCount(Map<String,Object> map);

    List<CmsRecommend> queryVenueAllArea(Map<String,Object> map);

    List<CmsRecommend> queryCmsRecommend(CmsRecommend record);
}