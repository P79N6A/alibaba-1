package com.sun3d.why.service.impl;

import com.culturecloud.model.bean.common.CcpInformationModule;
import com.sun3d.why.dao.CcpInformationModuleMapper;
import com.sun3d.why.dao.SysModuleMapper;
import com.sun3d.why.dao.SysRoleModuleMapper;
import com.sun3d.why.model.SysModule;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.service.CcpInformationModuleService;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.UUIDUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@Transactional
public class CcpInformationModuleServiceImpl implements CcpInformationModuleService {
	
	@Autowired
	private CcpInformationModuleMapper ccpInformationModuleMapper;
	@Autowired
	private SysModuleMapper sysModuleMapper;
	@Autowired
	private SysRoleModuleMapper sysRoleModuleMapper;
	@Autowired
	private StaticServer staticServer;

	@Override
	public List<CcpInformationModule> queryInformationModuleList(CcpInformationModule ccpInformationModule, Pagination page) {
		Map<String, Object> map = new HashMap<String, Object>();
		if(StringUtils.isNotBlank(ccpInformationModule.getInformationModuleName())){
			map.put("informationModuleName", ccpInformationModule.getInformationModuleName());
		}
		if(page!=null){
			map.put("firstResult", page.getFirstResult());
			map.put("rows", page.getRows());
			int total = ccpInformationModuleMapper.queryInformationModuleByConditionCount(map);
			// 设置分页的总条数来获取总页数
			page.setTotal(total);
			page.setRows(page.getRows());
		}
		List<CcpInformationModule> list = ccpInformationModuleMapper.queryInformationModuleByCondition(map);
		return list;
	}

	@Override
	public int saveOrUpdateInformationModule(SysUser sysUser, CcpInformationModule ccpInformationModule) {
		int result = 0;
		SysModule sysModuleInformation = sysModuleMapper.queryParentModuleByUrl("${path}/ccpInformation/index.do");
		if(StringUtils.isNotBlank(ccpInformationModule.getInformationModuleId())){
			ccpInformationModule.setUpdateTime(new Date());
			ccpInformationModule.setUpdateUser(sysUser.getUserId());
			result = ccpInformationModuleMapper.update(ccpInformationModule);
			
			if(result > 0){
				if(sysModuleInformation != null){
					SysModule sysModuleOld = sysModuleMapper.queryChildModuleByUrl("${path}/ccpInformation/informationIndex.do?informationModuleId="+ccpInformationModule.getInformationModuleId());
					
					if(sysModuleOld != null){
						result = addOrEditModule(sysModuleOld.getModuleId(),ccpInformationModule,sysModuleInformation,sysUser.getUserId());
					}else{
						result = addOrEditModule(null,ccpInformationModule,sysModuleInformation,sysUser.getUserId());
					}
				}
			}
		}else{
			ccpInformationModule.setInformationModuleId(UUIDUtils.createUUId());
			ccpInformationModule.setInformationModuleStatus(1);
			ccpInformationModule.setCreateTime(new Date());
			ccpInformationModule.setCreateUser(sysUser.getUserId());
			result = ccpInformationModuleMapper.insert(ccpInformationModule);
			
			if(result > 0){
				if(sysModuleInformation != null){
			        result = addOrEditModule(null,ccpInformationModule,sysModuleInformation,sysUser.getUserId());
				}
			}
		}
		return result;
	}

	private int addOrEditModule(String moduleId, CcpInformationModule ccpInformationModule, SysModule sysModuleInformation, String userId){
		int result = 0;
		SysModule module = new SysModule();
        module.setModuleName(ccpInformationModule.getInformationModuleName());
        module.setModuleUrl("${path}/ccpInformation/informationIndex.do?informationModuleId="+ccpInformationModule.getInformationModuleId());
        module.setModuleParentId(sysModuleInformation.getModuleId());
        module.setModuleState(1);
        module.setModuleSort(sysModuleInformation.getModuleSort());
        module.setModuleRemark(ccpInformationModule.getInformationModuleId());
        module.setModuleUpdateTime(new Date());
        module.setModuleUpdateUser(userId);
        
        if(StringUtils.isNotBlank(moduleId)){
        	module.setModuleId(moduleId);
        	result = sysModuleMapper.editModuleById(module);
        }else{
        	module.setModuleId(UUIDUtils.createUUId());
        	module.setModuleCreateTime(new Date());
            module.setModuleCreateUser(userId);
        	result = sysModuleMapper.addModule(module);
        }
        return result;
	}

}
