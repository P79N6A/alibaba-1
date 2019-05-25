package com.sun3d.why.service.impl;


import com.sun3d.why.dao.CmsAndroidVersionMapper;
import com.sun3d.why.model.CmsAndroidVersion;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.service.CmsAndroidVersionService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.JSONResponse;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.UUIDUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;

@Service
@Transactional
public class CmsAndroidVersionServiceImpl implements CmsAndroidVersionService{
    @Autowired
    private StaticServer staticServer;
    @Autowired
    private CmsAndroidVersionMapper cmsAndroidVersionMapper;

    @Override
    public int deleteCmsAndroidByVid(String vId) {
        return cmsAndroidVersionMapper.deleteCmsAndroidByVid(vId);
    }

    @Override
    public int addCmsAndroidVersion(CmsAndroidVersion record) {
        return cmsAndroidVersionMapper.addCmsAndroidVersion(record);
    }

    @Override
    public CmsAndroidVersion queryCmsAndroidVersionByVid(String vId) {
        return cmsAndroidVersionMapper.queryCmsAndroidVersionByVid(vId);
    }

    @Override
    public int updateByCmsAndroidVersion(CmsAndroidVersion record) {
        return cmsAndroidVersionMapper.updateByCmsAndroidVersion(record);
    }

    @Override
    public List<CmsAndroidVersion> queryPageList(CmsAndroidVersion record, Pagination page) {
        Map<String, Object> map = new HashMap<String, Object>();
        if (record.getBuildVnumber() != null) {
            map.put("buildVnumber", record.getBuildVnumber());
        }
        if (record.getExternalVnumber() != null && StringUtils.isNotBlank(record.getExternalVnumber())) {
            map.put("externalVnumber", record.getExternalVnumber());
        }
        if (page != null) {
            map.put("firstResult",page.getFirstResult());
            map.put("rows",page.getRows());
        }
        return cmsAndroidVersionMapper.queryCmsAndroidVersionByMap(map);
    }

    @Override
    public int  queryPageCount(CmsAndroidVersion record) {
        Map<String, Object> map = new HashMap<String, Object>();
        if (record.getBuildVnumber() != null) {
            map.put("buildVnumber", record.getBuildVnumber());
        }
        if (record.getExternalVnumber() != null && StringUtils.isNotBlank(record.getExternalVnumber())) {
            map.put("externalVnumber", record.getExternalVnumber());
        }
        return cmsAndroidVersionMapper.queryCmsAndroidVersionCountByMap(map);
    }

    @Override
    public String  addAndroidVersion(CmsAndroidVersion record, SysUser loginUser) {
        //判断内部版本号  内部版本号不能为空 且不重复
        CmsAndroidVersion version = new CmsAndroidVersion();
        version.setBuildVnumber(record.getBuildVnumber());
        int rsCount = queryPageCount(version);
        if (rsCount > 0) {
            return Constant.RESULT_STR_REPEAT;
        }
        record.setvId(UUIDUtils.createUUId());
        record.setVersionCreateTime(new Date());
        record.setVersionUpdateTime(new Date());
        record.setVersionUpdateUser(loginUser.getUserId());
        record.setVersionCreateUser(loginUser.getUserId());
        int count = addCmsAndroidVersion(record);
        if (count > 0) {
            return "success";
        } else {
            return "error";
        }
    }

    public String editAndroidVersion(CmsAndroidVersion record,SysUser loginUser){
        if(record.getBuildVnumber() - record.getOldBuildVnumber() != 0){
            CmsAndroidVersion version = new CmsAndroidVersion();
            version.setBuildVnumber(record.getBuildVnumber());
            int rsCount = queryPageCount(version);
            if (rsCount > 0) {
                return Constant.RESULT_STR_REPEAT;
            }
        }
        record.setVersionUpdateTime(new Date());
        record.setVersionUpdateUser(loginUser.getUserId());
        int count = cmsAndroidVersionMapper.updateByCmsAndroidVersion(record);
        if (count > 0) {
            return Constant.RESULT_STR_SUCCESS;
        } else {
            return  Constant.RESULT_STR_FAILURE;
        }
    }
    /**
     * app版本更新
     * @return json
     */
    @Override
    public String queryAppAndroidVersionList() {
        List<Map<String, Object>> mapList = new ArrayList<Map<String, Object>>();
        CmsAndroidVersion cmsAndroidVersion=cmsAndroidVersionMapper.queryAppAndroidVersionList();
        if (cmsAndroidVersion!=null) {
            Map<String, Object> map = new HashMap<String, Object>();
            map.put("buildNumber", cmsAndroidVersion.getBuildVnumber() != null ? cmsAndroidVersion.getBuildVnumber() : "");
            map.put("externalVnumber", cmsAndroidVersion.getExternalVnumber() != null ? cmsAndroidVersion.getExternalVnumber() : "");
            map.put("updateDescr", cmsAndroidVersion.getUpdateDescr() != null ? cmsAndroidVersion.getUpdateDescr() : "");
            String updateUrl = "";
            if (org.apache.commons.lang3.StringUtils.isNotBlank(cmsAndroidVersion.getUpdateUrl())) {
                updateUrl = staticServer.getStaticServerUrl() + cmsAndroidVersion.getUpdateUrl();
            }
            map.put("updateUrl", updateUrl);
            long versionUpdateTime = cmsAndroidVersion.getVersionUpdateTime().getTime();
            map.put("versionUpdateTime", versionUpdateTime / 1000);
            long versionCreateTime = cmsAndroidVersion.getVersionCreateTime().getTime();
            map.put("versionCreateTime", versionCreateTime / 1000);
            map.put("versionCreateUser", cmsAndroidVersion.getVersionCreateUser() != null ? cmsAndroidVersion.getVersionCreateUser() : "");
            map.put("versionUpdateUser", cmsAndroidVersion.getVersionUpdateUser() != null ? cmsAndroidVersion.getVersionUpdateUser() : "");
            if(StringUtils.isNotBlank(cmsAndroidVersion.getVersionUpdateStatus())&& cmsAndroidVersion.getVersionUpdateStatus().equals("Y")){
                map.put("versionUpdateStatus",1);
            }else {
                map.put("versionUpdateStatus",0);
            }
            mapList.add(map);
        }
        return JSONResponse.toAppResultFormat(0,mapList);
    }
}