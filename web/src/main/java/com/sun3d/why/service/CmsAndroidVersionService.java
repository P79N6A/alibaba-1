package com.sun3d.why.service;


import com.sun3d.why.model.CmsAndroidVersion;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.util.Pagination;

import java.util.List;

public interface CmsAndroidVersionService {

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

    List<CmsAndroidVersion> queryPageList(CmsAndroidVersion record, Pagination page);

    String  addAndroidVersion(CmsAndroidVersion record,SysUser loginUser);

    public int  queryPageCount(CmsAndroidVersion record);

    public String editAndroidVersion(CmsAndroidVersion record,SysUser loginUser);

    /**
     * app返回最新安卓版本
     * @return
     */
    String  queryAppAndroidVersionList();
}