package com.sun3d.why.service.impl;

import com.sun3d.why.dao.CmsRecommendMapper;
import com.sun3d.why.model.CmsRecommend;
import com.sun3d.why.model.extmodel.AreaData;
import com.sun3d.why.service.CmsRecommendService;
import com.sun3d.why.util.Pagination;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by cj on 2015/7/30.
 */
@Service
@Transactional
public class CmsRecommendServiceImpl implements CmsRecommendService {

    @Autowired
    private CmsRecommendMapper cmsRecommendMapper;

    @Autowired
    private HttpSession session;

    @Override
    public int addCmsRecommend(CmsRecommend record) {

        return cmsRecommendMapper.addCmsRecommend(record);
    }

    @Override
    public int deleteCmsRecommendById(String recommendId) {

        return cmsRecommendMapper.deleteCmsRecommendById(recommendId);
    }

    @Override
    public int editCmsRecommend(CmsRecommend record) {

        return cmsRecommendMapper.editCmsRecommend(record);
    }

    @Override
    public CmsRecommend queryCmsRecommendById(String recommendId) {

        return cmsRecommendMapper.queryCmsRecommendById(recommendId);
    }

    @Override
    public List<CmsRecommend> queryCmsRecommendList(Map<String,Object> map) {

        return cmsRecommendMapper.queryCmsRecommendList(map);
    }

    @Override
    public int queryCmsRecommendCount(Map<String,Object> map) {

        return cmsRecommendMapper.queryCmsRecommendCount(map);
    }

    @Override
    public List<CmsRecommend> queryCmsRecommendIndex(CmsRecommend cmsRecommend, Pagination page) {
        Map<String,Object> map = new HashMap<String, Object>();
        if(StringUtils.isNotBlank(cmsRecommend.getContentName())){
            map.put("contentName","%"+cmsRecommend.getContentName()+"%");
        }
        map.put("firstResult", page.getFirstResult());
        map.put("rows", page.getRows());
        int total = cmsRecommendMapper.queryCmsRecommendCount(map);
        page.setTotal(total);
        return cmsRecommendMapper.queryCmsRecommendList(map);
    }

    @Override
    public List<AreaData> queryVenueAllArea() {
        Map map = new HashMap();
        List<CmsRecommend> recommendList = cmsRecommendMapper.queryVenueAllArea(map);
        if (CollectionUtils.isEmpty(recommendList)) {
            return null;
        }
        List<AreaData> dataList = new ArrayList<AreaData>();
        for (CmsRecommend cmsRecommend : recommendList) {
            String area = cmsRecommend.getArea();
            if (StringUtils.isNotBlank(area)) {
                String[] areas = area.split(",");
                AreaData data = new AreaData();
                if (areas.length > 1 && areas[0] != null && areas[1] != null) {
                    data.setId(areas[0]);
                    data.setText(areas[1]);
                    dataList.add(data);
                }
            }
        }
        return dataList;
    }

    @Override
    public List<CmsRecommend> queryCmsRecommend(CmsRecommend record) {

        return cmsRecommendMapper.queryCmsRecommend(record);
    }
}
