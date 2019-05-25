package com.sun3d.why.dao;

import com.sun3d.why.model.qyg.QygUser;


public interface QygUserMapper {
    int deleteByPrimaryKey(String userId);

    int insert(QygUser record);

    int insertSelective(QygUser record);

    QygUser selectByPrimaryKey(String userId);

    int updateByPrimaryKeySelective(QygUser record);

    int updateByPrimaryKey(QygUser record);
}