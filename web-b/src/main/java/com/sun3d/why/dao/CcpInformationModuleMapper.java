package com.sun3d.why.dao;

import com.culturecloud.model.bean.common.CcpInformationModule;

import java.util.List;
import java.util.Map;

public interface CcpInformationModuleMapper {
    int deleteByPrimaryKey(String informationModuleId);

    int insert(CcpInformationModule record);

    CcpInformationModule selectByPrimaryKey(String informationModuleId);

    int update(CcpInformationModule record);
    
    int queryInformationModuleByConditionCount(Map<String, Object> map);

	List<CcpInformationModule> queryInformationModuleByCondition(Map<String, Object> map);
}