package com.sun3d.why.dao;

import com.sun3d.why.model.AppImageWithStart;

public interface AppImageWithStartMapper {
    int deleteByPrimaryKey(Integer imageid);

    int insert(AppImageWithStart record);

    int insertSelective(AppImageWithStart record);

    AppImageWithStart selectByPrimaryKey(Integer imageid);

    int updateByPrimaryKeySelective(AppImageWithStart record);

    int updateByPrimaryKey(AppImageWithStart record);

	AppImageWithStart queryStartupImg();
}