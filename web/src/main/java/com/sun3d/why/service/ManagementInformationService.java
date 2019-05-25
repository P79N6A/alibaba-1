package com.sun3d.why.service;

import com.sun3d.why.model.ManagementInformation;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.util.Pagination;

import java.util.List;

public interface ManagementInformationService {

    /**
     * 根据活动对象查询活动列表信息
     *
     * @param information 活动对象
     * @param page     分页对象
     * @param sysUser  用户对象
     * @return 活动列表信息
     */
    List<ManagementInformation> informationList(ManagementInformation information, Pagination page, SysUser sysUser);

    /**
     * 根据活动对象查询活动列表信息
     *
     * @param information 活动对象
     * @return 活动列表信息
     */
    String addInformation(ManagementInformation information, SysUser sysUser);
    /**
     * 根据活动对象查询活动列表信息
     *
     * @return 活动列表信息
     */
    ManagementInformation getInformation(String informationId);

    ManagementInformation getInformationSQL(String informationId);
}
