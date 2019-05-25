package com.sun3d.why.dao.volunteer;


import com.sun3d.why.model.volunteer.VolunteerSuggesstion;

public interface VolunteerSuggesstionMapper {
    int deleteByPrimaryKey(String uuid);

    int insert(VolunteerSuggesstion record);

    int insertSelective(VolunteerSuggesstion record);

    VolunteerSuggesstion selectByPrimaryKey(String uuid);

    int updateByPrimaryKeySelective(VolunteerSuggesstion record);

    int updateByPrimaryKey(VolunteerSuggesstion record);
}