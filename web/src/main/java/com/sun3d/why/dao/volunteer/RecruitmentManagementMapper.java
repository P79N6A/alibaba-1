package com.sun3d.why.dao.volunteer;


import com.sun3d.why.model.volunteer.RecruitmentManagement;

public interface RecruitmentManagementMapper {
    int deleteByPrimaryKey(String uuid);

    int insert(RecruitmentManagement record);

    int insertSelective(RecruitmentManagement record);

    RecruitmentManagement selectByPrimaryKey(String uuid);

    int updateByPrimaryKeySelective(RecruitmentManagement record);

    int updateByPrimaryKey(RecruitmentManagement record);
}