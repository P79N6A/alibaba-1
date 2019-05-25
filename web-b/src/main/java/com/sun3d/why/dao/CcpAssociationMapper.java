package com.sun3d.why.dao;

import java.util.List;
import java.util.Map;

import com.culturecloud.model.bean.association.CcpAssociationApply;
import com.sun3d.why.model.CcpAssociation;

public interface CcpAssociationMapper {

	int queryAssociationCountByCondition(Map<String, Object> map);
	
	List<CcpAssociation> queryAssociationByCondition(Map<String, Object> map);
	
	int queryAssociationApplyCountByCondition(Map<String, Object> map);
	
	List<CcpAssociation> queryAssociationApplyByCondition(Map<String, Object> map);
	
	int saveAssnApply(CcpAssociationApply ccpAssociationApply);
	
	CcpAssociation selectByPrimaryKey(String assnId);

    int update(CcpAssociation record);
	
	int deleteByPrimaryKey(String assnId);

    int insert(CcpAssociation record);

    List<CcpAssociation> selectAllAssn();
}