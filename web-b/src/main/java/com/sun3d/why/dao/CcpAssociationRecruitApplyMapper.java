package com.sun3d.why.dao;


import com.sun3d.why.model.CcpAssociationRecruitApply;

import java.util.List;
import java.util.Map;


public interface CcpAssociationRecruitApplyMapper {
    int deleteByPrimaryKey(String recruitApplyId);

    int insert(CcpAssociationRecruitApply record);

    int insertSelective(CcpAssociationRecruitApply record);

    CcpAssociationRecruitApply selectByPrimaryKey(String recruitApplyId);

    int updateByPrimaryKeySelective(CcpAssociationRecruitApply record);

    int updateByPrimaryKey(CcpAssociationRecruitApply record);
    
    int queryRecruitApplyCountByMap(Map<String, Object> map);

	List<CcpAssociationRecruitApply> queryRecruitApplyByMap(Map<String, Object> map);
}