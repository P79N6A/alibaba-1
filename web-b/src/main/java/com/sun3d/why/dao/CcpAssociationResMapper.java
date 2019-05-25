package com.sun3d.why.dao;

import java.util.List;

import com.sun3d.why.model.CcpAssociationRes;

public interface CcpAssociationResMapper {
    int deleteByPrimaryKey(String resId);
    
    int deleteByAssnId(String assnId);

    int insert(CcpAssociationRes record);

    CcpAssociationRes selectByPrimaryKey(String resId);

    int update(CcpAssociationRes record);
    
    List <CcpAssociationRes> queryAssnResByAssnId(String assnId);

}