package com.sun3d.why.dao;

import com.sun3d.why.model.CmsSuperOrderUser;

public interface CmsSuperOrderUserMapper {
    int deleteByPrimaryKey(String userId);

    int insert(CmsSuperOrderUser record);

    CmsSuperOrderUser selectByPrimaryKey(String userId);

    int update(CmsSuperOrderUser record);
    
    CmsSuperOrderUser querySuperOrderUserByUserMobileNo(String userMobileNo);

}