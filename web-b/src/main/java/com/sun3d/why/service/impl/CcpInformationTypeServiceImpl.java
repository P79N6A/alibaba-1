

package com.sun3d.why.service.impl;

import com.culturecloud.model.bean.common.CcpInformationType;
import com.sun3d.why.dao.CcpInformationTypeMapper;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.service.CcpInformationTypeService;
import com.sun3d.why.util.Pagination;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Transactional
@Service
public class CcpInformationTypeServiceImpl implements CcpInformationTypeService{
	
	@Autowired
	private CcpInformationTypeMapper ccpInformationTypeMapper;

	@Override
	public List<CcpInformationType> queryInformationTypeByCondition(SysUser sysUser, CcpInformationType informationType,
                                                                    Pagination page) {
		Map<String, Object> map = new HashMap<>();
		// 资讯模块ID
		if(StringUtils.isNotBlank(informationType.getInformationModuleId())){
			map.put("informationModuleId", informationType.getInformationModuleId());
		}

		if(page!=null){
			map.put("firstResult", page.getFirstResult());
			map.put("rows", page.getRows());
			int total =ccpInformationTypeMapper.queryInformationTypeByConditionCount(map);

			// 设置分页的总条数来获取总页数
			page.setTotal(total);
			page.setRows(page.getRows());
		}
		List<CcpInformationType>  list=	ccpInformationTypeMapper.queryInformationTypeByCondition(map);
		
		return list;
	}

	@Override
	public CcpInformationType queryInformationTypeById(String informationTypeId) {
		return ccpInformationTypeMapper.selectByPrimaryKey(informationTypeId);
	}

	@Override
	public int createInformationType(CcpInformationType informationType) {
		return ccpInformationTypeMapper.insert(informationType);
	}

	@Override
	public int updateInformationType(CcpInformationType informationType) {
		return ccpInformationTypeMapper.updateByPrimaryKeySelective(informationType);
	}

	@Override
	public int delInformationType(String informationTypeId) {
		return ccpInformationTypeMapper.deleteByPrimaryKey(informationTypeId);
	}

	@Override
	public int queryTypeUseCount(String informationTypeId) {
		return ccpInformationTypeMapper.queryTypeUseCount(informationTypeId);
	}

	@Override
	public List<CcpInformationType> queryAllInformationType(SysUser sysUser, String informationModuleId) {
	
		Map<String, Object> map = new HashMap<>();
		if(StringUtils.isNotBlank(informationModuleId)){
			map.put("informationModuleId", informationModuleId);
		}
		return ccpInformationTypeMapper.queryInformationTypeByCondition(map);
	}

	@Override
	public List<CcpInformationType> queryInformationTypeInParentShop(SysUser sysUser, String informationModuleId) {
		Map<String, Object> map = new HashMap<>();
		if(StringUtils.isNotBlank(informationModuleId)){
			map.put("informationModuleId", informationModuleId);
		}
		
		//查询由这些用户创建的所有类型
		List<CcpInformationType> typeList = ccpInformationTypeMapper.queryInformationTypeByCondition(map);
		return typeList;		
	}

}
