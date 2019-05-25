package com.sun3d.why.service;

import com.culturecloud.model.bean.common.CcpInformationType;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.util.Pagination;

import java.util.List;

public interface CcpInformationTypeService {

	
	List<CcpInformationType>queryInformationTypeByCondition(SysUser sysUser, CcpInformationType informationType, Pagination page);
	
	CcpInformationType queryInformationTypeById(String informationTypeId);
	
	int createInformationType(CcpInformationType informationType);
	
	int updateInformationType(CcpInformationType informationType);
	
	int delInformationType(String informationTypeId);
	
	/**
	 * 查询使用数
	 * @param informationTypeId
	 * @return
	 */
	int queryTypeUseCount(String informationTypeId);
	
	/**
	 * 根据模板店铺以及子店铺的所有可用分类
	 * @return
	 */
	List<CcpInformationType> queryAllInformationType(SysUser sysUser, String informationModuleId);
	
	/**
	 * 查询父级店铺中的类型
	 */
	List<CcpInformationType> queryInformationTypeInParentShop(SysUser sysUser, String informationModuleId);
	
}
