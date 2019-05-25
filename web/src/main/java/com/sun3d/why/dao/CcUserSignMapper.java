package com.sun3d.why.dao;

import com.sun3d.why.model.CcUserSign;

public interface CcUserSignMapper {
    int deleteByPrimaryKey(String userId);

    int insert(CcUserSign record);

    CcUserSign selectByPrimaryKey(String userId);

    int update(CcUserSign record);
}