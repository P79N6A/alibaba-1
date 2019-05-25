package com.sun3d.why.dao;


import com.sun3d.why.model.CmsAndroidVersion;

import java.util.List;
import java.util.Map;

public interface CmsAndroidVersionMapper {

    /**
     * 根据版本Id删除信息
     * @param vId
     * @return 1 成功  0 失败
     */
    int deleteCmsAndroidByVid(String vId);

    /**
     * 插入信息
     * @param record
     * @return 1 成功  0 失败
     */
    int addCmsAndroidVersion(CmsAndroidVersion record);

    /**
     * 根据Id 查询信息
     * @param vId
     * @return 对象
     */
    CmsAndroidVersion queryCmsAndroidVersionByVid(String vId);

    /**
     * 根据Id 更新对象信息
     * @param record
     * @return 1 成功  0 失败
     */
    int updateByCmsAndroidVersion(CmsAndroidVersion record);

    List<CmsAndroidVersion> queryCmsAndroidVersionByMap(Map<String, Object> map);

    Integer queryCmsAndroidVersionCountByMap(Map<String, Object> map);

    /**
     * app获取最新版本
     * @return
     */
    CmsAndroidVersion queryAppAndroidVersionList();
}