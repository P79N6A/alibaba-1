package com.sun3d.why.service.impl;

import com.sun3d.why.dao.CmsAntiqueTypeMapper;
import com.sun3d.why.model.CmsAntiqueType;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.service.CmsAntiqueTypeService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.Pagination;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by Administrator on 2015/7/18.
 */
@Service
@Transactional
public class CmsAntiqueTypeServiceImpl implements CmsAntiqueTypeService {

    @Autowired
    private CmsAntiqueTypeMapper cmsAntiqueTypeMapper;

    @Override
    public int deleteByPrimaryKey(String antiqueTypeId) {
        return 0;
    }

    @Override
    public int insert(CmsAntiqueType record) {
        return 0;
    }

    @Override
    public int addAntiqueType(CmsAntiqueType record) {
        return cmsAntiqueTypeMapper.addAntiqueType(record);
    }

    @Override
    public CmsAntiqueType queryById(String antiqueTypeId) {
        return cmsAntiqueTypeMapper.queryById(antiqueTypeId);
    }

    @Override
    public int updateById(CmsAntiqueType record) {
        return cmsAntiqueTypeMapper.updateById(record);
    }

    @Override
    public int queryCount(Map<String, Object> params) {
        return cmsAntiqueTypeMapper.queryCount(params);
    }

    @Override
    public List<CmsAntiqueType> queryByVenueId(CmsAntiqueType cmsAntiqueType,SysUser user) {
        Map<String,Object> params = new HashMap<String, Object>();

        /**
         * 权限处理
         */
        String userDeptPath = user.getUserDeptPath();
        if(userDeptPath != null){
            params.put("venueDept", "%" + userDeptPath + "%");
        }

        if(StringUtils.isNotBlank(cmsAntiqueType.getVenueId())){
            params.put("venueId",cmsAntiqueType.getVenueId());
        }
        return cmsAntiqueTypeMapper.queryByVenueId(params);
    }

    @Override
    public List<CmsAntiqueType> queryByConditions(CmsAntiqueType cmsAntiqueType,Pagination page,SysUser user) {
        Map<String,Object> params = new HashMap<String, Object>();
        /**
         * 权限处理
         */
        String userDeptPath = user.getUserDeptPath();
        if(userDeptPath != null){
            params.put("venueDept", "%" + userDeptPath + "%");
        }
        if(StringUtils.isNotBlank(cmsAntiqueType.getVenueId())){
            params.put("venueId",cmsAntiqueType.getVenueId());
        }
        if(StringUtils.isNotBlank(cmsAntiqueType.getAntiqueTypeName())){
            params.put("antiqueTypeName","%"+cmsAntiqueType.getAntiqueTypeName()+"%");
        }
        //分页
        if (page != null && page.getFirstResult() != null && page.getRows() != null) {
            params.put("firstResult", page.getFirstResult());
            params.put("rows", page.getRows());
            int total = cmsAntiqueTypeMapper.queryCount(params);
            page.setTotal(total);
        }
        return cmsAntiqueTypeMapper.queryByConditions(params);
    }

    @Override
    public Integer addBatch(List<CmsAntiqueType> typeList) {
        return cmsAntiqueTypeMapper.addBatch(typeList);
    }



    @Override
    public List<CmsAntiqueType> queryAppAntiqueType(String venueId) {
        Map<String,Object> map=new HashMap<String, Object>();
        if(StringUtils.isNotBlank(venueId) ){
            map.put("venueId",venueId);
        }
        map.put("antiqueTypeState", Constant.NORMAL);
        return cmsAntiqueTypeMapper.queryAppAntiqueType(map);
    }


}
