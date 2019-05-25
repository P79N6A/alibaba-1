package com.sun3d.why.dao;

import java.util.List;

import com.sun3d.why.model.DcFrontUser;

public interface DcFrontUserMapper {
	
	List<DcFrontUser> queryDcFrontUserByCondition(DcFrontUser record);

    int deleteByPrimaryKey(String userId);

    int insert(DcFrontUser record);

    int insertSelective(DcFrontUser record);

    DcFrontUser selectByPrimaryKey(String userId);

    int updateByPrimaryKeySelective(DcFrontUser record);

    int updateByPrimaryKey(DcFrontUser record);
}