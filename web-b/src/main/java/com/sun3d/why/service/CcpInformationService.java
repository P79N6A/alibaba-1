package com.sun3d.why.service;

import com.culturecloud.model.bean.common.CcpInformation;
import com.sun3d.why.dao.dto.CcpInformationDto;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.util.Pagination;

import java.util.List;

public interface CcpInformationService {

	 /**
     * 根据活动对象查询活动列表信息
     *
     * @param information 活动对象
     * @param page     分页对象
     * @param sysUser  用户对象
     * @return 活动列表信息
     */
    List<CcpInformationDto> informationList(CcpInformation information, Pagination page, SysUser sysUser);

    /**
     * 根据活动对象查询活动列表信息
     *
     * @param information 活动对象
     * @return 活动列表信息
     */
    int addInformation(CcpInformation information);
    
    /**
     * 根据活动对象查询活动列表信息
     *
     * @param information 活动对象
     * @return 活动列表信息
     */
    int updateInformation(CcpInformation information);
    
    /**
     * 根据活动对象查询活动列表信息
     *
     * @return 活动列表信息
     */
    CcpInformation getInformation(String informationId);

}
