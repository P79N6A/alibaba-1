package com.sun3d.why.service.impl;

import com.sun3d.why.dao.CmsSpecialMapper;
import com.sun3d.why.model.CmsActivity;
import com.sun3d.why.service.CmsSpecialService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;


@Transactional(rollbackFor = Exception.class)
@Service
public class CmsSpecialServiceImpl implements CmsSpecialService {


    @Autowired
    private CmsSpecialMapper cmsSpecialMapper;

    /**
     * 主题页面
     *
     * @param activity 活动对象
     * @return 列表信息
     */
    @Override
    public List<CmsActivity> querySpecialOneList(CmsActivity activity) {
        Map<String, Object> map = new HashMap<String, Object>();
        return cmsSpecialMapper.querySpecialOneList(map);
    }

    /**
     * 主题页面
     *
     * @param activity 活动对象
     * @return 列表信息
     */
    @Override
    public List<CmsActivity> querySpecialTwoList(CmsActivity activity) {
        Map<String, Object> map = new HashMap<String, Object>();
        return cmsSpecialMapper.querySpecialTwoList(map);
    }
}
