package com.sun3d.why.dao;

import java.util.List;
import java.util.Map;

import com.culturecloud.model.bean.association.CcpAssociationApply;
import com.sun3d.why.model.CcpAssociation;

public interface CcpAssociationMapper {

	int queryAssociationCountByCondition(Map<String, Object> map);
	
	List<CcpAssociation> queryAssociationByCondition(Map<String, Object> map);
	
	int saveAssnApply(CcpAssociationApply ccpAssociationApply);
}