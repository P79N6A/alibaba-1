package com.sun3d.why.dao;

import com.sun3d.why.model.CcUserInfo;

public interface CcUserInfoMapper {
    int deleteByPrimaryKey(String infoId);

    int insert(CcUserInfo record);

    CcUserInfo selectByPrimaryKey(String infoId);

    int update(CcUserInfo record);
    
    CcUserInfo queryUserInfo(CcUserInfo record);
}