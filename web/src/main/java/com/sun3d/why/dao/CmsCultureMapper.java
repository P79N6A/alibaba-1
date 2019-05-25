package com.sun3d.why.dao;

import com.sun3d.why.model.CmsCulture;

import java.util.List;
import java.util.Map;


public interface CmsCultureMapper {


    CmsCulture queryById(String cultureId);

    int addCmsCulture(CmsCulture cmsCulture);

    int updateCmsCulture(CmsCulture cmsCulture);

    List<CmsCulture> queryByConditions(Map<String,Object> params);

    int queryCount(Map<String,Object> params);


    List<CmsCulture> queryArea(Map<String,Object> params);

    int delete(String id);


    CmsCulture queryAppById(String cultureId);

    /**
     * app根据条件筛选非遗
     * @param map
     * @return
     */
    List<CmsCulture> queryAppCultureIndex(Map<String, Object> map);

    /**
     * app根据条件筛选获取条数
     * @param map
     * @return
     */
    int queryAppCultureCount(Map<String, Object> map);

    List<CmsCulture> queryFrontList(Map<String, Object> map);

    List<CmsCulture> queryRecommendCulture(Map<String, Object> map);
}