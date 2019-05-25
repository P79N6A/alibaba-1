package com.sun3d.why.dao;

import com.sun3d.why.model.SmsLog;

public interface SmsLogMapper {
    int deleteByPrimaryKey(String id);

    int insert(SmsLog record);

    int insertSelective(SmsLog record);

    SmsLog selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(SmsLog record);

    int updateByPrimaryKey(SmsLog record);
}