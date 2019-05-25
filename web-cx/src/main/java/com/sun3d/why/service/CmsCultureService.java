package com.sun3d.why.service;

import com.sun3d.why.model.CmsCulture;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.PaginationApp;

import java.util.List;
import java.util.Map;

/**
 * Created by Administrator on 2015/8/15.
 */
public interface CmsCultureService {

    CmsCulture queryById(String cultureId);

    int addCmsCulture(CmsCulture cmsCulture);

    int updateCmsCulture(CmsCulture cmsCulture);


    List<CmsCulture> queryByConditions(CmsCulture culture, Pagination page, SysUser user, String areaData, PaginationApp pageApp);

    int queryCount(Map<String,Object> params);


    List<CmsCulture> queryArea(Map<String,Object> params);
    int delete(String id);

    /**
     * app获取非遗详情
     * @param cultureId
     * @return
     */
    CmsCulture queryAppById(String cultureId);

    /**
     * app根据条件筛选非遗
     * @param culture
     * @param appType
     * @param pageApp
     * @return
     */
    List<CmsCulture> queryAppCultureIndex(CmsCulture culture, String appType, PaginationApp pageApp);

    List<CmsCulture> queryForFront(CmsCulture culture, Pagination page);

    /**
     * 前端2.0查询非遗详情中的推荐非遗
     * @param culture
     * @param page
     * @return
     */
    List<CmsCulture> queryRecommendCulture(CmsCulture culture, Pagination page);
}
