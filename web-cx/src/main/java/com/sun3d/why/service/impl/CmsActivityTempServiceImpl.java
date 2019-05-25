package com.sun3d.why.service.impl;

import com.sun3d.why.dao.CmsActivityTempMapper;
import com.sun3d.why.model.temp.CmsActivityTemp;
import com.sun3d.why.service.CmsActivityTempService;
import com.sun3d.why.util.Pagination;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by Administrator on 2015/7/27.
 */
@Transactional
@Service
public class CmsActivityTempServiceImpl implements CmsActivityTempService {

    @Autowired
    private CmsActivityTempMapper cmsActivityTempMapper;

    @Override
    public int countByCondition(Map<String, Object> params) {
        return cmsActivityTempMapper.countByCondition(params);
    }

    @Override
    public List<CmsActivityTemp> queryByCondition(Pagination page,String areaCode) {

        Map<String,Object> params = new HashMap<String, Object>();

        if(StringUtils.isNotBlank(areaCode)){
            params.put("areaCode",areaCode);
        }
        //分页
        if (page != null && page.getFirstResult() != null && page.getRows() != null) {
            params.put("firstResult", page.getFirstResult());
            params.put("rows", page.getRows());
            int total = cmsActivityTempMapper.countByCondition(params);
            page.setTotal(total);
        }
        return cmsActivityTempMapper.queryByCondition(params);
    }
}
