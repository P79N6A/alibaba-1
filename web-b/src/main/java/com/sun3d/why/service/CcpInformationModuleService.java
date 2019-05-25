package com.sun3d.why.service;

import com.culturecloud.model.bean.common.CcpInformationModule;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.util.Pagination;

import java.util.List;

public interface CcpInformationModuleService {

	 /**
     * 根据活动对象查询活动列表信息
     * @param information 活动对象
     * @param page     分页对象
     * @param sysUser  用户对象
     * @return 活动列表信息
     */
    List<CcpInformationModule> queryInformationModuleList(CcpInformationModule ccpInformationModule, Pagination page);
    
    int saveOrUpdateInformationModule(SysUser sysUser, CcpInformationModule ccpInformationModule);
    
}
