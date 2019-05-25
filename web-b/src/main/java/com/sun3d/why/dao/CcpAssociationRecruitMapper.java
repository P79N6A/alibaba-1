package com.sun3d.why.dao;

import java.util.List;
import java.util.Map;

import com.sun3d.why.model.CcpAssociationRecruit;

public interface CcpAssociationRecruitMapper {
    int deleteByPrimaryKey(String recruitId);

    int insert(CcpAssociationRecruit record);

    int insertSelective(CcpAssociationRecruit record);

    CcpAssociationRecruit selectByPrimaryKey(String recruitId);

    int updateByPrimaryKeySelective(CcpAssociationRecruit record);

    int updateByPrimaryKey(CcpAssociationRecruit record);

	List<CcpAssociationRecruit> selectRecruitByMap(Map<String, Object> queryMap);
}