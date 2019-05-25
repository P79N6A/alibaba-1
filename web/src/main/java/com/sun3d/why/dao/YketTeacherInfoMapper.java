package com.sun3d.why.dao;

import com.sun3d.why.model.bean.yket.YketTeacherInfo;

public interface YketTeacherInfoMapper {
    int insert(YketTeacherInfo record);

    int insertSelective(YketTeacherInfo record);
    
    YketTeacherInfo selectForUpdate(String teacherId);

    YketTeacherInfo selectYketTeacherInfo(String teacherId);
    
    int updateTeacherInfo(YketTeacherInfo record);
}