package com.sun3d.why.service.impl;

import com.sun3d.why.dao.CmsCultureMapper;
import com.sun3d.why.model.CmsCulture;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.service.CmsCultureService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.PaginationApp;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by Administrator on 2015/8/15.
 */
@Transactional
@Service
public class CmsCultureServiceImpl implements CmsCultureService {

    @Autowired
    private CmsCultureMapper cmsCultureMapper;

    @Override
    public CmsCulture queryById(String cultureId) {
        return cmsCultureMapper.queryById(cultureId);
    }

    @Override
    public int addCmsCulture(CmsCulture cmsCulture) {
        return cmsCultureMapper.addCmsCulture(cmsCulture);
    }

    @Override
    public int updateCmsCulture(CmsCulture cmsCulture) {
        return cmsCultureMapper.updateCmsCulture(cmsCulture);
    }



    @Override
    public List<CmsCulture> queryByConditions(CmsCulture culture, Pagination page, SysUser user, String areaData, PaginationApp pageApp) {
        Map<String,Object> params = new HashMap<String, Object>();
        params.put("culState",culture.getCultureState());

        if(StringUtils.isNotBlank(areaData)){
            params.put("areaData", "%" + areaData + "%");
        }

        if(StringUtils.isNotBlank(culture.getCultureName())){
            params.put("culName","%"+culture.getCultureName()+"%");
        }

        if(StringUtils.isNotBlank(culture.getCultureType())){
            params.put("culType",culture.getCultureType());
        }

        if(StringUtils.isNotBlank(culture.getCultureSystem())){
            params.put("culSystem",culture.getCultureSystem());
        }

        //网页分页
        if (page != null && page.getFirstResult() != null && page.getRows() != null) {
            int total = cmsCultureMapper.queryCount(params);
            params.put("firstResult", page.getFirstResult());
            params.put("rows", page.getRows());
            page.setTotal(total);
        }
        //app分页
        if (pageApp != null && pageApp.getFirstResult() != null && pageApp.getRows() != null) {
            params.put("firstResult", pageApp.getFirstResult());
            params.put("rows", pageApp.getRows());
        }
        return cmsCultureMapper.queryByConditions(params);
    }

    @Override
    public int queryCount(Map<String, Object> params) {
        return cmsCultureMapper.queryCount(params);
    }


    @Override
    public List<CmsCulture> queryArea(Map<String, Object> params) {
        return cmsCultureMapper.queryArea(params);
    }

    @Override
    public int delete(String id) {
        return cmsCultureMapper.delete(id);
    }


    /**
     * app获取非遗详情
     * @param cultureId
     * @return
     */
    @Override
    public CmsCulture queryAppById(String cultureId) {
        return cmsCultureMapper.queryAppById(cultureId);
    }

    /**
     * app根据条件筛选非遗
     * @param culture
     * @param appType
     * @param pageApp
     * @return
     */
    @Override
    public List<CmsCulture> queryAppCultureIndex(CmsCulture culture, String appType, PaginationApp pageApp) {
        Map<String,Object> map = new HashMap<String, Object>();
        map.put("cultureState", Constant.NORMAL);
        map.put("appType",appType);
        if(culture!=null && StringUtils.isNotBlank(culture.getCultureArea())){
            map.put("areaArea", "%" + culture.getCultureArea() + "%");
        }
        if(culture!=null && StringUtils.isNotBlank(culture.getCultureName())){
            map.put("cultureName","%"+culture.getCultureName()+"%");
        }
        if(culture!=null && StringUtils.isNotBlank(culture.getCultureType())){
            map.put("cultureType",culture.getCultureType());
        }
        if(culture!=null && StringUtils.isNotBlank(culture.getCultureSystem())){
            map.put("culSystem",culture.getCultureSystem());
        }
        //app分页
        if (pageApp != null && pageApp.getFirstResult() != null && pageApp.getRows() != null) {
            map.put("firstResult", pageApp.getFirstResult());
            map.put("rows", pageApp.getRows());
            int total=cmsCultureMapper.queryAppCultureCount(map);
            pageApp.setTotal(total);
        }
        return cmsCultureMapper.queryAppCultureIndex(map);
    }

    @Override
    public List<CmsCulture> queryForFront(CmsCulture culture, Pagination page) {

        Map<String,Object> params = new HashMap<String, Object>();

        params.put("culState",1);

        if(StringUtils.isNotBlank(culture.getCultureName())){
            params.put("culName","%"+culture.getCultureName()+"%");
        }

        if(StringUtils.isNotBlank(culture.getCultureType())){
            params.put("culType",culture.getCultureType());
        }

        if(StringUtils.isNotBlank(culture.getCultureSystem())){
            params.put("culSystem",culture.getCultureSystem());
        }

        if(StringUtils.isNotBlank(culture.getCultureYears())){
            params.put("culYear",culture.getCultureYears());
        }

        if (page != null && page.getFirstResult() != null && page.getRows() != null) {
            int total = cmsCultureMapper.queryCount(params);
            params.put("firstResult", page.getFirstResult());
            params.put("rows", page.getRows());
            page.setTotal(total);
        }


        return cmsCultureMapper.queryFrontList(params);
    }

    /**
     * 前端2.0查询非遗详情中的推荐非遗
     * @param culture
     * @param page
     * @return
     */
    @Override
    public List<CmsCulture> queryRecommendCulture(CmsCulture culture, Pagination page){
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("cultureState", Constant.NORMAL);
        if(StringUtils.isNotBlank(culture.getCultureId())){
            map.put("cultureId", culture.getCultureId());
        }
        if(StringUtils.isNotBlank(culture.getCultureType())){
            map.put("cultureType", culture.getCultureType());
        }
        if(StringUtils.isNotBlank(culture.getCultureArea())){
            map.put("cultureArea", culture.getCultureArea());
        }
        if (page != null && page.getFirstResult() != null && page.getRows() != null) {
            map.put("firstResult", page.getFirstResult());
            map.put("rows", page.getRows());
        }
        List<CmsCulture> list = cmsCultureMapper.queryRecommendCulture(map);
        if(CollectionUtils.isEmpty(list)){
            map.remove("cultureType");
            list = cmsCultureMapper.queryRecommendCulture(map);
            if(CollectionUtils.isEmpty(list)){
                map.put("cultureType", culture.getCultureType());
                map.remove("cultureArea");
                list = cmsCultureMapper.queryRecommendCulture(map);
                if(CollectionUtils.isEmpty(list)){
                    map.remove("cultureType");
                    list = cmsCultureMapper.queryRecommendCulture(map);
                }
            }
        }
        return list;
    }
}
