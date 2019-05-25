package com.sun3d.why.dao.volunteer;


import com.sun3d.why.model.volunteer.Volunteer;

import java.util.List;
import java.util.Map;

public interface VolunteerMapper {
    int deleteByPrimaryKey(String uuid);

    int insert(Volunteer record);

    int insertSelective(Volunteer record);

    Volunteer selectByPrimaryKey(String uuid);

    int updateByPrimaryKeySelective(Volunteer record);

    int updateByPrimaryKey(Volunteer record);

    List<Volunteer> queryNewVolunteerList(Map<String, Object> map);

    void auditNewVolunteer(Map<String, Object> map);

    int queryTotalVolunteer(Map<String, Object> queryMap);


    List<Volunteer> queryNewVolunteerListByUserId(String userId);

    List<Volunteer> queryNewVolunteer(Map<String, Object> queryMap);

    Integer countVolunteer();
}