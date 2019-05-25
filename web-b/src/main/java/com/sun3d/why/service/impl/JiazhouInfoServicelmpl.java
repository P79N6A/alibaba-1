package com.sun3d.why.service.impl;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.sun3d.why.dao.CmsTagMapper;
import com.sun3d.why.dao.CcpJiazhouInfoMapper;
import com.sun3d.why.model.CmsTag;
import com.sun3d.why.model.CcpJiazhouInfo;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.service.CcpJiazhouInfoService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.UUIDUtils;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;



@Transactional
@Service
public class JiazhouInfoServicelmpl implements CcpJiazhouInfoService {
    @Autowired
    private CcpJiazhouInfoMapper jiazhouInfoMapper;
    @Autowired
    private CmsTagMapper cmsTagMapper;
    
	@Override
	public List<CcpJiazhouInfo> jiazhouInfoList(CcpJiazhouInfo jiazhouInfo,
			Pagination page, SysUser sysUser) {
        Map<String, Object> map = new HashMap<String, Object>();
        if (jiazhouInfo != null && StringUtils.isNotBlank(jiazhouInfo.getJiazhouInfoTitle())) {
            map.put("jiazhouInfoTitle", "%" + jiazhouInfo.getJiazhouInfoTitle() + "%");
        }
        //分页
        if (page != null && page.getFirstResult() != null && page.getRows() != null) {
            map.put("firstResult", page.getFirstResult());
            map.put("rows", page.getRows());
            int total = jiazhouInfoMapper.jiazhouInfoListCount(map);
            page.setTotal(total);
        }

        return jiazhouInfoMapper.jiazhouInfoList(map);
	}

	@Override
	public String addJiazhouInfo(CcpJiazhouInfo jiazhouInfo, SysUser sysUser) {
	        int count;	
	        jiazhouInfo.setJiazhouInfoUpdateTime(new Date());
	        jiazhouInfo.setJiazhouInfoUpdateUser(sysUser.getUserId());
	        if (StringUtils.isBlank(jiazhouInfo.getJiazhouInfoId())) {
	        	jiazhouInfo.setJiazhouInfoId(UUIDUtils.createUUId());
	        	jiazhouInfo.setBrowseCount(0);
	        	jiazhouInfo.setJiazhouInfoCreateTime(new Date());
	        	jiazhouInfo.setJiazhouInfoCreateUser(sysUser.getUserId());
	            count = jiazhouInfoMapper.insertJiazhouInfo(jiazhouInfo);
	        } else {
	            count = jiazhouInfoMapper.updateJiazhouInfo(jiazhouInfo);
	        }	        
	        if (count > 0) {
	            return Constant.RESULT_STR_SUCCESS;
	        } else {
	            return Constant.RESULT_STR_FAILURE;
	        }
	}

	@Override
	public CcpJiazhouInfo getJiazhouInfo(String jiazhouInfoId) {
	    	CcpJiazhouInfo info = new CcpJiazhouInfo();
		 if (jiazhouInfoId !=null && StringUtils.isNotBlank(jiazhouInfoId)) {
			   info = jiazhouInfoMapper.selectByJiazhouInfoId(jiazhouInfoId);		   	        
	        }  
		     return info;
	}

	@Override
	public List<Map<String, Object>> getJiazhouInfoSortList(String dictCode) {
        List<Map<String, Object>> mapThemeList = new ArrayList<Map<String, Object>>();
        //分类集合
        if (dictCode != null && StringUtils.isNotBlank(dictCode)) {
            Map<String, Object> map = new HashMap<String, Object>();
            map.put("dictState", Constant.NORMAL);
            map.put("dictCode", dictCode);
            List<CmsTag> listTheme = cmsTagMapper.querySortByCondition(map);
            if (CollectionUtils.isNotEmpty(listTheme)) {
                for (CmsTag tagList : listTheme) {
                    if (tagList != null) {
                        Map<String, Object> mapTheme = new HashMap<String, Object>();
                        mapTheme.put("dictId", tagList.getTagId() != null ? tagList.getTagId() : "");
                        mapTheme.put("dictName", tagList.getTagName() != null ? tagList.getTagName() : "");
                        mapThemeList.add(mapTheme);
                    }
                }
            }
        }
        return mapThemeList;
	}

	@Override
	public void delJiazhouInfo(String jiazhouInfoId) {
		 if (jiazhouInfoId !=null && StringUtils.isNotBlank(jiazhouInfoId)) {
			 jiazhouInfoMapper.delJiazhouInfo(jiazhouInfoId);		   	        
	        }  		
	}

}
