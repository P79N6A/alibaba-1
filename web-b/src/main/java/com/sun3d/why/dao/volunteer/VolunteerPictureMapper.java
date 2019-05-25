package com.sun3d.why.dao.volunteer;


import com.sun3d.why.model.volunteer.VolunteerPicture;

public interface VolunteerPictureMapper {
    int deleteByPrimaryKey(String uuid);

    int insert(VolunteerPicture record);

    int insertSelective(VolunteerPicture record);

    VolunteerPicture selectByPrimaryKey(String uuid);

    int updateByPrimaryKeySelective(VolunteerPicture record);

    int updateByPrimaryKey(VolunteerPicture record);
}